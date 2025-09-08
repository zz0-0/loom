import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/features/core/search/data/repositories/search_repository_impl.dart';
import 'package:loom/features/core/search/domain/repositories/search_repository.dart';
import 'package:loom/shared/data/providers.dart';

/// Repository providers for dependency injection
final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  final fileRepository = ref.watch(fileRepositoryProvider);
  return SearchRepositoryImpl(fileRepository);
});
