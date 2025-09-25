import 'package:flutter/material.dart';

/// Centralized color constants for consistent coloring across the app
/// This complements the theme system by providing semantic colors and utility colors
class AppColors {
  // Semantic colors (these should adapt to light/dark themes)
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // macOS window control colors (these are standard and don't change with theme)
  static const Color macOSCloseRed = Color(0xFFFF5F57);
  static const Color macOSMinimizeOrange = Color(0xFFFFBD2E);
  static const Color macOSMaximizeGreen = Color(0xFF28CA42);

  // Syntax highlighting colors (these could be theme-aware in the future)
  static const Color syntaxKeyword = Color(0xFF0000FF);
  static const Color syntaxString = Color(0xFF008000);
  static const Color syntaxComment = Color(0xFF808080);
  static const Color syntaxNumber = Color(0xFFFF6600);
  static const Color syntaxFunction = Color(0xFF795E26);

  // Utility colors
  static const Color transparent = Colors.transparent;
  static const Color white = Colors.white;
  static const Color black = Colors.black;

  // Opacity variants
  static Color withOpacity(Color color, double opacity) {
    return color.withOpacity(opacity);
  }

  static Color successWithOpacity(double opacity) =>
      success.withOpacity(opacity);
  static Color warningWithOpacity(double opacity) =>
      warning.withOpacity(opacity);
  static Color errorWithOpacity(double opacity) => error.withOpacity(opacity);
  static Color infoWithOpacity(double opacity) => info.withOpacity(opacity);

  // Theme-aware color getters (these require BuildContext)
  static Color getSuccessColor(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    // ignore: prefer_const_constructors
    return brightness == Brightness.dark ? Color(0xFF81C784) : success;
  }

  static Color getWarningColor(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark ? const Color(0xFFFFB74D) : warning;
  }

  static Color getErrorColor(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark ? const Color(0xFFEF5350) : error;
  }

  static Color getInfoColor(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark ? const Color(0xFF64B5F6) : info;
  }

  // Color manipulation utilities
  static Color lighten(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    return hsl
        .withLightness((hsl.lightness + amount).clamp(0.0, 1.0))
        .toColor();
  }

  static Color darken(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    return hsl
        .withLightness((hsl.lightness - amount).clamp(0.0, 1.0))
        .toColor();
  }

  static Color blend(Color color1, Color color2, double ratio) {
    return Color.lerp(color1, color2, ratio) ?? color1;
  }
}
