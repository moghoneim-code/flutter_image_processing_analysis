import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/helper/snackbar_helper.dart';
import '../../../../core/services/history_refresh_service.dart';
import '../../domain/use_cases/save_live_result_use_case.dart';

/// Controller managing the live camera text recognition screen.
///
/// [LiveTextController] initializes the device camera, streams frames
/// to Google ML Kit for real-time OCR, and provides controls for
/// pausing, resuming, and capturing results to save in history.
///
/// Dependencies:
/// - [SaveLiveResultUseCase]: Persists captured text and image to history.
class LiveTextController extends GetxController {
  /// Use case for saving captured live scan results.
  final SaveLiveResultUseCase _saveLiveResultUseCase;

  /// Service for notifying the home screen of history changes.
  late final HistoryRefreshService _refreshService;

  /// Creates a [LiveTextController] with the required use case.
  LiveTextController({required SaveLiveResultUseCase saveLiveResultUseCase})
    : _saveLiveResultUseCase = saveLiveResultUseCase;

  /// The camera controller for managing camera hardware.
  CameraController? cameraController;

  /// ML Kit text recognizer for processing camera frames.
  final TextRecognizer _textRecognizer = TextRecognizer();

  /// Whether a camera frame is currently being processed.
  var isProcessing = false.obs;

  /// The most recently recognized text from the camera feed.
  var recognizedText = "".obs;

  /// Whether the live scan is currently paused.
  var isPaused = false.obs;

  @override
  void onInit() {
    super.onInit();
    _refreshService = Get.find<HistoryRefreshService>();
    _initializeCamera();
  }

  /// Initializes the device camera and starts the image stream.
  Future<void> _initializeCamera() async {
    await ErrorHandler.guardVoid(
      () async {
        final cameras = await availableCameras();
        if (cameras.isEmpty) {
          SnackBarHelper.showErrorMessage('No cameras available on this device.');
          return;
        }

        cameraController = CameraController(
          cameras[0],
          ResolutionPreset.high,
          enableAudio: false,
        );

        await cameraController?.initialize();
        _startStream();
        update();
      },
      fallbackMessage: 'Failed to initialize camera.',
    );
  }

  /// Starts streaming camera frames for OCR processing.
  void _startStream() {
    cameraController?.startImageStream((image) {
      if (!isProcessing.value && !isPaused.value) {
        _processCameraImage(image);
      }
    });
  }

  /// Processes a single camera frame through the text recognizer.
  Future<void> _processCameraImage(CameraImage image) async {
    isProcessing.value = true;
    try {
      final inputImage = _convertCameraImage(image);
      if (inputImage != null) {
        final result = await _textRecognizer.processImage(inputImage);

        String newText = result.text.trim();
        if (newText.isEmpty) {
          return;
        }
        if (newText.length < 3) {
          return;
        }
        if (newText != recognizedText.value) {
          recognizedText.value = newText;
        }
      }
    } on Failure {
      /// Silently handled on the hot path to avoid spamming the user.
    } catch (e) {
      debugPrint("OCR Error: $e");
    } finally {
      await Future.delayed(const Duration(milliseconds: 50));
      isProcessing.value = false;
    }
  }

  /// Captures a photo and saves the current recognized text to history.
  ///
  /// Takes a picture using the camera controller, then persists
  /// the recognized text and image path via [SaveLiveResultUseCase].
  Future<void> captureAndSave() async {
    if (recognizedText.value.isEmpty) {
      SnackBarHelper.showErrorMessage("No text recognized to save!");
      return;
    }

    try {
      isPaused.value = true;

      final XFile photo = await cameraController!.takePicture();

      await _saveLiveResultUseCase.execute(
        text: recognizedText.value,
        imagePath: photo.path,
      );

      _refreshService.notify();
      SnackBarHelper.showSuccessMessage(
        "Image captured and result saved to history!");
      isPaused.value = false;
    } catch (e) {
      ErrorHandler.handle(e, fallbackMessage: 'Error saving result.');
      isPaused.value = false;
    }
  }

  /// Toggles the pause state of the live camera feed.
  void togglePause() {
    isPaused.value = !isPaused.value;
  }

  /// Converts a [CameraImage] to an ML Kit [InputImage].
  ///
  /// Concatenates all image plane bytes and constructs the required
  /// metadata including rotation, format, and dimensions.
  InputImage? _convertCameraImage(CameraImage image) {
    if (cameraController == null) return null;
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final metadata = InputImageMetadata(
      size: Size(image.width.toDouble(), image.height.toDouble()),
      rotation: InputImageRotationValue.fromRawValue(
        cameraController!.description.sensorOrientation,
      )!,
      format: InputImageFormatValue.fromRawValue(image.format.raw)!,
      bytesPerRow: image.planes[0].bytesPerRow,
    );

    return InputImage.fromBytes(bytes: bytes, metadata: metadata);
  }

  @override
  void onClose() {
    cameraController?.dispose();
    _textRecognizer.close();
    super.onClose();
  }
}