import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/shared/data/repositories/file_repository_impl.dart';
import 'package:loom/shared/data/services/code_folding_service_impl.dart';
import 'package:loom/shared/data/services/edit_history_service_impl.dart';
import 'package:loom/shared/data/services/file_content_service_impl.dart';
import 'package:loom/shared/domain/repositories/file_repository.dart';
import 'package:loom/shared/domain/repositories/shared_settings_repository.dart';
import 'package:loom/shared/domain/services/code_folding_service.dart';
import 'package:loom/shared/domain/services/edit_history_service.dart';
import 'package:loom/shared/domain/services/file_content_service.dart';
import 'package:loom/shared/domain/use_cases/file_operations_use_cases.dart';

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
