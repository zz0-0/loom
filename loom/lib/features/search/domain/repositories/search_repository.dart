import 'package:loom/features/search/domain/entities/search_entities.dart';

/// Repository interface for search operations
abstract class SearchRepository {
  /// Perform a search across files in the workspace
  Future<SearchResults> searchInWorkspace(SearchQuery query);

  /// Perform a search in currently open files
  Future<SearchResults> searchInOpenFiles(SearchQuery query);

  /// Perform a search in a specific file
  Future<List<SearchResult>> searchInFile(String filePath, SearchQuery query);

  /// Get recent search queries
  Future<List<SearchQuery>> getRecentSearches();

  /// Save a search query to recent searches
  Future<void> saveRecentSearch(SearchQuery query);

  /// Clear recent searches
  Future<void> clearRecentSearches();
}
