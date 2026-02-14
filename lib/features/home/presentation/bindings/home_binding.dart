import 'package:get/get.dart';
import '../../../../core/services/database/app_database.dart';
import '../../../../core/services/database/sqlite_database_impl.dart';
import '../../../text_recognition/domain/use_cases/save_live_result_use_case.dart';
import '../../../text_recognition/presentation/controllers/live_text_controller.dart';
import '../../data/impl/history_repository_impl.dart';
import '../../domain/repositories/home_repository.dart';
import '../../domain/use_cases/delete_history_use_case.dart';
import '../../domain/use_cases/get_history_use_case.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AppDatabase>(() => SqliteDatabaseImpl());

    Get.lazyPut<HomeRepository>(
      () => HomeRepositoryImpl(Get.find<AppDatabase>()),
    );

    Get.lazyPut(() => GetHistoryUseCase(Get.find<HomeRepository>()));

    Get.lazyPut(() => DeleteHistoryUseCase(Get.find<HomeRepository>()));

    Get.lazyPut(() => SaveLiveResultUseCase(Get.find<HomeRepository>()));
    Get.lazyPut(
      () => LiveTextController(
        saveLiveResultUseCase: Get.find<SaveLiveResultUseCase>(),
      ),
    );

    Get.lazyPut(
      () => HomeController(
        getHistoryUseCase: Get.find<GetHistoryUseCase>(),
        deleteHistoryUseCase: Get.find<DeleteHistoryUseCase>(),
      ),
    );
  }
}
