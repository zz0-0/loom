import 'package:flutter/material.dart';
import 'package:loom/common/index.dart';

/// Line numbers widget for editing mode that handles text-based line calculations
class PreviewModeLineNumbersWidget extends BaseLineNumbersWidget {
  const PreviewModeLineNumbersWidget({
    required super.scrollController,
    required super.theme,
    required this.text,
    required this.foldingManager,
    required this.maxWidth,
    required this.showMinimap,
    required this.onFoldChanged,
    super.key,
    super.width = 80.0,
  });

  final String text;
  final CodeFoldingManager foldingManager;
  final double maxWidth;
  final bool showMinimap;
  final VoidCallback onFoldChanged;

  @override
  List<int> getLineNumbers() {
    final foldedText = _getFoldedText();
    final lines = foldedText.split('\n');
    final isUsingFoldedText = foldingManager.regions.isNotEmpty &&
        foldingManager.regions.any((r) => r.isFolded);

    if (isUsingFoldedText) {
      // Use the line mapping from folding manager to get original line numbers
      final lineMapping = foldingManager.lastLineMapping ??
          List.generate(lines.length, (i) => i + 1);
      return lineMapping;
    } else {
      return List.generate(lines.length, (index) => index + 1);
    }
  }

  @override
  List<double> getLineHeights() {
    final foldedLines = _getFoldedText().split('\n');
    final textWidth = _calculateTextWidth();

    return _calculateWrappedLineHeights(foldedLines, textWidth, theme);
  }

  String _getFoldedText() {
    return foldingManager.regions.isNotEmpty &&
            foldingManager.regions.any((r) => r.isFolded)
        ? foldingManager.getFoldedText()
        : text;
  }

  double _calculateTextWidth() {
    final minimapWidth = showMinimap ? 200 : 0;
    return maxWidth -
        width -
        32 -
        minimapWidth; // Subtract line number width, padding, and minimap width
  }

  List<double> _calculateWrappedLineHeights(
    List<String> lines,
    double maxWidth,
    ThemeData theme,
  ) {
    final heights = <double>[];
    const fontSize = AppTypography.editorBody;
    const lineHeight = AppTypography.lineHeightNormal;
    const minLineHeight = fontSize * lineHeight; // 21.0

    for (final line in lines) {
      if (line.isEmpty) {
        heights.add(minLineHeight);
        continue;
      }

      // Use TextPainter to measure the actual height when wrapped
      final textPainter = TextPainter(
        text: TextSpan(
          text: line,
          style: AppTypography.editorTextStyle,
        ),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: maxWidth);

      // Get the actual height after layout
      final actualHeight = textPainter.height;

      // Ensure minimum height
      heights.add(actualHeight > minLineHeight ? actualHeight : minLineHeight);
    }

    return heights;
  }

  @override
  Widget build(BuildContext context) {
    final foldedText = _getFoldedText();
    final foldedLines = foldedText.split('\n');
    final lineHeights = getLineHeights();
    final lineNumbers = getLineNumbers();

    return Container(
      width: width,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.1),
        border: Border(
          right: BorderSide(
            color: theme.dividerColor,
          ),
        ),
      ),
      child: SingleChildScrollView(
        controller: scrollController,
        physics: const NeverScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(
            top: AppSpacing.md,
            bottom: AppSpacing.sm,
            left: AppSpacing.sm,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: foldedLines.asMap().entries.map((entry) {
              final index = entry.key;
              final foldedLine = entry.value;
              final lineHeight =
                  index < lineHeights.length ? lineHeights[index] : 24.0;
              final lineNumber =
                  index < lineNumbers.length ? lineNumbers[index] : index + 1;

              // Check if this folded line corresponds to a foldable region
              final isFoldableRegion = _isFoldableRegionLine(foldedLine);
              final isFolded = _isFoldedRegionLine(foldedLine);

              return Container(
                height: lineHeight,
                alignment: Alignment.topRight,
                padding: AppSpacing.paddingRightSm,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Folding control - show for all foldable regions
                    if (isFoldableRegion)
                      InkWell(
                        onTap: () {
                          // Find the corresponding region in the original text
                          final regionIndex = _findRegionIndexForFoldedLine(
                            index,
                            foldedLines,
                          );
                          if (regionIndex != -1) {
                            foldingManager.toggleFold(regionIndex);
                            onFoldChanged(); // Trigger rebuild
                          }
                        },
                        child: Icon(
                          isFolded
                              ? Icons.chevron_right // Folded state
                              : Icons.expand_more, // Unfolded state
                          size: AppDimensions.iconSmall,
                          color: theme.colorScheme.onSurfaceVariant
                              .withOpacity(0.6),
                        ),
                      )
                    else
                      const SizedBox(width: 14),

                    // Line number
                    SizedBox(
                      width: 30, // Fixed width for line numbers
                      child: Text(
                        '$lineNumber',
                        style: AppTypography.lineNumbersTextStyle.copyWith(
                          color: theme.colorScheme.onSurfaceVariant
                              .withOpacity(0.6),
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  int _findRegionIndexForFoldedLine(
    int foldedLineIndex,
    List<String> foldedLines,
  ) {
    final foldedLine = foldedLines[foldedLineIndex];

    // Extract the title from the folded line
    final titleEndIndex = foldedLine.indexOf(' ...');
    final lineText = titleEndIndex != -1
        ? foldedLine.substring(0, titleEndIndex).trim()
        : foldedLine.trim();

    // For headers, extract just the title part (after # and spaces)
    String title;
    if (lineText.startsWith('#')) {
      final headerMatch = RegExp(r'^(#{1,6})\s*(.*)$').firstMatch(lineText);
      if (headerMatch != null) {
        title = headerMatch.group(2) ?? '';
      } else {
        title = lineText;
      }
    } else {
      title = lineText;
    }

    // Find the region with this title
    for (var i = 0; i < foldingManager.regions.length; i++) {
      if (foldingManager.regions[i].title == title) {
        return i;
      }
    }

    return -1;
  }

  bool _isFoldableRegionLine(String foldedLine) {
    // Extract the title from the folded line
    final titleEndIndex = foldedLine.indexOf(' ...');
    final lineText = titleEndIndex != -1
        ? foldedLine.substring(0, titleEndIndex).trim()
        : foldedLine.trim();

    // For headers, extract just the title part (after # and spaces)
    if (lineText.startsWith('#')) {
      final headerMatch = RegExp(r'^(#{1,6})\s*(.*)$').firstMatch(lineText);
      if (headerMatch != null) {
        final title = headerMatch.group(2) ?? '';
        // Check if any region has this title
        return foldingManager.regions.any((region) => region.title == title);
      }
    }

    // For code blocks, check the full line text
    return foldingManager.regions.any((region) => region.title == lineText);
  }

  bool _isFoldedRegionLine(String foldedLine) {
    // A line is folded if it contains "..." and "folded"
    return foldedLine.contains('...') && foldedLine.contains('folded');
  }
}
