import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:loom/common/index.dart';
import 'package:loom/src/rust/api/blox_api.dart';

/// Line numbers widget for preview mode that calculates heights based on rendered block heights
class LivePreviewModeLineNumbersWidget extends BaseLineNumbersWidget {
  const LivePreviewModeLineNumbersWidget({
    required super.scrollController,
    required super.theme,
    required this.blocks,
    required this.foldingManager,
    required this.maxWidth,
    required this.showMinimap,
    required this.onFoldChanged,
    super.key,
    super.width = 80.0,
  });

  final List<BloxBlock> blocks;
  final CodeFoldingManager foldingManager;
  final double maxWidth;
  final bool showMinimap;
  final VoidCallback onFoldChanged;

  @override
  List<int> getLineNumbers() {
    // For preview mode, we need to generate line numbers based on the blocks
    // Each block may span multiple lines, so we need to expand them
    final lineNumbers = <int>[];
    var currentLine = 1;

    for (final block in blocks) {
      final lineSpan = _getBlockLineSpan(block);
      for (var i = 0; i < lineSpan; i++) {
        lineNumbers.add(currentLine + i);
      }
      currentLine += lineSpan;
    }

    return lineNumbers;
  }

  @override
  List<double> getLineHeights() {
    // Calculate heights based on block types and their rendered heights
    final heights = <double>[];
    const baseLineHeight = 21.0; // Same as editing mode

    for (final block in blocks) {
      if (block.blockType.toLowerCase() == 'list') {
        // Handle list items individually
        // Each item gets its text height + bottom padding (4px)
        // The container padding (4px top + 4px bottom) is handled by top padding
        for (final item in block.listItems) {
          final itemHeight =
              _calculateListItemHeight(item.content, baseLineHeight);
          heights.add(itemHeight); // AppSpacing.xs bottom padding per item
        }
      } else {
        final lineSpan = _getBlockLineSpan(block);
        final blockHeight = _calculateBlockHeight(block, baseLineHeight);
        final lineHeight = blockHeight / lineSpan;

        for (var i = 0; i < lineSpan; i++) {
          heights.add(lineHeight);
        }
      }
    }

    return heights;
  }

  List<double> getLineTopPaddings() {
    // Calculate top padding for each line number to align with content
    final paddings = <double>[];
    var previousBottomPadding = 0.0;

    for (final block in blocks) {
      final topPadding = _getBlockTopPadding(block);

      if (block.blockType.toLowerCase() == 'list') {
        // Handle list items individually - each gets the block's top padding
        // First item includes previous block's bottom padding
        paddings.add(topPadding + previousBottomPadding);
        // Subsequent items only get top padding
        for (var i = 1; i < block.listItems.length; i++) {
          paddings.add(topPadding);
        }
      } else {
        final lineSpan = _getBlockLineSpan(block);
        // First line includes previous block's bottom padding
        paddings.add(topPadding + previousBottomPadding);
        // Subsequent lines only get top padding
        for (var i = 1; i < lineSpan; i++) {
          paddings.add(topPadding);
        }
      }

      if (block.blockType.toLowerCase() == 'list') {
        // Update previous bottom padding for next block only when
        // previous block is a list
        previousBottomPadding = _getBlockBottomPadding(block);
      }
    }

    return paddings;
  }

  int _getBlockLineSpan(BloxBlock block) {
    // For most blocks, they correspond to 1 line
    // But code blocks, lists, etc. can span multiple lines
    switch (block.blockType.toLowerCase()) {
      case 'code':
      case 'c':
        // Code blocks span multiple lines
        return block.content.split('\n').length +
            2; // +2 for opening/closing ```
      case 'list':
        // Lists have multiple items
        return block.listItems.length;
      case 'quote':
      case 'q':
        // Quotes can span multiple lines
        return block.content.split('\n').length;
      default:
        // Most blocks (paragraph, heading, etc.) span 1 line
        return 1;
    }
  }

  double _calculateBlockHeight(BloxBlock block, double baseLineHeight) {
    // Use TextPainter to measure actual rendered height with appropriate styles
    switch (block.blockType.toLowerCase()) {
      case 'paragraph':
      case 'p':
        final text = block.inlineElements
            .map(
              (e) => e.when(
                text: (content) => content,
                bold: (content) => content,
                italic: (content) => content,
                code: (content) => content,
                link: (text, url) => text,
                strikethrough: (content) => content,
                highlight: (content) => content,
                subscript: (content) => content,
                superscript: (content) => content,
                math: (content) => content,
                reference: (content) => content,
                footnote: (id, text) => '[$id]',
                custom: (elementType, attributes, content) => content,
              ),
            )
            .join();
        if (text.isEmpty) {
          return 28; // Measured actual height for empty paragraphs
        }
        return _measureTextHeight(text, AppTypography.editorTextStyle) +
            8; // AppSpacing.paddingVerticalXs = 4px top + 4px bottom

      case 'document':
      case 'section':
      case 'h1':
      case 'h2':
      case 'h3':
      case 'h4':
      case 'h5':
      case 'h6':
        final level = block.level.toInt();
        // Use the same style calculation as BloxRenderer
        final baseStyle = theme.textTheme.bodyMedium!;
        final headingStyle = AppTypography.getHeadingStyle(level).copyWith(
          color: baseStyle.color,
          fontFamily: baseStyle.fontFamily,
          height: baseStyle.height,
        );
        final textHeight =
            _measureTextHeight(block.getAttribute('title') ?? '', headingStyle);
        // Add padding based on block type: document=32px, section=16px, headings=8px
        final padding = switch (block.blockType.toLowerCase()) {
          'document' => 32, // AppSpacing.paddingVerticalMd
          'section' => 16, // AppSpacing.paddingVerticalSm
          _ => 8, // AppSpacing.paddingVerticalXs for h1-h6
        };
        return textHeight + padding;

      case 'code':
      case 'c':
        // Measure the code content height + margin + padding
        final codeHeight =
            _measureTextHeight(block.content, AppTypography.codeTextStyle);
        return codeHeight +
            16; // AppSpacing.marginVerticalXs (4+4) + AppSpacing.paddingSm (8+8) = 16

      case 'quote':
      case 'q':
        final quoteHeight = _measureTextHeight(
          block.inlineElements
              .map(
                (e) => e.when(
                  text: (content) => content,
                  bold: (content) => content,
                  italic: (content) => content,
                  code: (content) => content,
                  link: (text, url) => text,
                  strikethrough: (content) => content,
                  highlight: (content) => content,
                  subscript: (content) => content,
                  superscript: (content) => content,
                  math: (content) => content,
                  reference: (content) => content,
                  footnote: (id, text) => '[$id]',
                  custom: (elementType, attributes, content) => content,
                ),
              )
              .join(),
          AppTypography.editorTextStyle,
        );
        return quoteHeight +
            16; // AppSpacing.marginVerticalXs (4+4) + AppSpacing.paddingSm (8+8) = 16

      case 'list':
        // Lists are handled separately in getLineHeights
        return 0; // Not used for lists

      case 'table':
      case 'tbl':
        // Tables have header + data rows
        final rows = block.table?.rows.length ?? 0;
        final hasHeader = block.table?.header != null;
        return baseLineHeight * (rows + (hasHeader ? 1 : 0)) +
            8; // AppSpacing.paddingVerticalXs

      case 'image':
      case 'img':
        return 200; // Fixed height for images in BloxRenderer

      case 'math':
      case 'm':
        return _measureTextHeight(block.content, AppTypography.mathTextStyle) +
            16; // AppSpacing.marginVerticalXs (4+4) + AppSpacing.paddingSm (8+8) = 16

      default:
        return _measureTextHeight(
              block.inlineElements
                  .map(
                    (e) => e.when(
                      text: (content) => content,
                      bold: (content) => content,
                      italic: (content) => content,
                      code: (content) => content,
                      link: (text, url) => text,
                      strikethrough: (content) => content,
                      highlight: (content) => content,
                      subscript: (content) => content,
                      superscript: (content) => content,
                      math: (content) => content,
                      reference: (content) => content,
                      footnote: (id, text) => '[$id]',
                      custom: (elementType, attributes, content) => content,
                    ),
                  )
                  .join(),
              AppTypography.editorTextStyle,
            ) +
            8; // Default to paragraph padding
    }
  }

  double _calculateListItemHeight(String itemContent, double baseLineHeight) {
    // Measure the actual height of the list item content using the same style as BloxRenderer
    // List items use theme.textTheme.bodyMedium for rendering
    final textStyle = theme.textTheme.bodyMedium!;
    // For list items, available width is:
    // Total width - line numbers (80) - content padding (32) - marker width (14)
    // = maxWidth - 80 - 32 - 14 = maxWidth - 126
    final availableWidth = maxWidth - 126;
    final textHeight =
        _measureTextHeightWithWidth(itemContent, textStyle, availableWidth);
    // Add bottom padding from BloxRenderer (AppSpacing.xs = 4)
    final paddedHeight = textHeight + 4;
    // Ensure minimum height of 24px for list items
    return math.max(paddedHeight, 24);
  }

  double _measureTextHeight(String text, TextStyle style) {
    if (text.isEmpty) {
      return style.fontSize! * (style.height ?? 1.2);
    }

    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout(
        maxWidth: maxWidth - width - 32,
      ); // Account for BloxViewer horizontal padding (16+16)

    return textPainter.height;
  }

  double _getBlockTopPadding(BloxBlock block) {
    // Calculate the top padding offset for line number alignment
    // This matches the padding structure in BloxRenderer for each block type
    switch (block.blockType.toLowerCase()) {
      case 'paragraph':
      case 'p':
        // Paragraphs: padding 4px top
        return 4;
      case 'document':
        // Document titles: padding 16px
        return 16.0 + 15;
      case 'section':
        // Sections: padding 8px
        return 8.0 + 15;
      case 'h1':
      case 'h2':
      case 'h3':
      case 'h4':
      case 'h5':
      case 'h6':
        // Regular headings: padding 4px
        return 4.0 + 10;
      case 'code':
      case 'c':
        // Code blocks: margin 4px top
        return 4;
      case 'quote':
      case 'q':
        // Quote blocks: margin 4px top
        return 4;
      case 'list':
        // Lists: padding 4px top
        return 4;
      case 'table':
      case 'tbl':
        // Tables: padding 4px top
        return 4;
      case 'image':
      case 'img':
        // Image blocks: padding 4px top
        return 4;
      case 'math':
      case 'm':
        // Math blocks: margin 4px top
        return 4;
      default:
        // Default blocks (treated as paragraphs): padding 4px top
        return 4;
    }
  }

  double _getBlockBottomPadding(BloxBlock block) {
    // Calculate the bottom padding for each block type
    // This matches the padding structure in BloxRenderer for each block type
    switch (block.blockType.toLowerCase()) {
      case 'paragraph':
      case 'p':
        // Paragraphs: padding 4px bottom
        return 4;
      case 'document':
        // Document titles: padding 16px bottom
        return 16;
      case 'section':
        // Sections: padding 8px bottom
        return 8;
      case 'h1':
      case 'h2':
      case 'h3':
      case 'h4':
      case 'h5':
      case 'h6':
        // Regular headings: padding 4px bottom
        return 4;
      case 'code':
      case 'c':
        // Code blocks: margin 4px bottom
        return 4;
      case 'quote':
      case 'q':
        // Quote blocks: margin 4px bottom
        return 4;
      case 'list':
        // Lists: padding 4px bottom
        return 4;
      case 'table':
      case 'tbl':
        // Tables: padding 4px bottom
        return 4;
      case 'image':
      case 'img':
        // Image blocks: padding 4px bottom
        return 4;
      case 'math':
      case 'm':
        // Math blocks: margin 4px bottom
        return 4;
      default:
        // Default blocks (treated as paragraphs): padding 4px bottom
        return 4;
    }
  }

  double _measureTextHeightWithWidth(
    String text,
    TextStyle style,
    double availableWidth,
  ) {
    if (text.isEmpty) {
      return style.fontSize! * (style.height ?? 1.2);
    }

    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: availableWidth);

    return textPainter.height;
  }

  @override
  Widget build(BuildContext context) {
    final lineNumbers = getLineNumbers();
    final lineHeights = getLineHeights();
    final lineTopPaddings = getLineTopPaddings();

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
            children: lineNumbers.asMap().entries.map((entry) {
              final index = entry.key;
              final lineNumber = entry.value;
              final lineHeight = index < lineHeights.length
                  ? lineHeights[index]
                  : AppDimensions.listItemHeight;
              final topPadding =
                  index < lineTopPaddings.length ? lineTopPaddings[index] : 4.0;

              return Container(
                height: lineHeight,
                padding: EdgeInsets.only(top: topPadding, right: 8),
                child: SizedBox(
                  width: AppDimensions.lineNumbersMinWidth,
                  child: Text(
                    '$lineNumber',
                    style: AppTypography.lineNumbersTextStyle.copyWith(
                      color:
                          theme.colorScheme.onSurfaceVariant.withOpacity(0.6),
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
