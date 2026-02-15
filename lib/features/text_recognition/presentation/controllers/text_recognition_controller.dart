import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/errors/error_handler.dart';
import '../../../../core/helper/snackbar_helper.dart';
import '../../../../core/services/history_refresh_service.dart';
import '../../../../core/services/image_picker/image_picker_service.dart';
import '../../../processing/domain/entities/processing_result.dart';
import '../../domain/use_cases/copy_to_clipboard_use_case.dart';
import '../../domain/use_cases/export_document_use_case.dart';
import '../../domain/use_cases/recognize_text_use_case.dart';
import '../../domain/use_cases/share_text_use_case.dart';

/// Controller managing the text recognition screen state and actions.
///
/// [TextRecognitionController] handles OCR processing, PDF export,
/// clipboard copy, text sharing, and new image selection. It receives
/// a [ProcessingResult] or [File] via route arguments on initialization.
///
/// Dependencies:
/// - [recognizeTextUseCase]: Performs OCR and saves the result.
/// - [copyUseCase]: Copies recognized text to the clipboard.
/// - [shareUseCase]: Shares recognized text via the platform share sheet.
/// - [exportUseCase]: Exports the image as a PDF document.
class TextRecognitionController extends GetxController {
  /// Use case for OCR text extraction and persistence.
  final RecognizeTextUseCase recognizeTextUseCase;

  /// Use case for copying text to clipboard.
  final CopyToClipboardUseCase copyUseCase;

  /// Use case for sharing text content.
  final ShareTextUseCase shareUseCase;

  /// Use case for PDF document export.
  final ExportDocumentUseCase exportUseCase;

  /// Service for picking and cropping replacement images.
  final ImagePickerService _imagePickerService = ImagePickerService();

  /// Service for notifying the home screen of history changes.
  late final HistoryRefreshService _refreshService;

  /// The currently selected image file, or `null` if none is selected.
  final Rxn<File> selectedImage = Rxn<File>();

  /// The recognized text content displayed in the UI.
  final RxString recognizedText = "Initializing Owl OCR...".obs;

  /// Whether an OCR or export operation is currently in progress.
  final RxBool isProcessing = false.obs;

  /// Creates a [TextRecognitionController] with the required use cases.
  TextRecognitionController({
    required this.recognizeTextUseCase,
    required this.copyUseCase,
    required this.shareUseCase,
    required this.exportUseCase,
  });

  @override
  void onInit() {
    super.onInit();
    _refreshService = Get.find<HistoryRefreshService>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleInitialArguments();
    });
  }

  /// Processes the initial route arguments to set up the screen state.
  ///
  /// Accepts either a [ProcessingResult] (with optional pre-extracted text)
  /// or a raw [File]. Navigates back if no valid argument is provided.
  void _handleInitialArguments() {
    if (Get.arguments is ProcessingResult) {
      final result = Get.arguments as ProcessingResult;
      selectedImage.value = result.file;
      if (result.extractedText != null && result.extractedText!.isNotEmpty) {
        recognizedText.value = result.extractedText!;
      } else {
        processImage();
      }
    } else if (Get.arguments is File) {
      selectedImage.value = Get.arguments;
      processImage();
    } else {
      Get.back();
      SnackBarHelper.showErrorMessage("No valid image source found.");
    }
  }

  /// Runs OCR on the currently selected image.
  ///
  /// Updates [recognizedText] with the extraction result and
  /// notifies [HistoryRefreshService] to update the home screen.
  Future<void> processImage() async {
    if (selectedImage.value == null) return;

    try {
      isProcessing.value = true;
      recognizedText.value = "Analyzing document pixels...";

      final resultModel = await recognizeTextUseCase.execute(selectedImage.value!);

      recognizedText.value = resultModel.result;
      _refreshService.notify();
    } catch (e) {
      recognizedText.value = "Failed to extract text. Please try again.";
      ErrorHandler.handle(e, fallbackMessage: 'OCR Engine failed to read this document.');
    } finally {
      isProcessing.value = false;
    }
  }

  /// Generates a PDF from the selected image and saves it to history.
  Future<void> generatePDF() async {
    if (selectedImage.value == null || recognizedText.value.isEmpty) return;

    try {
      isProcessing.value = true;

      await exportUseCase.execute(selectedImage.value!, recognizedText.value);

      _refreshService.notify();
      SnackBarHelper.showSuccessMessage("PDF generated and saved to your history.");
    } catch (e) {
      ErrorHandler.handle(e, fallbackMessage: 'Could not export PDF.');
    } finally {
      isProcessing.value = false;
    }
  }

  /// Picks a new image from the given [source] and runs OCR on it.
  Future<void> pickNewImage(ImageSource source) async {
    await ErrorHandler.guardVoid(
      () async {
        final File? image = await _imagePickerService.pickImage(source);
        if (image != null) {
          selectedImage.value = image;
          processImage();
        }
      },
      fallbackMessage: 'Failed to pick image.',
    );
  }

  /// Copies the recognized text to the system clipboard.
  void copyToClipboard() async {
    if (recognizedText.value.isNotEmpty && !isProcessing.value) {
      final success = await ErrorHandler.guardVoid(
        () => copyUseCase.execute(recognizedText.value),
        fallbackMessage: 'Failed to copy text.',
      );
      if (success) {
        SnackBarHelper.showInfoMessage("Text copied to clipboard.");
      }
    }
  }

  /// Shares the recognized text via the platform share sheet.
  void shareText() async {
    if (recognizedText.value.isNotEmpty && !isProcessing.value) {
      await ErrorHandler.guardVoid(
        () => shareUseCase.execute(recognizedText.value),
        fallbackMessage: 'Failed to share text.',
      );
    }
  }
}