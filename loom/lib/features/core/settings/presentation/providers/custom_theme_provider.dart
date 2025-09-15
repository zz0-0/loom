import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/common/index.dart';

// Custom theme data class
class CustomThemeData {
  const CustomThemeData({
    required this.name,
    required this.primaryColor,
    required this.secondaryColor,
    required this.surfaceColor,
    required this.onPrimaryColor,
    required this.onSecondaryColor,
    required this.onSurfaceColor,
    required this.errorColor,
    required this.onErrorColor,
    this.fontFamily = 'Inter',
    this.fontSize = 14.0,
    this.isBuiltIn = false,
  });

  // Create from JSON
  factory CustomThemeData.fromJson(Map<String, dynamic> json) {
    return CustomThemeData(
      name: json['name'] as String,
      primaryColor: Color(json['primaryColor'] as int),
      secondaryColor: Color(json['secondaryColor'] as int),
      surfaceColor: Color(json['surfaceColor'] as int),
      onPrimaryColor: Color(json['onPrimaryColor'] as int),
      onSecondaryColor: Color(json['onSecondaryColor'] as int),
      onSurfaceColor: Color(json['onSurfaceColor'] as int),
      errorColor: Color(json['errorColor'] as int),
      onErrorColor: Color(json['onErrorColor'] as int),
      fontFamily: json['fontFamily'] as String? ?? 'Inter',
      fontSize: (json['fontSize'] as num?)?.toDouble() ?? 14.0,
      isBuiltIn: json['isBuiltIn'] as bool? ?? false,
    );
  }

  final String name;
  final Color primaryColor;
  final Color secondaryColor;
  final Color surfaceColor;
  final Color onPrimaryColor;
  final Color onSecondaryColor;
  final Color onSurfaceColor;
  final Color errorColor;
  final Color onErrorColor;
  final String fontFamily;
  final double fontSize;
  final bool isBuiltIn;

  // Create ColorScheme from custom theme data
  ColorScheme toColorScheme(Brightness brightness) {
    // For system themes, adapt surface colors based on brightness
    final actualSurfaceColor = _isSystemTheme()
        ? (brightness == Brightness.light
            ? const Color(0xFFFFFBFE)
            : const Color(0xFF111111))
        : surfaceColor;

    final actualOnSurfaceColor = _isSystemTheme()
        ? (brightness == Brightness.light
            ? const Color(0xFF1C1B1F)
            : const Color(0xFFE6E1E5))
        : onSurfaceColor;

    return ColorScheme(
      brightness: brightness,
      primary: primaryColor,
      onPrimary: onPrimaryColor,
      secondary: secondaryColor,
      onSecondary: onSecondaryColor,
      error: errorColor,
      onError: onErrorColor,
      surface: actualSurfaceColor,
      onSurface: actualOnSurfaceColor,
      surfaceContainerHighest: brightness == Brightness.light
          ? actualSurfaceColor.withOpacity(0.8)
          : actualSurfaceColor.withOpacity(0.2),
      outline: brightness == Brightness.light
          ? actualOnSurfaceColor.withOpacity(0.3)
          : actualOnSurfaceColor.withOpacity(0.5),
    );
  }

  // Create ThemeData from custom theme data
  ThemeData toThemeData(Brightness? systemBrightness) {
    // For system themes, use the system brightness; otherwise use the theme's implied brightness
    final brightness = _isSystemTheme()
        ? (systemBrightness ?? Brightness.dark)
        : _getImpliedBrightness();

    final colorScheme = toColorScheme(brightness);
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: brightness,
      fontFamily: fontFamily,
      scaffoldBackgroundColor: colorScheme.surface,
      canvasColor: colorScheme.surface,
      textTheme: _createTextTheme(brightness, fontFamily, fontSize),
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        titleTextStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w500,
          color: colorScheme.onSurface,
          fontFamily: fontFamily,
        ),
      ),
      cardTheme: CardTheme(
        elevation: 1,
        shape: AppRadius.roundedRectangleMd,
        color: colorScheme.surface,
      ),
      dialogTheme: DialogTheme(
        backgroundColor: colorScheme.surface,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorScheme.surface,
      ),
    );
  }

  bool _isSystemTheme() {
    return name.toLowerCase().startsWith('system');
  }

  Brightness _getImpliedBrightness() {
    return name.toLowerCase().contains('dark')
        ? Brightness.dark
        : Brightness.light;
  }

  TextTheme _createTextTheme(
    Brightness brightness,
    String fontFamily,
    double fontSize,
  ) {
    final baseTextTheme = brightness == Brightness.light
        ? Typography.material2021().black
        : Typography.material2021().white;

    // Get the appropriate colors for the brightness
    // Use Material 3 standard colors that properly adapt to brightness
    final textColor = brightness == Brightness.light
        ? const Color(0xFF1C1B1F) // Dark text on light background
        : const Color(0xFFE6E1E5); // Light text on dark background

    final onSurfaceVariantColor = brightness == Brightness.light
        ? const Color(0xFF49454F) // Dark variant text on light background
        : const Color(0xFFCAC4D0); // Light variant text on dark background

    return baseTextTheme.copyWith(
      displayLarge: baseTextTheme.displayLarge?.copyWith(
        fontFamily: fontFamily,
        fontSize: fontSize + 12,
        color: textColor,
      ),
      displayMedium: baseTextTheme.displayMedium?.copyWith(
        fontFamily: fontFamily,
        fontSize: fontSize + 8,
        color: textColor,
      ),
      displaySmall: baseTextTheme.displaySmall?.copyWith(
        fontFamily: fontFamily,
        fontSize: fontSize + 4,
        color: textColor,
      ),
      headlineLarge: baseTextTheme.headlineLarge?.copyWith(
        fontFamily: fontFamily,
        fontSize: fontSize + 6,
        color: textColor,
      ),
      headlineMedium: baseTextTheme.headlineMedium?.copyWith(
        fontFamily: fontFamily,
        fontSize: fontSize + 4,
        color: textColor,
      ),
      headlineSmall: baseTextTheme.headlineSmall?.copyWith(
        fontFamily: fontFamily,
        fontSize: fontSize + 2,
        color: textColor,
      ),
      titleLarge: baseTextTheme.titleLarge?.copyWith(
        fontFamily: fontFamily,
        fontSize: fontSize + 2,
        color: textColor,
      ),
      titleMedium: baseTextTheme.titleMedium?.copyWith(
        fontFamily: fontFamily,
        fontSize: fontSize,
        color: textColor,
      ),
      titleSmall: baseTextTheme.titleSmall?.copyWith(
        fontFamily: fontFamily,
        fontSize: fontSize - 2,
        color: textColor,
      ),
      bodyLarge: baseTextTheme.bodyLarge?.copyWith(
        fontFamily: fontFamily,
        fontSize: fontSize,
        color: textColor,
      ),
      bodyMedium: baseTextTheme.bodyMedium?.copyWith(
        fontFamily: fontFamily,
        fontSize: fontSize - 2,
        color: textColor,
      ),
      bodySmall: baseTextTheme.bodySmall?.copyWith(
        fontFamily: fontFamily,
        fontSize: fontSize - 4,
        color: textColor,
      ),
      labelLarge: baseTextTheme.labelLarge?.copyWith(
        fontFamily: fontFamily,
        fontSize: fontSize - 2,
        color: textColor,
      ),
      labelMedium: baseTextTheme.labelMedium?.copyWith(
        fontFamily: fontFamily,
        fontSize: fontSize - 4,
        color: onSurfaceVariantColor,
      ),
      labelSmall: baseTextTheme.labelSmall?.copyWith(
        fontFamily: fontFamily,
        fontSize: fontSize - 6,
        color: onSurfaceVariantColor,
      ),
    );
  }

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'primaryColor': primaryColor.value,
      'secondaryColor': secondaryColor.value,
      'surfaceColor': surfaceColor.value,
      'onPrimaryColor': onPrimaryColor.value,
      'onSecondaryColor': onSecondaryColor.value,
      'onSurfaceColor': onSurfaceColor.value,
      'errorColor': errorColor.value,
      'onErrorColor': onErrorColor.value,
      'fontFamily': fontFamily,
      'fontSize': fontSize,
      'isBuiltIn': isBuiltIn,
    };
  }

  // Copy with new values
  CustomThemeData copyWith({
    String? name,
    Color? primaryColor,
    Color? secondaryColor,
    Color? surfaceColor,
    Color? onPrimaryColor,
    Color? onSecondaryColor,
    Color? onSurfaceColor,
    Color? errorColor,
    Color? onErrorColor,
    String? fontFamily,
    double? fontSize,
    bool? isBuiltIn,
  }) {
    return CustomThemeData(
      name: name ?? this.name,
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      surfaceColor: surfaceColor ?? this.surfaceColor,
      onPrimaryColor: onPrimaryColor ?? this.onPrimaryColor,
      onSecondaryColor: onSecondaryColor ?? this.onSecondaryColor,
      onSurfaceColor: onSurfaceColor ?? this.onSurfaceColor,
      errorColor: errorColor ?? this.errorColor,
      onErrorColor: onErrorColor ?? this.onErrorColor,
      fontFamily: fontFamily ?? this.fontFamily,
      fontSize: fontSize ?? this.fontSize,
      isBuiltIn: isBuiltIn ?? this.isBuiltIn,
    );
  }
}

// Built-in themes
class BuiltInThemes {
  static const CustomThemeData defaultLight = CustomThemeData(
    name: 'Default Light',
    primaryColor: Color(0xFF0066CC),
    secondaryColor: Color(0xFF6366F1),
    surfaceColor: Color(0xFFFFFBFE),
    onPrimaryColor: Color(0xFFFFFFFF),
    onSecondaryColor: Color(0xFFFFFFFF),
    onSurfaceColor: Color(0xFF1C1B1F),
    errorColor: Color(0xFFBA1A1A),
    onErrorColor: Color(0xFFFFFFFF),
    isBuiltIn: true,
  );

  static const CustomThemeData defaultDark = CustomThemeData(
    name: 'Default Dark',
    primaryColor: Color(0xFF99CCFF),
    secondaryColor: Color(0xFF9CA3FF),
    surfaceColor: Color(0xFF111111),
    onPrimaryColor: Color(0xFF001B3D),
    onSecondaryColor: Color(0xFF001B3D),
    onSurfaceColor: Color(0xFFE6E1E5),
    errorColor: Color(0xFFFFB4AB),
    onErrorColor: Color(0xFF690005),
    isBuiltIn: true,
  );

  static const CustomThemeData ocean = CustomThemeData(
    name: 'Ocean',
    primaryColor: Color(0xFF0077BE),
    secondaryColor: Color(0xFF00A8CC),
    surfaceColor: Color(0xFFF8F9FA),
    onPrimaryColor: Color(0xFFFFFFFF),
    onSecondaryColor: Color(0xFFFFFFFF),
    onSurfaceColor: Color(0xFF1C1B1F),
    errorColor: Color(0xFFBA1A1A),
    onErrorColor: Color(0xFFFFFFFF),
    isBuiltIn: true,
  );

  static const CustomThemeData forest = CustomThemeData(
    name: 'Forest',
    primaryColor: Color(0xFF2E7D32),
    secondaryColor: Color(0xFF4CAF50),
    surfaceColor: Color(0xFFF1F8E9),
    onPrimaryColor: Color(0xFFFFFFFF),
    onSecondaryColor: Color(0xFFFFFFFF),
    onSurfaceColor: Color(0xFF1C1B1F),
    errorColor: Color(0xFFBA1A1A),
    onErrorColor: Color(0xFFFFFFFF),
    isBuiltIn: true,
  );

  static const CustomThemeData sunset = CustomThemeData(
    name: 'Sunset',
    primaryColor: Color(0xFFFF6B35),
    secondaryColor: Color(0xFFF7931E),
    surfaceColor: Color(0xFFFFFBFE),
    onPrimaryColor: Color(0xFFFFFFFF),
    onSecondaryColor: Color(0xFFFFFFFF),
    onSurfaceColor: Color(0xFF1C1B1F),
    errorColor: Color(0xFFBA1A1A),
    onErrorColor: Color(0xFFFFFFFF),
    isBuiltIn: true,
  );

  static const CustomThemeData oceanDark = CustomThemeData(
    name: 'Ocean Dark',
    primaryColor: Color(0xFF4FC3F7),
    secondaryColor: Color(0xFF29B6F6),
    surfaceColor: Color(0xFF0D1117),
    onPrimaryColor: Color(0xFF001B3D),
    onSecondaryColor: Color(0xFF001B3D),
    onSurfaceColor: Color(0xFFE6E1E5),
    errorColor: Color(0xFFEF5350),
    onErrorColor: Color(0xFF690005),
    isBuiltIn: true,
  );

  static const CustomThemeData forestDark = CustomThemeData(
    name: 'Forest Dark',
    primaryColor: Color(0xFF66BB6A),
    secondaryColor: Color(0xFF81C784),
    surfaceColor: Color(0xFF0D1117),
    onPrimaryColor: Color(0xFF001B3D),
    onSecondaryColor: Color(0xFF001B3D),
    onSurfaceColor: Color(0xFFE6E1E5),
    errorColor: Color(0xFFEF5350),
    onErrorColor: Color(0xFF690005),
    isBuiltIn: true,
  );

  static const CustomThemeData sunsetDark = CustomThemeData(
    name: 'Sunset Dark',
    primaryColor: Color(0xFFFF8A65),
    secondaryColor: Color(0xFFFFAB91),
    surfaceColor: Color(0xFF0D1117),
    onPrimaryColor: Color(0xFF001B3D),
    onSecondaryColor: Color(0xFF001B3D),
    onSurfaceColor: Color(0xFFE6E1E5),
    errorColor: Color(0xFFEF5350),
    onErrorColor: Color(0xFF690005),
    isBuiltIn: true,
  );

  // System themes that automatically adapt to system brightness
  static const CustomThemeData systemDefault = CustomThemeData(
    name: 'System Default',
    primaryColor: Color(0xFF0066CC),
    secondaryColor: Color(0xFF6366F1),
    surfaceColor: Color(0xFFFFFFFF), // Will be overridden by system brightness
    onPrimaryColor: Color(0xFFFFFFFF),
    onSecondaryColor: Color(0xFFFFFFFF),
    onSurfaceColor:
        Color(0xFF000000), // Will be overridden by system brightness
    errorColor: Color(0xFFBA1A1A),
    onErrorColor: Color(0xFFFFFFFF),
    isBuiltIn: true,
  );

  static const CustomThemeData systemOcean = CustomThemeData(
    name: 'System Ocean',
    primaryColor: Color(0xFF0077BE),
    secondaryColor: Color(0xFF00A8CC),
    surfaceColor: Color(0xFFFFFFFF), // Will be overridden by system brightness
    onPrimaryColor: Color(0xFFFFFFFF),
    onSecondaryColor: Color(0xFFFFFFFF),
    onSurfaceColor:
        Color(0xFF000000), // Will be overridden by system brightness
    errorColor: Color(0xFFBA1A1A),
    onErrorColor: Color(0xFFFFFFFF),
    isBuiltIn: true,
  );

  static const CustomThemeData systemForest = CustomThemeData(
    name: 'System Forest',
    primaryColor: Color(0xFF4CAF50),
    secondaryColor: Color(0xFF66BB6A),
    surfaceColor: Color(0xFFFFFFFF), // Will be overridden by system brightness
    onPrimaryColor: Color(0xFFFFFFFF),
    onSecondaryColor: Color(0xFFFFFFFF),
    onSurfaceColor:
        Color(0xFF000000), // Will be overridden by system brightness
    errorColor: Color(0xFFBA1A1A),
    onErrorColor: Color(0xFFFFFFFF),
    isBuiltIn: true,
  );

  static const CustomThemeData systemSunset = CustomThemeData(
    name: 'System Sunset',
    primaryColor: Color(0xFFFF5722),
    secondaryColor: Color(0xFFFF8A65),
    surfaceColor: Color(0xFFFFFFFF), // Will be overridden by system brightness
    onPrimaryColor: Color(0xFFFFFFFF),
    onSecondaryColor: Color(0xFFFFFFFF),
    onSurfaceColor:
        Color(0xFF000000), // Will be overridden by system brightness
    errorColor: Color(0xFFBA1A1A),
    onErrorColor: Color(0xFFFFFFFF),
    isBuiltIn: true,
  );

  static List<CustomThemeData> get all => [
        defaultLight,
        defaultDark,
        ocean,
        oceanDark,
        forest,
        forestDark,
        sunset,
        sunsetDark,
        systemDefault,
        systemOcean,
        systemForest,
        systemSunset,
      ];

  static List<CustomThemeData> get lightThemes => [
        defaultLight,
        ocean,
        forest,
        sunset,
      ];

  static List<CustomThemeData> get darkThemes => [
        defaultDark,
        oceanDark,
        forestDark,
        sunsetDark,
      ];

  static List<CustomThemeData> get systemThemes => [
        systemDefault,
        systemOcean,
        systemForest,
        systemSunset,
      ];

  static bool isSystemTheme(CustomThemeData theme) {
    return theme.name.toLowerCase().startsWith('system');
  }
}

// Custom theme provider
class CustomThemeNotifier extends StateNotifier<CustomThemeData> {
  CustomThemeNotifier(this._settingsRepository, [CustomThemeData? initialTheme])
      : super(initialTheme ?? BuiltInThemes.systemDefault);

  final SharedSettingsRepository _settingsRepository;

  Future<void> setTheme(CustomThemeData theme) async {
    state = theme;
    await _saveTheme();
  }

  Future<void> updateTheme(
    CustomThemeData Function(CustomThemeData) updater,
  ) async {
    state = updater(state);
    await _saveTheme();
  }

  Future<void> _saveTheme() async {
    try {
      final themeJson = jsonEncode(state.toJson());
      await _settingsRepository.setTheme('custom:$themeJson');
    } catch (e) {
      debugPrint('Failed to save custom theme: $e');
    }
  }

  Future<void> loadSavedTheme() async {
    try {
      final themeString = await _settingsRepository.getTheme();
      if (themeString.startsWith('custom:')) {
        final themeJson = themeString.substring(7); // Remove 'custom:' prefix
        final decoded = jsonDecode(themeJson);
        if (decoded is Map<String, dynamic>) {
          final themeData = CustomThemeData.fromJson(decoded);
          state = themeData;
        }
      }
    } catch (e) {
      // Use default theme if loading fails
      state = BuiltInThemes.systemDefault;
      debugPrint('Failed to load custom theme: $e');
    }
  }
}

// Font settings
class FontSettings {
  const FontSettings({
    this.fontFamily = 'Inter',
    this.fontSize = 14.0,
  });

  factory FontSettings.fromJson(Map<String, dynamic> json) {
    return FontSettings(
      fontFamily: json['fontFamily'] as String? ?? 'Inter',
      fontSize: (json['fontSize'] as num?)?.toDouble() ?? 14.0,
    );
  }

  final String fontFamily;
  final double fontSize;

  FontSettings copyWith({
    String? fontFamily,
    double? fontSize,
  }) {
    return FontSettings(
      fontFamily: fontFamily ?? this.fontFamily,
      fontSize: fontSize ?? this.fontSize,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fontFamily': fontFamily,
      'fontSize': fontSize,
    };
  }
}

class FontSettingsNotifier extends StateNotifier<FontSettings> {
  FontSettingsNotifier() : super(const FontSettings());

  Future<void> setFontFamily(String fontFamily) async {
    state = state.copyWith(fontFamily: fontFamily);
    await _saveSettings();
  }

  Future<void> setFontSize(double fontSize) async {
    state = state.copyWith(fontSize: fontSize);
    await _saveSettings();
  }

  Future<void> _saveSettings() async {
    try {
      final settingsJson = jsonEncode(state.toJson());
      // For now, we'll store font settings in a simple way
      // In a real app, you'd want to extend the repository or use a different storage mechanism
      debugPrint('Font settings saved: $settingsJson');
    } catch (e) {
      debugPrint('Failed to save font settings: $e');
    }
  }

  Future<void> loadSavedSettings() async {
    try {
      // For now, we'll use default settings
      // In a real app, you'd want to load from persistent storage
      state = const FontSettings();
    } catch (e) {
      // Use default settings if loading fails
      state = const FontSettings();
      debugPrint('Failed to load font settings: $e');
    }
  }
}

// Providers
final customThemeProvider =
    StateNotifierProvider<CustomThemeNotifier, CustomThemeData>(
  (ref) => CustomThemeNotifier(ref.watch(sharedSettingsRepositoryProvider)),
);

final fontSettingsProvider =
    StateNotifierProvider<FontSettingsNotifier, FontSettings>(
  (ref) => FontSettingsNotifier(),
);

// Combined theme provider that merges custom theme with font settings
final currentThemeProvider = Provider<ThemeData>((ref) {
  final customTheme = ref.watch(customThemeProvider);
  final fontSettings = ref.watch(fontSettingsProvider);

  // Get system brightness for system themes
  final systemBrightness =
      WidgetsBinding.instance.platformDispatcher.platformBrightness;

  // Check if this is a system theme
  final isSystemTheme = BuiltInThemes.isSystemTheme(customTheme);

  return customTheme
      .copyWith(
        fontFamily: fontSettings.fontFamily,
        fontSize: fontSettings.fontSize,
      )
      .toThemeData(isSystemTheme ? systemBrightness : null);
});
