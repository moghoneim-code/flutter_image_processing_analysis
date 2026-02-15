import 'dart:io';
import 'package:open_filex/open_filex.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/repositories/i_history_detail_repository.dart';

/// Concrete implementation of [IHistoryDetailRepository].
///
/// [HistoryDetailRepositoryImpl] delegates file sharing to [Share]
/// and file opening to [OpenFiles], wrapping platform errors in
/// domain-level failure types.
class HistoryDetailRepositoryImpl implements IHistoryDetailRepository {
  @override
  Future<void> shareFile(File file, {String? text}) async {
    try {
      await Share.shareXFiles(
        [XFile(file.path)],
        text: text,
      );
    } catch (e) {
      throw ShareFailure('Failed to share file: $e');
    }
  }

  @override
  Future<void> openFile(String filePath) async {
    try {
      final result = await OpenFilex.open(filePath);
      if (result.type != ResultType.done) {
        throw ProcessingFailure('Could not open file: ${result.message}');
      }
    } on Failure {
      rethrow;
    } catch (e) {
      throw ProcessingFailure('Failed to open file: $e');
    }
  }
}
