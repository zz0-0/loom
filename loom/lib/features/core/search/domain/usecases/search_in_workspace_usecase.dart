import 'package:loom/features/core/search/index.dart';

/// Use case for performing workspace-wide search
class SearchInWorkspaceUseCase {
  const SearchInWorkspaceUseCase(this._repository);
  final SearchRepository _repository;

  Future<SearchResults> execute(SearchQuery query) {
    return _repository.searchInWorkspace(query);
  }
}
