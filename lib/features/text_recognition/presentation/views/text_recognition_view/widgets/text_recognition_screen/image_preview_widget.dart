import 'dart:io';
import 'package:flutter/material.dart';

class ImagePreviewWidget extends StatelessWidget {
  final File imageFile;
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