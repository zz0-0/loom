import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/features/core/settings/settings_appearance/data/repositories/appearance_settings_repository_impl.dart';
import 'package:loom/features/core/settings/settings_core/domain/repositories/settings_repositories.dart';

/// Repository providers for dependency injection
final appearanceSettingsRepositoryProvider =
    Provider<AppearanceSettingsRepository>((ref) {
  return AppearanceSettingsRepositoryImpl();
});
