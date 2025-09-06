import 'package:loom/features/search/domain/entities/search_entities.dart';
import 'package:loom/features/search/domain/repositories/search_repository.dart';

/// Use case for performing workspace-wide search
class SearchInWorkspaceUseCase {
  const SearchInWorkspaceUseCase(this._repository);
  final SearchRepository _repository;

  Future<SearchResults> execute(SearchQuery query) {
    return _repository.searchInWorkspace(query);
  }
}

/// Use case for searching in open files
class SearchInOpenFilesUseCase {
  const SearchInOpenFilesUseCase(this._repository);
  final SearchRepository _repository;

  Future<SearchResults> execute(SearchQuery query) {
    return _repository.searchInOpenFiles(query);
  }
}

/// Use case for searching in a specific file
class SearchInFileUseCase {
  const SearchInFileUseCase(this._repository);
  final SearchRepository _repository;

  Future<List<SearchResult>> execute(String filePath, SearchQuery query) {
    return _repository.searchInFile(filePath, query);
  }
}

/// Use case for managing recent searches
class ManageRecentSearchesUseCase {
  const ManageRecentSearchesUseCase(this._repository);
  final SearchRepository _repository;

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
