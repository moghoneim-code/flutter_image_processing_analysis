import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

import '../../../../../../../core/shared/widgets/buttons/app_action_button.dart';
import '../../../../controllers/text_recognition_controller.dart';

/// A row of action buttons for copying and sharing recognized text.
///
/// [TextActionButtons] provides two side-by-side buttons:
/// - **COPY**: Copies the recognized text to the clipboard via
///   [TextRecognitionController.copyToClipboard].
/// - **SHARE**: Opens the platform share sheet via
///   [TextRecognitionController.shareText].
class TextActionButtons extends GetView<TextRecognitionController> {
  /// Creates a [TextActionButtons] widget.
  const TextActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppActionButton(
            label: "COPY",
            icon: Icons.copy_rounded,
            style: AppButtonStyle.solid,
            onTap: () => controller.copyToClipboard(),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: AppActionButton(
            label: "SHARE",
            icon: Icons.share_rounded,
            style: AppButtonStyle.gradient,
            onTap: () => controller.shareText(),
          ),
        ),
      ],
    );
  }
}