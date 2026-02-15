import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
        _buildButton(
          label: "SHARE",
          icon: Icons.share_rounded,
          color: const Color(0xFF1C1C26),
          onTap: () => controller.shareImage(),
        ),
        const SizedBox(width: 12),
        _buildButton(
          label: "RE-SCAN",
          icon: Icons.refresh_rounded,
          color: const Color(0xFFE95167),
          onTap: () => Get.back(),
        ),
      ],
    );
  }

  /// Builds a single action button with the given style and callback.
  ///
  /// - [label]: The button text label.
  /// - [icon]: The leading icon.
  /// - [color]: The button background color.
  /// - [onTap]: Callback invoked on button press.
  Widget _buildButton({required String label, required IconData icon, required Color color, required VoidCallback onTap}) {
    return Expanded(
      child: SizedBox(
        height: 56,
        child: ElevatedButton.icon(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: color == const Color(0xFF1C1C26)
                  ? BorderSide(color: Colors.white.withOpacity(0.1))
                  : BorderSide.none,
            ),
          ),
          icon: Icon(icon, color: Colors.white, size: 20),
          label: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}