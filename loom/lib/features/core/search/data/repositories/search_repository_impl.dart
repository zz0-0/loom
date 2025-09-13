import 'dart:io' show Directory;

import 'package:loom/common/index.dart';
import 'package:loom/features/core/search/index.dart';
import 'package:path/path.dart' as path;

/// Implementation of SearchRepository
class SearchRepositoryImpl implements SearchRepository {
  SearchRepositoryImpl(this._fileRepository);

  final FileRepository _fileRepository;

  @override
  Future<SearchResults> searchInWorkspace(SearchQuery query) async {
    final stopwatch = Stopwatch()..start();

    final workspacePath = Directory.current.path;
    final allFiles = await _getAllFiles(workspacePath, query);

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
    final results = <SearchResult>[];

    try {
      final content = await _fileRepository.readFile(filePath);
      final lines = content.split('\n');

      for (var i = 0; i < lines.length; i++) {
        final line = lines[i];
        final matches = _findMatchesInLine(line, query);

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

  @override
  Future<SearchResults> replaceInWorkspace(
    SearchQuery query,
    String replaceText, {
    bool replaceAll = false,
  }) async {
    final stopwatch = Stopwatch()..start();

    final workspacePath = Directory.current.path;
    final allFiles = await _getAllFiles(workspacePath, query);

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

  @override
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
        final matches = _findMatchesInLine(line, query);

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

  /// Get all files in workspace that match the search criteria
  Future<List<String>> _getAllFiles(
    String workspacePath,
    SearchQuery query,
  ) async {
    final allFiles = await _fileRepository.listFilesRecursively(workspacePath);

    return allFiles.where((filePath) {
      // Skip hidden files unless explicitly included
      if (!query.includeHiddenFiles &&
          path.basename(filePath).startsWith('.')) {
        return false;
      }

      // Check file extension filter
      if (query.fileExtensions.isNotEmpty) {
        final extension = path.extension(filePath).toLowerCase();
        if (!query.fileExtensions.contains(extension)) {
          return false;
        }
      }

      // Check exclude patterns
      for (final pattern in query.excludePatterns) {
        if (filePath.contains(pattern)) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  /// Find all matches in a line based on the search query
  List<_Match> _findMatchesInLine(String line, SearchQuery query) {
    final matches = <_Match>[];

    if (query.searchText.isEmpty) return matches;

    final searchText =
        query.caseSensitive ? query.searchText : query.searchText.toLowerCase();
    final targetLine = query.caseSensitive ? line : line.toLowerCase();

    if (query.useRegex) {
      try {
        final pattern = RegExp(searchText, caseSensitive: query.caseSensitive);
        for (final match in pattern.allMatches(targetLine)) {
          matches.add(_Match(match.start, match.end));
        }
      } catch (e) {
        // Invalid regex, return empty
      }
    } else {
      var startIndex = 0;
      while (true) {
        final index = targetLine.indexOf(searchText, startIndex);
        if (index == -1) break;

        matches.add(_Match(index, index + searchText.length));
        startIndex = index + 1; // Move past this match
      }
    }

    return matches;
  }
}

/// Internal match representation
class _Match {
  const _Match(this.start, this.end);
  final int start;
  final int end;
}
