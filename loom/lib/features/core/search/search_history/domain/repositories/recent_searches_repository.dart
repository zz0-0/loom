import 'package:loom/features/core/search/search_core/domain/entities/search_entities.dart';

/// Repository for managing recent search queries
abstract class RecentSearchesRepository {
  /// Get the list of recent search queries
  Future<List<SearchQuery>> getRecentSearches();

  /// Save a search query to recent searches
  Future<void> saveRecentSearch(SearchQuery query);

  /// Clear all recent searches
  Future<void> clearRecentSearches();
}
