import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../core/shared/widgets/buttons/app_pdf_export_button.dart';
import '../../../../controllers/face_detection_controller.dart';

/// A PDF export button for the face detection screen.
///
/// [FacePdfButton] reactively observes [FaceDetectionController.isExporting]
/// to disable itself and show a loading spinner while the PDF is being
/// generated. When tapped, it calls [FaceDetectionController.generatePdf].
class FacePdfButton extends GetView<FaceDetectionController> {
  /// Creates a [FacePdfButton] widget.
  const FacePdfButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => AppPdfExportButton(
      label: "SAVE ANALYSIS AS PDF",
      loadingLabel: "GENERATING PDF...",
      isLoading: controller.isExporting.value,
      onPressed: () => controller.generatePdf(),
    ));
  }
}