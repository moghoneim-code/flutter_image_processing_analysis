import 'package:flutter/material.dart';

import '../../../../../../core/utils/constants/colors/app_colors.dart';

/// The app name and tagline displayed below the logo on the splash screen.
///
/// The app name uses a gradient shader ([burrowingOwl] → [tawnyOwl])
/// and the tagline is rendered in [AppColors.greyText].
class SplashTitle extends StatelessWidget {
  /// Creates a [SplashTitle] widget.
  const SplashTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [AppColors.burrowingOwl, AppColors.tawnyOwl],
          ).createShader(bounds),
          child: const Text(
            'ImageFlow AI',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Smart Image Processing & Analysis',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.greyText,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}