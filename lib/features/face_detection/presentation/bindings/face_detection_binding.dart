import 'package:get/get.dart';
import '../../../../core/services/database/app_database.dart';
import '../../../../core/services/database/sqlite_database_impl.dart';
import '../../../../core/services/image_processing/image_pre_processor.dart';
import '../../../../core/services/pdf/pdf_service.dart';
import '../../data/repositories/face_detection_repository_impl.dart';
import '../../domain/repositories/face_detection_repository.dart';
import '../../domain/use_cases/export_face_pdf_use_case.dart';
import '../../domain/use_cases/save_face_history_use_case.dart';
import '../../domain/use_cases/share_face_result_use_case.dart';
import '../controllers/face_detection_controller.dart';

/// GetX binding that registers all dependencies for the face detection route.
///
/// [FaceDetectionBinding] lazily injects the core services ([AppDatabase],
/// [PdfService]), the [FaceDetectionRepository] implementation, all
/// face detection use cases, and the [FaceDetectionController] when
/// the `/face-detection` route is accessed.
class FaceDetectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AppDatabase>(() => SqliteDatabaseImpl());
    Get.lazyPut(() => PdfService());
    Get.lazyPut(() => ImagePreProcessor());

    Get.lazyPut<FaceDetectionRepository>(
      () => FaceDetectionRepositoryImpl(
          Get.find<AppDatabase>(), Get.find<PdfService>()),
    );

    Get.lazyPut(() => SaveFaceHistoryUseCase(Get.find()));
    Get.lazyPut(() => ExportFacePdfUseCase(Get.find()));
    Get.lazyPut(() => ShareFaceResultUseCase(Get.find()));

    Get.put(FaceDetectionController(
      saveHistoryUseCase: Get.find(),
      exportPdfUseCase: Get.find(),
      shareUseCase: Get.find(),
      imagePreProcessor: Get.find(),
    ));
  }
}