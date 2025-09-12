import 'package:loom/features/core/search/search_core/domain/entities/search_entities.dart';
import 'package:loom/features/core/search/search_history/domain/repositories/recent_searches_repository.dart';

/// Implementation of RecentSearchesRepository
class RecentSearchesRepositoryImpl implements RecentSearchesRepository {
  static const int _maxRecentSearches = 10;
  final List<SearchQuery> _recentSearches = [];

  @override
  Future<List<SearchQuery>> getRecentSearches() async {
    return List.from(_recentSearches);
  }

  @override
  Future<void> saveRecentSearch(SearchQuery query) async {
    // Remove if already exists
    _recentSearches
      ..removeWhere((q) => q.searchText == query.searchText)

      // Add to beginning
      ..insert(0, query);

    // Limit size
    if (_recentSearches.length > _maxRecentSearches) {
      _recentSearches.removeRange(_maxRecentSearches, _recentSearches.length);
    }
  }

  @override
  Future<void> clearRecentSearches() async {
    _recentSearches.clear();
  }
}
