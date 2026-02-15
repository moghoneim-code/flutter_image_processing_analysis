import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../core/utils/constants/colors/app_colors.dart';
import '../../../controllers/live_text_controller.dart';

/// Full-screen live camera OCR scanning interface.
///
/// [LiveScanScreen] displays the device camera feed in real-time and
/// overlays the recognized text at the top of the screen. It provides
/// controls for pausing/resuming the scan, capturing and saving the
/// current result, and closing the screen.
///
/// This screen is bound to [LiveTextController] via [LiveScanBinding]
/// and accessed through the `/live-text-recognition` route.
class LiveScanScreen extends GetView<LiveTextController> {
  /// Creates a [LiveScanScreen] widget.
  const LiveScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LiveTextController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              if (controller.cameraController != null &&
                  controller.cameraController!.value.isInitialized)
                Positioned.fill(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: controller
                          ?.cameraController!
                          .value
                          .previewSize!
                          .height,
                      height: controller
                          ?.cameraController!
                          .value
                          .previewSize!
                          .width,
                      child: CameraPreview(controller.cameraController!),
                    ),
                  ),
                )
              else
                Center(
                  child: CircularProgressIndicator(color: AppColors.elfOwl),
                ),

              _buildTopOverlay(),

              _buildBottomControls(),
            ],
          ),
        );
      },
    );
  }

  /// Builds the semi-transparent overlay displaying the recognized text.
  ///
  /// Positioned at the top of the screen and updates reactively via
  /// [LiveTextController.recognizedText].
  Widget _buildTopOverlay() {
    return Positioned(
      top: 60,
      left: 20,
      right: 20,
      child: Obx(
        () => Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.amber.withOpacity(0.5)),
          ),
          child: Text(
            controller.recognizedText.value.isEmpty
                ? "Align text within the frame..."
                : controller.recognizedText.value,
            style: const TextStyle(color: Colors.white, fontSize: 16),
            textAlign: TextAlign.center,
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  /// Builds the bottom control bar with close, capture, and pause buttons.
  ///
  /// The capture button triggers [LiveTextController.captureAndSave] to
  /// take a photo and persist the recognized text. The pause button
  /// toggles the live scanning state.
  Widget _buildBottomControls() {
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