import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

import '../../../../../../../core/utils/constants/colors/app_colors.dart';
import '../../../../controllers/processing_controller.dart';

/// Displays the current processing status message in uppercase.
///
/// [ProcessingStatusText] reactively observes
/// [ProcessingController.statusMessage] and renders it with
/// letter spacing for a stylized appearance.
class ProcessingStatusText extends GetView<ProcessingController> {
  /// Creates a [ProcessingStatusText] instance.
  const ProcessingStatusText({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Text(
      controller.statusMessage.value.toUpperCase(),
      style:  TextStyle(color: AppColors.white, letterSpacing: 2, fontWeight: FontWeight.bold),
    ));
  }
}

/// Displays the current processing progress as a percentage.
///
/// [ProcessingPercentage] reactively observes
/// [ProcessingController.progress] and shows it as an integer
/// percentage value (e.g., "75%").
class ProcessingPercentage extends GetView<ProcessingController> {
  /// Creates a [ProcessingPercentage] instance.
  const ProcessingPercentage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Text(
      "${(controller.progress.value * 100).toInt()}%",
      style: TextStyle(color: AppColors.tawnyOwl, fontWeight: FontWeight.bold, fontFamily: 'JetBrainsMono'),
    ));
  }
}