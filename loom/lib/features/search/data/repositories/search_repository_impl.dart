import 'dart:io';

import 'package:loom/features/search/domain/entities/search_entities.dart';
import 'package:loom/features/search/domain/repositories/search_repository.dart';
import 'package:path/path.dart' as path;

/// Implementation of SearchRepository
class SearchRepositoryImpl implements SearchRepository {
  static const int _maxRecentSearches = 10;
  final List<SearchQuery> _recentSearches = [];

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
      final file = File(filePath);
      if (!file.existsSync()) return results;

      final content = await file.readAsString();
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
  Future<List<SearchQuery>> getRecentSearches() async {
    return List.from(_recentSearches);
  }

  @override
  Future<void> saveRecentSearch(SearchQuery query) async {
    // Remove if already exists
    _recentSearches
      ..removeWhere((q) => q.searchText == query.searchText)

      // Add to beginning
      ..insert(0, query);

    // Limit size
    if (_recentSearches.length > _maxRecentSearches) {
      _recentSearches.removeRange(_maxRecentSearches, _recentSearches.length);
    }
  }

  @override
  Future<void> clearRecentSearches() async {
    _recentSearches.clear();
  }

  @override
  Future<SearchResults> replaceInWorkspace(
    SearchQuery query,
    String replaceText,
    bool replaceAll,
  ) async {
    final stopwatch = Stopwatch()..start();

    final workspacePath = Directory.current.path;
    final allFiles = await _getAllFiles(workspacePath, query);

    final groups = <SearchResultsGroup>[];
    var totalMatches = 0;

    for (final filePath in allFiles) {
      final fileResults =
          await replaceInFile(filePath, query, replaceText, replaceAll);
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
    String replaceText,
    bool replaceAll,
  ) async {
    final results = <SearchResult>[];

    try {
      final file = File(filePath);
      if (!file.existsSync()) return results;

      var content = await file.readAsString();
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
        await file.writeAsString(content);
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
    final files = <String>[];

    await _collectFiles(Directory(workspacePath), files, query);
    return files;
  }

  /// Recursively collect files matching the criteria
  Future<void> _collectFiles(
    Directory dir,
    List<String> files,
    SearchQuery query,
  ) async {
    try {
      await for (final entity in dir.list()) {
        if (entity is File) {
          final filePath = entity.path;

          // Skip hidden files unless explicitly included
          if (!query.includeHiddenFiles &&
              path.basename(filePath).startsWith('.')) {
            continue;
          }

          // Check file extension filter
          if (query.fileExtensions.isNotEmpty) {
            final extension = path.extension(filePath).toLowerCase();
            if (!query.fileExtensions.contains(extension)) {
              continue;
            }
          }

          // Check exclude patterns
          var shouldExclude = false;
          for (final pattern in query.excludePatterns) {
            if (filePath.contains(pattern)) {
              shouldExclude = true;
              break;
            }
          }
          if (shouldExclude) continue;

          files.add(filePath);
        } else if (entity is Directory) {
          // Skip hidden directories unless explicitly included
          if (!query.includeHiddenFiles &&
              path.basename(entity.path).startsWith('.')) {
            continue;
          }

          // Skip common directories that shouldn't be searched
          final dirName = path.basename(entity.path);
          if (['.git', 'node_modules', 'build', '.dart_tool', 'android', 'ios']
              .contains(dirName)) {
            continue;
          }

          await _collectFiles(entity, files, query);
        }
      }
    } catch (e) {
      // Skip directories that can't be read
    }
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
