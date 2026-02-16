import 'dart:io';
import 'package:flutter/material.dart';

import '../../../../../../../core/utils/constants/colors/app_colors.dart';

/// Displays the analyzed image that yielded no detection results.
///
/// [NoResultImagePreview] renders the image inside a rounded container
/// matching the app's standard image preview styling. Shows a broken
/// image icon as a fallback if the file cannot be loaded.
class NoResultImagePreview extends StatelessWidget {
  /// The image file to display.
  final File imageFile;

  /// Creates a [NoResultImagePreview] for the given [imageFile].
  const NoResultImagePreview({super.key, required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.bgSecondary,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Image.file(
          imageFile,
          fit: BoxFit.contain,
          errorBuilder: (_, _, _) => const Center(
            child: Icon(
              Icons.broken_image,
              color: Colors.white,
              size: 50,
            ),
          ),
        ),
      ),
    );
  }
}
