import '../../../../core/errors/failures.dart';
import '../../data/models/history_model.dart';
import '../repositories/home_repository.dart';

/// Use case for retrieving all processing history records.
///
/// [GetHistoryUseCase] encapsulates the business logic for fetching
/// the complete history list from the [HomeRepository].
class GetHistoryUseCase {
  /// The repository used to access history data.
  final HomeRepository repository;

  /// Creates a [GetHistoryUseCase] with the given [repository].
  GetHistoryUseCase(this.repository);

  /// Executes the use case and returns a list of [HistoryModel].
  ///
  /// Throws a [DatabaseFailure] if the operation fails.
  Future<List<HistoryModel>> call() async {
    try {
      return await repository.getAllHistory();
    } on Failure {
      rethrow;
    } catch (e) {
      throw DatabaseFailure('Failed to get history: $e');
    }
  }
}