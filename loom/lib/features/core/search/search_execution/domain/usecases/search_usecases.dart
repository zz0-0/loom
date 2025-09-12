import 'package:loom/features/core/search/index.dart';

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

/// Use case for replacing text in workspace
class ReplaceInWorkspaceUseCase {
  const ReplaceInWorkspaceUseCase(this._repository);
  final SearchRepository _repository;

  Future<SearchResults> execute(
    SearchQuery query,
    String replaceText, {
    bool replaceAll = false,
  }) {
    return _repository.replaceInWorkspace(
      query,
      replaceText,
      replaceAll: replaceAll,
    );
  }
}

/// Use case for replacing text in a specific file
class ReplaceInFileUseCase {
  const ReplaceInFileUseCase(this._repository);
  final SearchRepository _repository;

  Future<List<SearchResult>> execute(
    String filePath,
    SearchQuery query,
    String replaceText, {
    bool replaceAll = false,
  }) {
    return _repository.replaceInFile(
      filePath,
      query,
      replaceText,
      replaceAll: replaceAll,
    );
  }
}
