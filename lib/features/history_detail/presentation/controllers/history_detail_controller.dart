import 'dart:io';
import 'package:get/get.dart';
import '../../../../core/errors/error_handler.dart';
import '../../../../core/helper/snackbar_helper.dart';
import '../../../../core/services/history_refresh_service.dart';
import '../../../home/data/models/history_model.dart';
import '../../../home/domain/use_cases/delete_history_use_case.dart';
import '../../domain/use_cases/open_history_file_use_case.dart';
import '../../domain/use_cases/share_history_file_use_case.dart';

/// Controller for the history detail screen.
///
/// [HistoryDetailController] receives a [HistoryModel] via [Get.arguments]
/// and exposes the item's data along with computed file metadata.
/// It provides actions for sharing, opening, and deleting the history record.
class HistoryDetailController extends GetxController {
  final DeleteHistoryUseCase _deleteHistoryUseCase;
  final ShareHistoryFileUseCase _shareHistoryFileUseCase;
  final OpenHistoryFileUseCase _openHistoryFileUseCase;

  HistoryDetailController({
    required DeleteHistoryUseCase deleteHistoryUseCase,
    required ShareHistoryFileUseCase shareHistoryFileUseCase,
    required OpenHistoryFileUseCase openHistoryFileUseCase,
  })  : _deleteHistoryUseCase = deleteHistoryUseCase,
        _shareHistoryFileUseCase = shareHistoryFileUseCase,
        _openHistoryFileUseCase = openHistoryFileUseCase;

  /// The history item being displayed.
  late final HistoryModel historyItem;

  /// Whether the file exists on disk.
  final fileExists = false.obs;

  /// Human-readable file size string.
  final fileSize = ''.obs;

  /// Whether an async action is currently in progress.
  final isProcessing = false.obs;

  @override
  void onInit() {
    super.onInit();
    historyItem = Get.arguments as HistoryModel;
    _loadFileMetadata();
  }

  /// Loads file existence and size metadata from the file system.
  void _loadFileMetadata() {
    final file = File(historyItem.imagePath);
    fileExists.value = file.existsSync();
    if (fileExists.value) {
      final bytes = file.lengthSync();
      fileSize.value = _formatFileSize(bytes);
    }
  }

  /// Formats a byte count into a human-readable string.
  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  /// Shares the history file via the platform share sheet.
  Future<void> shareFile() async {
    isProcessing.value = true;
    await ErrorHandler.guardVoid(
      () => _shareHistoryFileUseCase.execute(
        File(historyItem.imagePath),
        text: historyItem.result.isNotEmpty ? historyItem.result : null,
      ),
      fallbackMessage: 'Failed to share file.',
    );
    isProcessing.value = false;
  }

  /// Opens the history file in the device's default application.
  Future<void> openFile() async {
    isProcessing.value = true;
    await ErrorHandler.guardVoid(
      () => _openHistoryFileUseCase.execute(historyItem.imagePath),
      fallbackMessage: 'Failed to open file.',
    );
    isProcessing.value = false;
  }

  /// Deletes the history record, navigates back, and shows a success snackbar.
  Future<void> deleteItem() async {
    if (historyItem.id == null) return;
    isProcessing.value = true;
    final success = await ErrorHandler.guardVoid(
      () => _deleteHistoryUseCase.execute(historyItem.id!),
      fallbackMessage: 'Failed to delete history item.',
    );

    if (success) {
      Get.find<HistoryRefreshService>().notify();
      Get.back();
      SnackBarHelper.showSuccessMessage('History item deleted successfully.');
    } else {
      isProcessing.value = false;
    }
  }
}
