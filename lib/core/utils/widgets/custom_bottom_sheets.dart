import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../features/text_recognition/presentation/bindings/live_scan_binding.dart';
import '../../../../features/text_recognition/presentation/views/text_recognition_view/screens/live_scan_screen.dart';
import '../constants/colors/app_colors.dart';
import '../../../../features/home/presentation/views/home_view/widgets/capture_option_item.dart';

/// Utility class for displaying custom bottom sheets.
///
/// [CustomBottomSheets] provides static methods to show styled
/// modal bottom sheets for image capture method selection.
class CustomBottomSheets {
  CustomBottomSheets._();

  /// Displays a bottom sheet with image capture options.
  ///
  /// Presents three capture methods to the user:
  /// - **Camera**: Takes a photo using the device camera via [onCameraTap].
  /// - **Live AI**: Navigates to the [LiveScanScreen] for real-time OCR.
  /// - **Gallery**: Selects an image from the gallery via [onGalleryTap].
  ///
  /// - [onCameraTap]: Callback invoked when the camera option is selected.
  /// - [onGalleryTap]: Callback invoked when the gallery option is selected.
  static void showImagePicker({
    required VoidCallback onCameraTap,
    required VoidCallback onGalleryTap,
  }) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.bgSecondary,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          border: Border.all(
            color: AppColors.greatGreyOwl.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.greatGreyOwl.withOpacity(0.4),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 30),

            const Text(
              "Capture Method",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),

            Wrap(
              spacing: 20,
              runSpacing: 20,
              alignment: WrapAlignment.center,
              children: [
                CaptureOptionItem(
                  label: "Camera",
                  icon: Icons.camera_alt_rounded,
                  onTap: () {
                    Get.back();
                    onCameraTap();
                  },
                ),
                CaptureOptionItem(
                  label: "Live AI",
                  icon: Icons.auto_awesome_rounded,
                  onTap: () {
                    Get.back();
                    Get.to(
                          () => const LiveScanScreen(),
                      binding: LiveScanBinding(),
                    );
                  },
                ),
                CaptureOptionItem(
                  label: "Gallery",
                  icon: Icons.photo_library_rounded,
                  onTap: () {
                    Get.back();
                    onGalleryTap();
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }
}