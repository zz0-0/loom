import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/features/search/data/repositories/search_repository_impl.dart';
import 'package:loom/features/search/domain/repositories/search_repository.dart';

/// Repository providers for dependency injection
final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  return SearchRepositoryImpl();
});
