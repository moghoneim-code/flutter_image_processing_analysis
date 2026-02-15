import '../../../../core/errors/failures.dart';
import '../../../../core/services/database/app_database.dart';
import '../../domain/repositories/home_repository.dart';
import '../models/history_model.dart';

/// Concrete implementation of [HomeRepository] backed by [AppDatabase].
///
/// [HomeRepositoryImpl] delegates all persistence operations to the
/// injected [AppDatabase] instance and wraps errors in [DatabaseFailure].
class HomeRepositoryImpl implements HomeRepository {
  /// The database instance used for all data operations.
  final AppDatabase database;

  /// Creates a [HomeRepositoryImpl] with the given [database].
  HomeRepositoryImpl(this.database);

  @override
  Future<List<HistoryModel>> getAllHistory() async {
    try {
      return await database.getAll();
    } on DatabaseFailure {
      rethrow;
    } catch (e) {
      throw DatabaseFailure('Failed to load history: $e');
    }
  }

  @override
  Future<void> deleteHistoryItem(int id) async {
    try {
      await database.delete(id);
    } on DatabaseFailure {
      rethrow;
    } catch (e) {
      throw DatabaseFailure('Failed to delete history item: $e');
    }
  }

  @override
  Future<void> addHistoryItem(HistoryModel item) async {
    try {
      await database.insert(item);
    } on DatabaseFailure {
      rethrow;
    } catch (e) {
      throw DatabaseFailure('Failed to add history item: $e');
    }
  }
}