import 'package:flutter/cupertino.dart';
import 'package:flutter_image_processing_analysis/features/processing/presentation/views/processing_view/widgets/processing_screen/scanning_line_effect.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

import '../../../../../../../core/utils/constants/colors/app_colors.dart';
import '../../../../controllers/processing_controller.dart';

/// Preview widget showing the selected image with a scanning effect overlay.
///
/// [ProcessingImagePreview] displays the original image file from
/// [ProcessingController.originalImage] inside a rounded container
/// with the [ScanningLineEffect] animation layered on top.
class ProcessingImagePreview extends GetView<ProcessingController> {
  /// Creates a [ProcessingImagePreview] instance.
  const ProcessingImagePreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220, width: 220,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(36),
        border: Border.all(color: AppColors.white.withOpacity(0.1)),
        color: AppColors.bgSecondary.withOpacity(0.5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            Image.file(controller.originalImage, fit: BoxFit.cover,
                width: double.infinity, height: double.infinity),
            const ScanningLineEffect(),
          ],
        ),
      ),
    );
  }
}