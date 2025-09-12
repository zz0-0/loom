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

/// File content service provider
final fileContentServiceProvider = Provider<FileContentService>(
  (ref) => FileContentServiceImpl(),
);

/// Edit history service provider
final editHistoryServiceProvider = Provider<EditHistoryService>(
  (ref) => EditHistoryServiceImpl(),
);

/// Code folding service provider
final codeFoldingServiceProvider = Provider<CodeFoldingService>(
  (ref) => CodeFoldingServiceImpl(),
);

/// Create file use case provider
final createFileUseCaseProvider = Provider<CreateFileUseCase>(
  (ref) => CreateFileUseCase(ref.watch(fileRepositoryProvider)),
);

/// Create directory use case provider
final createDirectoryUseCaseProvider = Provider<CreateDirectoryUseCase>(
  (ref) => CreateDirectoryUseCase(ref.watch(fileRepositoryProvider)),
);
