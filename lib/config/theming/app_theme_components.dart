import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ButtonsTheme {
  static ElevatedButtonThemeData elevatedButtonThemeData = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFFEA4F6C), // Burrowing Owl
      foregroundColor: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: EdgeInsets.symmetric(vertical: 16),
    ),
  );

  static TextButtonThemeData textButtonThemeData = TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Color(0xFFED6F72), // Great Horned Owl
      textStyle: TextStyle(fontWeight: FontWeight.bold),
    ),
  );
}
class InputDecorationsTheme {
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
class CustomAppBarTheme {
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

class TextsTheme {
  static TextTheme textTheme = TextTheme(
    headlineLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    titleMedium: TextStyle(color: Colors.white, fontSize: 18),
    bodyMedium: TextStyle(color: Color(0xFFA0A0A8), fontSize: 14),
  );
}