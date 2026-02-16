import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/live_text_controller.dart';
import '../widgets/live_scan_screen/live_scan_bottom_controls.dart';
import '../widgets/live_scan_screen/live_scan_camera_preview.dart';
import '../widgets/live_scan_screen/live_scan_text_overlay.dart';

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
      builder: (_) {
        return const Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              LiveScanCameraPreview(),
              LiveScanTextOverlay(),
              LiveScanBottomControls(),
            ],
          ),
        );
      },
    );
  }
}
