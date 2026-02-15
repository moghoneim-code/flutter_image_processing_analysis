import 'package:flutter/material.dart';
import 'package:flutter_image_processing_analysis/core/utils/constants/strings/app_images.dart';

import '../../../../../../core/utils/constants/colors/app_colors.dart';

/// The owl logo with a subtle radial glow behind it.
///
/// Displayed at the center of the splash screen above the app name.
class SplashLogo extends StatelessWidget {
  /// Creates a [SplashLogo] widget.
  const SplashLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 160,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            AppColors.burrowingOwl.withValues(alpha: 0.15),
            Colors.transparent,
          ],
          radius: 0.8,
        ),
      ),
      child: Center(
        child: Image.asset(
          AppImages.appLogo,
          width: 120,
          height: 120,
        ),
      ),
    );
  }
}