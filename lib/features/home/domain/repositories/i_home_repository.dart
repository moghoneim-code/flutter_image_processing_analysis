import '../../data/models/history_model.dart';

/// Abstract repository interface for home feature data operations.
///
/// [IHomeRepository] defines the contract for managing history records.
/// Implementations such as [HomeRepositoryImpl] provide the concrete
/// database interaction logic.
abstract class IHomeRepository {
  /// Retrieves all history records from the database.
  ///
  /// Returns a list of [HistoryModel] ordered by most recent first.
  Future<List<HistoryModel>> getAllHistory();

  /// Deletes the history record with the given [id].
  Future<void> deleteHistoryItem(int id);

  /// Adds a new [item] to the history database.
  Future<void> addHistoryItem(HistoryModel item);
}