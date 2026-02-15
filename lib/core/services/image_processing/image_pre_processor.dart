import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import '../../errors/failures.dart';

/// Maximum dimension (width or height) for images before processing.
///
/// Images larger than this are downscaled to prevent OOM crashes and
/// reduce processing time. 1920px is sufficient for ML Kit detection,
/// document enhancement, and face compositing.
const int _kMaxProcessingDimension = 1920;

/// Top-level isolate function that decodes, orients, and downscales
/// an image to [_kMaxProcessingDimension]. Returns JPEG bytes or
/// `null` if decoding fails.
Uint8List? _resizeForProcessingIsolate(Uint8List bytes) {
  img.Image? decoded = img.decodeImage(bytes);
  if (decoded == null) return null;

  final oriented = img.bakeOrientation(decoded);
  final maxDim = math.max(oriented.width, oriented.height);

  if (maxDim <= _kMaxProcessingDimension) {
    return Uint8List.fromList(img.encodeJpg(oriented, quality: 90));
  }

  final scale = _kMaxProcessingDimension / maxDim;
  final resized = img.copyResize(
    oriented,
    width: (oriented.width * scale).round(),
    height: (oriented.height * scale).round(),
    interpolation: img.Interpolation.linear,
  );

  return Uint8List.fromList(img.encodeJpg(resized, quality: 90));
}

/// Top-level isolate function for document enhancement.
///
/// Decodes, orients, detects edges, finds corners, applies perspective
/// correction, grayscale, and contrast — all off the main thread.
/// Returns JPEG bytes or `null` if decoding fails.
Uint8List? _enhanceForScanningIsolate(Uint8List bytes) {
  img.Image? decoded = img.decodeImage(bytes);
  if (decoded == null) return null;

  final image = img.bakeOrientation(decoded);

  final edges = _detectEdgesIsolate(image);
  final corners = _findDocumentCornersIsolate(edges, image.width, image.height);

  img.Image result;
  if (corners != null) {
    result = _perspectiveTransformIsolate(image, corners);
  } else {
    result = image;
  }

  result = img.grayscale(result);
  result = img.adjustColor(result, contrast: 1.2);

  return Uint8List.fromList(img.encodeJpg(result, quality: 90));
}

/// Isolate-safe edge detection using Sobel filtering and binary thresholding.
img.Image _detectEdgesIsolate(img.Image image) {
  img.Image work = image;

  final maxDim = math.max(work.width, work.height);
  if (maxDim > 800) {
    final scale = 800 / maxDim;
    work = img.copyResize(
      work,
      width: (work.width * scale).round(),
      height: (work.height * scale).round(),
    );
  }

  work = img.grayscale(work);
  work = img.sobel(work);

  for (int y = 0; y < work.height; y++) {
    for (int x = 0; x < work.width; x++) {
      final pixel = work.getPixel(x, y);
      final luminance = img.getLuminance(pixel);
      if (luminance > 80) {
        work.setPixelRgb(x, y, 255, 255, 255);
      } else {
        work.setPixelRgb(x, y, 0, 0, 0);
      }
    }
  }

  return work;
}

/// Isolate-safe document corner detection from an edge-detected image.
List<img.Point>? _findDocumentCornersIsolate(
  img.Image edgeImage,
  int origW,
  int origH,
) {
  final w = edgeImage.width;
  final h = edgeImage.height;
  final scaleX = origW / w;
  final scaleY = origH / h;

  img.Point? topLeft;
  img.Point? topRight;
  img.Point? bottomLeft;
  img.Point? bottomRight;

  bool isEdge(int x, int y) {
    return img.getLuminance(edgeImage.getPixel(x, y)) > 200;
  }

  outer:
  for (int y = 0; y < h ~/ 2; y++) {
    for (int x = 0; x < w ~/ 2; x++) {
      if (isEdge(x, y)) {
        topLeft = img.Point(x * scaleX, y * scaleY);
        break outer;
      }
    }
  }

  outer:
  for (int y = 0; y < h ~/ 2; y++) {
    for (int x = w - 1; x >= w ~/ 2; x--) {
      if (isEdge(x, y)) {
        topRight = img.Point(x * scaleX, y * scaleY);
        break outer;
      }
    }
  }

  outer:
  for (int y = h - 1; y >= h ~/ 2; y--) {
    for (int x = 0; x < w ~/ 2; x++) {
      if (isEdge(x, y)) {
        bottomLeft = img.Point(x * scaleX, y * scaleY);
        break outer;
      }
    }
  }

  outer:
  for (int y = h - 1; y >= h ~/ 2; y--) {
    for (int x = w - 1; x >= w ~/ 2; x--) {
      if (isEdge(x, y)) {
        bottomRight = img.Point(x * scaleX, y * scaleY);
        break outer;
      }
    }
  }

  if (topLeft == null ||
      topRight == null ||
      bottomLeft == null ||
      bottomRight == null) {
    return null;
  }

  final area = 0.5 *
      ((topLeft.x * topRight.y - topRight.x * topLeft.y) +
              (topRight.x * bottomRight.y - bottomRight.x * topRight.y) +
              (bottomRight.x * bottomLeft.y - bottomLeft.x * bottomRight.y) +
              (bottomLeft.x * topLeft.y - topLeft.x * bottomLeft.y))
          .abs()
          .toDouble();

  if (area < origW * origH * 0.2) return null;

  return [topLeft, topRight, bottomRight, bottomLeft];
}

/// Isolate-safe perspective transform.
img.Image _perspectiveTransformIsolate(
  img.Image image,
  List<img.Point> corners,
) {
  final topLeft = corners[0];
  final topRight = corners[1];
  final bottomRight = corners[2];
  final bottomLeft = corners[3];

  double dist(img.Point a, img.Point b) {
    final dx = (a.x - b.x).toDouble();
    final dy = (a.y - b.y).toDouble();
    return math.sqrt(dx * dx + dy * dy);
  }

  final outW = math.max(dist(topLeft, topRight), dist(bottomLeft, bottomRight)).round();
  final outH = math.max(dist(topLeft, bottomLeft), dist(topRight, bottomRight)).round();

  final output = img.Image(width: outW, height: outH);

  return img.copyRectify(
    image,
    topLeft: topLeft,
    topRight: topRight,
    bottomLeft: bottomLeft,
    bottomRight: bottomRight,
    interpolation: img.Interpolation.linear,
    toImage: output,
  );
}

/// Payload for the face composite isolate function.
class _FaceCompositeParams {
  final Uint8List bytes;
  final List<Map<String, double>> faceRects;

  _FaceCompositeParams(this.bytes, this.faceRects);
}

/// Payload for the transform isolate function.
class _TransformParams {
  final Uint8List bytes;
  final int quarterTurns;
  final bool flipHorizontal;
  final bool flipVertical;

  _TransformParams(this.bytes, this.quarterTurns, this.flipHorizontal, this.flipVertical);
}

/// Top-level isolate function that applies rotation and flip transforms.
///
/// Decodes the image, applies [quarterTurns] * 90° clockwise rotation,
/// then horizontal/vertical flips as requested. Returns JPEG bytes or
/// `null` if decoding fails.
Uint8List? _applyTransformsIsolate(_TransformParams params) {
  img.Image? decoded = img.decodeImage(params.bytes);
  if (decoded == null) return null;

  var result = img.bakeOrientation(decoded);

  if (params.quarterTurns % 4 != 0) {
    final angle = (params.quarterTurns % 4) * 90;
    result = img.copyRotate(result, angle: angle);
  }

  if (params.flipHorizontal) {
    result = img.flipHorizontal(result);
  }

  if (params.flipVertical) {
    result = img.flipVertical(result);
  }

  return Uint8List.fromList(img.encodeJpg(result, quality: 90));
}

/// Top-level isolate function for face composite generation.
///
/// Decodes, orients, then composites grayscale face regions — all off
/// the main thread. Returns JPEG bytes or `null` if decoding fails.
Uint8List? _createFaceCompositeIsolate(_FaceCompositeParams params) {
  img.Image? decoded = img.decodeImage(params.bytes);
  if (decoded == null) return null;

  final originalImage = img.bakeOrientation(decoded);

  for (var rect in params.faceRects) {
    int x = rect['left']!.toInt().clamp(0, originalImage.width - 1);
    int y = rect['top']!.toInt().clamp(0, originalImage.height - 1);
    int w = rect['width']!.toInt().clamp(1, originalImage.width - x);
    int h = rect['height']!.toInt().clamp(1, originalImage.height - y);

    if (w <= 0 || h <= 0) continue;

    img.Image faceCrop = img.copyCrop(
      originalImage,
      x: x,
      y: y,
      width: w,
      height: h,
    );

    img.Image grayFace = img.grayscale(faceCrop);

    img.compositeImage(
      originalImage,
      grayFace,
      dstX: x,
      dstY: y,
    );
  }

  return Uint8List.fromList(img.encodeJpg(originalImage, quality: 90));
}

/// Service for pre-processing images before analysis or display.
///
/// [ImagePreProcessor] provides methods to enhance document scans
/// and create face composite images by manipulating pixel data.
///
/// Heavy image operations (decoding, pixel manipulation, encoding)
/// are offloaded to background isolates via [compute] to keep the
/// UI thread responsive.
///
/// All processed images are saved to the app documents directory
/// (not temp) so they persist for history viewing.
class ImagePreProcessor {

  /// Downscales the given [imageFile] to a max dimension of 1920px.
  ///
  /// This prevents OOM crashes and dramatically speeds up all
  /// downstream ML Kit and image-processing operations. If the image
  /// is already within bounds, the oriented JPEG is returned.
  ///
  /// Returns a new [File] with the resized image.
  /// Throws an [ImageProcessingFailure] if the operation fails.
  Future<File> resizeForProcessing(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();

      final resizedBytes = await compute(_resizeForProcessingIsolate, bytes);

      if (resizedBytes == null) return imageFile;

      return await _saveProcessedBytes(resizedBytes, "resized");
    } catch (e) {
      if (e is ImageProcessingFailure) rethrow;
      throw ImageProcessingFailure('Failed to resize image: $e');
    }
  }

  /// Enhances the given [imageFile] for document scanning.
  ///
  /// Offloads the CPU-intensive work (decode, edge detection, perspective
  /// correction, grayscale, contrast, encode) to a background isolate.
  ///
  /// Returns a new [File] containing the enhanced image.
  /// Throws an [ImageProcessingFailure] if the operation fails.
  Future<File> enhanceForScanning(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();

      final processedBytes = await compute(_enhanceForScanningIsolate, bytes);

      if (processedBytes == null) return imageFile;

      return await _saveProcessedBytes(processedBytes, "enhanced_doc");
    } catch (e) {
      if (e is ImageProcessingFailure) rethrow;
      throw ImageProcessingFailure('Failed to enhance image for scanning: $e');
    }
  }

  /// Creates a face composite image from the given [imageFile] and [faces].
  ///
  /// Extracts face bounding box data from [Face] objects (which use
  /// platform channels and aren't isolate-safe), then offloads all
  /// pixel manipulation to a background isolate.
  ///
  /// Returns a new [File] containing the composite image.
  /// Throws an [ImageProcessingFailure] if the operation fails.
  Future<File> createFaceComposite(File imageFile, List<Face> faces) async {
    try {
      if (faces.isEmpty) return imageFile;

      final bytes = await imageFile.readAsBytes();

      final faceRects = faces.map((f) => {
        'left': f.boundingBox.left,
        'top': f.boundingBox.top,
        'width': f.boundingBox.width,
        'height': f.boundingBox.height,
      }).toList();

      final processedBytes = await compute(
        _createFaceCompositeIsolate,
        _FaceCompositeParams(bytes, faceRects),
      );

      if (processedBytes == null) return imageFile;

      return await _saveProcessedBytes(processedBytes, "face_composite");
    } catch (e) {
      if (e is ImageProcessingFailure) rethrow;
      throw ImageProcessingFailure('Failed to create face composite: $e');
    }
  }

  /// Applies rotation and flip transforms to the given [imageFile].
  ///
  /// [quarterTurns] specifies clockwise 90° increments (0–3).
  /// [flipH] and [flipV] apply horizontal and vertical flips respectively.
  ///
  /// Returns a new [File] with the transformed image.
  /// Throws an [ImageProcessingFailure] if the operation fails.
  Future<File> applyTransforms(
    File imageFile,
    int quarterTurns,
    bool flipH,
    bool flipV,
  ) async {
    try {
      final bytes = await imageFile.readAsBytes();

      final transformedBytes = await compute(
        _applyTransformsIsolate,
        _TransformParams(bytes, quarterTurns, flipH, flipV),
      );

      if (transformedBytes == null) return imageFile;

      return await _saveProcessedBytes(transformedBytes, "transformed");
    } catch (e) {
      if (e is ImageProcessingFailure) rethrow;
      throw ImageProcessingFailure('Failed to apply transforms: $e');
    }
  }

  /// Saves pre-encoded JPEG [bytes] to the app documents directory.
  ///
  /// Uses the documents directory (not temp) so files persist across
  /// sessions and are available for history viewing.
  Future<File> _saveProcessedBytes(Uint8List bytes, String prefix) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final processedDir = Directory('${appDir.path}/processed_images');
      if (!await processedDir.exists()) {
        await processedDir.create(recursive: true);
      }

      final path =
          '${processedDir.path}/${prefix}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final file = File(path);
      await file.writeAsBytes(bytes);
      return file;
    } catch (e) {
      if (e is ImageProcessingFailure) rethrow;
      throw ImageProcessingFailure('Failed to save processed image: $e');
    }
  }
}
