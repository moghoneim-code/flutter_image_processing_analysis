import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../../../core/utils/utils/constants/colors/app_colors.dart';
import '../../../../controllers/text_recognition_controller.dart';
// lib/features/text_recognition/presentation/views/widgets/picker_source_sheet.dart
class PickerSourceSheet extends GetView<TextRecognitionController> {
  const PickerSourceSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.bgPrimary,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.greatGreyOwl, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 24),
          _buildOption(Icons.photo_library_outlined, "Gallery", AppColors.burrowingOwl, () => controller.pickNewImage(ImageSource.gallery)),
          const SizedBox(height: 12),
          _buildOption(Icons.camera_alt_outlined, "Camera", AppColors.burrowingOwl, () => controller.pickNewImage(ImageSource.camera)),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildOption(IconData icon, String label, Color color, VoidCallback onTap) {
    return ListTile(
      onTap: () { Get.back(); onTap(); },
      leading: Icon(icon, color: color),
      title: Text(label, style: TextStyle(color: AppColors.white, fontWeight: FontWeight.w500)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      tileColor: AppColors.bgSecondary,
    );
  }
}