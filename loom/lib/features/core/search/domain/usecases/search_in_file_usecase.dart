import 'package:loom/features/core/search/index.dart';

/// Use case for searching in a specific file
class SearchInFileUseCase {
  const SearchInFileUseCase(this._repository);
  final SearchRepository _repository;

  Future<List<SearchResult>> execute(String filePath, SearchQuery query) {
    return _repository.searchInFile(filePath, query);
  }
}
