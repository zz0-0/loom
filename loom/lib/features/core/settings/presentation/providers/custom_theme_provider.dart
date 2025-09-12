import 'dart:convert';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/common/data/providers.dart';
import 'package:loom/common/domain/repositories/shared_settings_repository.dart';
import 'package:loom/common/presentation/providers/theme_provider.dart';
import 'package:loom/common/presentation/theme/app_theme.dart';

// Custom theme data class
class CustomThemeData {
  const CustomThemeData({
    required this.name,
    required this.primaryColor,
    required this.secondaryColor,
    required this.surfaceColor,
    required this.backgroundColor,
    required this.onPrimaryColor,
    required this.onSecondaryColor,
    required this.onSurfaceColor,
    required this.onBackgroundColor,
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
      backgroundColor: Color(json['backgroundColor'] as int),
      onPrimaryColor: Color(json['onPrimaryColor'] as int),
      onSecondaryColor: Color(json['onSecondaryColor'] as int),
      onSurfaceColor: Color(json['onSurfaceColor'] as int),
      onBackgroundColor: Color(json['onBackgroundColor'] as int),
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
  final Color backgroundColor;
  final Color onPrimaryColor;
  final Color onSecondaryColor;
  final Color onSurfaceColor;
  final Color onBackgroundColor;
  final Color errorColor;
  final Color onErrorColor;
  final String fontFamily;
  final double fontSize;
  final bool isBuiltIn;

  // Create ColorScheme from custom theme data
  ColorScheme toColorScheme(Brightness brightness) {
    return ColorScheme(
      brightness: brightness,
      primary: primaryColor,
      onPrimary: onPrimaryColor,
      secondary: secondaryColor,
      onSecondary: onSecondaryColor,
      error: errorColor,
      onError: onErrorColor,
      surface: surfaceColor,
      onSurface: onSurfaceColor,
      surfaceContainerHighest: brightness == Brightness.light
          ? surfaceColor.withOpacity(0.8)
          : surfaceColor.withOpacity(0.2),
      outline: brightness == Brightness.light
          ? onSurfaceColor.withOpacity(0.3)
          : onSurfaceColor.withOpacity(0.5),
    );
  }

  // Create ThemeData from custom theme data
  ThemeData toThemeData(Brightness brightness) {
    final colorScheme = toColorScheme(brightness);
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: brightness,
      fontFamily: fontFamily,
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
      cardTheme: const CardTheme(
        elevation: 1,
        shape: AppRadius.roundedRectangleMd,
      ),
    );
  }

  TextTheme _createTextTheme(
    Brightness brightness,
    String fontFamily,
    double fontSize,
  ) {
    final baseTextTheme = brightness == Brightness.light
        ? Typography.material2021().black
        : Typography.material2021().white;

    return baseTextTheme.copyWith(
      displayLarge: baseTextTheme.displayLarge?.copyWith(
        fontFamily: fontFamily,
        fontSize: fontSize + 12,
      ),
      displayMedium: baseTextTheme.displayMedium?.copyWith(
        fontFamily: fontFamily,
        fontSize: fontSize + 8,
      ),
      displaySmall: baseTextTheme.displaySmall?.copyWith(
        fontFamily: fontFamily,
        fontSize: fontSize + 4,
      ),
      headlineLarge: baseTextTheme.headlineLarge?.copyWith(
        fontFamily: fontFamily,
        fontSize: fontSize + 6,
      ),
      headlineMedium: baseTextTheme.headlineMedium?.copyWith(
        fontFamily: fontFamily,
        fontSize: fontSize + 4,
      ),
      headlineSmall: baseTextTheme.headlineSmall?.copyWith(
        fontFamily: fontFamily,
        fontSize: fontSize + 2,
      ),
      titleLarge: baseTextTheme.titleLarge?.copyWith(
        fontFamily: fontFamily,
        fontSize: fontSize + 2,
      ),
      titleMedium: baseTextTheme.titleMedium?.copyWith(
        fontFamily: fontFamily,
        fontSize: fontSize,
      ),
      titleSmall: baseTextTheme.titleSmall?.copyWith(
        fontFamily: fontFamily,
        fontSize: fontSize - 2,
      ),
      bodyLarge: baseTextTheme.bodyLarge?.copyWith(
        fontFamily: fontFamily,
        fontSize: fontSize,
      ),
      bodyMedium: baseTextTheme.bodyMedium?.copyWith(
        fontFamily: fontFamily,
        fontSize: fontSize - 2,
      ),
      bodySmall: baseTextTheme.bodySmall?.copyWith(
        fontFamily: fontFamily,
        fontSize: fontSize - 4,
      ),
      labelLarge: baseTextTheme.labelLarge?.copyWith(
        fontFamily: fontFamily,
        fontSize: fontSize - 2,
      ),
      labelMedium: baseTextTheme.labelMedium?.copyWith(
        fontFamily: fontFamily,
        fontSize: fontSize - 4,
      ),
      labelSmall: baseTextTheme.labelSmall?.copyWith(
        fontFamily: fontFamily,
        fontSize: fontSize - 6,
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
      'backgroundColor': backgroundColor.value,
      'onPrimaryColor': onPrimaryColor.value,
      'onSecondaryColor': onSecondaryColor.value,
      'onSurfaceColor': onSurfaceColor.value,
      'onBackgroundColor': onBackgroundColor.value,
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
    Color? backgroundColor,
    Color? onPrimaryColor,
    Color? onSecondaryColor,
    Color? onSurfaceColor,
    Color? onBackgroundColor,
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
      backgroundColor: backgroundColor ?? this.backgroundColor,
      onPrimaryColor: onPrimaryColor ?? this.onPrimaryColor,
      onSecondaryColor: onSecondaryColor ?? this.onSecondaryColor,
      onSurfaceColor: onSurfaceColor ?? this.onSurfaceColor,
      onBackgroundColor: onBackgroundColor ?? this.onBackgroundColor,
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
    backgroundColor: Color(0xFFFFFBFE),
    onPrimaryColor: Color(0xFFFFFFFF),
    onSecondaryColor: Color(0xFFFFFFFF),
    onSurfaceColor: Color(0xFF1C1B1F),
    onBackgroundColor: Color(0xFF1C1B1F),
    errorColor: Color(0xFFBA1A1A),
    onErrorColor: Color(0xFFFFFFFF),
    isBuiltIn: true,
  );

  static const CustomThemeData defaultDark = CustomThemeData(
    name: 'Default Dark',
    primaryColor: Color(0xFF99CCFF),
    secondaryColor: Color(0xFF9CA3FF),
    surfaceColor: Color(0xFF111111),
    backgroundColor: Color(0xFF111111),
    onPrimaryColor: Color(0xFF001B3D),
    onSecondaryColor: Color(0xFF001B3D),
    onSurfaceColor: Color(0xFFE6E1E5),
    onBackgroundColor: Color(0xFFE6E1E5),
    errorColor: Color(0xFFFFB4AB),
    onErrorColor: Color(0xFF690005),
    isBuiltIn: true,
  );

  static const CustomThemeData ocean = CustomThemeData(
    name: 'Ocean',
    primaryColor: Color(0xFF0077BE),
    secondaryColor: Color(0xFF00A8CC),
    surfaceColor: Color(0xFFF8F9FA),
    backgroundColor: Color(0xFFF8F9FA),
    onPrimaryColor: Color(0xFFFFFFFF),
    onSecondaryColor: Color(0xFFFFFFFF),
    onSurfaceColor: Color(0xFF1C1B1F),
    onBackgroundColor: Color(0xFF1C1B1F),
    errorColor: Color(0xFFBA1A1A),
    onErrorColor: Color(0xFFFFFFFF),
    isBuiltIn: true,
  );

  static const CustomThemeData forest = CustomThemeData(
    name: 'Forest',
    primaryColor: Color(0xFF2E7D32),
    secondaryColor: Color(0xFF4CAF50),
    surfaceColor: Color(0xFFF1F8E9),
    backgroundColor: Color(0xFFF1F8E9),
    onPrimaryColor: Color(0xFFFFFFFF),
    onSecondaryColor: Color(0xFFFFFFFF),
    onSurfaceColor: Color(0xFF1C1B1F),
    onBackgroundColor: Color(0xFF1C1B1F),
    errorColor: Color(0xFFBA1A1A),
    onErrorColor: Color(0xFFFFFFFF),
    isBuiltIn: true,
  );

  static const CustomThemeData sunset = CustomThemeData(
    name: 'Sunset',
    primaryColor: Color(0xFFFF6B35),
    secondaryColor: Color(0xFFF7931E),
    surfaceColor: Color(0xFFFFFBFE),
    backgroundColor: Color(0xFFFFFBFE),
    onPrimaryColor: Color(0xFFFFFFFF),
    onSecondaryColor: Color(0xFFFFFFFF),
    onSurfaceColor: Color(0xFF1C1B1F),
    onBackgroundColor: Color(0xFF1C1B1F),
    errorColor: Color(0xFFBA1A1A),
    onErrorColor: Color(0xFFFFFFFF),
    isBuiltIn: true,
  );

  static List<CustomThemeData> get all => [
        defaultLight,
        defaultDark,
        ocean,
        forest,
        sunset,
      ];
}

// Custom theme provider
class CustomThemeNotifier extends StateNotifier<CustomThemeData> {
  CustomThemeNotifier(this._settingsRepository, [CustomThemeData? initialTheme])
      : super(initialTheme ?? BuiltInThemes.defaultLight);

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
      state = BuiltInThemes.defaultLight;
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
  final themeMode = ref.watch(themeModeProvider);

  final brightness = switch (themeMode) {
    AdaptiveThemeMode.light => Brightness.light,
    AdaptiveThemeMode.dark => Brightness.dark,
    AdaptiveThemeMode.system =>
      WidgetsBinding.instance.platformDispatcher.platformBrightness,
  };

  return customTheme
      .copyWith(
        fontFamily: fontSettings.fontFamily,
        fontSize: fontSettings.fontSize,
      )
      .toThemeData(brightness);
});
