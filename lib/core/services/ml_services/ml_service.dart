import 'dart:io';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import '../../errors/failures.dart';
import '../../utils/constants/enums/processing_type.dart';

/// Holds the result of content-type analysis including any detected data.
///
/// [AnalysisResult] avoids redundant ML Kit calls by caching the face
/// list or recognized text that was already produced during classification.
class AnalysisResult {
  /// The detected content type.
  final ProcessingType type;

  /// Faces detected during classification (non-null only for [ProcessingType.face]).
  final List<Face>? faces;

  AnalysisResult({required this.type, this.faces});
}

/// Service that wraps Google ML Kit for face detection and text recognition.
///
/// [MLService] provides methods to classify image content, detect faces,
/// and extract text using on-device machine learning models.
class MLService {
  /// Face detector using fast mode — sufficient for classification and
  /// bounding-box extraction while being significantly cheaper than accurate mode.
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableTracking: true,
      performanceMode: FaceDetectorMode.fast,
    ),
  );

  /// Text recognizer configured for Latin script recognition.
  final TextRecognizer _textRecognizer = TextRecognizer(
    script: TextRecognitionScript.latin,
  );

  /// Analyzes the given [imageFile] and determines its content type.
  ///
  /// Returns an [AnalysisResult] containing the [ProcessingType] and,
  /// for face images, the detected [Face] list so callers can reuse it
  /// without running face detection a second time.
  ///
  /// Throws a [ProcessingFailure] if analysis fails.
  Future<AnalysisResult> analyzeContent(File imageFile) async {
    try {
      final inputImage = InputImage.fromFile(imageFile);

      final faces = await _faceDetector.processImage(inputImage);
      if (faces.isNotEmpty) {
        return AnalysisResult(type: ProcessingType.face, faces: faces);
      }

      final recognizedText = await _textRecognizer.processImage(inputImage);
      if (recognizedText.text.trim().isNotEmpty) {
        return AnalysisResult(type: ProcessingType.document);
      }

      return AnalysisResult(type: ProcessingType.none);
    } catch (e) {
      throw ProcessingFailure('Failed to detect content type: $e');
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
