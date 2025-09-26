import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/common/index.dart';
import 'package:loom/common/presentation/widgets/editor/blox_syntax_highlighter.dart';
import 'package:loom/common/presentation/widgets/editor/live_preview_mode_line_numbers_widget.dart';
import 'package:loom/src/rust/api/blox_api.dart';

/// Unified Blox editor widget that supports multiple viewing modes
class BloxEditor extends ConsumerStatefulWidget {
  const BloxEditor({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.filePath,
    super.key,
    this.initialMode = BloxEditorMode.editing,
    this.showLineNumbers = true,
    this.showMinimap = false,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onChanged;
  final String? filePath;
  final BloxEditorMode initialMode;
  final bool showLineNumbers;
  final bool showMinimap;

  @override
  ConsumerState<BloxEditor> createState() => _BloxEditorState();
}

class _BloxEditorState extends ConsumerState<BloxEditor> {
  late BloxEditorMode _currentMode;
  final ScrollController _scrollController = ScrollController();
  final ScrollController _lineNumbersScrollController = ScrollController();
  final ScrollController _syntaxScrollController = ScrollController();
  final ScrollController _previewScrollController = ScrollController();
  final FocusNode _keyboardFocusNode = FocusNode();

  // Services
  late final CodeFoldingManager _foldingManager;
  BloxSyntaxHighlighter? _bloxHighlighter;

  // Parsed blocks for preview modes
  List<BloxBlock> _parsedBlocks = [];

  @override
  void initState() {
    super.initState();
    _currentMode = widget.initialMode;
    _foldingManager = CodeFoldingManager(widget.controller.text);
    _initializeSyntaxHighlighter();

    // Sync scroll controllers
    _scrollController.addListener(_syncScrollControllers);
    _previewScrollController.addListener(_syncPreviewScrollControllers);

    // Parse initial content if needed
    if (_requiresBlockParsing(_currentMode)) {
      _parseContent();
    }

    widget.controller.addListener(_onTextChanged);
  }

  @override
  void didUpdateWidget(BloxEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller.text != widget.controller.text) {
      _foldingManager = CodeFoldingManager(widget.controller.text);
      if (_requiresBlockParsing(_currentMode)) {
        _parseContent();
      }
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_syncScrollControllers)
      ..dispose();
    _lineNumbersScrollController.dispose();
    _syntaxScrollController.dispose();
    _previewScrollController
      ..removeListener(_syncPreviewScrollControllers)
      ..dispose();
    _keyboardFocusNode.dispose();
    _bloxHighlighter?.dispose();
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _initializeSyntaxHighlighter() {
    _bloxHighlighter = BloxSyntaxHighlighter();
  }

  void _syncScrollControllers() {
    if (_scrollController.hasClients) {
      final offset = _scrollController.offset;

      if (_lineNumbersScrollController.hasClients &&
          (_lineNumbersScrollController.offset - offset).abs() > 0.1) {
        _lineNumbersScrollController.jumpTo(offset);
      }

      if (_syntaxScrollController.hasClients &&
          (_syntaxScrollController.offset - offset).abs() > 0.1) {
        _syntaxScrollController.jumpTo(offset);
      }

      if (_previewScrollController.hasClients &&
          (_previewScrollController.offset - offset).abs() > 0.1) {
        _previewScrollController.jumpTo(offset);
      }
    }
  }

  void _syncPreviewScrollControllers() {
    if (_previewScrollController.hasClients) {
      final offset = _previewScrollController.offset;

      if (_lineNumbersScrollController.hasClients &&
          (_lineNumbersScrollController.offset - offset).abs() > 0.1) {
        _lineNumbersScrollController.jumpTo(offset);
      }
    }
  }

  void _onTextChanged() {
    // Update folding manager
    final oldFoldStates =
        _foldingManager.regions.map((r) => r.isFolded).toList();
    _foldingManager = CodeFoldingManager(widget.controller.text, oldFoldStates);

    // Re-parse content for preview modes
    if (_requiresBlockParsing(_currentMode)) {
      _parseContent();
    }

    widget.onChanged();
  }

  bool _requiresBlockParsing(BloxEditorMode mode) {
    return mode == BloxEditorMode.preview ||
        mode == BloxEditorMode.sideBySide ||
        mode == BloxEditorMode.livePreview;
  }

  Future<void> _parseContent() async {
    try {
      // Parse Blox content properly
      _parsedBlocks = _parseBloxContent(widget.controller.text);
    } catch (e) {
      // Fallback to simple paragraph parsing if proper parsing fails
      _parsedBlocks = _createFallbackBlocks(widget.controller.text);
    }
  }

  List<BloxBlock> _createFallbackBlocks(String text) {
    // Simple fallback implementation - split by double newlines for paragraphs
    final paragraphs = text.split('\n\n');
    return paragraphs.map((paragraph) {
      return BloxBlock(
        blockType: 'paragraph',
        content: paragraph,
        attributes: const {},
        children: const [],
        lineNumber: BigInt.zero,
        inlineElements: [BloxInlineElement.text(paragraph)],
        listItems: const [],
        level: BigInt.zero,
      );
    }).toList();
  }

  List<BloxBlock> _parseBloxContent(String text) {
    final lines = text.split('\n');
    final blocks = <BloxBlock>[];
    var currentLineNumber = 1;

    for (var i = 0; i < lines.length; i++) {
      final line = lines[i].trim();
      final originalLineNumber = currentLineNumber;

      if (line.isEmpty) {
        // Create an empty paragraph block for empty lines to preserve spacing in preview mode
        final block = BloxBlock(
          blockType: 'paragraph',
          content: '',
          attributes: const {},
          children: const [],
          lineNumber: BigInt.from(originalLineNumber),
          inlineElements: const [], // Empty inline elements for empty line
          listItems: const [],
          level: BigInt.zero,
        );
        blocks.add(block);
        currentLineNumber++;
        continue;
      }

      // Parse document block
      if (line.startsWith('#document')) {
        final block = _parseDocumentBlock(line, originalLineNumber);
        if (block != null) {
          blocks.add(block);
        }
        currentLineNumber++;
        continue;
      }

      // Parse section blocks
      if (line.startsWith('#section')) {
        final block = _parseSectionBlock(line, originalLineNumber);
        if (block != null) {
          blocks.add(block);
        }
        currentLineNumber++;
        continue;
      }

      // Parse heading blocks (# ## ###) - but not #document or #section
      if (line.startsWith('#') &&
          !line.startsWith('#document') &&
          !line.startsWith('#section')) {
        final block = _parseHeadingBlock(line, originalLineNumber);
        if (block != null) {
          blocks.add(block);
        }
        currentLineNumber++;
        continue;
      }

      // Parse list items
      if (line.startsWith('- ') ||
          line.startsWith('* ') ||
          RegExp(r'^\d+\.\s').hasMatch(line)) {
        final block = _parseListBlock(lines, i, originalLineNumber);
        if (block != null) {
          blocks.add(block);
          // Skip the lines consumed by the list
          i += _getListBlockLength(lines, i) - 1;
          currentLineNumber += _getListBlockLength(lines, i);
        } else {
          currentLineNumber++;
        }
        continue;
      }

      // Parse code blocks
      if (line.startsWith('```')) {
        final block = _parseCodeBlock(lines, i, originalLineNumber);
        if (block != null) {
          blocks.add(block);
          // Skip the lines consumed by the code block
          final codeLength = _getCodeBlockLength(lines, i);
          i += codeLength - 1;
          currentLineNumber += codeLength;
        } else {
          currentLineNumber++;
        }
        continue;
      }

      // Parse quote blocks
      if (line.startsWith('> ')) {
        final block = _parseQuoteBlock(lines, i, originalLineNumber);
        if (block != null) {
          blocks.add(block);
          // Skip the lines consumed by the quote
          final quoteLength = _getQuoteBlockLength(lines, i);
          i += quoteLength - 1;
          currentLineNumber += quoteLength;
        } else {
          currentLineNumber++;
        }
        continue;
      }

      // Default to paragraph
      final block = _parseParagraphBlock(lines, i, originalLineNumber);
      if (block != null) {
        blocks.add(block);
        // Skip lines consumed by paragraph (usually just one)
        final paraLength = _getParagraphBlockLength(lines, i);
        i += paraLength - 1;
        currentLineNumber += paraLength;
      } else {
        currentLineNumber++;
      }
    }

    return blocks;
  }

  BloxBlock? _parseDocumentBlock(String line, int lineNumber) {
    final match = RegExp(r'#document\s+(.+)').firstMatch(line);
    if (match != null) {
      final attributes = _parseAttributes(match.group(1)!);
      final title = attributes['title'] ?? '';
      return BloxBlock(
        blockType: 'document',
        content: title,
        attributes: attributes,
        children: const [],
        lineNumber: BigInt.from(lineNumber),
        inlineElements: [BloxInlineElement.text(title)],
        listItems: const [],
        level: BigInt.from(-1), // Document title is larger than h1
      );
    }
    return null;
  }

  BloxBlock? _parseSectionBlock(String line, int lineNumber) {
    final match = RegExp(r'#section\s+(.+)').firstMatch(line);
    if (match != null) {
      final attributes = _parseAttributes(match.group(1)!);
      final title = attributes['title'] ?? '';
      return BloxBlock(
        blockType: 'section',
        content: title,
        attributes: attributes,
        children: const [],
        lineNumber: BigInt.from(lineNumber),
        inlineElements: [BloxInlineElement.text(title)],
        listItems: const [],
        level: BigInt.one,
      );
    }
    return null;
  }

  BloxBlock? _parseHeadingBlock(String line, int lineNumber) {
    final match = RegExp(r'^(#{1,6})\s*(.*)$').firstMatch(line);
    if (match != null) {
      final level = match.group(1)!.length;
      final title = match.group(2)!;
      return BloxBlock(
        blockType: 'h$level',
        content: title,
        attributes: {'title': title},
        children: const [],
        lineNumber: BigInt.from(lineNumber),
        inlineElements: [BloxInlineElement.text(title)],
        listItems: const [],
        level: BigInt.from(level),
      );
    }
    return null;
  }

  BloxBlock? _parseListBlock(
    List<String> lines,
    int startIndex,
    int lineNumber,
  ) {
    final items = <BloxListItem>[];
    var i = startIndex;

    while (i < lines.length) {
      final line = lines[i].trim();
      if (line.isEmpty) {
        i++;
        continue;
      }

      if (line.startsWith('- ') || line.startsWith('* ')) {
        final content = line.substring(2);
        items.add(
          BloxListItem(
            itemType: const BloxListItemType.unchecked(),
            content: content,
            children: const [],
            level: BigInt.zero,
          ),
        );
        i++;
      } else if (RegExp(r'^\d+\.\s').hasMatch(line)) {
        final match = RegExp(r'^\d+\.\s(.*)$').firstMatch(line);
        if (match != null) {
          final content = match.group(1)!;
          items.add(
            BloxListItem(
              itemType: const BloxListItemType.unchecked(),
              content: content,
              children: const [],
              level: BigInt.zero,
            ),
          );
          i++;
        } else {
          break;
        }
      } else {
        break;
      }
    }

    if (items.isNotEmpty) {
      return BloxBlock(
        blockType: 'list',
        content: '',
        attributes: const {},
        children: const [],
        lineNumber: BigInt.from(lineNumber),
        inlineElements: const [],
        listItems: items,
        level: BigInt.zero,
      );
    }
    return null;
  }

  BloxBlock? _parseCodeBlock(
    List<String> lines,
    int startIndex,
    int lineNumber,
  ) {
    if (!lines[startIndex].trim().startsWith('```')) return null;

    final langLine = lines[startIndex].trim();
    final lang = langLine.length > 3 ? langLine.substring(3) : '';

    var i = startIndex + 1;
    final codeLines = <String>[];

    while (i < lines.length && !lines[i].trim().startsWith('```')) {
      codeLines.add(lines[i]);
      i++;
    }

    final content = codeLines.join('\n');
    return BloxBlock(
      blockType: 'code',
      content: content,
      attributes: {'lang': lang},
      children: const [],
      lineNumber: BigInt.from(lineNumber),
      inlineElements: [BloxInlineElement.text(content)],
      listItems: const [],
      level: BigInt.zero,
    );
  }

  BloxBlock? _parseQuoteBlock(
    List<String> lines,
    int startIndex,
    int lineNumber,
  ) {
    final quoteLines = <String>[];
    var i = startIndex;

    while (i < lines.length) {
      final line = lines[i];
      if (line.trim().startsWith('> ')) {
        quoteLines.add(line.trim().substring(2));
        i++;
      } else if (line.trim().isEmpty) {
        i++;
      } else {
        break;
      }
    }

    if (quoteLines.isNotEmpty) {
      final content = quoteLines.join('\n');
      return BloxBlock(
        blockType: 'quote',
        content: content,
        attributes: const {},
        children: const [],
        lineNumber: BigInt.from(lineNumber),
        inlineElements: [BloxInlineElement.text(content)],
        listItems: const [],
        level: BigInt.zero,
      );
    }
    return null;
  }

  BloxBlock? _parseParagraphBlock(
    List<String> lines,
    int startIndex,
    int lineNumber,
  ) {
    final line = lines[startIndex];
    if (line.trim().isEmpty) return null;

    return BloxBlock(
      blockType: 'paragraph',
      content: line,
      attributes: const {},
      children: const [],
      lineNumber: BigInt.from(lineNumber),
      inlineElements: [BloxInlineElement.text(line)],
      listItems: const [],
      level: BigInt.zero,
    );
  }

  Map<String, String> _parseAttributes(String attributeString) {
    final attributes = <String, String>{};
    final attrPattern = RegExp(r'(\w+)="([^"]*)"');
    final matches = attrPattern.allMatches(attributeString);

    for (final match in matches) {
      attributes[match.group(1)!] = match.group(2)!;
    }

    return attributes;
  }

  int _getListBlockLength(List<String> lines, int startIndex) {
    var length = 0;
    var i = startIndex;

    while (i < lines.length) {
      final line = lines[i].trim();
      if (line.startsWith('- ') ||
          line.startsWith('* ') ||
          RegExp(r'^\d+\.\s').hasMatch(line)) {
        length++;
        i++;
      } else if (line.isEmpty) {
        // Skip empty lines, just like _parseListBlock does
        i++;
      } else {
        break;
      }
    }

    return length;
  }

  int _getCodeBlockLength(List<String> lines, int startIndex) {
    var length = 1; // Start with the opening ```
    var i = startIndex + 1;

    while (i < lines.length) {
      if (lines[i].trim().startsWith('```')) {
        length++;
        break;
      }
      length++;
      i++;
    }

    return length;
  }

  int _getQuoteBlockLength(List<String> lines, int startIndex) {
    var length = 0;
    var i = startIndex;

    while (i < lines.length) {
      final line = lines[i];
      if (line.trim().startsWith('> ') || line.trim().isEmpty) {
        length++;
        i++;
      } else {
        break;
      }
    }

    return length;
  }

  int _getParagraphBlockLength(List<String> lines, int startIndex) {
    return 1; // Paragraphs are single lines
  }

  void _switchMode(BloxEditorMode newMode) {
    setState(() {
      _currentMode = newMode;
    });

    if (_requiresBlockParsing(newMode)) {
      _parseContent();
    }
  }

  void _foldAll() {
    for (var i = 0; i < _foldingManager.regions.length; i++) {
      _foldingManager.toggleFold(i);
      if (!_foldingManager.isRegionFolded(i)) {
        _foldingManager.toggleFold(i); // Ensure it's folded
      }
    }
    setState(() {});
  }

  void _unfoldAll() {
    for (var i = 0; i < _foldingManager.regions.length; i++) {
      _foldingManager.toggleFold(i);
      if (_foldingManager.isRegionFolded(i)) {
        _foldingManager.toggleFold(i); // Ensure it's unfolded
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Request focus for keyboard handling
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_keyboardFocusNode.hasFocus) {
        _keyboardFocusNode.requestFocus();
      }
    });

    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            // Mode selector toolbar
            _buildModeSelector(theme),

            // Editor content
            Expanded(
              child: _buildEditorContent(theme, constraints.maxWidth),
            ),
          ],
        );
      },
    );
  }

  Widget _buildModeSelector(ThemeData theme) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
        border: Border(
          bottom: BorderSide(color: theme.dividerColor),
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Text(
            'Mode:',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 8),
          ...BloxEditorMode.values.map((mode) {
            final isSelected = mode == _currentMode;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: FilterChip(
                label: Row(
                  children: [
                    Icon(mode.icon, size: AppDimensions.iconLarge),
                    const SizedBox(width: 4),
                    Text(mode.displayName),
                  ],
                ),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    _switchMode(mode);
                  }
                },
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                selectedColor: theme.colorScheme.primaryContainer,
                checkmarkColor: theme.colorScheme.primary,
              ),
            );
          }),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildEditorContent(ThemeData theme, double maxWidth) {
    final content = switch (_currentMode) {
      BloxEditorMode.editing => _buildEditingMode(theme, maxWidth),
      BloxEditorMode.preview => _buildPreviewMode(theme, maxWidth),
      BloxEditorMode.sideBySide => _buildSideBySideMode(theme, maxWidth),
      BloxEditorMode.livePreview => _buildLivePreviewMode(theme, maxWidth),
    };

    return KeyboardListener(
      focusNode: _keyboardFocusNode,
      onKeyEvent: (event) {
        if (HardwareKeyboard.instance.isControlPressed) {
          if (HardwareKeyboard.instance.isShiftPressed) {
            if (event.logicalKey == LogicalKeyboardKey.bracketLeft) {
              _foldAll();
            } else if (event.logicalKey == LogicalKeyboardKey.bracketRight) {
              _unfoldAll();
            }
          }
        }
      },
      child: content,
    );
  }

  Widget _buildEditingMode(ThemeData theme, double maxWidth) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Line numbers
        if (widget.showLineNumbers)
          EditingModeLineNumbersWidget(
            scrollController: _lineNumbersScrollController,
            theme: theme,
            text: widget.controller.text,
            foldingManager: _foldingManager,
            maxWidth: maxWidth,
            showMinimap: widget.showMinimap,
            onFoldChanged: () => setState(() {}),
          ),

        // Editor
        Expanded(
          child: _buildBloxTextEditor(theme),
        ),

        // Minimap
        if (widget.showMinimap)
          SizedBox(
            width: 200,
            child: MinimapWidget(
              text: widget.controller.text,
              scrollPosition: _scrollController.hasClients
                  ? _scrollController.position.pixels
                  : 0,
              maxScrollExtent: _scrollController.hasClients
                  ? _scrollController.position.maxScrollExtent
                  : 0,
              viewportHeight: _scrollController.hasClients
                  ? _scrollController.position.viewportDimension
                  : 0,
              onScrollToPosition: (position) {
                if (_scrollController.hasClients) {
                  _scrollController.animateTo(
                    position,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                  );
                }
              },
              isBloxFile: true,
              showLineNumbers: widget.showLineNumbers,
            ),
          ),
      ],
    );
  }

  Widget _buildPreviewMode(ThemeData theme, double maxWidth) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Line numbers for preview
        if (widget.showLineNumbers)
          PreviewModeLineNumbersWidget(
            scrollController: _lineNumbersScrollController,
            theme: theme,
            blocks: _parsedBlocks,
            foldingManager: _foldingManager,
            maxWidth: maxWidth,
            showMinimap: widget.showMinimap,
            onFoldChanged: () => setState(() {}),
          ),

        // Preview content
        Expanded(
          child: BloxViewer(
            blocks: _parsedBlocks,
            scrollController: _previewScrollController,
            isDark: theme.brightness == Brightness.dark,
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: 8,
            ), // Match editing mode padding
          ),
        ),

        // Minimap
        if (widget.showMinimap)
          SizedBox(
            width: 200,
            child: MinimapWidget(
              text: widget.controller.text,
              scrollPosition: _previewScrollController.hasClients
                  ? _previewScrollController.position.pixels
                  : 0,
              maxScrollExtent: _previewScrollController.hasClients
                  ? _previewScrollController.position.maxScrollExtent
                  : 0,
              viewportHeight: _previewScrollController.hasClients
                  ? _previewScrollController.position.viewportDimension
                  : 0,
              onScrollToPosition: (position) {
                if (_previewScrollController.hasClients) {
                  _previewScrollController.animateTo(
                    position,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                  );
                }
              },
              isBloxFile: true,
              showLineNumbers: widget.showLineNumbers,
            ),
          ),
      ],
    );
  }

  Widget _buildSideBySideMode(ThemeData theme, double maxWidth) {
    final halfWidth = maxWidth / 2;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Left side: Editing
        SizedBox(
          width: halfWidth,
          child: Row(
            children: [
              if (widget.showLineNumbers)
                EditingModeLineNumbersWidget(
                  scrollController: _lineNumbersScrollController,
                  theme: theme,
                  text: widget.controller.text,
                  foldingManager: _foldingManager,
                  maxWidth: halfWidth,
                  showMinimap: false,
                  width: 60, // Smaller width for side-by-side
                  onFoldChanged: () => setState(() {}),
                ),
              Expanded(
                child: _buildBloxTextEditor(theme),
              ),
            ],
          ),
        ),

        // Right side: Preview
        SizedBox(
          width: halfWidth,
          child: Row(
            children: [
              if (widget.showLineNumbers)
                PreviewModeLineNumbersWidget(
                  scrollController: _lineNumbersScrollController,
                  theme: theme,
                  blocks: _parsedBlocks,
                  foldingManager: _foldingManager,
                  maxWidth: maxWidth,
                  showMinimap: widget.showMinimap,
                  onFoldChanged: () => setState(() {}),
                ),
              Expanded(
                child: BloxViewer(
                  blocks: _parsedBlocks,
                  scrollController: _previewScrollController,
                  isDark: theme.brightness == Brightness.dark,
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 16,
                    bottom: 8,
                  ), // Match editing mode padding
                ),
              ),
              // Minimap
              if (widget.showMinimap)
                SizedBox(
                  width: 100, // Smaller width for side-by-side
                  child: MinimapWidget(
                    text: widget.controller.text,
                    scrollPosition: _previewScrollController.hasClients
                        ? _previewScrollController.position.pixels
                        : 0,
                    maxScrollExtent: _previewScrollController.hasClients
                        ? _previewScrollController.position.maxScrollExtent
                        : 0,
                    viewportHeight: _previewScrollController.hasClients
                        ? _previewScrollController.position.viewportDimension
                        : 0,
                    onScrollToPosition: (position) {
                      if (_previewScrollController.hasClients) {
                        _previewScrollController.animateTo(
                          position,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    isBloxFile: true,
                    showLineNumbers: widget.showLineNumbers,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLivePreviewMode(ThemeData theme, double maxWidth) {
    // Live preview mode: single view with styled editing
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Line numbers for live preview (using dynamic height calculation)
        if (widget.showLineNumbers)
          LivePreviewModeLineNumbersWidget(
            scrollController: _lineNumbersScrollController,
            theme: theme,
            blocks: _parsedBlocks,
            foldingManager: _foldingManager,
            maxWidth: maxWidth,
            showMinimap: widget.showMinimap,
            onFoldChanged: () => setState(() {}),
          ),

        // Live preview editor with styled content
        Expanded(
          child: _buildLivePreviewEditor(theme),
        ),

        // Minimap
        if (widget.showMinimap)
          SizedBox(
            width: 200,
            child: MinimapWidget(
              text: widget.controller.text,
              scrollPosition: _scrollController.hasClients
                  ? _scrollController.position.pixels
                  : 0,
              maxScrollExtent: _scrollController.hasClients
                  ? _scrollController.position.maxScrollExtent
                  : 0,
              viewportHeight: _scrollController.hasClients
                  ? _scrollController.position.viewportDimension
                  : 0,
              onScrollToPosition: (position) {
                if (_scrollController.hasClients) {
                  _scrollController.animateTo(
                    position,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                  );
                }
              },
              isBloxFile: true,
              showLineNumbers: widget.showLineNumbers,
            ),
          ),
      ],
    );
  }

  Widget _buildBloxTextEditor(ThemeData theme) {
    // Update highlighter
    _bloxHighlighter!.text = widget.controller.text;
    _bloxHighlighter!.updateTheme(theme);

    // Get the display text (folded or full)
    final displayText = _foldingManager.regions.isNotEmpty &&
            _foldingManager.regions.any((r) => r.isFolded)
        ? _foldingManager.getFoldedText()
        : widget.controller.text;

    // Update highlighter with display text for proper highlighting
    _bloxHighlighter!.text = displayText;

    // Get folding state for key
    final foldingKey = _foldingManager.regions
        .map((r) => '${r.startLine}-${r.endLine}-${r.isFolded}')
        .join('|');

    return Stack(
      children: [
        // Syntax highlighted display
        SingleChildScrollView(
          controller: _syntaxScrollController,
          physics: const NeverScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.md,
              right: AppSpacing.md,
              top: AppSpacing.md,
              bottom: AppSpacing.sm,
            ),
            child: Container(
              constraints: const BoxConstraints(minWidth: double.infinity),
              child: SelectableText.rich(
                _bloxHighlighter!.getHighlightedText(),
                key: ValueKey('syntax-$foldingKey'),
                style: AppTypography.editorTextStyle,
              ),
            ),
          ),
        ),

        // Editable TextField
        Positioned.fill(
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: const NeverScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(
                left: AppSpacing.md,
                right: AppSpacing.md,
                top: AppSpacing.md,
                bottom: AppSpacing.sm,
              ),
              child: Container(
                constraints: const BoxConstraints(minWidth: double.infinity),
                child: TextField(
                  controller: widget.controller,
                  focusNode: widget.focusNode,
                  maxLines: null,
                  style: AppTypography.editorTextStyle.copyWith(
                    color: Colors.transparent,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                  ),
                  onChanged: (_) => _onTextChanged(),
                  cursorColor: theme.colorScheme.primary,
                  showCursor: true,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLivePreviewEditor(ThemeData theme) {
    // In live preview mode, we show styled content as you type
    // This is a more advanced implementation that would render styled blocks inline
    // For now, we'll use a hybrid approach with syntax highlighting and basic styling

    return Stack(
      children: [
        // Live preview display with styled content
        SingleChildScrollView(
          controller: _syntaxScrollController,
          physics: const NeverScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.md,
              right: AppSpacing.md,
              top: AppSpacing.md,
              bottom: AppSpacing.sm,
            ),
            child: Container(
              constraints: const BoxConstraints(minWidth: double.infinity),
              child: _buildLivePreviewContent(theme),
            ),
          ),
        ),

        // Editable TextField overlay
        Positioned.fill(
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: const NeverScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(
                left: AppSpacing.md,
                right: AppSpacing.md,
                top: AppSpacing.md,
                bottom: AppSpacing.sm,
              ),
              child: Container(
                constraints: const BoxConstraints(minWidth: double.infinity),
                child: TextField(
                  controller: widget.controller,
                  focusNode: widget.focusNode,
                  maxLines: null,
                  style: AppTypography.editorTextStyle.copyWith(
                    color: Colors
                        .transparent, // Make text invisible so styled content shows through
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                  ),
                  onChanged: (_) => _onTextChanged(),
                  cursorColor: theme.colorScheme.primary,
                  showCursor: true,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLivePreviewContent(ThemeData theme) {
    // Use the already parsed blocks that are updated in real-time
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _parsedBlocks.map((block) {
        return BloxRenderer.renderBlock(
          context,
          block,
          baseStyle: theme.textTheme.bodyMedium,
          isDark: theme.brightness == Brightness.dark,
        );
      }).toList(),
    );
  }
}
