import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/features/core/settings/index.dart';

// Service providers
final settingsFileServiceProvider = Provider<SettingsFileService>((ref) {
  return const SettingsFileService();
});

final settingsSerializationServiceProvider =
    Provider<SettingsSerializationService>((ref) {
  return const SettingsSerializationService();
});

// Repository providers
final appInfoRepositoryProvider = Provider<AppInfoRepository>((ref) {
  return AppInfoRepositoryImpl();
});

final appearanceSettingsRepositoryProvider =
    Provider<AppearanceSettingsRepository>((ref) {
  final fileService = ref.watch(settingsFileServiceProvider);
  final serializationService = ref.watch(settingsSerializationServiceProvider);
  return AppearanceSettingsRepositoryImpl(fileService, serializationService);
});

final generalSettingsRepositoryProvider =
    Provider<GeneralSettingsRepository>((ref) {
  final fileService = ref.watch(settingsFileServiceProvider);
  final serializationService = ref.watch(settingsSerializationServiceProvider);
  return GeneralSettingsRepositoryImpl(fileService, serializationService);
});

final interfaceSettingsRepositoryProvider =
    Provider<InterfaceSettingsRepository>((ref) {
  final fileService = ref.watch(settingsFileServiceProvider);
  final serializationService = ref.watch(settingsSerializationServiceProvider);
  return InterfaceSettingsRepositoryImpl(fileService, serializationService);
});
