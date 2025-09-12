/// Service for managing code folding operations
abstract class CodeFoldingService {
  /// Parses content and identifies foldable regions
  Future<List<FoldableRegion>> parseFoldableRegions(String content);

  /// Toggles folding for a specific region
  void toggleFold(int regionIndex);

  /// Checks if a region is folded
  bool isRegionFolded(int regionIndex);

  /// Gets the folded text representation
  String getFoldedText();

  /// Gets all foldable regions
  List<FoldableRegion> get regions;
}

/// Represents a foldable region in code
class FoldableRegion {
  FoldableRegion({
    required this.startLine,
    required this.endLine,
    required this.title,
    required this.type,
    required this.level,
    this.isFolded = false,
  });

  final int startLine;
  final int endLine;
  final String title;
  final FoldableRegionType type;
  final int level;
  bool isFolded;
}

/// Types of foldable regions
enum FoldableRegionType {
  codeBlock,
  section,
  commentBlock,
  function,
  classDefinition,
}
