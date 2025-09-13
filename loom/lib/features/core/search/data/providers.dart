import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/common/index.dart';
import 'package:loom/features/core/search/index.dart';

/// Service providers
final fileFilterServiceProvider = Provider<FileFilterService>((ref) {
  final fileRepository = ref.watch(fileRepositoryProvider);
  return FileFilterService(fileRepository);
});

final textMatchServiceProvider = Provider<TextMatchService>((ref) {
  return const TextMatchService();
});

final searchExecutionServiceProvider = Provider<SearchExecutionService>((ref) {
  final fileRepository = ref.watch(fileRepositoryProvider);
  final fileFilterService = ref.watch(fileFilterServiceProvider);
  final textMatchService = ref.watch(textMatchServiceProvider);
  return SearchExecutionService(
    fileRepository,
    fileFilterService,
    textMatchService,
  );
});

final replaceExecutionServiceProvider =
    Provider<ReplaceExecutionService>((ref) {
  final fileRepository = ref.watch(fileRepositoryProvider);
  final fileFilterService = ref.watch(fileFilterServiceProvider);
  final textMatchService = ref.watch(textMatchServiceProvider);
  return ReplaceExecutionService(
    fileRepository,
    fileFilterService,
    textMatchService,
  );
});

/// Repository providers
final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  final searchExecutionService = ref.watch(searchExecutionServiceProvider);
  final replaceExecutionService = ref.watch(replaceExecutionServiceProvider);
  return SearchRepositoryImpl(
    searchExecutionService,
    replaceExecutionService,
  );
});

final recentSearchesRepositoryProvider =
    Provider<RecentSearchesRepository>((ref) {
  return RecentSearchesRepositoryImpl();
});
