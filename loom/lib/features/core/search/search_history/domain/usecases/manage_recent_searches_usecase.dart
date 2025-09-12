import 'package:loom/features/core/search/search_core/domain/entities/search_entities.dart';
import 'package:loom/features/core/search/search_history/domain/repositories/recent_searches_repository.dart';

/// Use case for managing recent searches
class ManageRecentSearchesUseCase {
  const ManageRecentSearchesUseCase(this._repository);

  final RecentSearchesRepository _repository;

  /// Get recent searches
  Future<List<SearchQuery>> getRecentSearches() {
    return _repository.getRecentSearches();
  }

  /// Save a recent search
  Future<void> saveRecentSearch(SearchQuery query) {
    return _repository.saveRecentSearch(query);
  }

  /// Clear all recent searches
  Future<void> clearRecentSearches() {
    return _repository.clearRecentSearches();
  }
}
