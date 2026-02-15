import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/utils/constants/colors/app_colors.dart';
import '../../../controllers/splash_controller.dart';
import '../widgets/splash_logo.dart';
import '../widgets/splash_title.dart';

/// Animated splash screen displayed on app launch.
///
/// Delegates animation state and navigation timing to [SplashController].
/// Composes the [SplashLogo] and [SplashTitle] widgets with a
/// combined fade-in and scale entrance animation.
class SplashScreen extends GetView<SplashController> {
  /// Creates a [SplashScreen] widget.
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: Center(
        child: FadeTransition(
          opacity: controller.fadeAnimation,
          child: ScaleTransition(
            scale: controller.scaleAnimation,
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SplashLogo(),
                SizedBox(height: 32),
                SplashTitle(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}