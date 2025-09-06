import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/features/settings/data/repositories/settings_repositories_impl.dart';
import 'package:loom/features/settings/domain/repositories/settings_repositories.dart';

/// Repository providers for dependency injection
final appearanceSettingsRepositoryProvider =
    Provider<AppearanceSettingsRepository>((ref) {
  return AppearanceSettingsRepositoryImpl();
});

final interfaceSettingsRepositoryProvider =
    Provider<InterfaceSettingsRepository>((ref) {
  return InterfaceSettingsRepositoryImpl();
});

final generalSettingsRepositoryProvider =
    Provider<GeneralSettingsRepository>((ref) {
  return GeneralSettingsRepositoryImpl();
});

final appInfoRepositoryProvider = Provider<AppInfoRepository>((ref) {
  return AppInfoRepositoryImpl();
});
