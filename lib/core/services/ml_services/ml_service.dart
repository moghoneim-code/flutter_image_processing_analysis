import 'dart:io';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import '../../errors/failures.dart';
import '../../utils/constants/enums/processing_type.dart';

/// Service that wraps Google ML Kit for face detection and text recognition.
///
/// [MLService] provides methods to classify image content, detect faces,
/// and extract text using on-device machine learning models.
class MLService {
  /// Face detector configured for accurate mode with tracking enabled.
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableTracking: true,
      performanceMode: FaceDetectorMode.accurate,
    ),
  );

  /// Text recognizer configured for Latin script recognition.
  final TextRecognizer _textRecognizer = TextRecognizer(
    script: TextRecognitionScript.latin,
  );

  /// Analyzes the given [imageFile] and determines its content type.
  ///
  /// Returns [ProcessingType.face] if faces are detected,
  /// [ProcessingType.document] if text is found, or
  /// [ProcessingType.none] if neither is detected.
  ///
  /// Throws a [ProcessingFailure] if analysis fails.
  Future<ProcessingType> detectContentType(File imageFile) async {
    try {
      final inputImage = InputImage.fromFile(imageFile);

      final faces = await _faceDetector.processImage(inputImage);
      if (faces.isNotEmpty) return ProcessingType.face;

      final recognizedText = await _textRecognizer.processImage(inputImage);
      if (recognizedText.text.trim().isNotEmpty) return ProcessingType.document;

      return ProcessingType.none;
    } catch (e) {
      throw ProcessingFailure('Failed to detect content type: $e');
    }
  }

  /// Detects all faces in the given [imageFile].
  ///
  /// Returns a list of [Face] objects representing detected faces
  /// with bounding boxes and tracking information.
  ///
  /// Throws a [ProcessingFailure] if face detection fails.
  Future<List<Face>> getFaces(File imageFile) async {
    try {
      final inputImage = InputImage.fromFile(imageFile);
      return await _faceDetector.processImage(inputImage);
    } catch (e) {
      throw ProcessingFailure('Failed to detect faces: $e');
    }
  }

  /// Performs optical character recognition (OCR) on the given [imageFile].
  ///
  /// Returns the recognized text as a single concatenated string.
  ///
  /// Throws a [ProcessingFailure] if text recognition fails.
  Future<String> recognizeText(File imageFile) async {
    try {
      final inputImage = InputImage.fromFile(imageFile);
      final RecognizedText recognizedText =
          await _textRecognizer.processImage(inputImage);
      return recognizedText.text;
    } catch (e) {
      throw ProcessingFailure('Failed to recognize text: $e');
    }
  }

  /// Releases all ML Kit resources held by this service.
  void dispose() {
    _faceDetector.close();
    _textRecognizer.close();
  }
}