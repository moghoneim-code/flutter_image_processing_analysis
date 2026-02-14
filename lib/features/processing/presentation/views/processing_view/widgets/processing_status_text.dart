import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

import '../../../../../../core/utils/utils/constants/colors/app_colors.dart';
import '../../../controllers/processing_controller.dart';



class ProcessingStatusText extends GetView<ProcessingController> {
  const ProcessingStatusText({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Text(
      controller.statusMessage.value.toUpperCase(),
      style:  TextStyle(color: AppColors.white, letterSpacing: 2, fontWeight: FontWeight.bold),
    ));
  }
}

class ProcessingPercentage extends GetView<ProcessingController> {
  const ProcessingPercentage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Text(
      "${(controller.progress.value * 100).toInt()}%",
      style: TextStyle(color: AppColors.tawnyOwl, fontWeight: FontWeight.bold, fontFamily: 'JetBrainsMono'),
    ));
  }
}