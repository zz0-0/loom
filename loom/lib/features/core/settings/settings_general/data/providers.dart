import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/features/core/settings/settings_core/domain/repositories/settings_repositories.dart';
import 'package:loom/features/core/settings/settings_general/data/repositories/general_settings_repository_impl.dart';

/// Repository providers for dependency injection
final generalSettingsRepositoryProvider =
    Provider<GeneralSettingsRepository>((ref) {
  return GeneralSettingsRepositoryImpl();
});
