import 'package:flutter/material.dart';
import '../../../../../../../core/utils/constants/colors/app_colors.dart';

/// Decorative background widget with ambient glowing circles.
///
/// [AmbientBackgroundBlur] renders two semi-transparent circular
/// shapes positioned at the top-right and bottom-left corners
/// to create a subtle ambient glow effect behind the processing UI.
class AmbientBackgroundBlur extends StatelessWidget {
  /// Creates an [AmbientBackgroundBlur] instance.
  const AmbientBackgroundBlur({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -100,
          right: -50,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.burrowingOwl.withOpacity(0.08),
            ),
          ),
        ),
        Positioned(
          bottom: -50,
          left: -50,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.tawnyOwl.withOpacity(0.05),
            ),
          ),
        ),
      ],
    );
  }
}