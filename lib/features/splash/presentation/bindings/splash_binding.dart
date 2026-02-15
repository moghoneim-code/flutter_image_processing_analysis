import 'package:get/get.dart';

import '../controllers/splash_controller.dart';

/// Registers [SplashController] when the splash route is accessed.
class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(() => SplashController());
  }
}