import 'package:flutter/material.dart';

import 'app_theme_components.dart';

/// Provides the application's theme configuration.
///
/// [AppTheme] defines a Material 3 dark theme with the owl-themed
/// color palette, custom component themes from [ButtonsTheme],
/// [InputDecorationsTheme], [CustomAppBarTheme], and [TextsTheme].
class AppTheme {
  AppTheme._();

  /// The dark theme used throughout the application.
  ///
  /// Features a dark scaffold background (`#12121A`), the primary
  /// brand color (`#EA4F6C`), and card surfaces styled with
  /// rounded corners and the [AppColors.elfOwl] background.
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: Color(0xFF12121A),
    primaryColor: Color(0xFFEA4F6C),
    brightness: Brightness.dark,
    textTheme: TextsTheme.textTheme,
    elevatedButtonTheme: ButtonsTheme.elevatedButtonThemeData,
    textButtonTheme: ButtonsTheme.textButtonThemeData,
    inputDecorationTheme: InputDecorationsTheme.inputDecorationTheme,
    appBarTheme: CustomAppBarTheme.appBarThemeData,
    cardTheme: CardThemeData(
      color: Color(0xFF1F1D2F),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );
}