import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loom/src/rust/api/blox_api.dart';

/// Enhanced Blox renderer that handles inline elements, lists, and tables
class BloxRenderer {
  /// Render a BloxBlock with enhanced features
  static Widget renderBlock(
    BuildContext context,
    BloxBlock block, {
    TextStyle? baseStyle,
    bool isDark = false,
  }) {
    final theme = Theme.of(context);
    final defaultStyle = baseStyle ?? theme.textTheme.bodyMedium!;

    switch (block.blockType.toLowerCase()) {
      case 'paragraph':
      case 'p':
        return _renderParagraph(context, block, defaultStyle);

      case 'section':
      case 'h1':
      case 'h2':
      case 'h3':
      case 'h4':
      case 'h5':
      case 'h6':
        return _renderHeading(context, block, defaultStyle);

      case 'code':
      case 'c':
        return _renderCodeBlock(context, block, defaultStyle);

      case 'quote':
      case 'q':
        return _renderQuote(context, block, defaultStyle);

      case 'list':
        return _renderList(context, block, defaultStyle);

      case 'table':
      case 'tbl':
        return _renderTable(context, block, defaultStyle);

      case 'image':
      case 'img':
        return _renderImage(context, block, defaultStyle);

      case 'math':
      case 'm':
        return _renderMath(context, block, defaultStyle);

      default:
        // For unknown block types, render as paragraph
        return _renderParagraph(context, block, defaultStyle);
    }
  }

  static Widget _renderParagraph(
    BuildContext context,
    BloxBlock block,
    TextStyle baseStyle,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: RichText(
        text: _buildInlineTextSpan(context, block.inlineElements, baseStyle),
      ),
    );
  }

  static Widget _renderHeading(
    BuildContext context,
    BloxBlock block,
    TextStyle baseStyle,
  ) {
    final level = block.level.toInt();
    final headingStyle = _getHeadingStyle(baseStyle, level);

    final title = block.getAttribute('title') ?? '';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: headingStyle,
          ),
          if (block.inlineElements.isNotEmpty) ...[
            const SizedBox(height: 8),
            RichText(
              text: _buildInlineTextSpan(
                context,
                block.inlineElements,
                baseStyle,
              ),
            ),
          ],
        ],
      ),
    );
  }

  static Widget _renderCodeBlock(
    BuildContext context,
    BloxBlock block,
    TextStyle baseStyle,
  ) {
    final theme = Theme.of(context);
    final lang = block.getAttribute('lang') ?? '';

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.dividerColor,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (lang.isNotEmpty) ...[
            Text(
              lang,
              style: baseStyle.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
          ],
          Text(
            block.content,
            style: baseStyle.copyWith(
              fontFamily: 'monospace',
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _renderQuote(
    BuildContext context,
    BloxBlock block,
    TextStyle baseStyle,
  ) {
    final theme = Theme.of(context);
    final author = block.getAttribute('author');

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: theme.colorScheme.primary,
            width: 4,
          ),
        ),
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text:
                _buildInlineTextSpan(context, block.inlineElements, baseStyle),
          ),
          if (author != null) ...[
            const SizedBox(height: 8),
            Text(
              '— $author',
              style: baseStyle.copyWith(
                fontStyle: FontStyle.italic,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }

  static Widget _renderList(
    BuildContext context,
    BloxBlock block,
    TextStyle baseStyle,
  ) {
    if (block.listItems.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: block.listItems
            .map((item) => _renderListItem(context, item, baseStyle, 0))
            .toList(),
      ),
    );
  }

  static Widget _renderListItem(
    BuildContext context,
    BloxListItem item,
    TextStyle baseStyle,
    int indentLevel,
  ) {
    final indent = indentLevel * 20.0;

    return Padding(
      padding: EdgeInsets.only(left: indent, bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // List marker
          SizedBox(
            width: 24,
            child: _buildListMarker(item.itemType, baseStyle),
          ),

          // Item content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    text: item.content,
                    style: baseStyle,
                  ),
                ),

                // Render children
                if (item.children.isNotEmpty)
                  ...item.children.map(
                    (child) => _renderListItem(
                      context,
                      child,
                      baseStyle,
                      indentLevel + 1,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildListMarker(
    BloxListItemType itemType,
    TextStyle baseStyle,
  ) {
    return itemType.when(
      unchecked: () => Text('•', style: baseStyle),
      checked: () => Text('✓', style: baseStyle.copyWith(color: Colors.green)),
      definition: (term) => Text(
        '$term:',
        style: baseStyle.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  static Widget _renderTable(
    BuildContext context,
    BloxBlock block,
    TextStyle baseStyle,
  ) {
    if (block.table == null) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final table = block.table!;
    final caption = block.getAttribute('caption');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (caption != null) ...[
            Text(
              caption,
              style: baseStyle.copyWith(
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 8),
          ],
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: theme.dividerColor),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Table(
              border: TableBorder.symmetric(
                inside: BorderSide(color: theme.dividerColor),
              ),
              columnWidths: const {
                // Auto-size columns
              },
              children: [
                // Header row
                if (table.header != null)
                  _buildTableRow(
                    context,
                    table.header!,
                    baseStyle,
                    isHeader: true,
                  ),

                // Data rows
                ...table.rows.map(
                  (row) =>
                      _buildTableRow(context, row, baseStyle, isHeader: false),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static TableRow _buildTableRow(
    BuildContext context,
    BloxTableRow row,
    TextStyle baseStyle, {
    required bool isHeader,
  }) {
    final theme = Theme.of(context);

    return TableRow(
      decoration: BoxDecoration(
        color: isHeader ? theme.colorScheme.surfaceContainerHighest : null,
      ),
      children: row.cells.map((cell) {
        final cellStyle = isHeader
            ? baseStyle.copyWith(fontWeight: FontWeight.w600)
            : baseStyle;

        return Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            cell.content,
            style: cellStyle,
          ),
        );
      }).toList(),
    );
  }

  static Widget _renderImage(
    BuildContext context,
    BloxBlock block,
    TextStyle baseStyle,
  ) {
    final theme = Theme.of(context);
    final src = block.getAttribute('src') ?? '';
    final alt = block.getAttribute('alt') ?? '';
    final width = block.getAttribute('width');
    final height = block.getAttribute('height');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: theme.dividerColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(
              Icons.image,
              size: 48,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 8),
            Text(
              alt.isNotEmpty ? alt : 'Image: $src',
              style: baseStyle.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (width != null || height != null) ...[
              const SizedBox(height: 4),
              Text(
                '${width ?? 'auto'} × ${height ?? 'auto'}',
                style: baseStyle.copyWith(
                  fontSize: 12,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  static Widget _renderMath(
    BuildContext context,
    BloxBlock block,
    TextStyle baseStyle,
  ) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.dividerColor,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.functions,
            color: theme.colorScheme.primary,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            block.content,
            style: baseStyle.copyWith(
              fontFamily: 'monospace',
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  static TextSpan _buildInlineTextSpan(
    BuildContext context,
    List<BloxInlineElement> elements,
    TextStyle baseStyle,
  ) {
    if (elements.isEmpty) {
      return TextSpan(text: '', style: baseStyle);
    }

    final spans = <TextSpan>[];

    for (final element in elements) {
      spans.add(
        element.when(
          text: (content) => TextSpan(text: content, style: baseStyle),
          bold: (content) => TextSpan(
            text: content,
            style: baseStyle.copyWith(fontWeight: FontWeight.bold),
          ),
          italic: (content) => TextSpan(
            text: content,
            style: baseStyle.copyWith(fontStyle: FontStyle.italic),
          ),
          code: (content) => TextSpan(
            text: content,
            style: baseStyle.copyWith(
              fontFamily: 'monospace',
              backgroundColor:
                  Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
          ),
          link: (text, url) => TextSpan(
            text: text,
            style: baseStyle.copyWith(
              color: Theme.of(context).colorScheme.primary,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () => _handleLinkTap(context, url),
          ),
          strikethrough: (content) => TextSpan(
            text: content,
            style: baseStyle.copyWith(
              decoration: TextDecoration.lineThrough,
            ),
          ),
          highlight: (content) => TextSpan(
            text: content,
            style: baseStyle.copyWith(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            ),
          ),
          subscript: (content) => TextSpan(
            text: content,
            style: baseStyle.copyWith(
              fontSize: baseStyle.fontSize! * 0.8,
              textBaseline: TextBaseline.alphabetic,
            ),
          ),
          superscript: (content) => TextSpan(
            text: content,
            style: baseStyle.copyWith(
              fontSize: baseStyle.fontSize! * 0.8,
              textBaseline: TextBaseline.alphabetic,
            ),
          ),
          math: (content) => TextSpan(
            text: content,
            style: baseStyle.copyWith(
              fontFamily: 'monospace',
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          reference: (content) => TextSpan(
            text: content,
            style: baseStyle.copyWith(
              color: Theme.of(context).colorScheme.secondary,
              fontStyle: FontStyle.italic,
            ),
          ),
          footnote: (id, text) => TextSpan(
            text: '[$id]',
            style: baseStyle.copyWith(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: baseStyle.fontSize! * 0.8,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () => _handleFootnoteTap(context, id, text),
          ),
          custom: (elementType, attributes, content) => TextSpan(
            text: content,
            style: baseStyle.copyWith(
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
        ),
      );
    }

    return TextSpan(children: spans, style: baseStyle);
  }

  static TextStyle _getHeadingStyle(TextStyle baseStyle, int level) {
    final fontSize = switch (level) {
      1 => 28.0,
      2 => 24.0,
      3 => 20.0,
      4 => 18.0,
      5 => 16.0,
      6 => 14.0,
      _ => 16.0,
    };

    return baseStyle.copyWith(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
    );
  }

  static void _handleLinkTap(BuildContext context, String url) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Open Link'),
        content: Text('Open this link in your browser?\n\n$url'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Copy URL to clipboard as fallback
              Clipboard.setData(ClipboardData(text: url));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('URL copied to clipboard: $url'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Copy URL'),
          ),
        ],
      ),
    );
  }

  static void _handleFootnoteTap(BuildContext context, String id, String text) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Footnote $id'),
        content: Text(text),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

extension BloxBlockExtensions on BloxBlock {
  String? getAttribute(String key) {
    return attributes[key];
  }
}
