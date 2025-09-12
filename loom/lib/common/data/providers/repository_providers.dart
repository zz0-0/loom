import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/common/index.dart';

/// Shared settings repository provider
/// This should be overridden by the appropriate feature implementation
final sharedSettingsRepositoryProvider = Provider<SharedSettingsRepository>(
  (ref) {
    throw UnimplementedError(
      'SharedSettingsRepository must be implemented by a feature',
    );
  },
);

/// File repository provider
final fileRepositoryProvider = Provider<FileRepository>(
  (ref) => FileRepositoryImpl(),
);
