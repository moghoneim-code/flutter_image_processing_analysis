import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../core/utils/utils/constants/colors/app_colors.dart';
import '../../../../controllers/text_recognition_controller.dart';

class RecognitionImageHeader extends GetView<TextRecognitionController> {
  final VoidCallback onCameraTap;
  const RecognitionImageHeader({super.key, required this.onCameraTap});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Obx(() => Container(
          height: 240,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: AppColors.bgSecondary,
            border: Border.all(color: AppColors.greatGreyOwl.withValues(alpha: 0.5), width: 1.5),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: controller.selectedImage.value != null
                ? Image.file(controller.selectedImage.value!, fit: BoxFit.cover)
                : Icon(Icons.image, color: AppColors.greyText, size: 50),
          ),
        )),
        Padding(
          padding: const EdgeInsets.all(12),
          child: FloatingActionButton(
            mini: true,
            backgroundColor: AppColors.burrowingOwl ,
            onPressed: onCameraTap,
            child: Icon(Icons.camera_alt, color: AppColors.white, size: 18),
          ),
        ),
      ],
    );
  }
}