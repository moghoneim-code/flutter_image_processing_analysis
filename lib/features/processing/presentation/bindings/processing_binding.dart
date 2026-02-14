import 'package:get/get.dart';
import '../../../../core/services/image_processing/image_pre_processor.dart';
import '../../../../core/services/ml_services/ml_service.dart';
import '../../data/repositories/processing_repository_impl.dart';
import '../../domain/repositories/i_processing_repository.dart';
import '../../domain/use_cases/process_image_use_case.dart';
import '../controllers/processing_controller.dart';

class ProcessingBinding extends Bindings {
  @override
  void dependencies() {
    // 1. Data Sources / Services
    Get.lazyPut(() => MLService());
    Get.lazyPut(() => ImagePreProcessor());

    // 2. Repository Implementation
    Get.lazyPut<IProcessingRepository>(
            () => ProcessingRepositoryImpl(Get.find(), Get.find())
    );

    // 3. Use Case
    Get.lazyPut(() => ProcessImageUseCase(Get.find()));

    // 4. Controller
    Get.put(ProcessingController(Get.find()));
  }
}