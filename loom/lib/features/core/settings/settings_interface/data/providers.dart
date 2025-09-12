import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/features/core/settings/settings_core/domain/repositories/settings_repositories.dart';
import 'package:loom/features/core/settings/settings_interface/data/repositories/interface_settings_repository_impl.dart';

/// Repository providers for dependency injection
final interfaceSettingsRepositoryProvider =
    Provider<InterfaceSettingsRepository>((ref) {
  return InterfaceSettingsRepositoryImpl();
});
