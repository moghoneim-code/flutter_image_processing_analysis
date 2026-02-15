import 'dart:io';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/constants/enums/processing_type.dart';
import '../../../home/data/models/history_model.dart';
import '../repositories/text_recognition_repository.dart';

/// Use case for saving a text recognition result to history.
///
/// [SaveTextResultUseCase] persists a [HistoryModel] record containing
/// the image path and recognized text, without performing OCR. This is
/// used when text has already been extracted (e.g. from the processing
/// pipeline) and only the history entry needs to be created.
class SaveTextResultUseCase {
  /// The repository for persisting history records.
  final TextRecognitionRepository _repository;

  /// Creates a [SaveTextResultUseCase] with the given [_repository].
  SaveTextResultUseCase(this._repository);

  /// Saves a history record for the given [image] with the [text] result.
  ///
  /// Returns the created [HistoryModel].
  /// Throws a [ProcessingFailure] if saving fails.
  Future<HistoryModel> execute(File image, String text) async {
    try {
      final item = HistoryModel(
        id: DateTime.now().millisecondsSinceEpoch,
        imagePath: image.path,
        result: text.isEmpty ? "No text detected" : text,
        type: ProcessingType.text,
        dateTime: DateTime.now().toString(),
      );

      await _repository.saveResult(item);
      return item;
    } on Failure {
      rethrow;
    } catch (e) {
      throw ProcessingFailure('Failed to save text result: $e');
    }
  }
}