import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/features/core/search/search_history/data/repositories/recent_searches_repository_impl.dart';
import 'package:loom/features/core/search/search_history/domain/repositories/recent_searches_repository.dart';

/// Repository providers for recent searches
final recentSearchesRepositoryProvider =
    Provider<RecentSearchesRepository>((ref) {
  return RecentSearchesRepositoryImpl();
});
