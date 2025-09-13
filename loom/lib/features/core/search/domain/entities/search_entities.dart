/// Search result item containing match information
class SearchResult {
  const SearchResult({
    required this.filePath,
    required this.fileName,
    required this.lineNumber,
    required this.lineContent,
    required this.matchStart,
    required this.matchEnd,
    required this.matchedText,
  });

  /// Create a SearchResult from a file path and match information
  factory SearchResult.fromMatch(
    String filePath,
    int lineNumber,
    String lineContent,
    int matchStart,
    int matchEnd,
  ) {
    final fileName = filePath.split('/').last;
    final matchedText = lineContent.substring(matchStart, matchEnd);

    return SearchResult(
      filePath: filePath,
      fileName: fileName,
      lineNumber: lineNumber,
      lineContent: lineContent,
      matchStart: matchStart,
      matchEnd: matchEnd,
      matchedText: matchedText,
    );
  }
  final String filePath;
  final String fileName;
  final int lineNumber;
  final String lineContent;
  final int matchStart;
  final int matchEnd;
  final String matchedText;
}

/// Search query configuration
class SearchQuery {
  const SearchQuery({
    required this.searchText,
    this.caseSensitive = false,
    this.useRegex = false,
    this.fileExtensions = const [],
    this.excludePatterns = const [],
    this.includeHiddenFiles = false,
  });
  final String searchText;
  final bool caseSensitive;
  final bool useRegex;
  final List<String> fileExtensions;
  final List<String> excludePatterns;
  final bool includeHiddenFiles;

  /// Create a copy with modified properties
  SearchQuery copyWith({
    String? searchText,
    bool? caseSensitive,
    bool? useRegex,
    List<String>? fileExtensions,
    List<String>? excludePatterns,
    bool? includeHiddenFiles,
  }) {
    return SearchQuery(
      searchText: searchText ?? this.searchText,
      caseSensitive: caseSensitive ?? this.caseSensitive,
      useRegex: useRegex ?? this.useRegex,
      fileExtensions: fileExtensions ?? this.fileExtensions,
      excludePatterns: excludePatterns ?? this.excludePatterns,
      includeHiddenFiles: includeHiddenFiles ?? this.includeHiddenFiles,
    );
  }
}

/// Search results grouped by file
class SearchResultsGroup {
  const SearchResultsGroup({
    required this.filePath,
    required this.fileName,
    required this.results,
    required this.totalMatches,
  });

  /// Create from a list of search results for the same file
  factory SearchResultsGroup.fromResults(List<SearchResult> fileResults) {
    if (fileResults.isEmpty) {
      throw ArgumentError(
          'Cannot create SearchResultsGroup from empty results',);
    }

    final firstResult = fileResults.first;
    return SearchResultsGroup(
      filePath: firstResult.filePath,
      fileName: firstResult.fileName,
      results: fileResults,
      totalMatches: fileResults.length,
    );
  }
  final String filePath;
  final String fileName;
  final List<SearchResult> results;
  final int totalMatches;
}

/// Overall search results containing all matches
class SearchResults {
  const SearchResults({
    required this.groups,
    required this.totalFiles,
    required this.totalMatches,
    required this.searchTime,
    required this.query,
  });
  final List<SearchResultsGroup> groups;
  final int totalFiles;
  final int totalMatches;
  final Duration searchTime;
  final SearchQuery query;

  /// Check if search returned any results
  bool get hasResults => totalMatches > 0;

  /// Check if search is empty
  bool get isEmpty => totalMatches == 0;
}
