import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../features/text_recognition/presentation/bindings/live_scan_bindings.dart';
import '../../../../features/text_recognition/presentation/views/text_recognition_view/screens/live_scan_screen.dart';
import '../constants/colors/app_colors.dart';
import '../../../../features/home/presentation/views/home_view/widgets/capture_option_item.dart';
// استيراد صفحة اللايف والـ Binding الخاص بها

class CustomBottomSheets {
  CustomBottomSheets._();

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
            // Indicator bar
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

            // عرض الخيارات في Row أو Wrap
            Wrap(
              spacing: 20,
              runSpacing: 20,
              alignment: WrapAlignment.center,
              children: [
                // خيار الكاميرا العادية
                CaptureOptionItem(
                  label: "Camera",
                  icon: Icons.camera_alt_rounded,
                  onTap: () {
                    Get.back(); // إغلاق الشيت أولاً
                    onCameraTap();
                  },
                ),
                CaptureOptionItem(
                  label: "Live AI",
                  icon: Icons.auto_awesome_rounded, // أيقونة مميزة للايف
                  onTap: () {
                    Get.back(); // إغلاق الشيت
                    Get.to(
                          () => const LiveScanScreen(),
                      binding: LiveScanBinding(),
                    );
                  },
                ),
                // خيار الجاليري
                CaptureOptionItem(
                  label: "Gallery",
                  icon: Icons.photo_library_rounded,
                  onTap: () {
                    Get.back(); // إغلاق الشيت
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