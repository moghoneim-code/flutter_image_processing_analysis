import 'dart:io';
import '../../../../core/errors/failures.dart';
import '../../../../core/services/image_processing/image_pre_processor.dart';
import '../../../../core/services/ml_services/ml_service.dart';
import '../../../../core/utils/constants/enums/processing_type.dart';
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
  Future<ProcessingType> analyzeImage(File image) async {
    try {
      return await _mlService.detectContentType(image);
    } on ProcessingFailure {
      rethrow;
    } catch (e) {
      throw ProcessingFailure('Failed to analyze image: $e');
    }
  }

  @override
  Future<File> processFaceComposite(File image) async {
    try {
      final faces = await _mlService.getFaces(image);
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