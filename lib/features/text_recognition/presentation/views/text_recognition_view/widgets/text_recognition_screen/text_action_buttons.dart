import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

import '../../../../../../../core/utils/constants/colors/app_colors.dart';
import '../../../../controllers/text_recognition_controller.dart';

/// A row of action buttons for copying and sharing recognized text.
///
/// [TextActionButtons] provides two side-by-side buttons:
/// - **COPY**: Copies the recognized text to the clipboard via
///   [TextRecognitionController.copyToClipboard].
/// - **SHARE**: Opens the platform share sheet via
///   [TextRecognitionController.shareText].
class TextActionButtons extends GetView<TextRecognitionController> {
  /// Creates a [TextActionButtons] widget.
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

  /// Builds a flat action button with a solid background and border.
  ///
  /// - [label]: The button text label.
  /// - [icon]: The leading icon.
  /// - [bgColor]: The background color.
  /// - [borderColor]: The border color.
  /// - [textColor]: The text and icon color.
  /// - [onTap]: Callback invoked on button press.
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

  /// Builds a gradient-styled action button using the app primary gradient.
  ///
  /// - [label]: The button text label.
  /// - [icon]: The leading icon.
  /// - [onTap]: Callback invoked on button press.
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