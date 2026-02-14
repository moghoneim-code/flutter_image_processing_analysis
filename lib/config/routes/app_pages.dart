import 'package:get/get_navigation/src/routes/get_route.dart';
import '../../features/home/presentation/bindings/home_binding.dart';
import '../../features/home/presentation/views/home_view/screens/home_screen.dart';
import '../../features/processing/presentation/bindings/processing_binding.dart';
import '../../features/processing/presentation/views/processing_view/screens/processing_screen.dart';
import '../../features/text_recognition/presentation/bindings/text_recognition_binding.dart';
import '../../features/text_recognition/presentation/views/text_recognition_view/screens/text_recognition_screen.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
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
  ];
}