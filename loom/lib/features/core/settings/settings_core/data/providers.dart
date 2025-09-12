import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/features/core/settings/settings_core/data/repositories/app_info_repository_impl.dart';
import 'package:loom/features/core/settings/settings_core/domain/repositories/settings_repositories.dart';

/// Repository providers for dependency injection
final appInfoRepositoryProvider = Provider<AppInfoRepository>((ref) {
  return AppInfoRepositoryImpl();
});
