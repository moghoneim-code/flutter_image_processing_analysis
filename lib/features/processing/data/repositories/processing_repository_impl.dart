import 'dart:io';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/services/image_processing/image_pre_processor.dart';
import '../../../../core/services/ml_services/ml_service.dart';
import '../../domain/repositories/processing_repository.dart';

/// Concrete implementation of [ProcessingRepository].
///
/// [ProcessingRepositoryImpl] delegates ML operations to [MLService]
/// and image manipulation to [ImagePreProcessor], wrapping all errors
/// in the appropriate [Failure] subclass.
class ProcessingRepositoryImpl implements ProcessingRepository {
  /// The ML service for content detection and text recognition.
  final MLService _mlService;

  /// The image pre-processor for enhancement and compositing.
  final ImagePreProcessor _preProcessor;

  /// Creates a [ProcessingRepositoryImpl] with the given services.
  ProcessingRepositoryImpl(this._mlService, this._preProcessor);

  @override
  Future<File> resizeForProcessing(File image) async {
    try {
      return await _preProcessor.resizeForProcessing(image);
    } on Failure {
      rethrow;
    } catch (e) {
      throw ProcessingFailure('Failed to resize image: $e');
    }
  }

  @override
  Future<AnalysisResult> analyzeImage(File image) async {
    try {
      return await _mlService.analyzeContent(image);
    } on ProcessingFailure {
      rethrow;
    } catch (e) {
      throw ProcessingFailure('Failed to analyze image: $e');
    }
  }

  @override
  Future<File> processFaceComposite(File image, List<Face> faces) async {
    try {
      return await _preProcessor.createFaceComposite(image, faces);
    } on Failure {
      rethrow;
    } catch (e) {
      throw ProcessingFailure('Failed to process face composite: $e');
    }
  }

  @override
  Future<File> processDocumentEnhancement(File image) async {
    try {
      return await _preProcessor.enhanceForScanning(image);
    } on Failure {
      rethrow;
    } catch (e) {
      throw ProcessingFailure('Failed to enhance document: $e');
    }
  }

  @override
  Future<String> extractText(File image) async {
    try {
      return await _mlService.recognizeText(image);
    } on ProcessingFailure {
      rethrow;
    } catch (e) {
      throw ProcessingFailure('Failed to extract text: $e');
    }
  }
}
