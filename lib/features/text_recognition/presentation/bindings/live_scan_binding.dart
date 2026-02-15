import 'package:get/get.dart';
import '../../../../core/services/database/app_database.dart';
import '../../../../core/services/database/sqlite_database_impl.dart';
import '../../../home/data/repositories/home_repository_impl.dart';
import '../../../home/domain/repositories/i_home_repository.dart';
import '../../domain/use_cases/save_live_result_use_case.dart';
import '../controllers/live_text_controller.dart';

/// GetX binding that registers all dependencies for the live scan screen.
///
/// [LiveScanBinding] is self-contained and checks for existing
/// registrations of [AppDatabase] and [IHomeRepository] to avoid
/// duplicate dependency conflicts. It injects [SaveLiveResultUseCase]
/// and [LiveTextController].
class LiveScanBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<AppDatabase>()) {
      Get.lazyPut<AppDatabase>(() => SqliteDatabaseImpl());
    }
    if (!Get.isRegistered<IHomeRepository>()) {
      Get.lazyPut<IHomeRepository>(
        () => HomeRepositoryImpl(Get.find<AppDatabase>()),
      );
    }

    Get.lazyPut(() => SaveLiveResultUseCase(Get.find<IHomeRepository>()));

    Get.lazyPut(() => LiveTextController(
          saveLiveResultUseCase: Get.find<SaveLiveResultUseCase>(),
        ));
  }
}