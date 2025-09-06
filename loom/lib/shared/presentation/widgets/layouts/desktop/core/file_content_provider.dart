import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/features/export/presentation/widgets/export_dialog.dart';
import 'package:loom/shared/presentation/providers/tab_provider.dart';
import 'package:loom/shared/presentation/widgets/editor/blox_syntax_highlighter.dart';
import 'package:loom/shared/presentation/widgets/editor/find_replace_dialog.dart';
import 'package:loom/shared/presentation/widgets/layouts/desktop/core/ui_registry.dart';
import 'package:loom/src/rust/api/blox_api.dart';

/// Clipboard service for text operations
class ClipboardService {
  static Future<void> copyToClipboard(String text) async {
    if (text.isNotEmpty) {
      await Clipboard.setData(ClipboardData(text: text));
    }
  }

  static Future<String?> pasteFromClipboard() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    return data?.text;
  }
}

/// Undo/Redo manager for text editing
class TextEditHistory {
  final List<String> _history = [];
  int _currentIndex = -1;
  static const int maxHistorySize = 100;

  void addState(String text) {
    // Remove any redo states after current position
    if (_currentIndex < _history.length - 1) {
      _history.removeRange(_currentIndex + 1, _history.length);
    }

    // Add new state
    _history.add(text);
    _currentIndex = _history.length - 1;

    // Limit history size
    if (_history.length > maxHistorySize) {
      _history.removeAt(0);
      _currentIndex--;
    }
  }

  String? undo() {
    if (_currentIndex > 0) {
      _currentIndex--;
      return _history[_currentIndex];
    }
    return null;
  }

  String? redo() {
    if (_currentIndex < _history.length - 1) {
      _currentIndex++;
      return _history[_currentIndex];
    }
    return null;
  }

  bool get canUndo => _currentIndex > 0;
  bool get canRedo => _currentIndex < _history.length - 1;

  void clear() {
    _history.clear();
    _currentIndex = -1;
  }
}

/// Content provider for displaying and editing files
class FileContentProvider implements ContentProvider {
  @override
  String get id => 'file';

  @override
  bool canHandle(String? contentId) {
    // Handle file paths (any string that looks like a file path)
    if (contentId == null) return false;
    return contentId.contains('/') ||
        contentId.contains(r'\') ||
        contentId.contains('.');
  }

  @override
  Widget build(BuildContext context) {
    return const FileEditor();
  }
}

/// File editor widget that displays file content with Blox support
class FileEditor extends ConsumerStatefulWidget {
  const FileEditor({super.key});

  @override
  ConsumerState<FileEditor> createState() => _FileEditorState();
}

class _FileEditorState extends ConsumerState<FileEditor> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _keyboardFocusNode = FocusNode();
  final FocusNode _textFieldFocusNode = FocusNode();

  // Undo/Redo system
  final TextEditHistory _editHistory = TextEditHistory();

  // Syntax highlighting
  BloxSyntaxHighlighter? _bloxHighlighter;
  final bool _enableSyntaxHighlighting = true;

  String? _currentFilePath;
  bool _isLoading = false;
  String? _error;
  bool _showLineNumbers = true;
  bool _isBloxFile = false;
  bool _isLoadingFile = false; // Flag to track if we're loading a file

  // Code folding
  late CodeFoldingManager _foldingManager;

  // Blox-specific state
  BloxDocument? _parsedDocument;
  List<String> _syntaxWarnings = [];
  @override
  void initState() {
    super.initState();
    _loadCurrentFile();
    _controller.addListener(_onTextChanged);
    _initializeSyntaxHighlighter();
    _foldingManager = CodeFoldingManager('');
  }

  @override
  void didUpdateWidget(FileEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    _loadCurrentFile();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _keyboardFocusNode.dispose();
    _textFieldFocusNode.dispose();
    _bloxHighlighter?.dispose();
    super.dispose();
  }

  void _initializeSyntaxHighlighter() {
    _bloxHighlighter = BloxSyntaxHighlighter();
    // Theme will be updated in _buildBloxEditor when the widget is built
  }

  void _loadCurrentFile() {
    final tabState = ref.read(tabProvider);
    final activeTab = tabState.activeTab;

    if (activeTab != null && activeTab.contentType == 'file') {
      final filePath = activeTab.id;

      // Only reload if the file path has changed
      if (_currentFilePath != filePath) {
        _currentFilePath = filePath;
        _isBloxFile = filePath.toLowerCase().endsWith('.blox');
        _loadFileContent(filePath);
      }
    } else {
      // Clear current file if no valid tab is selected
      _currentFilePath = null;
      _controller.clear();
      setState(() {
        _isLoading = false;
        _error = null;
        _parsedDocument = null;
        _syntaxWarnings = [];
      });
    }
  }

  Future<void> _loadFileContent(String filePath) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final file = File(filePath);
      if (file.existsSync()) {
        final content = await file.readAsString();

        // Set flag to prevent marking as dirty during loading
        _isLoadingFile = true;
        _controller.text = content;
        _isLoadingFile = false;

        // Initialize undo/redo history with loaded content
        _editHistory
          ..clear()
          ..addState(content);

        // Parse Blox content if it's a .blox file
        if (_isBloxFile) {
          await _parseBloxContent(content);
        }

        // Mark tab as clean after successful load
        if (_currentFilePath != null) {
          ref
              .read(tabProvider.notifier)
              .updateTab(_currentFilePath!, isDirty: false);
        }
      } else {
        _error = 'File not found: $filePath';
      }
    } catch (e) {
      _error = 'Error loading file: $e';
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _parseBloxContent(String content) async {
    try {
      // Parse the document
      final document = parseBloxString(content: content);
      _parsedDocument = document;

      // Validate syntax
      final warnings = validateBloxSyntax(content: content);
      _syntaxWarnings = warnings;

      setState(() {});
    } catch (e) {
      _syntaxWarnings = ['Parse error: $e'];
      setState(() {});
    }
  }

  Future<void> _saveFile() async {
    if (_currentFilePath == null) return;

    try {
      final file = File(_currentFilePath!);
      await file.writeAsString(_controller.text);

      // Re-parse if it's a Blox file
      if (_isBloxFile) {
        await _parseBloxContent(_controller.text);
      }

      // Mark tab as not dirty
      ref
          .read(tabProvider.notifier)
          .updateTab(_currentFilePath!, isDirty: false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('File saved successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving file: $e')),
        );
      }
    }
  }

  void _onTextChanged() {
    // Don't mark as dirty if we're currently loading a file
    if (_currentFilePath != null && !_isLoadingFile) {
      // Mark tab as dirty when content changes
      ref
          .read(tabProvider.notifier)
          .updateTab(_currentFilePath!, isDirty: true);

      // Add current state to undo history
      _editHistory.addState(_controller.text);
    }

    // Update code folding regions
    _foldingManager = CodeFoldingManager(_controller.text);

    // Debounced parsing for Blox files
    if (_isBloxFile) {
      _debounceParse();
    }
  }

  void _undo() {
    final previousState = _editHistory.undo();
    if (previousState != null) {
      _controller.text = previousState;
      // Mark as dirty if the content changed
      if (_currentFilePath != null) {
        ref
            .read(tabProvider.notifier)
            .updateTab(_currentFilePath!, isDirty: true);
      }
    }
  }

  void _redo() {
    final nextState = _editHistory.redo();
    if (nextState != null) {
      _controller.text = nextState;
      // Mark as dirty if the content changed
      if (_currentFilePath != null) {
        ref
            .read(tabProvider.notifier)
            .updateTab(_currentFilePath!, isDirty: true);
      }
    }
  }

  void _copySelection() {
    final selection = _controller.selection;
    if (selection.isValid && !selection.isCollapsed) {
      final selectedText =
          _controller.text.substring(selection.start, selection.end);
      ClipboardService.copyToClipboard(selectedText);
    }
  }

  void _cutSelection() {
    final selection = _controller.selection;
    if (selection.isValid && !selection.isCollapsed) {
      final selectedText =
          _controller.text.substring(selection.start, selection.end);
      ClipboardService.copyToClipboard(selectedText);

      // Remove the selected text
      _controller
        ..text =
            _controller.text.replaceRange(selection.start, selection.end, '')
        ..selection = TextSelection.collapsed(offset: selection.start);

      // Mark as dirty
      if (_currentFilePath != null) {
        ref
            .read(tabProvider.notifier)
            .updateTab(_currentFilePath!, isDirty: true);
      }
    }
  }

  Future<void> _pasteFromClipboard() async {
    final clipboardText = await ClipboardService.pasteFromClipboard();
    if (clipboardText != null && clipboardText.isNotEmpty) {
      final selection = _controller.selection;

      if (selection.isValid && !selection.isCollapsed) {
        // Replace selected text
        _controller
          ..text = _controller.text.replaceRange(
            selection.start,
            selection.end,
            clipboardText,
          )
          ..selection = TextSelection.collapsed(
            offset: selection.start + clipboardText.length,
          );
      } else {
        // Insert at cursor position
        final cursorPosition = selection.baseOffset;
        _controller
          ..text = _controller.text.replaceRange(
            cursorPosition,
            cursorPosition,
            clipboardText,
          )
          ..selection = TextSelection.collapsed(
            offset: cursorPosition + clipboardText.length,
          );
      }

      // Mark as dirty
      if (_currentFilePath != null) {
        ref
            .read(tabProvider.notifier)
            .updateTab(_currentFilePath!, isDirty: true);
      }
    }
  }

  void _selectAll() {
    _controller.selection = TextSelection(
      baseOffset: 0,
      extentOffset: _controller.text.length,
    );
  }

  void _indentSelection() {
    final selection = _controller.selection;
    final text = _controller.text;

    if (selection.isCollapsed) {
      // No selection - just insert tab at cursor
      final cursorPosition = selection.baseOffset;
      _controller
        ..text = text.replaceRange(cursorPosition, cursorPosition, '\t')
        ..selection = TextSelection.collapsed(offset: cursorPosition + 1);
    } else {
      // Selection - indent all selected lines
      final start = selection.start;
      final end = selection.end;

      // Find the lines that are selected
      final beforeSelection = text.substring(0, start);
      final selectedText = text.substring(start, end);
      final afterSelection = text.substring(end);

      // Split selected text into lines
      final lines = selectedText.split('\n');

      // Indent each line
      final indentedLines = lines.map((line) => '\t$line').toList();

      // Reconstruct the text
      final newSelectedText = indentedLines.join('\n');
      _controller
        ..text = beforeSelection + newSelectedText + afterSelection

        // Update selection to cover the indented text
        ..selection = TextSelection(
          baseOffset: start,
          extentOffset: start + newSelectedText.length,
        );
    }

    // Mark as dirty
    if (_currentFilePath != null) {
      ref
          .read(tabProvider.notifier)
          .updateTab(_currentFilePath!, isDirty: true);
    }
  }

  void _dedentSelection() {
    final selection = _controller.selection;
    final text = _controller.text;

    if (selection.isCollapsed) {
      // No selection - remove tab/indentation from current line
      final lines = text.split('\n');
      final cursorPosition = selection.baseOffset;

      // Find which line the cursor is on
      var currentPos = 0;
      var lineIndex = 0;
      for (var i = 0; i < lines.length; i++) {
        final lineLength = lines[i].length + 1; // +1 for newline
        if (currentPos + lineLength > cursorPosition) {
          lineIndex = i;
          break;
        }
        currentPos += lineLength;
      }

      final line = lines[lineIndex];
      if (line.startsWith('\t')) {
        // Remove tab
        lines[lineIndex] = line.substring(1);
        _controller.text = lines.join('\n');

        // Adjust cursor position
        final newCursorPos = cursorPosition - 1;
        _controller.selection = TextSelection.collapsed(offset: newCursorPos);
      } else if (line.startsWith('    ')) {
        // Remove 4 spaces (common indent)
        lines[lineIndex] = line.substring(4);
        _controller.text = lines.join('\n');

        // Adjust cursor position
        final newCursorPos = cursorPosition - 4;
        _controller.selection = TextSelection.collapsed(offset: newCursorPos);
      }
    } else {
      // Selection - dedent all selected lines
      final start = selection.start;
      final end = selection.end;

      final beforeSelection = text.substring(0, start);
      final selectedText = text.substring(start, end);
      final afterSelection = text.substring(end);

      // Split selected text into lines
      final lines = selectedText.split('\n');

      // Dedent each line
      final dedentedLines = lines.map((line) {
        if (line.startsWith('\t')) {
          return line.substring(1);
        } else if (line.startsWith('    ')) {
          return line.substring(4);
        } else if (line.startsWith('  ')) {
          return line.substring(2);
        } else if (line.startsWith(' ')) {
          return line.substring(1);
        }
        return line;
      }).toList();

      // Reconstruct the text
      final newSelectedText = dedentedLines.join('\n');
      _controller
        ..text = beforeSelection + newSelectedText + afterSelection

        // Update selection to cover the dedented text
        ..selection = TextSelection(
          baseOffset: start,
          extentOffset: start + newSelectedText.length,
        );
    }

    // Mark as dirty
    if (_currentFilePath != null) {
      ref
          .read(tabProvider.notifier)
          .updateTab(_currentFilePath!, isDirty: true);
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

  void _debounceParse() {
    // Simple debounce - in a real app, you'd use a proper debouncer
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted && _isBloxFile) {
        _parseBloxContent(_controller.text);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              _error!,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Toolbar
        Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
            border: Border(
              bottom: BorderSide(
                color: theme.dividerColor,
              ),
            ),
          ),
          child: Row(
            children: [
              // File type indicator
              if (_isBloxFile)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Blox',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

              const Spacer(),

              // Line numbers toggle
              IconButton(
                icon: Icon(
                  _showLineNumbers
                      ? Icons.format_list_numbered
                      : Icons.format_list_numbered_outlined,
                ),
                onPressed: () =>
                    setState(() => _showLineNumbers = !_showLineNumbers),
                tooltip: 'Toggle line numbers',
              ),

              // Syntax validation for Blox files
              if (_isBloxFile && _syntaxWarnings.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.warning, color: Colors.orange),
                  onPressed: () => _showSyntaxWarnings(context),
                  tooltip: '${_syntaxWarnings.length} syntax warnings',
                ),

              IconButton(
                icon: const Icon(Icons.undo),
                onPressed: _editHistory.canUndo ? _undo : null,
                tooltip: 'Undo (Ctrl+Z)',
              ),

              IconButton(
                icon: const Icon(Icons.redo),
                onPressed: _editHistory.canRedo ? _redo : null,
                tooltip: 'Redo (Ctrl+Y)',
              ),

              const SizedBox(width: 8),

              IconButton(
                icon: const Icon(Icons.content_cut),
                onPressed: _controller.selection.isValid &&
                        !_controller.selection.isCollapsed
                    ? _cutSelection
                    : null,
                tooltip: 'Cut (Ctrl+X)',
              ),

              IconButton(
                icon: const Icon(Icons.content_copy),
                onPressed: _controller.selection.isValid &&
                        !_controller.selection.isCollapsed
                    ? _copySelection
                    : null,
                tooltip: 'Copy (Ctrl+C)',
              ),

              IconButton(
                icon: const Icon(Icons.content_paste),
                onPressed: _pasteFromClipboard,
                tooltip: 'Paste (Ctrl+V)',
              ),

              const SizedBox(width: 8),

              IconButton(
                icon: const Icon(Icons.unfold_less),
                onPressed: _foldingManager.regions.isNotEmpty ? _foldAll : null,
                tooltip: 'Fold All (Ctrl+Shift+[)',
              ),

              IconButton(
                icon: const Icon(Icons.unfold_more),
                onPressed:
                    _foldingManager.regions.isNotEmpty ? _unfoldAll : null,
                tooltip: 'Unfold All (Ctrl+Shift+])',
              ),

              const SizedBox(width: 8),

              IconButton(
                icon: const Icon(Icons.file_download),
                onPressed: _showExportDialog,
                tooltip: 'Export (Ctrl+E)',
              ),
            ],
          ),
        ),

        // Editor area
        Expanded(
          child: FindReplaceShortcuts(
            onFind: _showFindDialog,
            onReplace: _showReplaceDialog,
            child: KeyboardListener(
              focusNode: _keyboardFocusNode,
              onKeyEvent: (event) {
                if (HardwareKeyboard.instance.isControlPressed) {
                  if (event.logicalKey == LogicalKeyboardKey.keyS) {
                    _saveFile();
                  } else if (event.logicalKey == LogicalKeyboardKey.keyZ) {
                    _undo();
                  } else if (event.logicalKey == LogicalKeyboardKey.keyY) {
                    _redo();
                  } else if (event.logicalKey == LogicalKeyboardKey.keyC) {
                    _copySelection();
                  } else if (event.logicalKey == LogicalKeyboardKey.keyV) {
                    _pasteFromClipboard();
                  } else if (event.logicalKey == LogicalKeyboardKey.keyX) {
                    _cutSelection();
                  } else if (event.logicalKey == LogicalKeyboardKey.keyA) {
                    _selectAll();
                  } else if (event.logicalKey == LogicalKeyboardKey.keyE) {
                    _showExportDialog();
                  } else if (HardwareKeyboard.instance.isShiftPressed) {
                    if (event.logicalKey == LogicalKeyboardKey.bracketLeft) {
                      _foldAll();
                    } else if (event.logicalKey ==
                        LogicalKeyboardKey.bracketRight) {
                      _unfoldAll();
                    }
                  }
                } else {
                  // Handle Tab and Shift+Tab for indentation
                  if (event.logicalKey == LogicalKeyboardKey.tab) {
                    if (HardwareKeyboard.instance.isShiftPressed) {
                      _dedentSelection();
                    } else {
                      _indentSelection();
                    }
                    return; // Prevent default tab behavior
                  }
                }
              },
              child: Row(
                children: [
                  // Line numbers (optional)
                  if (_showLineNumbers) _buildLineNumbers(theme),

                  // Text editor with syntax highlighting
                  Expanded(
                    child: _buildEditor(theme),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Status bar
        if (_isBloxFile &&
            (_parsedDocument != null || _syntaxWarnings.isNotEmpty))
          Container(
            height: 24,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
              border: Border(
                top: BorderSide(
                  color: theme.dividerColor,
                ),
              ),
            ),
            child: Row(
              children: [
                if (_parsedDocument != null)
                  Text(
                    '${_parsedDocument!.blocks.length} blocks',
                    style: theme.textTheme.bodySmall,
                  ),
                if (_syntaxWarnings.isNotEmpty) ...[
                  const SizedBox(width: 16),
                  const Icon(Icons.warning, size: 14, color: Colors.orange),
                  const SizedBox(width: 4),
                  Text(
                    '${_syntaxWarnings.length} warnings',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.orange,
                    ),
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildEditor(ThemeData theme) {
    if (_isBloxFile && _enableSyntaxHighlighting && _bloxHighlighter != null) {
      return _buildBloxEditor(theme);
    } else {
      return _buildPlainEditor(theme);
    }
  }

  Widget _buildLineNumbers(ThemeData theme) {
    final lines =
        _controller.text.isEmpty ? [''] : _controller.text.split('\n');

    const fontSize = 14.0;
    const lineHeight = 1.5;
    const actualLineHeight = fontSize * lineHeight; // 21.0

    return Container(
      width: 80, // Increased width for folding controls
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.1),
        border: Border(
          right: BorderSide(
            color: theme.dividerColor,
          ),
        ),
      ),
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: lines.asMap().entries.map((entry) {
              final lineNumber = entry.key + 1;

              // Check if this line starts a foldable region
              final foldableRegion = _foldingManager.regions.firstWhere(
                (region) => region.startLine == entry.key,
                orElse: () => FoldableRegion(
                  startLine: -1,
                  endLine: -1,
                  title: '',
                  type: FoldableRegionType.codeBlock,
                  level: 0,
                ),
              );

              return Container(
                height: actualLineHeight,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Folding control
                    if (foldableRegion.startLine != -1)
                      InkWell(
                        onTap: () {
                          final regionIndex =
                              _foldingManager.regions.indexOf(foldableRegion);
                          _foldingManager.toggleFold(regionIndex);
                          setState(() {});
                        },
                        child: Icon(
                          foldableRegion.isFolded
                              ? Icons.chevron_right
                              : Icons.expand_more,
                          size: 14,
                          color: theme.colorScheme.onSurfaceVariant
                              .withOpacity(0.6),
                        ),
                      )
                    else
                      const SizedBox(width: 14),

                    // Line number
                    Text(
                      '$lineNumber',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            theme.colorScheme.onSurfaceVariant.withOpacity(0.6),
                        fontFamily: 'monospace',
                        fontSize: fontSize,
                        height: lineHeight,
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

  Widget _buildBloxEditor(ThemeData theme) {
    // Update highlighter text and theme
    _bloxHighlighter!.text = _controller.text;
    _bloxHighlighter!.updateTheme(theme);

    return SingleChildScrollView(
      controller: _scrollController,
      child: Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 8),
        child: Stack(
          children: [
            // Syntax highlighted display
            SelectableText.rich(
              _bloxHighlighter!.getHighlightedText(),
              style: theme.textTheme.bodyMedium?.copyWith(
                fontFamily: 'monospace',
                fontSize: 14,
                height: 1.5,
              ),
            ),
            // Invisible TextField for input handling
            TextField(
              controller: _controller,
              maxLines: null,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontFamily: 'monospace',
                fontSize: 14,
                height: 1.5,
                color: Colors.transparent, // Make text invisible
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: 8,
                ),
              ),
              onChanged: (_) => _onTextChanged(),
              focusNode: _textFieldFocusNode,
              cursorColor: theme.colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlainEditor(ThemeData theme) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 8),
        child: TextField(
          controller: _controller,
          maxLines: null,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontFamily: 'monospace',
            fontSize: 14,
          ),
          decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: 8,
            ),
          ),
          onChanged: (_) => _onTextChanged(),
          focusNode: _textFieldFocusNode,
        ),
      ),
    );
  }

  void _showExportDialog() {
    if (_currentFilePath == null) return;

    showDialog<void>(
      context: context,
      builder: (context) => ExportDialog(
        content: _controller.text,
        fileName: _currentFilePath!.split('/').last,
      ),
    );
  }

  void _showSyntaxWarnings(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Syntax Warnings'),
        content: SizedBox(
          width: 400,
          height: 300,
          child: ListView.builder(
            itemCount: _syntaxWarnings.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: const Icon(Icons.warning, color: Colors.orange),
                title: Text(_syntaxWarnings[index]),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showFindDialog() {
    showDialog<void>(
      context: context,
      builder: (context) => FindReplaceDialog(
        onFind: _performFind,
        onReplace: _performReplace,
        onReplaceAll: _performReplaceAll,
      ),
    );
  }

  void _showReplaceDialog() {
    showDialog<void>(
      context: context,
      builder: (context) => FindReplaceDialog(
        onFind: _performFind,
        onReplace: _performReplace,
        onReplaceAll: _performReplaceAll,
      ),
    );
  }

  void _performFind(String searchText, bool caseSensitive, bool useRegex) {
    // Basic find implementation
    final text = _controller.text;
    if (text.isEmpty || searchText.isEmpty) return;

    var searchPattern = searchText;
    if (!caseSensitive) {
      searchPattern = searchPattern.toLowerCase();
    }

    final searchTarget = caseSensitive ? text : text.toLowerCase();
    final index =
        searchTarget.indexOf(searchPattern, _controller.selection.start);

    if (index != -1) {
      _controller.selection = TextSelection(
        baseOffset: index,
        extentOffset: index + searchText.length,
      );
    } else {
      // Show message if not found
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No matches found for "$searchText"')),
      );
    }
  }

  void _performReplace(
    String findText,
    String replaceText,
    bool caseSensitive,
    bool useRegex,
  ) {
    final selection = _controller.selection;
    if (selection.isValid && !selection.isCollapsed) {
      final selectedText =
          _controller.text.substring(selection.start, selection.end);
      final match = caseSensitive
          ? selectedText == findText
          : selectedText.toLowerCase() == findText.toLowerCase();

      if (match) {
        _controller
          ..text = _controller.text.replaceRange(
            selection.start,
            selection.end,
            replaceText,
          )

          // Move cursor after replacement
          ..selection = TextSelection.collapsed(
            offset: selection.start + replaceText.length,
          );
      }
    }

    // Find next occurrence
    _performFind(findText, caseSensitive, useRegex);
  }

  void _performReplaceAll(
    String findText,
    String replaceText,
    bool caseSensitive,
    bool useRegex,
  ) {
    if (findText.isEmpty) return;

    var text = _controller.text;
    var replacements = 0;

    if (caseSensitive) {
      final count = findText.allMatches(text).length;
      text = text.replaceAll(findText, replaceText);
      replacements = count;
    } else {
      final pattern = RegExp(RegExp.escape(findText), caseSensitive: false);
      final count = pattern.allMatches(text).length;
      text = text.replaceAll(pattern, replaceText);
      replacements = count;
    }

    _controller.text = text;

    // Show result
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Replaced $replacements occurrences')),
    );
  }
}

/// Code folding region information
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
  final int level; // Nesting level
  bool isFolded;
}

/// Types of foldable regions
enum FoldableRegionType {
  codeBlock, // ```code blocks```
  section, // # ## ### headers
  commentBlock, // /* */ or // blocks
  function, // function definitions
  classDefinition, // class definitions
}

/// Code folding manager
class CodeFoldingManager {
  CodeFoldingManager(this._text) {
    _parseRegions();
  }
  final List<FoldableRegion> _regions = [];
  final String _text;

  List<FoldableRegion> get regions => _regions;

  void _parseRegions() {
    final lines = _text.split('\n');
    _regions.clear();

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
  }

  void toggleFold(int regionIndex) {
    if (regionIndex >= 0 && regionIndex < _regions.length) {
      _regions[regionIndex].isFolded = !_regions[regionIndex].isFolded;
    }
  }

  bool isRegionFolded(int regionIndex) {
    if (regionIndex >= 0 && regionIndex < _regions.length) {
      return _regions[regionIndex].isFolded;
    }
    return false;
  }

  String getFoldedText() {
    if (_regions.isEmpty) return _text;

    final lines = _text.split('\n');
    final result = <String>[];

    for (var i = 0; i < lines.length; i++) {
      // Check if this line is the start of a folded region
      final foldedRegion = _regions.firstWhere(
        (region) => region.startLine == i && region.isFolded,
        orElse: () => FoldableRegion(
          startLine: -1,
          endLine: -1,
          title: '',
          type: FoldableRegionType.codeBlock,
          level: 0,
        ),
      );

      if (foldedRegion.startLine != -1) {
        // Add the folded line with indicator
        result.add(
          '${lines[i]} ... (${foldedRegion.endLine - foldedRegion.startLine} lines folded)',
        );
        i = foldedRegion.endLine; // Skip to end of folded region
      } else {
        result.add(lines[i]);
      }
    }

    return result.join('\n');
  }
}
