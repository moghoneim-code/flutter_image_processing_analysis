import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../core/shared/widgets/buttons/app_pdf_export_button.dart';
import '../../../../controllers/text_recognition_controller.dart';

/// A PDF export button for the text recognition screen.
///
/// [PdfExportButton] reactively observes [TextRecognitionController.isProcessing]
/// to disable itself and show a loading spinner while a PDF is being generated.
/// When tapped, it calls [TextRecognitionController.generatePDF].
class PdfExportButton extends GetView<TextRecognitionController> {
  /// Creates a [PdfExportButton] widget.
  const PdfExportButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => AppPdfExportButton(
      label: "SAVE AS PDF DOCUMENT",
      loadingLabel: "GENERATING PDF...",
      isLoading: controller.isProcessing.value && controller.recognizedText.value == "Processing...",
      onPressed: () => controller.generatePDF(),
    ));
  }
}