import 'package:flutter/material.dart';

import 'app_theme_components.dart';

class AppTheme {
  AppTheme._();

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: Color(0xFF12121A),
    primaryColor: Color(0xFFEA4F6C),
    brightness: Brightness.dark,
    // fontFamily: AppStrings.appFontFamily,
    textTheme: TextsTheme.textTheme,
    elevatedButtonTheme: ButtonsTheme.elevatedButtonThemeData,
    textButtonTheme: ButtonsTheme.textButtonThemeData,
    inputDecorationTheme: InputDecorationsTheme.inputDecorationTheme,
    // dialogTheme: CustomDialogTheme.dialogThemeData,
    // bottomSheetTheme: CustomBottomSheetTheme.dialogThemeData,
    appBarTheme: CustomAppBarTheme.appBarThemeData,
    cardTheme: CardThemeData(
      color: Color(0xFF1F1D2F),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );
}