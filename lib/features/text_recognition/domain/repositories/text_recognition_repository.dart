import '../../../home/data/models/history_model.dart';

/// Abstract repository interface for text recognition data operations.
///
/// [TextRecognitionRepository] defines the contract for persisting
/// text recognition results and history records. Implementations
/// such as [TextRecognitionRepositoryImpl] provide the concrete
/// database interaction logic.
abstract class TextRecognitionRepository {
  /// Saves a text recognition result [item] to the database.
  Future<void> saveResult(HistoryModel item);

  /// Adds a [history] record (e.g., PDF export) to the database.
  Future<void> addHistory(HistoryModel history);
}