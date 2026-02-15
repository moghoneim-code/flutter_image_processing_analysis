import 'package:get/get.dart';
import '../../../../core/services/database/app_database.dart';
import '../../../../core/services/database/sqlite_database_impl.dart';
import '../../../../core/services/ml_services/ml_service.dart';
import '../../../../core/services/pdf/pdf_service.dart';
import '../../data/repositories/text_recognition_repository_impl.dart';
import '../../domain/repositories/i_text_recognition_repository.dart';
import '../../domain/use_cases/copy_to_clipboard_use_case.dart';
import '../../domain/use_cases/export_document_use_case.dart';
import '../../domain/use_cases/recognize_text_use_case.dart';
import '../../domain/use_cases/share_text_use_case.dart';
import '../controllers/text_recognition_controller.dart';

/// GetX binding that registers all dependencies for the text recognition route.
///
/// [TextRecognitionBinding] injects the database, ML service, PDF service,
/// repository, all use cases, and the [TextRecognitionController] when
/// the `/text-recognition` route is accessed.
class TextRecognitionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AppDatabase>(() => SqliteDatabaseImpl());
    Get.lazyPut(() => MLService());
    Get.lazyPut(() => PdfService());

    Get.lazyPut<ITextRecognitionRepository>(
        () => TextRecognitionRepositoryImpl(Get.find<AppDatabase>()));

    Get.lazyPut(() => RecognizeTextUseCase(
        Get.find<ITextRecognitionRepository>(), Get.find<MLService>()));
    Get.lazyPut(() => CopyToClipboardUseCase());
    Get.lazyPut(() => ShareTextUseCase());
    Get.lazyPut(() => ExportDocumentUseCase(
        Get.find<PdfService>(), Get.find<ITextRecognitionRepository>()));

    Get.put(TextRecognitionController(
      recognizeTextUseCase: Get.find(),
      copyUseCase: Get.find(),
      shareUseCase: Get.find(),
      exportUseCase: Get.find(),
    ));
  }
}