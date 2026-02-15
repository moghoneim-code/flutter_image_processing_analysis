import '../../../../core/errors/failures.dart';
import '../repositories/history_detail_repository.dart';

/// Use case for opening a history file in the device's default application.
///
/// [OpenHistoryFileUseCase] delegates to [HistoryDetailRepository]
/// to open a processed image or PDF file using the platform file viewer.
class OpenHistoryFileUseCase {
  /// The repository used to perform the open operation.
  final HistoryDetailRepository repository;

  /// Creates an [OpenHistoryFileUseCase] with the given [repository].
  OpenHistoryFileUseCase(this.repository);

  /// Opens the file at the given [filePath] in the default app.
  ///
  /// Throws a [ProcessingFailure] if the file cannot be opened.
  Future<void> execute(String filePath) async {
    try {
      return await repository.openFile(filePath);
    } on Failure {
      rethrow;
    } catch (e) {
      throw ProcessingFailure('Failed to open file: $e');
    }
  }
}
