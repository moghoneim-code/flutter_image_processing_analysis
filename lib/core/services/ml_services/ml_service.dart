import 'dart:io';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import '../../utils/utils/constants/enums/ProcessingType.dart';

class MLService {
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      performanceMode: FaceDetectorMode.accurate,
    ),
  );

  final TextRecognizer _textRecognizer = TextRecognizer(
    script: TextRecognitionScript.latin,
  );

  Future<ProcessingType> detectContentType(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);

    try {
      final faces = await _faceDetector.processImage(inputImage);
      if (faces.isNotEmpty) return ProcessingType.face;

      final recognizedText = await _textRecognizer.processImage(inputImage);
      if (recognizedText.text.trim().isNotEmpty) return ProcessingType.document;

      return ProcessingType.none;
    } catch (e) {
      return ProcessingType.none;
    }
  }

  Future<String> recognizeText(File imageFile) async {
    try {
      final inputImage = InputImage.fromFile(imageFile);
      final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);
      return recognizedText.text;
    } catch (e) {
      return "";
    }
  }

  Future<List<Face>> getFaces(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    return await _faceDetector.processImage(inputImage);
  }

  void dispose() {
    _faceDetector.close();
    _textRecognizer.close();
  }
}