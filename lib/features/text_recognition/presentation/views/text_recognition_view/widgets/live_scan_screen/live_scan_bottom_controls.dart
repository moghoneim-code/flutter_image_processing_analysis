import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../core/utils/constants/colors/app_colors.dart';
import '../../../../controllers/live_text_controller.dart';

/// Bottom control bar with close, capture, and pause/resume buttons.
///
/// [LiveScanBottomControls] provides three actions:
/// - **Close**: Navigates back to the previous screen.
/// - **Capture**: Takes a photo and saves the recognized text via
///   [LiveTextController.captureAndSave].
/// - **Pause/Resume**: Toggles the live scanning state via
///   [LiveTextController.togglePause].
class LiveScanBottomControls extends GetView<LiveTextController> {
  /// Creates a [LiveScanBottomControls] widget.
  const LiveScanBottomControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 40,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CircleAvatar(
            backgroundColor: Colors.black26,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Get.back(),
            ),
          ),
          GestureDetector(
            onTap: () => controller.captureAndSave(),
            child: Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4),
                gradient: AppColors.primaryGradient,
              ),
              child: const Icon(
                Icons.save_alt_rounded,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
          CircleAvatar(
            backgroundColor: Colors.black26,
            child: IconButton(
              icon: Obx(
                () => Icon(
                  controller.isPaused.value ? Icons.play_arrow : Icons.pause,
                  color: Colors.white,
                ),
              ),
              onPressed: () => controller.togglePause(),
            ),
          ),
        ],
      ),
    );
  }
}
