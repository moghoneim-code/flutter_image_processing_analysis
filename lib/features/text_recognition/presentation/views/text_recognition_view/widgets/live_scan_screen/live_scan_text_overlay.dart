import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/live_text_controller.dart';

/// A semi-transparent overlay displaying the recognized text in real-time.
///
/// [LiveScanTextOverlay] is positioned at the top of the screen and
/// updates reactively via [LiveTextController.recognizedText]. Shows
/// a placeholder prompt when no text has been recognized yet.
class LiveScanTextOverlay extends GetView<LiveTextController> {
  /// Creates a [LiveScanTextOverlay] widget.
  const LiveScanTextOverlay({super.key});

  @override
  Widget build(BuildContext context) {
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
            border: Border.all(
              color: Colors.amber.withValues(alpha: 0.5),
            ),
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
}
