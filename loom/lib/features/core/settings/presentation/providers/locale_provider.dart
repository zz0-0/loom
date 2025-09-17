import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/features/core/settings/index.dart';

/// Provider for the current app locale based on general settings
final localeProvider = Provider<Locale?>((ref) {
  final generalSettings = ref.watch(generalSettingsProvider);

  if (generalSettings.followSystemLanguage) {
    return null; // null means follow system locale
  }

  return _languageToLocale(generalSettings.language);
});

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
