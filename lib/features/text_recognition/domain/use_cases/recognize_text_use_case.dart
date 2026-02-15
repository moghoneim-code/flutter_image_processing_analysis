import 'dart:io';
import '../../../../core/errors/failures.dart';
import '../../../../core/services/ml_services/ml_service.dart';
import '../../../../core/utils/constants/enums/processing_type.dart';
import '../../../home/data/models/history_model.dart';
import '../repositories/text_recognition_repository.dart';

/// Use case for performing OCR on an image and saving the result.
///
/// [RecognizeTextUseCase] extracts text from the given image using
/// [MLService], creates a [HistoryModel] record with the result,
/// and persists it via [TextRecognitionRepository].
class RecognizeTextUseCase {
  /// The repository for persisting recognition results.
  final TextRecognitionRepository repository;

  /// The ML service used for text recognition.
  final MLService mlService;

  /// Creates a [RecognizeTextUseCase] with the given dependencies.
  RecognizeTextUseCase(this.repository, this.mlService);

  /// Recognizes text in the given [image] and saves the result.
  ///
  /// Returns a [HistoryModel] containing the extracted text or
  /// "No text detected" if the image contains no readable text.
  ///
  /// Throws a [ProcessingFailure] if OCR or saving fails.
  Future<HistoryModel> execute(File image) async {
    try {
      final text = await mlService.recognizeText(image);

      final newItem = HistoryModel(
        id: DateTime.now().millisecondsSinceEpoch,
        imagePath: image.path,
        result: text.isEmpty ? "No text detected" : text,
        type: ProcessingType.text,
        dateTime: DateTime.now().toString(),
      );

      await repository.saveResult(newItem);
      return newItem;
    } on Failure {
      rethrow;
    } catch (e) {
      throw ProcessingFailure('Failed to recognize text: $e');
    }
  }
}