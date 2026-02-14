import 'package:flutter/cupertino.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

import '../../../../../../core/utils/utils/constants/colors/app_colors.dart';
import '../../../controllers/processing_controller.dart';

class ProcessingProgressBar extends GetView<ProcessingController> {
  const ProcessingProgressBar({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Container(
        height: 8, width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.bgSecondary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Obx(() => AnimatedContainer(
          duration: const Duration(milliseconds: 600),
          width: constraints.maxWidth * controller.progress.value,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(color: AppColors.burrowingOwl.withOpacity(0.6),
                  blurRadius: 12, spreadRadius: 2),
            ],
          ),
        )),
      ),
    );
  }
}