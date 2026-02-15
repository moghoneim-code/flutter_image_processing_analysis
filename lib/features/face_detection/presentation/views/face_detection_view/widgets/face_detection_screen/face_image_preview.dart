import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_compare_slider/image_compare_slider.dart';

import '../../../../controllers/face_detection_controller.dart';

/// A widget that displays a before/after comparison of the face composite
/// using an interactive drag slider.
class FaceImagePreview extends GetView<FaceDetectionController> {
  const FaceImagePreview({super.key});

  @override
  Widget build(BuildContext context) {
    final originalFile = controller.result.originalFile;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C26),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: originalFile != null
            ? ImageCompareSlider(
                itemOne: Image.file(originalFile, fit: BoxFit.contain),
                itemTwo: Image.file(controller.result.file, fit: BoxFit.contain),
              )
            : _buildSingleImage(controller.result.file),
      ),
    );
  }

  Widget _buildSingleImage(File file) {
    return Image.file(
      file,
      fit: BoxFit.contain,
      errorBuilder: (_, e, s) => const Center(
        child: Icon(Icons.broken_image, color: Colors.white, size: 50),
      ),
    );
  }
}
