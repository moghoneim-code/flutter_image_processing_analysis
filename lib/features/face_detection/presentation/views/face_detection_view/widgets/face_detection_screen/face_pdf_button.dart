import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/face_detection_controller.dart';

/// A gradient-styled button that triggers PDF export of the face composite.
///
/// [FacePdfButton] reactively observes [FaceDetectionController.isExporting]
/// to disable itself and show a loading spinner while the PDF is being
/// generated. When tapped, it calls [FaceDetectionController.generatePdf].
class FacePdfButton extends GetView<FaceDetectionController> {
  /// Creates a [FacePdfButton] widget.
  const FacePdfButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [Color(0xFF433660), Color(0xFFE95167)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: ElevatedButton.icon(
        onPressed: controller.isExporting.value ? null : () => controller.generatePdf(),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
        icon: controller.isExporting.value
            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
            : const Icon(Icons.picture_as_pdf_rounded, color: Colors.white),
        label: Text(
          controller.isExporting.value ? "GENERATING PDF..." : "SAVE ANALYSIS AS PDF",
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1),
        ),
      ),
    ));
  }
}