import 'package:flutter/material.dart';
import 'package:flutter_image_processing_analysis/core/utils/constants/colors/app_colors.dart';
import 'package:get/get.dart';
import '../../../controllers/text_recognition_controller.dart';
import '../widgets/text_recognition_screen/pdf_export_button.dart';
import '../widgets/text_recognition_screen/picker_source_sheet.dart';
import '../widgets/text_recognition_screen/recognition_image_header.dart';
import '../widgets/text_recognition_screen/result_text_card.dart';
import '../widgets/text_recognition_screen/text_action_buttons.dart';

/// Main screen for displaying OCR text recognition results.
///
/// [TextRecognitionScreen] presents the scanned image, the extracted
/// text, and action buttons for copying, sharing, and exporting to PDF.
/// It also provides a camera button that opens [PickerSourceSheet] to
/// select a new image from the gallery or camera.
///
/// This screen is bound to [TextRecognitionController] via GetX and
/// accessed through the `/text-recognition` route.
class TextRecognitionScreen extends GetView<TextRecognitionController> {
  /// Creates a [TextRecognitionScreen] widget.
  const TextRecognitionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("AI Scanner", style: TextStyle(fontSize: 18)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            RecognitionImageHeader(
              onCameraTap: () => _showPickerOptions(),
            ),
            const SizedBox(height: 24),
            const ResultTextCard(),
            const SizedBox(height: 32),
            const PdfExportButton(),
            const SizedBox(height: 32),
            const TextActionButtons(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  /// Opens the [PickerSourceSheet] bottom sheet for selecting a new image source.
  void _showPickerOptions() {
    Get.bottomSheet(
      const PickerSourceSheet(),
    );
  }
}