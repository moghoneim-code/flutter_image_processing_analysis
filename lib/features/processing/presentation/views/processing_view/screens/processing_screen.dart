import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import '../../../../../../core/utils/utils/constants/colors/app_colors.dart';
import '../../../controllers/processing_controller.dart';
import '../widgets/ambient_background_blur.dart';
import '../widgets/processing_image_preview.dart';
import '../widgets/processing_progress_bar.dart';
import '../widgets/processing_status_text.dart';

class ProcessingScreen extends GetView<ProcessingController> {
  const ProcessingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: Stack(
        children: [
          const AmbientBackgroundBlur(), // ويدجت الخلفية
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