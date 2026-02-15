import 'package:flutter/material.dart';
import 'hex_color.dart';

/// Centralized color palette for the ImageFlow AI application.
///
/// [AppColors] defines all brand colors following the owl-themed
/// naming convention, along with background, neutral, status,
/// and gradient color definitions.
class AppColors {
  AppColors._();

  /// Warm coral tone used for secondary highlights.
  static Color tawnyOwl = HexColor('#F1947B');

  /// Medium coral tone used for text buttons and accents.
  static Color greatHornedOwl = HexColor('#ED6F72');

  /// Primary brand color used for CTAs and key interactive elements.
  static Color burrowingOwl = HexColor('#EA4F6C');

  /// Deep muted rose used for secondary containers.
  static Color screechOwl = HexColor('#994164');

  /// Muted grey-purple used for borders and subtle elements.
  static Color greatGreyOwl = HexColor('#484C6D');

  /// Dark card background color.
  static Color elfOwl = HexColor('#1F1D2F');

  /// Primary dark background color for scaffolds.
  static Color bgPrimary = HexColor('#12121A');

  /// Secondary dark background color for cards and sheets.
  static Color bgSecondary = HexColor('#1C1C26');

  /// Pure white.
  static Color white = HexColor('#FFFFFF');

  /// Pure black.
  static Color black = HexColor('#000000');

  /// Transparent color.
  static Color transparent = Colors.transparent;

  /// Muted grey used for secondary text.
  static Color greyText = HexColor('#A0A0A8');

  /// Subtle grey used for borders with reduced opacity.
  static Color greyBorder = HexColor('#484C6D').withValues(alpha: 0.3);

  /// Green color indicating successful operations.
  static Color success = HexColor('#4CAF50');

  /// Red color indicating errors or destructive actions.
  static Color error = HexColor('#F44336');

  /// Primary color with 10% opacity for subtle tinted backgrounds.
  static Color primaryWithOpacity10 = burrowingOwl.withValues(alpha: 0.1);

  /// Grey color with 20% opacity for light overlays.
  static Color greyWithOpacity20 = greatGreyOwl.withValues(alpha: 0.2);

  /// Primary gradient transitioning from [burrowingOwl] to [greatHornedOwl].
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFEA4F6C), Color(0xFFED6F72)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}