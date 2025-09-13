import 'dart:io' show Directory;

import 'package:loom/common/index.dart';
import 'package:loom/features/core/search/index.dart';

/// Service for executing search operations
class SearchExecutionService {
  const SearchExecutionService(
    this._fileRepository,
    this._fileFilterService,
    this._textMatchService,
  );

  final FileRepository _fileRepository;
  final FileFilterService _fileFilterService;
  final TextMatchService _textMatchService;

  /// Perform a search across files in the workspace
  Future<SearchResults> searchInWorkspace(SearchQuery query) async {
    final stopwatch = Stopwatch()..start();

    final workspacePath = Directory.current.path;
    final allFiles =
        await _fileFilterService.getFilteredFiles(workspacePath, query);

    final groups = <SearchResultsGroup>[];
    var totalMatches = 0;

    for (final filePath in allFiles) {
      final fileResults = await searchInFile(filePath, query);
      if (fileResults.isNotEmpty) {
        groups.add(SearchResultsGroup.fromResults(fileResults));
        totalMatches += fileResults.length;
      }
    }

    stopwatch.stop();

    return SearchResults(
      groups: groups,
      totalFiles: groups.length,
      totalMatches: totalMatches,
      searchTime: stopwatch.elapsed,
      query: query,
    );
  }

  /// Perform a search in a specific file
  Future<List<SearchResult>> searchInFile(
    String filePath,
    SearchQuery query,
  ) async {
    final results = <SearchResult>[];

    try {
      final content = await _fileRepository.readFile(filePath);
      final lines = content.split('\n');

      for (var i = 0; i < lines.length; i++) {
        final line = lines[i];
        final matches = _textMatchService.findMatchesInLine(line, query);

        for (final match in matches) {
          results.add(
            SearchResult.fromMatch(
              filePath,
              i + 1, // 1-based line numbers
              line,
              match.start,
              match.end,
            ),
          );
        }
      }
    } catch (e) {
      // Skip files that can't be read
    }

    return results;
  }
}
