import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../core/utils/utils/constants/colors/app_colors.dart';
import '../../../../controllers/text_recognition_controller.dart';

class PdfExportButton extends GetView<TextRecognitionController> {
  const PdfExportButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [AppColors.elfOwl, AppColors.burrowingOwl.withOpacity(0.8)],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.elfOwl.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: controller.isProcessing.value ? null : () => controller.generatePDF(),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: controller.isProcessing.value && controller.recognizedText.value == "Processing..."
            ? const SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.picture_as_pdf_rounded, color: Colors.white),
            SizedBox(width: 12),
            Text(
              "SAVE AS PDF DOCUMENT",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
              ),
            ),
          ],
        ),
      ),
    ));
  }
}