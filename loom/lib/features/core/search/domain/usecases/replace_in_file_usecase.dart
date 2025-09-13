import 'package:loom/features/core/search/index.dart';

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
