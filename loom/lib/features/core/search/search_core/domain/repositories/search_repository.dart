import 'package:loom/features/core/search/search_core/domain/entities/search_entities.dart';

/// Repository interface for search operations
abstract class SearchRepository {
  /// Perform a search across files in the workspace
  Future<SearchResults> searchInWorkspace(SearchQuery query);

  /// Perform a search in currently open files
  Future<SearchResults> searchInOpenFiles(SearchQuery query);

  /// Perform a search in a specific file
  Future<List<SearchResult>> searchInFile(String filePath, SearchQuery query);

  /// Perform replace operations
  Future<SearchResults> replaceInWorkspace(
    SearchQuery query,
    String replaceText, {
    bool replaceAll = false,
  });

  /// Perform replace in a specific file
  Future<List<SearchResult>> replaceInFile(
    String filePath,
    SearchQuery query,
    String replaceText, {
    bool replaceAll = false,
  });
}
