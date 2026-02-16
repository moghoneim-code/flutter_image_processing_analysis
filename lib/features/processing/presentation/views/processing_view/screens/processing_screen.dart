import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import '../../../../../../core/utils/constants/colors/app_colors.dart';
import '../../../controllers/processing_controller.dart';
import '../widgets/processing_screen/ambient_background_blur.dart';
import '../widgets/processing_screen/processing_image_preview.dart';
import '../widgets/processing_screen/processing_progress_bar.dart';
import '../widgets/processing_screen/processing_status_text.dart';

/// Screen displayed during image analysis and processing.
///
/// [ProcessingScreen] shows the selected image preview with a
/// scanning line effect, a progress bar, status text, and a
/// percentage indicator while [ProcessingController] runs the
/// analysis pipeline.
class ProcessingScreen extends GetView<ProcessingController> {
  /// Creates a [ProcessingScreen] instance.
  const ProcessingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: Stack(
        children: [
          const AmbientBackgroundBlur(),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const ProcessingImagePreview(),
                  const SizedBox(height: 50),
                  const ProcessingStatusText(),
                  const SizedBox(height: 24),
                  const ProcessingProgressBar(),
                  const SizedBox(height: 16),
                  const ProcessingPercentage(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}