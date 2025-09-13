import 'package:loom/features/core/search/index.dart';

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
