import 'package:loom/features/core/search/index.dart';

/// Use case for searching in open files
class SearchInOpenFilesUseCase {
  const SearchInOpenFilesUseCase(this._repository);
  final SearchRepository _repository;

  Future<SearchResults> execute(SearchQuery query) {
    return _repository.searchInOpenFiles(query);
  }
}
