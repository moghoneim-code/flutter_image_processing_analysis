import '../../../../core/errors/failures.dart';
import '../../../home/domain/repositories/home_repository.dart';
import '../../../home/data/models/history_model.dart';
import '../../../../core/utils/constants/enums/processing_type.dart';

/// Use case for saving a live text recognition result to history.
///
/// [SaveLiveResultUseCase] creates a [HistoryModel] from the live
/// scan output and persists it via [HomeRepository].
class SaveLiveResultUseCase {
  /// The repository used to persist the history record.
  final HomeRepository repository;

  /// Creates a [SaveLiveResultUseCase] with the given [repository].
  SaveLiveResultUseCase(this.repository);

  /// Saves the live scan result to the history database.
  ///
  /// - [text]: The recognized text content from the live camera feed.
  /// - [imagePath]: The file path of the captured camera image.
  ///
  /// Throws a [DatabaseFailure] if the save operation fails.
  Future<void> execute({required String text, required String imagePath}) async {
    try {
      final historyItem = HistoryModel(
        result: text,
        imagePath: imagePath,
        dateTime: DateTime.now().toIso8601String(),
        type: ProcessingType.text,
      );

      return await repository.addHistoryItem(historyItem);
    } on Failure {
      rethrow;
    } catch (e) {
      throw DatabaseFailure('Failed to save live result: $e');
    }
  }
}