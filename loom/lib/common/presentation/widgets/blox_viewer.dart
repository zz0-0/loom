import 'package:flutter/material.dart';
import 'package:loom/common/index.dart';
import 'package:loom/src/rust/api/blox_api.dart';

/// A widget that displays Blox content using the enhanced BloxRenderer
class BloxViewer extends StatelessWidget {
  const BloxViewer({
    required this.blocks,
    super.key,
    this.baseStyle,
    this.isDark = false,
    this.scrollController,
    this.padding = const EdgeInsets.all(16),
  });
  final List<BloxBlock> blocks;
  final TextStyle? baseStyle;
  final bool isDark;
  final ScrollController? scrollController;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultStyle = baseStyle ?? theme.textTheme.bodyMedium!;

    return Container(
      padding: padding,
      child: ListView.builder(
        controller: scrollController,
        itemCount: blocks.length,
        itemBuilder: (context, index) {
          final block = blocks[index];
          return BloxRenderer.renderBlock(
            context,
            block,
            baseStyle: defaultStyle,
            isDark: isDark,
          );
        },
      ),
    );
  }
}

/// A widget that displays a single Blox block
class BloxBlockWidget extends StatelessWidget {
  const BloxBlockWidget({
    required this.block,
    super.key,
    this.baseStyle,
    this.isDark = false,
  });
  final BloxBlock block;
  final TextStyle? baseStyle;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultStyle = baseStyle ?? theme.textTheme.bodyMedium!;

    return BloxRenderer.renderBlock(
      context,
      block,
      baseStyle: defaultStyle,
      isDark: isDark,
    );
  }
}

/// A widget that displays Blox content in a scrollable container with syntax highlighting
class BloxDocumentViewer extends StatefulWidget {
  const BloxDocumentViewer({
    required this.blocks,
    super.key,
    this.title,
    this.showLineNumbers = false,
    this.isDark = false,
  });
  final List<BloxBlock> blocks;
  final String? title;
  final bool showLineNumbers;
  final bool isDark;

  @override
  State<BloxDocumentViewer> createState() => _BloxDocumentViewerState();
}

class _BloxDocumentViewerState extends State<BloxDocumentViewer> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: widget.title != null
          ? AppBar(
              title: Text(widget.title!),
              backgroundColor: theme.colorScheme.surface,
              foregroundColor: theme.colorScheme.onSurface,
            )
          : null,
      body: ColoredBox(
        color: theme.colorScheme.surface,
        child: BloxViewer(
          blocks: widget.blocks,
          scrollController: _scrollController,
          isDark: widget.isDark,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
    );
  }
}

/// A preview widget for Blox content that shows a condensed view
class BloxPreview extends StatelessWidget {
  const BloxPreview({
    required this.blocks,
    super.key,
    this.maxBlocks = 3,
    this.isDark = false,
  });
  final List<BloxBlock> blocks;
  final int maxBlocks;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayBlocks = blocks.take(maxBlocks).toList();
    final hasMore = blocks.length > maxBlocks;

    return ColoredBox(
      color: theme.colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...displayBlocks.map(
              (block) => BloxBlockWidget(
                block: block,
                isDark: isDark,
              ),
            ),
            if (hasMore)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  '... and ${blocks.length - maxBlocks} more blocks',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
