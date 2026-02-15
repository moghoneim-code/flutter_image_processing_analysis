import 'package:get/get.dart';
import '../../../../core/services/database/app_database.dart';
import '../../../../core/services/database/sqlite_database_impl.dart';
import '../../../home/data/repositories/home_repository_impl.dart';
import '../../../home/domain/repositories/home_repository.dart';
import '../../../home/domain/use_cases/delete_history_use_case.dart';
import '../../data/repositories/history_detail_repository_impl.dart';
import '../../domain/repositories/history_detail_repository.dart';
import '../../domain/use_cases/open_history_file_use_case.dart';
import '../../domain/use_cases/share_history_file_use_case.dart';
import '../controllers/history_detail_controller.dart';

/// GetX binding that registers all dependencies for the history detail screen.
///
/// [HistoryDetailBinding] is self-contained and checks for existing
/// registrations of shared services to avoid duplicate dependency conflicts.
///
/// Dependency injection order:
/// 1. Core services ([AppDatabase])
/// 2. Repositories ([HomeRepository], [HistoryDetailRepository])
/// 3. Use cases ([DeleteHistoryUseCase], [ShareHistoryFileUseCase], [OpenHistoryFileUseCase])
/// 4. Controller ([HistoryDetailController])
class HistoryDetailBinding extends Bindings {
  @override
  void dependencies() {
    // Core services
    if (!Get.isRegistered<AppDatabase>()) {
      Get.lazyPut<AppDatabase>(() => SqliteDatabaseImpl());
    }

    // Repositories
    if (!Get.isRegistered<HomeRepository>()) {
      Get.lazyPut<HomeRepository>(
        () => HomeRepositoryImpl(Get.find<AppDatabase>()),
      );
    }
    Get.lazyPut<HistoryDetailRepository>(
      () => HistoryDetailRepositoryImpl(),
    );

    // Use cases
    Get.lazyPut(() => DeleteHistoryUseCase(Get.find<HomeRepository>()));
    Get.lazyPut(() => ShareHistoryFileUseCase(Get.find<HistoryDetailRepository>()));
    Get.lazyPut(() => OpenHistoryFileUseCase(Get.find<HistoryDetailRepository>()));

    // Controller
    Get.lazyPut(() => HistoryDetailController(
          deleteHistoryUseCase: Get.find<DeleteHistoryUseCase>(),
          shareHistoryFileUseCase: Get.find<ShareHistoryFileUseCase>(),
          openHistoryFileUseCase: Get.find<OpenHistoryFileUseCase>(),
        ));
  }
}
