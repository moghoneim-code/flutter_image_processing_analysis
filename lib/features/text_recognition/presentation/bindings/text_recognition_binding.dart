import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import '../../../../core/services/database/app_database.dart';
import '../../../../core/services/database/sqlite_database_impl.dart';
import '../../../../core/services/ml_services/ml_service.dart';
import '../../../../core/services/pdf/pdf_service.dart';
import '../../data/repositories/history_repository.dart';
import '../../data/repositories/text_recognition_repository_impl.dart';
import '../../domain/repositories/text_recognition_repository.dart';
import '../../domain/use_cases/copy_to_clipboard_use_case.dart';
import '../../domain/use_cases/export_document_use_case.dart';
import '../../domain/use_cases/recognize_text_use_case.dart';
import '../../domain/use_cases/share_text_use_case.dart';
import '../controllers/text_recognition_controller.dart';

class TextRecognitionBinding extends Bindings {
  @override
  void dependencies() {
    // 1. Core Services & Database (الأساسيات)
    Get.lazyPut<AppDatabase>(() => SqliteDatabaseImpl());
    Get.lazyPut(() => MLService());
    Get.lazyPut(() => PdfService());

    // 2. Repositories (الطبقة اللي بتكلم الداتا)
    Get.lazyPut<TextRecognitionRepository>(() => TextRecognitionRepositoryImpl(Get.find()));
    Get.lazyPut(() => HistoryRepository(Get.find<AppDatabase>()));

    // 3. Use Cases (المنطق بتاع التطبيق)
    Get.lazyPut(() => RecognizeTextUseCase(Get.find(), Get.find()));
    Get.lazyPut(() => CopyToClipboardUseCase());
    Get.lazyPut(() => ShareTextUseCase());
    Get.lazyPut(() => ExportDocumentUseCase(Get.find<PdfService>(), Get.find<HistoryRepository>()));

    // 4. Controller (بيستلم كل الـ Use Cases)
    Get.put(TextRecognitionController(
      recognizeTextUseCase: Get.find(),
      copyUseCase: Get.find(),
      shareUseCase: Get.find(),
      exportUseCase: Get.find(), // ضفنا الـ PDF Export هنا
    ));
  }
}