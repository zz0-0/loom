import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/common/index.dart';
import 'package:loom/features/core/search/index.dart';

/// Repository providers for dependency injection
final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  final fileRepository = ref.watch(fileRepositoryProvider);
  return SearchRepositoryImpl(fileRepository);
});
