import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppSpacing {
  // Spacing scale based on 4px grid system
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;

  // Common padding values
  static const EdgeInsets paddingXs = EdgeInsets.all(xs);
  static const EdgeInsets paddingSm = EdgeInsets.all(sm);
  static const EdgeInsets paddingMd = EdgeInsets.all(md);
  static const EdgeInsets paddingLg = EdgeInsets.all(lg);
  static const EdgeInsets paddingXl = EdgeInsets.all(xl);

  // Horizontal padding
  static const EdgeInsets paddingHorizontalXs =
      EdgeInsets.symmetric(horizontal: xs);
  static const EdgeInsets paddingHorizontalSm =
      EdgeInsets.symmetric(horizontal: sm);
  static const EdgeInsets paddingHorizontalMd =
      EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets paddingHorizontalLg =
      EdgeInsets.symmetric(horizontal: lg);

  // Vertical padding
  static const EdgeInsets paddingVerticalXs =
      EdgeInsets.symmetric(vertical: xs);
  static const EdgeInsets paddingVerticalSm =
      EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets paddingVerticalMd =
      EdgeInsets.symmetric(vertical: md);
  static const EdgeInsets paddingVerticalLg =
      EdgeInsets.symmetric(vertical: lg);

  // Specific combinations
  static const EdgeInsets paddingTopMd = EdgeInsets.only(top: md);
  static const EdgeInsets paddingBottomMd = EdgeInsets.only(bottom: md);
  static const EdgeInsets paddingLeftMd = EdgeInsets.only(left: md);
  static const EdgeInsets paddingRightMd = EdgeInsets.only(right: md);
}

class AppRadius {
  // Border radius scale
  static const double xs = 2;
  static const double sm = 4;
  static const double md = 6;
  static const double lg = 8;
  static const double xl = 12;
  static const double xxl = 16;

  // Common border radius
  static const BorderRadius radiusXs = BorderRadius.all(Radius.circular(xs));
  static const BorderRadius radiusSm = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius radiusMd = BorderRadius.all(Radius.circular(md));
  static const BorderRadius radiusLg = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius radiusXl = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius radiusXxl = BorderRadius.all(Radius.circular(xxl));

  // Rounded rectangle borders
  static const RoundedRectangleBorder roundedRectangleXs =
      RoundedRectangleBorder(borderRadius: radiusXs);
  static const RoundedRectangleBorder roundedRectangleSm =
      RoundedRectangleBorder(borderRadius: radiusSm);
  static const RoundedRectangleBorder roundedRectangleMd =
      RoundedRectangleBorder(borderRadius: radiusMd);
  static const RoundedRectangleBorder roundedRectangleLg =
      RoundedRectangleBorder(borderRadius: radiusLg);
  static const RoundedRectangleBorder roundedRectangleXl =
      RoundedRectangleBorder(borderRadius: radiusXl);
  static const RoundedRectangleBorder roundedRectangleXxl =
      RoundedRectangleBorder(borderRadius: radiusXxl);
}

class AppTheme {
  // Base color schemes
  static const ColorScheme _baseLightColorScheme = ColorScheme.light(
    primary: Color(0xFF0066CC),
    secondary: Color(0xFF6366F1),
    surface: Color(0xFFFFFBFE),
    error: Color(0xFFBA1A1A),
  );

  static const ColorScheme _baseDarkColorScheme = ColorScheme.dark(
    primary: Color(0xFF99CCFF),
    secondary: Color(0xFF9CA3FF),
    surface: Color(0xFF111111),
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
      // ignore: no_default_cases
      default:
        return {};
    }
  }

  static Map<String, dynamic> _getWindowsTheme(
    ColorScheme colorScheme,
    Brightness brightness,
  ) {
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
      'cardTheme': const CardTheme(
        elevation: 1,
        shape: AppRadius.roundedRectangleSm,
      ),
    };
  }

  static Map<String, dynamic> _getMacOSTheme(
    ColorScheme colorScheme,
    Brightness brightness,
  ) {
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
      'cardTheme': const CardTheme(
        elevation: 0,
        shape: AppRadius.roundedRectangleMd,
      ),
    };
  }

  static Map<String, dynamic> _getLinuxTheme(
    ColorScheme colorScheme,
    Brightness brightness,
  ) {
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
      'cardTheme': const CardTheme(
        elevation: 1,
        shape: AppRadius.roundedRectangleMd,
      ),
    };
  }

  // VSCode-inspired dimensions
  static const double sidebarWidth = 240;
  static const double sidebarCollapsedWidth = 48;
  static const double topBarHeight = 35;
  static const double bottomBarHeight = 24;
  static const double sidePanelWidth = 300;
}
