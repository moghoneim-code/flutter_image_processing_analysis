import '../../../../features/home/data/models/history_model.dart';

/// Abstract interface for the application's local database.
///
/// [AppDatabase] defines the contract for all CRUD operations on
/// [HistoryModel] records. Implementations such as [SqliteDatabaseImpl]
/// provide the concrete persistence logic.
abstract class AppDatabase {
  /// Initializes the database connection and creates tables if needed.
  Future<void> init();

  /// Inserts a [history] record into the database.
  ///
  /// Returns the row ID of the newly inserted record.
  Future<int> insert(HistoryModel history);

  /// Retrieves all [HistoryModel] records from the database.
  ///
  /// Records are returned in descending order by ID (most recent first).
  Future<List<HistoryModel>> getAll();

  /// Deletes the history record with the given [id].
  ///
  /// Returns the number of rows affected.
  Future<int> delete(int id);

  /// Closes the database connection and releases resources.
  Future<void> close();
}