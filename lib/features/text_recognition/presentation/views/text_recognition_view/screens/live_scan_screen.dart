import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../core/utils/utils/constants/colors/app_colors.dart';
import '../../../controllers/live_text_controller.dart';

class LiveScanScreen extends GetView<LiveTextController> {
  const LiveScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // استخدمنا GetBuilder بدون init لأننا سنحقنه عبر الـ Binding
    return GetBuilder<LiveTextController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              // 1. عرض الكاميرا كخلفية
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
                /// replace with a loading indicator while the camera is initializing
                Center(
                  child: CircularProgressIndicator(color: AppColors.elfOwl),
                ),

              // 2. طبقة علوية (Overlay) لإظهار النص المكتشف
              _buildTopOverlay(),

              // 3. أزرار التحكم السفلى
              _buildBottomControls(),
            ],
          ),
        );
      },
    );
  }

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

  Widget _buildBottomControls() {
    return Positioned(
      bottom: 40,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // زر العودة
          CircleAvatar(
            backgroundColor: Colors.black26,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Get.back(),
            ),
          ),
          // زر الحفظ (Capture) باستخدام المسمى الجديد في الكنترولر
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
          // زر التثبيت/الإيقاف المؤقت
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
