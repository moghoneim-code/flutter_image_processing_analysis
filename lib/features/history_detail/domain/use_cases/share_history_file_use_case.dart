import 'dart:io';
import '../../../../core/errors/failures.dart';
import '../repositories/i_history_detail_repository.dart';

/// Use case for sharing a history file via the platform share sheet.
///
/// [ShareHistoryFileUseCase] delegates to [IHistoryDetailRepository]
/// to share a processed image or PDF file with other applications.
class ShareHistoryFileUseCase {
  /// The repository used to perform the share operation.
  final IHistoryDetailRepository repository;

  /// Creates a [ShareHistoryFileUseCase] with the given [repository].
  ShareHistoryFileUseCase(this.repository);

  /// Shares the given [file] using the platform share dialog.
  ///
  /// An optional [text] can be included alongside the file.
  /// Throws a [ShareFailure] if the share operation fails.
  Future<void> execute(File file, {String? text}) async {
    try {
      return await repository.shareFile(file, text: text);
    } on Failure {
      rethrow;
    } catch (e) {
      throw ShareFailure('Failed to share file: $e');
    }
  }
}
