import 'package:loom/features/core/search/index.dart';

/// Use case for managing recent searches
class ManageRecentSearchesUseCase {
  const ManageRecentSearchesUseCase(this._repository);
  final RecentSearchesRepository _repository;

  Future<List<SearchQuery>> getRecentSearches() {
    return _repository.getRecentSearches();
  }

  Future<void> saveRecentSearch(SearchQuery query) {
    return _repository.saveRecentSearch(query);
  }

  Future<void> clearRecentSearches() {
    return _repository.clearRecentSearches();
  }
}
