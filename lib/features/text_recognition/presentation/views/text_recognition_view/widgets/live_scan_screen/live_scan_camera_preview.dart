import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../core/utils/constants/colors/app_colors.dart';
import '../../../../controllers/live_text_controller.dart';

/// Displays the live camera feed for real-time text scanning.
///
/// [LiveScanCameraPreview] fills the available space with the camera
/// preview when the [CameraController] is initialized, or shows a
/// loading spinner while the camera is starting up.
class LiveScanCameraPreview extends GetView<LiveTextController> {
  /// Creates a [LiveScanCameraPreview] widget.
  const LiveScanCameraPreview({super.key});

  @override
  Widget build(BuildContext context) {
    if (controller.cameraController != null &&
        controller.cameraController!.value.isInitialized) {
      return Positioned.fill(
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: controller.cameraController!.value.previewSize!.height,
            height: controller.cameraController!.value.previewSize!.width,
            child: CameraPreview(controller.cameraController!),
          ),
        ),
      );
    }

    return Center(
      child: CircularProgressIndicator(color: AppColors.elfOwl),
    );
  }
}
