import 'package:flutter/material.dart';
import 'package:flutter_image_processing_analysis/core/utils/constants/colors/app_colors.dart';
import 'package:get/get.dart';

import 'config/routes/app_pages.dart';
import 'config/routes/app_routes.dart';
import 'core/services/refresh/history_refresh_service.dart';

/// Entry point of the ImageFlow AI application.
///
/// Registers the global [HistoryRefreshService] as a permanent
/// dependency before launching the widget tree.
void main() {
  Get.put(HistoryRefreshService(), permanent: true);
  runApp(const MyApp());
}

/// Root widget for the ImageFlow AI application.
///
/// Configures the [GetMaterialApp] with a dark theme, disables the
/// debug banner, and sets the initial route to [AppRoutes.home].
/// All route definitions are sourced from [AppPages.pages].
class MyApp extends StatelessWidget {
  /// Creates a [MyApp] instance.
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'ImageFlow AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: AppColors.bgPrimary,
      ),
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
    );
  }
}