import 'package:loom/features/core/search/index.dart';

/// Service for finding text matches in content
class TextMatchService {
  const TextMatchService();

  /// Find all matches in a line based on the search query
  List<Match> findMatchesInLine(String line, SearchQuery query) {
    final matches = <Match>[];

    if (query.searchText.isEmpty) return matches;

    final searchText =
        query.caseSensitive ? query.searchText : query.searchText.toLowerCase();
    final targetLine = query.caseSensitive ? line : line.toLowerCase();

    if (query.useRegex) {
      try {
        final pattern = RegExp(searchText, caseSensitive: query.caseSensitive);
        for (final match in pattern.allMatches(targetLine)) {
          matches.add(Match(match.start, match.end));
        }
      } catch (e) {
        // Invalid regex, return empty
      }
    } else {
      var startIndex = 0;
      while (true) {
        final index = targetLine.indexOf(searchText, startIndex);
        if (index == -1) break;

        matches.add(Match(index, index + searchText.length));
        startIndex = index + 1; // Move past this match
      }
    }

    return matches;
  }
}

/// Internal match representation
class Match {
  const Match(this.start, this.end);
  final int start;
  final int end;
}
