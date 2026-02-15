import '../../../../core/errors/failures.dart';
import '../../../../core/services/database/app_database.dart';
import '../../../home/data/models/history_model.dart';
import '../../domain/repositories/text_recognition_repository.dart';

/// Concrete implementation of [TextRecognitionRepository] backed by [AppDatabase].
///
/// [TextRecognitionRepositoryImpl] delegates all persistence operations
/// to the injected [AppDatabase] and wraps errors in [DatabaseFailure].
class TextRecognitionRepositoryImpl implements TextRecognitionRepository {
  /// The database instance used for all data operations.
  final AppDatabase database;

  /// Creates a [TextRecognitionRepositoryImpl] with the given [database].
  TextRecognitionRepositoryImpl(this.database);

  @override
  Future<void> saveResult(HistoryModel item) async {
    try {
      await database.insert(item);
    } on DatabaseFailure {
      rethrow;
    } catch (e) {
      throw DatabaseFailure('Failed to save text recognition result: $e');
    }
  }

  @override
  Future<void> addHistory(HistoryModel history) async {
    try {
      await database.insert(history);
    } on DatabaseFailure {
      rethrow;
    } catch (e) {
      throw DatabaseFailure('Failed to add history: $e');
    }
  }
}