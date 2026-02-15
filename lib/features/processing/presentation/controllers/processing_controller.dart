import 'dart:io';
import 'package:get/get.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/errors/error_handler.dart';
import '../../../../core/helper/snackbar_helper.dart';
import '../../../../core/utils/constants/enums/processing_type.dart';
import '../../domain/use_cases/process_image_use_case.dart';
import '../../domain/entities/processing_result.dart';

/// Controller managing the image processing screen state.
///
/// [ProcessingController] receives an image [File] via route arguments,
/// runs the [ProcessImageUseCase] pipeline, and navigates to the
/// appropriate result screen based on the detected content type.
///
/// The UI reacts to [statusMessage] and [progress] to display
/// real-time processing feedback.
class ProcessingController extends GetxController {
  /// The use case that orchestrates the processing pipeline.
  final ProcessImageUseCase _processImageUseCase;

  /// Creates a [ProcessingController] with the given use case.
  ProcessingController(this._processImageUseCase);

  /// Reactive status message displayed during processing.
  final statusMessage = "Owl AI is awakening...".obs;

  /// Reactive progress value from 0.0 to 1.0.
  final progress = 0.0.obs;

  /// The original image file received from the home screen.
  late File originalImage;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is File) {
      originalImage = Get.arguments;
      _startAnalysis();
    } else {
      Get.back();
    }
  }

  /// Runs the full image analysis pipeline with progress updates.
  Future<void> _startAnalysis() async {
    try {
      _updateUI(0.2, "Scanning for life forms...");

      final result = await _processImageUseCase.execute(originalImage);

      _updateUI(0.7, "Synthesizing pixels...");
      await Future.delayed(const Duration(milliseconds: 600));

      _updateUI(1.0, "Process Complete!");
      _handleNavigation(result);
    } catch (e) {
      ErrorHandler.handle(e, fallbackMessage: 'Owl AI failed to process this image.');
      Get.back();
    }
  }

  /// Updates the progress bar and status message.
  void _updateUI(double p, String m) {
    progress.value = p;
    statusMessage.value = m;
  }

  /// Navigates to the appropriate result screen based on the processing type.
  ///
  /// Routes to [AppRoutes.faceDetection] for face content,
  /// [AppRoutes.textRecognition] for document content, or
  /// shows an error and navigates back for unrecognized content.
  void _handleNavigation(ProcessingResult result) {
    String route;
    if (result.type == ProcessingType.face) {
      route = AppRoutes.faceDetection;
    } else if (result.type == ProcessingType.document) {
      route = AppRoutes.textRecognition;
    } else {
      SnackBarHelper.showErrorMessage("No clear content found.");
      Get.back();
      return;
    }

    Future.delayed(const Duration(milliseconds: 300), () {
      Get.offNamed(route, arguments: result);
    });
  }
}