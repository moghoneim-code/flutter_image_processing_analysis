import 'dart:io';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/constants/enums/processing_type.dart';
import '../entities/processing_result.dart';
import '../repositories/processing_repository.dart';

/// Use case that orchestrates the complete image processing pipeline.
///
/// [ProcessImageUseCase] first downscales the image to a safe size,
/// analyzes the content type, then routes to the appropriate processing
/// flow while reusing cached ML Kit results:
/// - **Face**: Creates a grayscale face composite using the already-detected faces.
/// - **Document**: Enhances the image and extracts text via OCR.
/// - **None**: Returns the original image unchanged.
class ProcessImageUseCase {
  /// The repository providing processing operations.
  final ProcessingRepository _repository;

  /// Creates a [ProcessImageUseCase] with the given [_repository].
  ProcessImageUseCase(this._repository);

  /// Processes the given [image] and returns a [ProcessingResult].
  ///
  /// The pipeline:
  /// 1. Downscales the image to prevent OOM crashes on large photos.
  /// 2. Determines the content type via [ProcessingRepository.analyzeImage].
  /// 3. For faces: generates a composite using cached face data (no re-detection).
  /// 4. For documents: enhances the image and extracts text.
  /// 5. For unrecognized content: returns the resized image with [ProcessingType.none].
  ///
  /// Throws a [ProcessingFailure] if any step fails.
  Future<ProcessingResult> execute(File image) async {
    try {
      final resized = await _repository.resizeForProcessing(image);

      final analysis = await _repository.analyzeImage(resized);

      if (analysis.type == ProcessingType.face) {
        final faceFile = await _repository.processFaceComposite(
          resized,
          analysis.faces!,
        );
        return ProcessingResult(
          file: faceFile,
          type: analysis.type,
          originalFile: resized,
        );
      }

      if (analysis.type == ProcessingType.document) {
        final docFile = await _repository.processDocumentEnhancement(resized);
        final text = await _repository.extractText(docFile);
        return ProcessingResult(
          file: docFile,
          type: analysis.type,
          extractedText: text,
        );
      }

      return ProcessingResult(file: resized, type: ProcessingType.none);
    } on Failure {
      rethrow;
    } catch (e) {
      throw ProcessingFailure('Failed to process image: $e');
    }
  }
}
