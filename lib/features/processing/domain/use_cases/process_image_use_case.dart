import 'dart:io';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/constants/enums/processing_type.dart';
import '../entities/processing_result.dart';
import '../repositories/i_processing_repository.dart';

/// Use case that orchestrates the complete image processing pipeline.
///
/// [ProcessImageUseCase] analyzes the image content type, then routes
/// to the appropriate processing flow:
/// - **Face**: Creates a grayscale face composite.
/// - **Document**: Enhances the image and extracts text via OCR.
/// - **None**: Returns the original image unchanged.
class ProcessImageUseCase {
  /// The repository providing processing operations.
  final IProcessingRepository _repository;

  /// Creates a [ProcessImageUseCase] with the given [_repository].
  ProcessImageUseCase(this._repository);

  /// Processes the given [image] and returns a [ProcessingResult].
  ///
  /// The pipeline:
  /// 1. Determines the content type via [IProcessingRepository.analyzeImage].
  /// 2. For faces: generates a composite via [IProcessingRepository.processFaceComposite].
  /// 3. For documents: enhances the image and extracts text.
  /// 4. For unrecognized content: returns the original image with [ProcessingType.none].
  ///
  /// Throws a [ProcessingFailure] if any step fails.
  Future<ProcessingResult> execute(File image) async {
    try {
      final type = await _repository.analyzeImage(image);

      if (type == ProcessingType.face) {
        final faceFile = await _repository.processFaceComposite(image);
        return ProcessingResult(file: faceFile, type: type, originalFile: image);
      }

      if (type == ProcessingType.document) {
        final docFile = await _repository.processDocumentEnhancement(image);
        final text = await _repository.extractText(docFile);
        return ProcessingResult(file: docFile, type: type, extractedText: text);
      }

      return ProcessingResult(file: image, type: ProcessingType.none);
    } on Failure {
      rethrow;
    } catch (e) {
      throw ProcessingFailure('Failed to process image: $e');
    }
  }
}