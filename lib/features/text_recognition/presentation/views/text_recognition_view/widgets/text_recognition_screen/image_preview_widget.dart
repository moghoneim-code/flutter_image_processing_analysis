import 'dart:io';
import 'package:flutter/material.dart';

/// A widget that displays an image file preview with rounded corners and shadow.
///
/// [ImagePreviewWidget] renders the provided [imageFile] inside a
/// rounded container with a subtle drop shadow, suitable for displaying
/// scanned or captured images in the text recognition flow.
///
/// Required parameters:
/// - [imageFile]: The [File] containing the image to display.
class ImagePreviewWidget extends StatelessWidget {
  /// The image file to render in the preview.
  final File imageFile;

  /// Creates an [ImagePreviewWidget] with the given [imageFile].
  const ImagePreviewWidget({super.key, required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 15, offset: const Offset(0, 5)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Image.file(imageFile, fit: BoxFit.cover),
      ),
    );
  }
}