import 'dart:io';

/// Abstract repository interface for history detail data operations.
///
/// [HistoryDetailRepository] defines the contract for sharing
/// and opening history files. Implementations such as
/// [HistoryDetailRepositoryImpl] provide the concrete
/// platform interaction logic.
abstract class HistoryDetailRepository {
  /// Shares the given [file] via the platform share sheet.
  ///
  /// An optional [text] can be included alongside the file.
  Future<void> shareFile(File file, {String? text});

  /// Opens the file at the given [filePath] in the device's default application.
  Future<void> openFile(String filePath);
}
