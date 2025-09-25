import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loom/common/index.dart';
import 'package:loom/flutter_gen/gen_l10n/app_localizations.dart';
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

      case 'document':
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
    final inlineText =
        _buildInlineTextSpan(context, block.inlineElements, baseStyle);

    // For empty paragraphs (empty lines), ensure minimum height to match text line height
    if (block.inlineElements.isEmpty) {
      return Padding(
        padding: AppSpacing.paddingVerticalXs,
        child: SizedBox(
          height: baseStyle.fontSize! *
              (baseStyle.height ?? 1.2), // Match text line height
          child: RichText(text: inlineText),
        ),
      );
    }

    return Padding(
      padding: AppSpacing.paddingVerticalXs,
      child: RichText(
        text: inlineText,
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

    // Document titles get more padding, sections get medium padding, regular headings get minimal padding
    final padding = switch (block.blockType.toLowerCase()) {
      'document' => AppSpacing.paddingVerticalMd, // 16px for document titles
      'section' => AppSpacing.paddingVerticalSm, // 8px for sections
      _ => AppSpacing.paddingVerticalXs, // 4px for regular headings
    };

    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: headingStyle,
          ),
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
      margin: AppSpacing.marginVerticalXs, // Reduced from marginVerticalSm
      padding: AppSpacing.paddingSm, // Reduced from paddingMd
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: AppRadius.radiusLg,
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
            const SizedBox(height: 4), // Reduced from 8
          ],
          Text(
            block.content,
            style: AppTypography.codeTextStyle,
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
      margin: AppSpacing.marginVerticalXs, // Reduced from marginVerticalSm
      padding: AppSpacing.paddingSm, // Reduced from paddingMd
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
            const SizedBox(height: 4), // Reduced from 8
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
      padding: AppSpacing.paddingVerticalXs,
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
    final indent = AppDimensions.getListItemIndent(indentLevel);

    return Padding(
      padding: EdgeInsets.only(left: indent, bottom: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // List marker
          SizedBox(
            width: AppDimensions.iconMedium,
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
      checked: () =>
          Text('✓', style: baseStyle.copyWith(color: AppColors.success)),
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
      padding: AppSpacing.paddingVerticalXs,
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
            const SizedBox(height: 4),
          ],
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: theme.dividerColor),
              borderRadius: AppRadius.radiusSm,
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
          padding: AppSpacing.paddingSm,
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
    final localizations = AppLocalizations.of(context);
    final src = block.getAttribute('src') ?? '';
    final alt = block.getAttribute('alt') ?? '';
    final width = block.getAttribute('width');
    final height = block.getAttribute('height');

    return Padding(
      padding: AppSpacing.paddingVerticalXs,
      child: Container(
        padding: AppSpacing.paddingMd,
        decoration: BoxDecoration(
          border: Border.all(color: theme.dividerColor),
          borderRadius: AppRadius.radiusLg,
        ),
        child: Column(
          children: [
            Icon(
              Icons.image,
              size: AppDimensions.iconMassive,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 4),
            Text(
              alt.isNotEmpty ? alt : localizations.imageAlt(src),
              style: baseStyle.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (width != null || height != null) ...[
              const SizedBox(height: 4),
              Text(
                '${width ?? 'auto'} × ${height ?? 'auto'}',
                style: AppTypography.smallTextStyle.copyWith(
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
      margin: AppSpacing.marginVerticalXs, // Reduced from marginVerticalSm
      padding: AppSpacing.paddingSm, // Reduced from paddingMd
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: AppRadius.radiusLg,
        border: Border.all(
          color: theme.dividerColor,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.functions,
            color: theme.colorScheme.primary,
            size: AppDimensions.iconXXXLarge,
          ),
          const SizedBox(height: 4), // Reduced from 8
          Text(
            block.content,
            style: AppTypography.mathTextStyle,
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
            style: AppTypography.getSubscriptStyle(baseStyle).copyWith(
              textBaseline: TextBaseline.alphabetic,
            ),
          ),
          superscript: (content) => TextSpan(
            text: content,
            style: AppTypography.getSuperscriptStyle(baseStyle).copyWith(
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
            style: AppTypography.getFootnoteStyle(baseStyle).copyWith(
              color: Theme.of(context).colorScheme.secondary,
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
    return AppTypography.getHeadingStyle(level).copyWith(
      color: baseStyle.color,
      fontFamily: baseStyle.fontFamily,
      height: baseStyle.height,
    );
  }

  static void _handleLinkTap(BuildContext context, String url) {
    final localizations = AppLocalizations.of(context);
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.openLink),
        content: Text(localizations.openLinkConfirmation(url)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(localizations.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Copy URL to clipboard as fallback
              Clipboard.setData(ClipboardData(text: url));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(localizations.urlCopiedToClipboard(url)),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: Text(localizations.copyUrl),
          ),
        ],
      ),
    );
  }

  static void _handleFootnoteTap(BuildContext context, String id, String text) {
    final localizations = AppLocalizations.of(context);
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.footnote(id)),
        content: Text(text),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(localizations.close),
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
