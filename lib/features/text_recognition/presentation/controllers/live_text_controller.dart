import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_processing_analysis/core/helper/snackbar_helper.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import '../../domain/use_cases/save_live_result_use_case.dart';

// Domain Layer imports

class LiveTextController extends GetxController {
  final SaveLiveResultUseCase _saveLiveResultUseCase;

  LiveTextController({required SaveLiveResultUseCase saveLiveResultUseCase})
    : _saveLiveResultUseCase = saveLiveResultUseCase;

  CameraController? cameraController;
  final TextRecognizer _textRecognizer = TextRecognizer();

  var isProcessing = false.obs;
  var recognizedText = "".obs; // النص اللي بيظهر لليوزر
  var isPaused = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) return;

      cameraController = CameraController(
        cameras[0],
        ResolutionPreset.high,
        enableAudio: false,
      );

      await cameraController?.initialize();
      _startStream();
      update();
    } catch (e) {
      debugPrint("Camera Error: $e");
    }
  }

  void _startStream() {
    cameraController?.startImageStream((image) {
      // بنعالج الفريم فقط لو مش مشغولين ولو مش عاملين Pause
      if (!isProcessing.value && !isPaused.value) {
        _processCameraImage(image);
      }
    });
  }

  Future<void> _processCameraImage(CameraImage image) async {
    isProcessing.value = true;
    try {
      final inputImage = _convertCameraImage(image);
      if (inputImage != null) {
        final result = await _textRecognizer.processImage(inputImage);

        String newText = result.text.trim();

        // --- منطق الثبات (Anti-Flicker Logic) ---

        // 1. لو الفريم الحالي مفيهوش نص، بنهمله تماماً ونحتفظ بالنص القديم
        if (newText.isEmpty) {
          return;
        }

        // 2. لو النص قصير جداً (ضوضاء كاميرا)، بنهمله
        if (newText.length < 3) {
          return;
        }

        // 3. تحديث النص فقط لو اختلف عن اللي معانا
        // ده بيمنع إعادة بناء الـ UI (Rebuild) بدون داعي ويقلل الرعشة
        if (newText != recognizedText.value) {
          recognizedText.value = newText;
        }
      }
    } catch (e) {
      debugPrint("OCR Error: $e");
    } finally {
      // تأخير بسيط جداً (Debounce) عشان نريح المعالج ونزود الثبات
      await Future.delayed(const Duration(milliseconds: 50));
      isProcessing.value = false;
    }
  }

  // ميزة الحفظ باستخدام الـ Use Case
  Future<void> captureAndSave() async {
    if (recognizedText.value.isEmpty) {
     SnackBarHelper
        .showErrorMessage("No text recognized to save!");
      return;
    }

    try {
      isPaused.value = true; // نوقف الاستريم مؤقتاً عشان نحفظ

      final XFile photo = await cameraController!.takePicture();

      await _saveLiveResultUseCase.execute(
        text: recognizedText.value,
        imagePath: photo.path,
      );

      SnackBarHelper.showSuccessMessage(
        "Image captured and result saved to history!");
      isPaused.value = false;
    } catch (e) {
      SnackBarHelper.showErrorMessage('Error saving result: ${e.toString()}');
      isPaused.value = false;
    }
  }

  void togglePause() {
    isPaused.value = !isPaused.value;
  }

  // تحويل فريمات الكاميرا لـ InputImage (المحرك)
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
