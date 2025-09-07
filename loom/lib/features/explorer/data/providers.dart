import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/features/explorer/data/adapters/shared_settings_adapter.dart';
import 'package:loom/features/explorer/data/repositories/settings_repository_impl.dart';
import 'package:loom/features/explorer/data/repositories/workspace_repository_impl.dart';
import 'package:loom/features/explorer/domain/repositories/workspace_repository.dart';
import 'package:loom/shared/data/providers.dart';
import 'package:loom/shared/domain/repositories/shared_settings_repository.dart';

/// Repository providers for dependency injection
/// These should be used by presentation layer instead of direct instantiation

final workspaceRepositoryProvider = Provider<WorkspaceRepository>((ref) {
  final fileRepository = ref.watch(fileRepositoryProvider);
  return WorkspaceRepositoryImpl(fileRepository);
});

final workspaceSettingsRepositoryProvider =
    Provider<WorkspaceSettingsRepository>((ref) {
  return WorkspaceSettingsRepositoryImpl();
});

/// Shared settings repository provider override
final sharedSettingsRepositoryProviderOverride =
    Provider<SharedSettingsRepository>((ref) {
  final settingsRepo = ref.watch(workspaceSettingsRepositoryProvider);
  return ExplorerSharedSettingsRepository(settingsRepo);
});
