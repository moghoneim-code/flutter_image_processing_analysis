import 'package:flutter/material.dart';
import 'hex_color.dart';

class AppColors {
  AppColors._();

  /// --------------------- CODEWAY OWL BRAND COLORS ----------------------------

  /// Primary - Warm Coral Family
  static Color tawnyOwl = HexColor('#F1947B');
  static Color greatHornedOwl = HexColor('#ED6F72');
  static Color burrowingOwl = HexColor('#EA4F6C');

  /// Secondary - Cool Muted Family
  static Color screechOwl = HexColor('#994164');
  static Color greatGreyOwl = HexColor('#484C6D');
  static Color elfOwl = HexColor('#1F1D2F');

  /// Foundation - Backgrounds
  static Color bgPrimary = HexColor('#12121A');
  static Color bgSecondary = HexColor('#1C1C26');

  /// --------------------- BASIC COLORS -----------------------------------------
  static Color white = HexColor('#FFFFFF');
  static Color black = HexColor('#000000');
  static Color transparent = Colors.transparent;

  /// --------------------- NEUTRAL / GREY ---------------------------------------
  static Color greyText = HexColor('#A0A0A8');
  static Color greyBorder = HexColor('#484C6D').withValues(alpha: 0.3);

  /// --------------------- STATUS COLORS ----------------------------------------
  static Color success = HexColor('#4CAF50');
  static Color error = HexColor('#F44336');

  /// --------------------- COLORS WITH OPACITY ----------------------------------
  static Color primaryWithOpacity10 = burrowingOwl.withValues(alpha: 0.1);
  static Color greyWithOpacity20 = greatGreyOwl.withValues(alpha: 0.2);

  /// --------------------- GRADIENTS (Bonus) ------------------------------------

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFEA4F6C), Color(0xFFED6F72)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}