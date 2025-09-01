import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppTheme {
  // Base color schemes
  static const ColorScheme _baseLightColorScheme = ColorScheme.light(
    primary: Color(0xFF0066CC),
    secondary: Color(0xFF6366F1),
    surface: Color(0xFFFFFBFE),
    background: Color(0xFFFFFBFE),
    error: Color(0xFFBA1A1A),
  );

  static const ColorScheme _baseDarkColorScheme = ColorScheme.dark(
    primary: Color(0xFF99CCFF),
    secondary: Color(0xFF9CA3FF),
    surface: Color(0xFF111111),
    background: Color(0xFF111111),
    error: Color(0xFFFFB4AB),
  );

  // Create adaptive theme data based on platform and dynamic colors
  static ThemeData createLightTheme([ColorScheme? dynamicColorScheme]) {
    final colorScheme = dynamicColorScheme ?? _baseLightColorScheme;
    final platformTheme =
        _getPlatformSpecificTheme(colorScheme, Brightness.light);

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: Brightness.light,
      appBarTheme: platformTheme['appBarTheme'] as AppBarTheme?,
      cardTheme: platformTheme['cardTheme'] as CardTheme?,
    );
  }

  static ThemeData createDarkTheme([ColorScheme? dynamicColorScheme]) {
    final colorScheme = dynamicColorScheme ?? _baseDarkColorScheme;
    final platformTheme =
        _getPlatformSpecificTheme(colorScheme, Brightness.dark);

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: Brightness.dark,
      appBarTheme: platformTheme['appBarTheme'] as AppBarTheme?,
      cardTheme: platformTheme['cardTheme'] as CardTheme?,
    );
  }

  // Platform-specific theme adjustments
  static Map<String, dynamic> _getPlatformSpecificTheme(
    ColorScheme colorScheme,
    Brightness brightness,
  ) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.windows:
        return _getWindowsTheme(colorScheme, brightness);
      case TargetPlatform.macOS:
        return _getMacOSTheme(colorScheme, brightness);
      case TargetPlatform.linux:
        return _getLinuxTheme(colorScheme, brightness);
      default:
        return {};
    }
  }

  static Map<String, dynamic> _getWindowsTheme(
      ColorScheme colorScheme, Brightness brightness) {
    return {
      'appBarTheme': AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        titleTextStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: colorScheme.onSurface,
        ),
      ),
      'cardTheme': CardTheme(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
    };
  }

  static Map<String, dynamic> _getMacOSTheme(
      ColorScheme colorScheme, Brightness brightness) {
    return {
      'appBarTheme': AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        titleTextStyle: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
      ),
      'cardTheme': CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    };
  }

  static Map<String, dynamic> _getLinuxTheme(
      ColorScheme colorScheme, Brightness brightness) {
    return {
      'appBarTheme': AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        titleTextStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: colorScheme.onSurface,
        ),
      ),
      'cardTheme': CardTheme(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
    };
  }

  // VSCode-inspired dimensions
  static const double sidebarWidth = 240.0;
  static const double sidebarCollapsedWidth = 48.0;
  static const double topBarHeight = 35.0;
  static const double bottomBarHeight = 24.0;
  static const double sidePanelWidth = 300.0;
}
