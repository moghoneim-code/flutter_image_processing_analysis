// lib/features/text_recognition/presentation/views/widgets/text_action_buttons.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

import '../../../../../../../core/utils/utils/constants/colors/app_colors.dart';
import '../../../../controllers/text_recognition_controller.dart';
// lib/features/text_recognition/presentation/views/widgets/text_action_buttons.dart
class TextActionButtons extends GetView<TextRecognitionController> {
  const TextActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildButton(
          label: "COPY",
          icon: Icons.copy_rounded,
          bgColor: AppColors.bgSecondary,
          borderColor: AppColors.greyBorder,
          textColor: AppColors.white,
          onTap: () => controller.copyToClipboard(),
        ),
        const SizedBox(width: 12),
        _buildGradientButton(
          label: "SHARE",
          icon: Icons.share_rounded,
          onTap: () => controller.shareText(),
        ),
      ],
    );
  }

  Widget _buildButton({required String label, required IconData icon, required Color bgColor, required Color borderColor, required Color textColor, required VoidCallback onTap}) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: textColor, size: 18),
              const SizedBox(width: 8),
              Text(label, style: TextStyle(color: textColor, fontSize: 13, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGradientButton({required String label, required IconData icon, required VoidCallback onTap}) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: AppColors.white, size: 18),
              const SizedBox(width: 8),
              Text(label, style: TextStyle(color: AppColors.white, fontSize: 13, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}