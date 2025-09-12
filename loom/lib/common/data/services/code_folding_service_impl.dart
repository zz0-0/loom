import 'package:loom/common/domain/services/code_folding_service.dart';

/// Implementation of CodeFoldingService
class CodeFoldingServiceImpl implements CodeFoldingService {
  final List<FoldableRegion> _regions = [];

  @override
  Future<List<FoldableRegion>> parseFoldableRegions(String content) async {
    _regions.clear();
    final lines = content.split('\n');

    // Parse markdown-style blocks first
    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];

      // Parse code blocks (```)
      if (line.trim().startsWith('```')) {
        final startLine = i;
        final language = line.trim().substring(3).trim();
        final title = language.isNotEmpty ? language : 'Code Block';

        // Find the end of the code block
        var endLine = startLine + 1;
        while (endLine < lines.length &&
            !lines[endLine].trim().startsWith('```')) {
          endLine++;
        }

        if (endLine < lines.length) {
          _regions.add(
            FoldableRegion(
              startLine: startLine,
              endLine: endLine,
              title: title,
              type: FoldableRegionType.codeBlock,
              level: 0,
            ),
          );
          i = endLine; // Skip to end of code block
        }
      }

      // Parse headers (# ## ###)
      else if (line.trim().startsWith('#')) {
        final headerMatch =
            RegExp(r'^(#{1,6})\s+(.+)$').firstMatch(line.trim());
        if (headerMatch != null) {
          final level = headerMatch.group(1)!.length;
          final title = headerMatch.group(2)!;

          // Find the end of this section (next header of same or higher level)
          var endLine = i + 1;
          while (endLine < lines.length) {
            final nextLine = lines[endLine].trim();
            if (nextLine.startsWith('#')) {
              final nextHeaderMatch = RegExp('^(#{1,6})').firstMatch(nextLine);
              if (nextHeaderMatch != null &&
                  nextHeaderMatch.group(1)!.length <= level) {
                break;
              }
            }
            endLine++;
          }

          if (endLine > i + 1) {
            // Only add if there's content after the header
            _regions.add(
              FoldableRegion(
                startLine: i,
                endLine: endLine - 1,
                title: title,
                type: FoldableRegionType.section,
                level: level - 1, // 0-based level
              ),
            );
          }
        }
      }
    }

    // Parse programming language constructs
    _parseProgrammingConstructs(lines);

    return _regions;
  }

  void _parseProgrammingConstructs(List<String> lines) {
    var braceCount = 0;
    var blockStart = -1;
    var inFunction = false;
    var inClass = false;

    for (var i = 0; i < lines.length; i++) {
      final line = lines[i].trim();

      // Detect class definitions
      if (line.startsWith('class ') ||
          line.startsWith('abstract class ') ||
          line.startsWith('interface ')) {
        inClass = true;
        blockStart = i;
      }

      // Detect function definitions
      else if ((line.contains('function') ||
              line.contains('def ') ||
              line.contains('void ') ||
              line.contains('Future ') ||
              line.contains('String ') ||
              line.contains('int ') ||
              line.contains('bool ') ||
              line.contains('double ')) &&
          line.contains('(') &&
          line.contains(')')) {
        inFunction = true;
        blockStart = i;
      }

      // Count braces for block detection
      braceCount += '{'.allMatches(line).length;
      braceCount -= '}'.allMatches(line).length;

      // End of block
      if (braceCount == 0 && blockStart != -1) {
        if (i > blockStart + 1) {
          // Only fold multi-line blocks
          if (inClass) {
            _regions.add(
              FoldableRegion(
                startLine: blockStart,
                endLine: i,
                title: _extractClassName(lines[blockStart]),
                type: FoldableRegionType.classDefinition,
                level: _getIndentLevel(lines[blockStart]),
              ),
            );
            inClass = false;
          } else if (inFunction) {
            _regions.add(
              FoldableRegion(
                startLine: blockStart,
                endLine: i,
                title: _extractFunctionName(lines[blockStart]),
                type: FoldableRegionType.function,
                level: _getIndentLevel(lines[blockStart]),
              ),
            );
            inFunction = false;
          }
        }
        blockStart = -1;
      }

      // Detect comment blocks
      if (line.startsWith('/*') ||
          line.startsWith('///') ||
          (line.startsWith('//') &&
              i + 1 < lines.length &&
              lines[i + 1].trim().startsWith('//'))) {
        final commentStart = i;
        var commentEnd = i;

        // Find end of comment block
        while (commentEnd < lines.length) {
          final commentLine = lines[commentEnd].trim();
          if (commentLine.endsWith('*/') ||
              (commentEnd > commentStart && !commentLine.startsWith('//'))) {
            break;
          }
          commentEnd++;
        }

        if (commentEnd > commentStart + 1) {
          _regions.add(
            FoldableRegion(
              startLine: commentStart,
              endLine: commentEnd,
              title: 'Comment Block',
              type: FoldableRegionType.commentBlock,
              level: _getIndentLevel(lines[commentStart]),
            ),
          );
        }
      }
    }
  }

  int _getIndentLevel(String line) {
    return line.length - line.trimLeft().length;
  }

  String _extractClassName(String line) {
    final parts = line.trim().split(' ');
    for (var i = 0; i < parts.length; i++) {
      if (parts[i] == 'class' || parts[i] == 'interface') {
        if (i + 1 < parts.length) {
          return parts[i + 1].split('<').first; // Remove generics
        }
      }
    }
    return 'Class';
  }

  String _extractFunctionName(String line) {
    final parts = line.trim().split('(');
    if (parts.isNotEmpty) {
      final beforeParen = parts[0].trim();
      final nameParts = beforeParen.split(' ');
      return nameParts.last;
    }
    return 'Function';
  }

  @override
  void toggleFold(int regionIndex) {
    if (regionIndex >= 0 && regionIndex < _regions.length) {
      _regions[regionIndex].isFolded = !_regions[regionIndex].isFolded;
    }
  }

  @override
  bool isRegionFolded(int regionIndex) {
    if (regionIndex >= 0 && regionIndex < _regions.length) {
      return _regions[regionIndex].isFolded;
    }
    return false;
  }

  @override
  String getFoldedText() {
    if (_regions.isEmpty) return '';

    // This would need the original content to work properly
    // For now, return empty string as this is a simplified implementation
    return '';
  }

  @override
  List<FoldableRegion> get regions => _regions;
}
