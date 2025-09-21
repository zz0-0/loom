import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/features/core/settings/index.dart';

/// Provider for the current app locale based on general settings
final localeProvider = Provider<Locale>((ref) {
  final generalSettings = ref.watch(generalSettingsProvider);

  Locale locale;
  if (generalSettings.followSystemLanguage) {
    // When following system language, we still need to return a supported locale
    // The system will handle the locale resolution, but we ensure it's supported
    locale = _getSupportedSystemLocale();
  } else {
    locale = _languageToLocale(generalSettings.language);
  }

  debugPrint(
      '🌍 localeProvider: Returning locale ${locale.languageCode} for language "${generalSettings.language}"',);
  return locale;
});

/// Get the system locale mapped to a supported locale
Locale _getSupportedSystemLocale() {
  // For now, default to English when following system
  // In a real app, you'd check Platform.localeName and map it
  return const Locale('en');
}

/// Convert language code to Locale
Locale _languageToLocale(String languageCode) {
  switch (languageCode) {
    case 'en':
      return const Locale('en');
    case 'es':
      return const Locale('es');
    case 'fr':
      return const Locale('fr');
    case 'de':
      return const Locale('de');
    case 'zh':
      return const Locale('zh');
    case 'ja':
      return const Locale('ja');
    case 'ko':
      return const Locale('ko');
    default:
      return const Locale('en');
  }
}
