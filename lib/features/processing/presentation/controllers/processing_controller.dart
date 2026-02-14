import 'dart:io';
import 'package:flutter_image_processing_analysis/config/routes/app_routes.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import '../../../../core/services/image_processing/image_pre_processor.dart';
import '../../../../core/services/ml_services/ml_service.dart';
import '../../../../core/utils/utils/constants/colors/app_colors.dart';
import '../../../../core/utils/utils/constants/enums/ProcessingType.dart';
import '../../domain/entities/processing_result.dart';
import '../../domain/use_cases/process_image_use_case.dart';

class ProcessingController extends GetxController {
  final ProcessImageUseCase _processImageUseCase;
  ProcessingController(this._processImageUseCase);

  final statusMessage = "Initializing Owl AI...".obs;
  final progress = 0.0.obs;
  late File originalImage;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is File) {
      originalImage = Get.arguments;
      _startFlow();
    } else {
      Get.back(); // حماية في حالة مفيش بيانات ممررة
    }
  }

  Future<void> _startFlow() async {
    try {
      _updateProgress(0.3, "Optimizing Image Quality...");

      final result = await _processImageUseCase.execute(originalImage);

      _updateProgress(0.7, "Analyzing Content...");
      await Future.delayed(const Duration(milliseconds: 800)); // تجربة مستخدم أفضل

      _updateProgress(1.0, "Ready!");

      _handleNavigation(result);
    } catch (e) {
      _handleError(e);
    }
  }

  void _updateProgress(double p, String m) {
    progress.value = p;
    statusMessage.value = m;
  }

  void _handleNavigation(ProcessingResult result) {

    String route = (result.type == ProcessingType.document)
        ? AppRoutes.textRecognition
        : AppRoutes.textRecognition;

    Future.delayed(const Duration(milliseconds: 400), () {
      Get.offNamed(route, arguments: result.file);
    });
  }

  void _handleError(dynamic e) {
    Get.back();
    Get.snackbar(
      "Processing Error",
      "Something went wrong while analyzing the image.",
      backgroundColor: AppColors.error.withOpacity(0.8),
      colorText: AppColors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}