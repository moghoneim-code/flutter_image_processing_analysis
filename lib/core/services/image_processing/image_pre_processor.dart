import 'dart:io';
import 'dart:math' as math;
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import '../../errors/failures.dart';

/// Service for pre-processing images before analysis or display.
///
/// [ImagePreProcessor] provides methods to enhance document scans
/// and create face composite images by manipulating pixel data.
///
/// All processed images are saved to the app documents directory
/// (not temp) so they persist for history viewing.
class ImagePreProcessor {

  /// Enhances the given [imageFile] for document scanning.
  ///
  /// Performs edge detection to find document boundaries, applies
  /// perspective correction if corners are found, then converts
  /// to grayscale and boosts contrast for readability.
  ///
  /// Falls back to simple grayscale + contrast if no clear document
  /// edges are detected.
  ///
  /// Returns a new [File] containing the enhanced image.
  /// Throws an [ImageProcessingFailure] if the operation fails.
  Future<File> enhanceForScanning(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      img.Image? decoded = img.decodeImage(bytes);

      if (decoded == null) return imageFile;

      // Apply EXIF orientation so pixel coordinates match visual orientation
      final image = img.bakeOrientation(decoded);

      final edges = _detectEdges(image);
      final corners = _findDocumentCorners(edges, image.width, image.height);

      img.Image result;
      if (corners != null) {
        result = _perspectiveTransform(image, corners);
      } else {
        result = image;
      }

      result = img.grayscale(result);
      result = img.adjustColor(result, contrast: 1.2);

      return await _saveProcessedImage(result, "enhanced_doc");
    } catch (e) {
      if (e is ImageProcessingFailure) rethrow;
      throw ImageProcessingFailure('Failed to enhance image for scanning: $e');
    }
  }

  /// Detects edges in the image using Sobel filtering and binary thresholding.
  ///
  /// Downscales large images to max 800px on longest side for performance,
  /// converts to grayscale, applies Sobel edge detection, then binarizes
  /// with a luminance threshold.
  img.Image _detectEdges(img.Image image) {
    img.Image work = image;

    /// Downscale for performance if needed
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

    /// Binary threshold
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

  /// Finds the four document corners from the edge-detected image.
  ///
  /// Scans from each quadrant corner inward to locate the nearest edge pixel.
  /// Scales coordinates back to [origW] x [origH] dimensions.
  /// Returns null if not all four corners are found or the detected area
  /// is less than 20% of the original image.
  List<img.Point>? _findDocumentCorners(
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

    /// Scan top-left quadrant
    outer:
    for (int y = 0; y < h ~/ 2; y++) {
      for (int x = 0; x < w ~/ 2; x++) {
        if (_isEdgePixel(edgeImage, x, y)) {
          topLeft = img.Point(x * scaleX, y * scaleY);
          break outer;
        }
      }
    }

    /// Scan top-right quadrant
    outer:
    for (int y = 0; y < h ~/ 2; y++) {
      for (int x = w - 1; x >= w ~/ 2; x--) {
        if (_isEdgePixel(edgeImage, x, y)) {
          topRight = img.Point(x * scaleX, y * scaleY);
          break outer;
        }
      }
    }

    /// Scan bottom-left quadrant
    outer:
    for (int y = h - 1; y >= h ~/ 2; y--) {
      for (int x = 0; x < w ~/ 2; x++) {
        if (_isEdgePixel(edgeImage, x, y)) {
          bottomLeft = img.Point(x * scaleX, y * scaleY);
          break outer;
        }
      }
    }

    /// Scan bottom-right quadrant
    outer:
    for (int y = h - 1; y >= h ~/ 2; y--) {
      for (int x = w - 1; x >= w ~/ 2; x--) {
        if (_isEdgePixel(edgeImage, x, y)) {
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

    /// Validate: detected area must be at least 20% of the original image
    final area = _quadArea(topLeft, topRight, bottomRight, bottomLeft);
    if (area < origW * origH * 0.2) return null;

    return [topLeft, topRight, bottomRight, bottomLeft];
  }

  /// Returns true if the pixel at [x],[y] is a white edge pixel.
  bool _isEdgePixel(img.Image image, int x, int y) {
    final pixel = image.getPixel(x, y);
    return img.getLuminance(pixel) > 200;
  }

  /// Computes the approximate area of a quadrilateral using the shoelace formula.
  double _quadArea(img.Point a, img.Point b, img.Point c, img.Point d) {
    return 0.5 *
        ((a.x * b.y - b.x * a.y) +
            (b.x * c.y - c.x * b.y) +
            (c.x * d.y - d.x * c.y) +
            (d.x * a.y - a.x * d.y))
            .abs()
            .toDouble();
  }

  /// Applies a perspective transform to rectify the document region.
  ///
  /// [corners] order: [topLeft, topRight, bottomRight, bottomLeft].
  /// Uses the image package's built-in [img.copyRectify] for the warp.
  img.Image _perspectiveTransform(img.Image image, List<img.Point> corners) {
    final topLeft = corners[0];
    final topRight = corners[1];
    final bottomRight = corners[2];
    final bottomLeft = corners[3];

    /// Compute output dimensions from corner distances
    final topWidth = _distance(topLeft, topRight);
    final bottomWidth = _distance(bottomLeft, bottomRight);
    final leftHeight = _distance(topLeft, bottomLeft);
    final rightHeight = _distance(topRight, bottomRight);

    final outW = math.max(topWidth, bottomWidth).round();
    final outH = math.max(leftHeight, rightHeight).round();

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

  /// Computes the Euclidean distance between two points.
  double _distance(img.Point a, img.Point b) {
    final dx = (a.x - b.x).toDouble();
    final dy = (a.y - b.y).toDouble();
    return math.sqrt(dx * dx + dy * dy);
  }

  /// Creates a face composite image from the given [imageFile] and [faces].
  ///
  /// For each detected [Face], the face region is extracted, converted
  /// to grayscale, and composited back onto the original color image.
  /// This creates a visual effect where faces appear in grayscale
  /// while the rest of the image remains in full color.
  ///
  /// EXIF orientation is baked in before processing so that ML Kit
  /// bounding boxes (which use displayed orientation) align correctly
  /// with the raw pixel data.
  ///
  /// - [imageFile]: The source image file to process.
  /// - [faces]: A list of [Face] objects with bounding box coordinates.
  ///
  /// Returns a new [File] containing the composite image.
  /// Throws an [ImageProcessingFailure] if the operation fails.
  Future<File> createFaceComposite(File imageFile, List<Face> faces) async {
    try {
      final bytes = await imageFile.readAsBytes();
      img.Image? decoded = img.decodeImage(bytes);

      if (decoded == null || faces.isEmpty) return imageFile;

      // Apply EXIF orientation so bounding boxes from ML Kit align correctly
      final originalImage = img.bakeOrientation(decoded);

      for (var face in faces) {
        final rect = face.boundingBox;

        int x = rect.left.toInt().clamp(0, originalImage.width - 1);
        int y = rect.top.toInt().clamp(0, originalImage.height - 1);
        int w = rect.width.toInt().clamp(1, originalImage.width - x);
        int h = rect.height.toInt().clamp(1, originalImage.height - y);

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

      return await _saveProcessedImage(originalImage, "face_composite");
    } catch (e) {
      if (e is ImageProcessingFailure) rethrow;
      throw ImageProcessingFailure('Failed to create face composite: $e');
    }
  }

  /// Saves the processed [image] to the app documents directory.
  ///
  /// Uses the documents directory (not temp) so files persist across
  /// sessions and are available for history viewing. Images are saved
  /// as JPEG with 90% quality to balance file size and visual fidelity.
  ///
  /// - [image]: The processed image to save.
  /// - [prefix]: A filename prefix describing the processing type.
  ///
  /// Returns the newly created [File].
  /// Throws an [ImageProcessingFailure] if saving fails.
  Future<File> _saveProcessedImage(img.Image image, String prefix) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final processedDir = Directory('${appDir.path}/processed_images');
      if (!await processedDir.exists()) {
        await processedDir.create(recursive: true);
      }

      final path =
          '${processedDir.path}/${prefix}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final file = File(path);
      await file.writeAsBytes(img.encodeJpg(image, quality: 90));
      return file;
    } catch (e) {
      if (e is ImageProcessingFailure) rethrow;
      throw ImageProcessingFailure('Failed to save processed image: $e');
    }
  }
}