import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../core/shared/widgets/buttons/app_action_button.dart';
import '../../../../controllers/face_detection_controller.dart';

/// A row of action buttons for the face detection results screen.
///
/// [FaceActionButtons] provides two side-by-side buttons:
/// - **SHARE**: Shares the face composite image via the platform
///   share sheet using [FaceDetectionController.shareImage].
/// - **RE-SCAN**: Navigates back to the previous screen for a new scan.
class FaceActionButtons extends GetView<FaceDetectionController> {
  /// Creates a [FaceActionButtons] widget.
  const FaceActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppActionButton(
            label: "SHARE",
            icon: Icons.share_rounded,
            style: AppButtonStyle.solid,
            onTap: () => controller.shareImage(),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: AppActionButton(
            label: "RE-SCAN",
            icon: Icons.refresh_rounded,
            style: AppButtonStyle.gradient,
            onTap: () => Get.back(),
          ),
        ),
      ],
    );
  }
}