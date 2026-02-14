import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'config/routes/app_pages.dart';
import 'config/routes/app_routes.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'ImageFlow AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF12121A),
      ),
      initialRoute: AppRoutes.home,
      getPages: AppPages.pages,
    );
  }
}