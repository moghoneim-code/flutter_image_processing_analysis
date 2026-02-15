import 'package:get/get.dart';
import '../../../../core/services/database/app_database.dart';
import '../../../../core/services/database/sqlite_database_impl.dart';
import '../../data/repositories/home_repository_impl.dart';
import '../../domain/repositories/home_repository.dart';
import '../../domain/use_cases/delete_history_use_case.dart';
import '../../domain/use_cases/get_history_use_case.dart';
import '../controllers/home_controller.dart';

/// GetX binding that registers all dependencies for the home route.
///
/// [HomeBinding] lazily injects the database, repository, use cases,
/// and controller needed by the [HomeScreen] when the `/home` route
/// is first accessed.
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AppDatabase>(() => SqliteDatabaseImpl());

    Get.lazyPut<HomeRepository>(
      () => HomeRepositoryImpl(Get.find<AppDatabase>()),
    );

    Get.lazyPut(() => GetHistoryUseCase(Get.find<HomeRepository>()));

    Get.lazyPut(() => DeleteHistoryUseCase(Get.find<HomeRepository>()));

    Get.lazyPut(
      () => HomeController(
        getHistoryUseCase: Get.find<GetHistoryUseCase>(),
        deleteHistoryUseCase: Get.find<DeleteHistoryUseCase>(),
      ),
    );
  }
}