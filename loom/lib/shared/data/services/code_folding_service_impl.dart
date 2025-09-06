import 'package:loom/shared/domain/services/code_folding_service.dart';

/// Implementation of CodeFoldingService
class CodeFoldingServiceImpl implements CodeFoldingService {
  final List<FoldableRegion> _regions = [];

  @override
  Future<List<FoldableRegion>> parseFoldableRegions(String content) async {
    _regions.clear();
    final lines = content.split('\n');

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

    return _regions;
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
