import 'package:get/get.dart';
import '../../../../core/services/image_processing/image_pre_processor.dart';
import '../../../../core/services/ml_services/ml_service.dart';
import '../../data/repositories/processing_repository_impl.dart';
import '../../domain/repositories/i_processing_repository.dart';
import '../../domain/use_cases/process_image_use_case.dart';
import '../controllers/processing_controller.dart';

/// GetX binding that registers all dependencies for the processing route.
///
/// [ProcessingBinding] injects [MLService], [ImagePreProcessor],
/// [ProcessingRepositoryImpl], [ProcessImageUseCase], and
/// [ProcessingController] when the `/processing` route is accessed.
class ProcessingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MLService());
    Get.lazyPut(() => ImagePreProcessor());

    Get.lazyPut<IProcessingRepository>(
            () => ProcessingRepositoryImpl(Get.find(), Get.find())
    );

    Get.lazyPut(() => ProcessImageUseCase(Get.find()));

    Get.put(ProcessingController(Get.find()));
  }
}