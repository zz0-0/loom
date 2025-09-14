import 'package:loom/features/core/search/index.dart';

/// Implementation of SearchRepository
class SearchRepositoryImpl implements SearchRepository {
  SearchRepositoryImpl(
    this._searchExecutionService,
    this._replaceExecutionService,
  );

  final SearchExecutionService _searchExecutionService;
  final ReplaceExecutionService _replaceExecutionService;

  @override
  Future<SearchResults> searchInWorkspace(
    SearchQuery query, {
    String? workspacePath,
  }) async {
    return _searchExecutionService.searchInWorkspace(
      query,
      workspacePath: workspacePath,
    );
  }

  @override
  Future<SearchResults> searchInOpenFiles(SearchQuery query) async {
    // For now, return empty results as we don't have access to open files
    // This would need integration with the tab provider
    return SearchResults(
      groups: [],
      totalFiles: 0,
      totalMatches: 0,
      searchTime: Duration.zero,
      query: query,
    );
  }

  @override
  Future<List<SearchResult>> searchInFile(
    String filePath,
    SearchQuery query,
  ) async {
    return _searchExecutionService.searchInFile(filePath, query);
  }

  @override
  Future<SearchResults> replaceInWorkspace(
    SearchQuery query,
    String replaceText, {
    bool replaceAll = false,
    String? workspacePath,
  }) async {
    return _replaceExecutionService.replaceInWorkspace(
      query,
      replaceText,
      replaceAll: replaceAll,
      workspacePath: workspacePath,
    );
  }

  @override
  Future<List<SearchResult>> replaceInFile(
    String filePath,
    SearchQuery query,
    String replaceText, {
    bool replaceAll = false,
  }) async {
    return _replaceExecutionService.replaceInFile(
      filePath,
      query,
      replaceText,
      replaceAll: replaceAll,
    );
  }
}
