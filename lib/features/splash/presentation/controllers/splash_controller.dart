import 'package:flutter/animation.dart';
import 'package:get/get.dart';

import '../../../../config/routes/app_routes.dart';

/// Controller that drives the splash screen animations and timed navigation.
///
/// Uses [GetTickerProviderStateMixin] to provide a [TickerProvider] for
/// the [AnimationController]. On initialization it starts a fade + scale
/// animation and navigates to [AppRoutes.home] after a 2.5-second delay.
class SplashController extends GetxController
    with GetTickerProviderStateMixin {
  /// The main animation controller driving both fade and scale.
  late final AnimationController animationController;

  /// Opacity animation from 0 → 1 with an ease-in curve.
  late final Animation<double> fadeAnimation;

  /// Scale animation from 0.8 → 1.0 with an ease-out-back curve.
  late final Animation<double> scaleAnimation;

  @override
  void onInit() {
    super.onInit();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeIn),
    );

    scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeOutBack),
    );

    animationController.forward();
    _navigateToHome();
  }

  /// Waits for the splash duration then replaces the entire navigation
  /// stack with the home screen.
  void _navigateToHome() {
    Future.delayed(const Duration(milliseconds: 2500), () {
      Get.offAllNamed(AppRoutes.home);
    });
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}