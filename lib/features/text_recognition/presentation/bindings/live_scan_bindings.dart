import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';

import '../../../home/domain/repositories/home_repository.dart';
import '../../domain/use_cases/save_live_result_use_case.dart';
import '../controllers/live_text_controller.dart';

class LiveScanBinding extends Bindings {
  @override
  void dependencies() {
    // 1. الـ Repository (Data Layer)
    // Get.find<HomeRepository>() مفترض إنه موجود من الـ HomeBinding

    // 2. الـ Use Case (Domain Layer)
    Get.lazyPut(() => SaveLiveResultUseCase(Get.find<HomeRepository>()));

    // 3. الـ Controller (Presentation Layer)
    Get.lazyPut(() => LiveTextController(
      saveLiveResultUseCase: Get.find<SaveLiveResultUseCase>(),
    ));
  }
}