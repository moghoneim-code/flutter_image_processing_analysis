import 'dart:io';

import 'package:get/get.dart';
import '../../../../core/errors/error_handler.dart';
import '../../../../core/services/image_processing/image_pre_processor.dart';
import '../../../../core/services/refresh/history_refresh_service.dart';
import '../../../../core/utils/constants/enums/processing_type.dart';
import '../../../home/data/models/history_model.dart';
import '../../../processing/domain/entities/processing_result.dart';
import '../../domain/use_cases/export_face_pdf_use_case.dart';
import '../../domain/use_cases/save_face_history_use_case.dart';
import '../../domain/use_cases/share_face_result_use_case.dart';

/// Controller managing the face detection results screen.
///
/// [FaceDetectionController] receives a [ProcessingResult] via route
/// arguments, auto-saves the face composite to history on initialization,
/// and provides actions for sharing the image and exporting it as a PDF.
///
/// Dependencies:
/// - [saveHistoryUseCase]: Persists the face detection result to the database.
/// - [exportPdfUseCase]: Generates a PDF from the face composite image.
/// - [shareUseCase]: Shares the image or PDF via the platform share sheet.
class FaceDetectionController extends GetxController {
  /// Use case for saving face detection results to history.
  final SaveFaceHistoryUseCase saveHistoryUseCase;

  /// Use case for exporting the face composite as a PDF document.
  final ExportFacePdfUseCase exportPdfUseCase;

  /// Use case for sharing the face detection result file.
  final ShareFaceResultUseCase shareUseCase;

  /// Service for applying image transforms before sharing/exporting.
  final ImagePreProcessor imagePreProcessor;

  /// Creates a [FaceDetectionController] with the required use cases.
  FaceDetectionController({
    required this.saveHistoryUseCase,
    required this.exportPdfUseCase,
    required this.shareUseCase,
    required this.imagePreProcessor,
  });

  /// Service for notifying the home screen of history changes.
  late final HistoryRefreshService _refreshService;

  /// The processing result containing the face composite image.
  late ProcessingResult result;

  /// Whether a PDF export operation is currently in progress.
  final isExporting = false.obs;

  /// Number of 90° clockwise rotations applied (0–3).
  final quarterTurns = 0.obs;

  /// Whether the image is flipped horizontally.
  final isFlippedHorizontally = false.obs;

  /// Whether the image is flipped vertically.
  final isFlippedVertically = false.obs;

  /// Rotates the preview 90° clockwise.
  void rotateRight() => quarterTurns.value = (quarterTurns.value + 1) % 4;

  /// Rotates the preview 90° counter-clockwise.
  void rotateLeft() => quarterTurns.value = (quarterTurns.value + 3) % 4;

  /// Toggles horizontal flip.
  void flipHorizontal() => isFlippedHorizontally.toggle();

  /// Toggles vertical flip.
  void flipVertical() => isFlippedVertically.toggle();

  /// Whether any transform is currently applied.
  bool get _hasTransforms =>
      quarterTurns.value != 0 ||
      isFlippedHorizontally.value ||
      isFlippedVertically.value;

  /// Applies current transforms to the result file and returns the transformed file.
  Future<File> _getTransformedFile() async {
    if (!_hasTransforms) return result.file;
    return imagePreProcessor.applyTransforms(
      result.file,
      quarterTurns.value,
      isFlippedHorizontally.value,
      isFlippedVertically.value,
    );
  }

  @override
  void onInit() {
    super.onInit();
    _refreshService = Get.find<HistoryRefreshService>();
    if (Get.arguments is ProcessingResult) {
      result = Get.arguments;
      _autoSave();
    }
  }

  /// Automatically saves the face detection result to history on screen entry.
  ///
  /// Creates a [HistoryModel] with the face composite image path and
  /// persists it via [SaveFaceHistoryUseCase], then notifies the
  /// [HistoryRefreshService] to update the home screen.
  void _autoSave() async {
    await ErrorHandler.guardVoid(
      () async {
        final history = HistoryModel(
          imagePath: result.file.path,
          result: "Face composite generated",
          dateTime: DateTime.now().toIso8601String(),
          type: ProcessingType.face,
        );
        await saveHistoryUseCase.execute(history);
        _refreshService.notify();
      },
      fallbackMessage: 'Failed to auto-save face result.',
    );
  }

  /// Shares the face composite image via the platform share sheet.
  ///
  /// Applies any active rotation/flip transforms before sharing.
  void shareImage() async {
    await ErrorHandler.guardVoid(
      () async {
        final file = await _getTransformedFile();
        await shareUseCase.execute(file);
      },
      fallbackMessage: 'Failed to share image.',
    );
  }

  /// Generates a PDF from the face composite and shares it.
  ///
  /// Applies any active rotation/flip transforms before exporting.
  /// Sets [isExporting] to `true` during the operation and resets
  /// it on completion or failure.
  Future<void> generatePdf() async {
    isExporting.value = true;
    try {
      final file = await _getTransformedFile();
      final pdfFile = await exportPdfUseCase.execute(file);
      await shareUseCase.execute(pdfFile);
    } catch (e) {
      ErrorHandler.handle(e, fallbackMessage: 'Failed to generate or share PDF.');
    } finally {
      isExporting.value = false;
    }
  }
}