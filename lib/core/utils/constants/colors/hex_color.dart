import 'dart:ui';

/// A [Color] subclass that accepts hexadecimal color strings.
///
/// [HexColor] converts a hex string (e.g., `'#FF5733'` or `'FF5733'`)
/// into a Flutter [Color] object. Supports both 6-digit (RGB) and
/// 8-digit (ARGB) hex formats.
class HexColor extends Color {
  /// Parses the [hexColor] string into an integer color value.
  ///
  /// Strips the `#` prefix if present and prepends `FF` for full
  /// opacity when only 6 hex digits are provided.
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return int.parse(hexColor, radix: 16);
  }

  /// Creates a [HexColor] from the given [hexColor] string.
  ///
  /// Example: `HexColor('#EA4F6C')` or `HexColor('EA4F6C')`.
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}