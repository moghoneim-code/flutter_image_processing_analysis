import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../core/utils/constants/colors/app_colors.dart';
import '../../../../controllers/face_detection_controller.dart';

/// A row of transform controls for rotating and flipping the face composite.
///
/// Provides four icon buttons: rotate left, rotate right, flip horizontal,
/// and flip vertical. Each button calls the corresponding method on
/// [FaceDetectionController] for instant visual feedback.
class FaceTransformButtons extends GetView<FaceDetectionController> {
  const FaceTransformButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.bgSecondary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.greyBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _TransformIconButton(
            icon: Icons.rotate_left_rounded,
            tooltip: 'Rotate Left',
            onTap: controller.rotateLeft,
          ),
          _TransformIconButton(
            icon: Icons.rotate_right_rounded,
            tooltip: 'Rotate Right',
            onTap: controller.rotateRight,
          ),
          _TransformIconButton(
            icon: Icons.flip_rounded,
            tooltip: 'Flip Horizontal',
            onTap: controller.flipHorizontal,
          ),
          _TransformIconButton(
            icon: Icons.flip_rounded,
            tooltip: 'Flip Vertical',
            isVerticalFlip: true,
            onTap: controller.flipVertical,
          ),
        ],
      ),
    );
  }
}

class _TransformIconButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final bool isVerticalFlip;

  const _TransformIconButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.isVerticalFlip = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget iconWidget = Icon(icon, color: Colors.white, size: 22);

    if (isVerticalFlip) {
      iconWidget = Transform.rotate(
        angle: 1.5708, // 90° in radians
        child: iconWidget,
      );
    }

    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: iconWidget,
          ),
        ),
      ),
    );
  }
}
