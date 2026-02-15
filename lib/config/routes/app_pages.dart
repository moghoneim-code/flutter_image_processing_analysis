import 'package:get/get_navigation/src/routes/get_route.dart';
import '../../features/face_detection/presentation/bindings/face_detection_binding.dart';
import '../../features/face_detection/presentation/views/face_detection_view/screens/face_detection_screen.dart';
import '../../features/history_detail/presentation/bindings/history_detail_binding.dart';
import '../../features/history_detail/presentation/views/history_detail_view/screens/history_detail_screen.dart';
import '../../features/home/presentation/bindings/home_binding.dart';
import '../../features/home/presentation/views/home_view/screens/home_screen.dart';
import '../../features/processing/presentation/bindings/processing_binding.dart';
import '../../features/processing/presentation/views/processing_view/screens/processing_screen.dart';
import '../../features/splash/presentation/bindings/splash_binding.dart';
import '../../features/splash/presentation/views/splash_view/screens/splash_screen.dart';
import '../../features/text_recognition/presentation/bindings/live_scan_binding.dart';
import '../../features/text_recognition/presentation/bindings/text_recognition_binding.dart';
import '../../features/text_recognition/presentation/views/text_recognition_view/screens/live_scan_screen.dart';
import '../../features/text_recognition/presentation/views/text_recognition_view/screens/text_recognition_screen.dart';
import 'app_routes.dart';

/// Registers all application pages with their route paths and bindings.
///
/// [AppPages] maps each [AppRoutes] constant to its corresponding
/// screen widget and [Bindings] class for GetX dependency injection.
/// This list is provided to [GetMaterialApp.getPages] in [MyApp].
class AppPages {
  /// The complete list of [GetPage] route definitions.
  static final pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.textRecognition,
      page: () => const TextRecognitionScreen(),
      binding: TextRecognitionBinding(),
    ),
    GetPage(
      name: AppRoutes.processing,
      page: () => const ProcessingScreen(),
      binding: ProcessingBinding(),
    ),
    GetPage(
      name: AppRoutes.faceDetection,
      page: () => const FaceDetectionScreen(),
      binding: FaceDetectionBinding(),
    ),
    GetPage(
      name: AppRoutes.liveTextRecognition,
      page: () => const LiveScanScreen(),
      binding: LiveScanBinding(),
    ),
    GetPage(
      name: AppRoutes.historyDetail,
      page: () => const HistoryDetailScreen(),
      binding: HistoryDetailBinding(),
    ),
  ];
}