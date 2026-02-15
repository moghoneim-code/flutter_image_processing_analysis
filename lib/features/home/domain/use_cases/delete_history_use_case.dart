import '../../../../core/errors/failures.dart';
import '../repositories/i_home_repository.dart';

/// Use case for deleting a single history record by its ID.
///
/// [DeleteHistoryUseCase] encapsulates the business logic for
/// removing a specific history entry from the [IHomeRepository].
class DeleteHistoryUseCase {
  /// The repository used to perform the deletion.
  final IHomeRepository repository;

  /// Creates a [DeleteHistoryUseCase] with the given [repository].
  DeleteHistoryUseCase(this.repository);

  /// Deletes the history record with the given [id].
  ///
  /// Throws a [DatabaseFailure] if the operation fails.
  Future<void> execute(int id) async {
    try {
      return await repository.deleteHistoryItem(id);
    } on Failure {
      rethrow;
    } catch (e) {
      throw DatabaseFailure('Failed to delete history item: $e');
    }
  }
}