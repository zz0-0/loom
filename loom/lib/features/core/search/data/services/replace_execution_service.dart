import 'dart:io' show Directory;

import 'package:loom/common/index.dart';
import 'package:loom/features/core/search/index.dart';

/// Service for executing replace operations
class ReplaceExecutionService {
  const ReplaceExecutionService(
    this._fileRepository,
    this._fileFilterService,
    this._textMatchService,
  );

  final FileRepository _fileRepository;
  final FileFilterService _fileFilterService;
  final TextMatchService _textMatchService;

  /// Perform replace operations across files in the workspace
  Future<SearchResults> replaceInWorkspace(
    SearchQuery query,
    String replaceText, {
    bool replaceAll = false,
  }) async {
    final stopwatch = Stopwatch()..start();

    final workspacePath = Directory.current.path;
    final allFiles =
        await _fileFilterService.getFilteredFiles(workspacePath, query);

    final groups = <SearchResultsGroup>[];
    var totalMatches = 0;

    for (final filePath in allFiles) {
      final fileResults = await replaceInFile(
        filePath,
        query,
        replaceText,
        replaceAll: replaceAll,
      );
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

  /// Perform replace in a specific file
  Future<List<SearchResult>> replaceInFile(
    String filePath,
    SearchQuery query,
    String replaceText, {
    bool replaceAll = false,
  }) async {
    final results = <SearchResult>[];

    try {
      var content = await _fileRepository.readFile(filePath);
      final originalContent = content;
      final lines = content.split('\n');

      for (var i = 0; i < lines.length; i++) {
        final line = lines[i];
        final matches = _textMatchService.findMatchesInLine(line, query);

        if (matches.isNotEmpty) {
          if (replaceAll) {
            // Replace all matches in this line
            var newLine = line;
            for (final match in matches.reversed) {
              final beforeMatch = newLine.substring(0, match.start);
              final afterMatch = newLine.substring(match.end);
              newLine = beforeMatch + replaceText + afterMatch;
            }
            lines[i] = newLine;
          } else {
            // Replace only first match
            final match = matches.first;
            final beforeMatch = line.substring(0, match.start);
            final afterMatch = line.substring(match.end);
            lines[i] = beforeMatch + replaceText + afterMatch;
          }

          // Record the replacement
          final match = matches.first; // Use first match for result
          results.add(
            SearchResult.fromMatch(
              filePath,
              i + 1,
              lines[i], // Use the new line content
              match.start,
              match.start + replaceText.length,
            ),
          );

          if (!replaceAll) {
            break; // Stop after first replacement if not replace all
          }
        }
      }

      // Write back the modified content
      if (content != originalContent) {
        content = lines.join('\n');
        await _fileRepository.writeFile(filePath, content);
      }
    } catch (e) {
      // Skip files that can't be read/written
    }

    return results;
  }
}
