import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../core/utils/constants/colors/app_colors.dart';
import '../../../../../../../core/utils/constants/enums/processing_type.dart';
import '../../../../controllers/history_detail_controller.dart';

/// Displays the processed image from the history record.
///
/// [DetailImagePreview] shows the image file as a full-width rounded
/// preview. For PDF/document types, it displays a PDF icon placeholder.
/// If the file does not exist, an error icon fallback is shown.
class DetailImagePreview extends GetView<HistoryDetailController> {
  const DetailImagePreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 280,
      decoration: BoxDecoration(
        color: AppColors.bgSecondary,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.greyBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Obx(() {
          if (!controller.fileExists.value) return _buildFileNotFound();
          if (controller.historyItem.type == ProcessingType.document) {
            return _buildPdfPlaceholder();
          }
          return _buildImagePreview();
        }),
      ),
    );
  }

  Widget _buildFileNotFound() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.broken_image_rounded,
            color: AppColors.greatGreyOwl,
            size: 48,
          ),
          const SizedBox(height: 12),
          Text(
            "File not found",
            style: TextStyle(color: AppColors.greyText, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildPdfPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.burrowingOwl, AppColors.tawnyOwl],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.picture_as_pdf_rounded,
              color: Colors.white,
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "PDF Document",
            style: TextStyle(
              color: AppColors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePreview() {
    return Image.file(
      File(controller.historyItem.imagePath),
      fit: BoxFit.cover,
      errorBuilder: (_, e, s) => Center(
        child: Icon(
          Icons.broken_image_rounded,
          color: AppColors.greatGreyOwl,
          size: 48,
        ),
      ),
    );
  }
}
