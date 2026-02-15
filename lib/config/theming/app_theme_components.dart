import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Theme configuration for elevated and text buttons.
///
/// [ButtonsTheme] defines the default styling for [ElevatedButton]
/// and [TextButton] widgets throughout the application.
class ButtonsTheme {
  /// Elevated button theme with the primary brand color background.
  static ElevatedButtonThemeData elevatedButtonThemeData = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFFEA4F6C),
      foregroundColor: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: EdgeInsets.symmetric(vertical: 16),
    ),
  );

  /// Text button theme with the secondary coral foreground color.
  static TextButtonThemeData textButtonThemeData = TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Color(0xFFED6F72),
      textStyle: TextStyle(fontWeight: FontWeight.bold),
    ),
  );
}

/// Theme configuration for text input fields.
///
/// [InputDecorationsTheme] defines filled input fields with rounded
/// borders that highlight in the primary brand color on focus.
class InputDecorationsTheme {
  /// The default input decoration theme applied to all text fields.
  static InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
    filled: true,
    fillColor: Color(0xFF1F1D2F),
    hintStyle: TextStyle(color: Color(0xFF484C6D)),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Color(0xFF484C6D).withOpacity(0.3)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Color(0xFFEA4F6C)),
    ),
  );
}

/// Theme configuration for the application bar.
///
/// [CustomAppBarTheme] provides a transparent, flat app bar with
/// white text and icons, using the light system overlay style.
class CustomAppBarTheme {
  /// The default app bar theme applied globally.
  static AppBarTheme appBarThemeData = AppBarTheme(
    elevation: 0,
    backgroundColor: Colors.transparent,
    centerTitle: false,
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(color: Colors.white),
    systemOverlayStyle: SystemUiOverlayStyle.light,
  );
}

/// Theme configuration for text styles.
///
/// [TextsTheme] defines the headline, title, and body text
/// styles used across the application's dark theme.
class TextsTheme {
  /// The default text theme with white headlines and muted body text.
  static TextTheme textTheme = TextTheme(
    headlineLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    titleMedium: TextStyle(color: Colors.white, fontSize: 18),
    bodyMedium: TextStyle(color: Color(0xFFA0A0A8), fontSize: 14),
  );
}