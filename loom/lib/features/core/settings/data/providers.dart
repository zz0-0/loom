import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/features/core/settings/index.dart';

// Repository providers
final appInfoRepositoryProvider = Provider<AppInfoRepository>((ref) {
  return AppInfoRepositoryImpl();
});

final appearanceSettingsRepositoryProvider =
    Provider<AppearanceSettingsRepository>((ref) {
  return AppearanceSettingsRepositoryImpl();
});

final generalSettingsRepositoryProvider =
    Provider<GeneralSettingsRepository>((ref) {
  return GeneralSettingsRepositoryImpl();
});

final interfaceSettingsRepositoryProvider =
    Provider<InterfaceSettingsRepository>((ref) {
  return InterfaceSettingsRepositoryImpl();
});
