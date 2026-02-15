import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../core/shared/widgets/text/highlighted_text.dart';
import '../../../../../../../core/shared/widgets/text_fields/search_text_field.dart';
import '../../../../../../../core/utils/constants/colors/app_colors.dart';
import '../../../../controllers/text_recognition_controller.dart';

/// A card widget displaying the OCR-extracted text content.
///
/// [ResultTextCard] reactively renders the recognized text from
/// [TextRecognitionController.recognizedText]. It shows a "DETECTED TEXT"
/// header with a processing indicator when OCR is active, and presents
/// the extracted text as selectable content below.
class ResultTextCard extends GetView<TextRecognitionController> {
  /// Creates a [ResultTextCard] widget.
  const ResultTextCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.bgPrimary.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.greyBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("DETECTED TEXT",
                  style: TextStyle(color: AppColors.tawnyOwl, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
              Obx(() => controller.isProcessing.value
                  ? SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.burrowingOwl))
                  : Icon(Icons.auto_awesome, color: AppColors.greatGreyOwl, size: 18)),
            ],
          ),
          const SizedBox(height: 12),
          SearchTextField(
            hint: 'Search in detected text...',
            onChanged: (value) => controller.searchQuery.value = value,
          ),
          const SizedBox(height: 16),
          Obx(() => HighlightedText(
            text: controller.recognizedText.value.isEmpty ? "Waiting for Owl to scan..." : controller.recognizedText.value,
            query: controller.searchQuery.value,
            style: TextStyle(color: AppColors.white.withValues(alpha: 0.9), fontSize: 15, height: 1.6),
          )),
        ],
      ),
    );
  }
}