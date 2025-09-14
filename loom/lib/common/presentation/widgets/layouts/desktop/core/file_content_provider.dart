import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/common/index.dart';
import 'package:loom/features/core/export/index.dart';
import 'package:loom/features/core/settings/index.dart';
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
  final ScrollController _lineNumbersScrollController = ScrollController();
  final ScrollController _syntaxScrollController = ScrollController();
  final FocusNode _keyboardFocusNode = FocusNode();
  final FocusNode _textFieldFocusNode = FocusNode();

  // Services from domain layer
  late final EditHistoryService _editHistoryService;
  late final AutoSaveService _autoSaveService;

  // Syntax highlighting
  BloxSyntaxHighlighter? _bloxHighlighter;
  final bool _enableSyntaxHighlighting = true;

  String? _currentFilePath;
  bool _isLoading = false;
  String? _error;
  bool _showLineNumbers = true;
  bool _isBloxFile = false;
  bool _isLoadingFile = false; // Flag to track if we're loading a file
  bool _showMinimap = false; // Minimap visibility toggle
  bool _showPreview = false; // Preview mode toggle for Blox files

  // Code folding
  late CodeFoldingManager _foldingManager;

  // Blox-specific state
  BloxDocument? _parsedDocument;
  List<String> _syntaxWarnings = [];
  @override
  void initState() {
    super.initState();
    _initializeServices();
    // Delay loading current file until after widget tree is built
    Future.microtask(() {
      if (mounted) {
        _loadCurrentFile();
      }
    });
    _controller.addListener(_onTextChanged);
    _initializeSyntaxHighlighter();
    _foldingManager = CodeFoldingManager('');

    // Add scroll listener to sync other scroll controllers
    _scrollController.addListener(_syncScrollControllers);
  }

  void _syncScrollControllers() {
    if (_scrollController.hasClients) {
      final offset = _scrollController.offset;

      // Only sync if the offset has actually changed to prevent unnecessary rebuilds
      if (_lineNumbersScrollController.hasClients &&
          (_lineNumbersScrollController.offset - offset).abs() > 0.1) {
        _lineNumbersScrollController.jumpTo(offset);
      }

      if (_syntaxScrollController.hasClients &&
          (_syntaxScrollController.offset - offset).abs() > 0.1) {
        _syntaxScrollController.jumpTo(offset);
      }
    }
  }

  void _initializeServices() {
    _editHistoryService = ref.read(editHistoryServiceProvider);
    _autoSaveService = ref.read(autoSaveServiceProvider);
  }

  @override
  void didUpdateWidget(FileEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    _loadCurrentFile();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController
      ..removeListener(_syncScrollControllers)
      ..dispose();
    _lineNumbersScrollController.dispose();
    _syntaxScrollController.dispose();
    _keyboardFocusNode.dispose();
    _textFieldFocusNode.dispose();
    _bloxHighlighter?.dispose();

    // Clean up auto-save for current file
    if (_currentFilePath != null) {
      _autoSaveService.cleanupFile(_currentFilePath!);
    }

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
        // Clean up previous file's auto-save
        if (_currentFilePath != null) {
          _autoSaveService.cleanupFile(_currentFilePath!);
        }

        _currentFilePath = filePath;
        _isBloxFile = filePath.toLowerCase().endsWith('.blox');

        // Delay provider update until after widget tree is built
        Future.microtask(() {
          if (mounted) {
            // Update editor state provider when file changes
            ref.read(editorStateProvider.notifier).updateFilePath(filePath);

            _loadFileContent(filePath);
          }
        });
      }
    } else {
      // Clear current file if no valid tab is selected
      _currentFilePath = null;
      _controller.clear();

      // Clear editor state when no file is selected
      Future.microtask(() {
        if (mounted) {
          ref.read(editorStateProvider.notifier).clear();
        }
      });

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
      final fileRepository = ref.read(fileRepositoryProvider);
      final content = await fileRepository.readFile(filePath);

      // Set flag to prevent marking as dirty during loading
      _isLoadingFile = true;
      _controller.text = content;
      _isLoadingFile = false;

      // Initialize undo/redo history with loaded content
      _editHistoryService.addState(content);

      // Update editor state with content
      await Future.microtask(() {
        if (mounted) {
          ref.read(editorStateProvider.notifier).updateContent(content);
        }
      });

      // Parse Blox content if it's a .blox file
      if (_isBloxFile) {
        await _parseBloxContent(content);
      }

      // Mark tab as clean after successful load
      await Future.microtask(() {
        if (mounted) {
          if (_currentFilePath != null) {
            ref
                .read(tabProvider.notifier)
                .updateTab(_currentFilePath!, isDirty: false);
          }
        }
      });

      // Initialize auto-save for this file
      _initializeAutoSaveForFile(filePath);
    } catch (e) {
      _error = 'Error loading file: $e';
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _initializeAutoSaveForFile(String filePath) {
    final autoSaveState = ref.read(autoSaveProvider);
    final isEnabled = autoSaveState.isEnabled;
    final intervalSeconds = autoSaveState.intervalSeconds;

    _autoSaveService.initializeAutoSave(
      filePath,
      intervalSeconds,
      _saveFile,
      isEnabled: isEnabled,
    );
  }

  Future<void> _parseBloxContent(String content) async {
    try {
      // Parse the document
      final document = parseBloxString(content: content);
      _parsedDocument = document;

      // Validate syntax
      final warnings = validateBloxSyntax(content: content);
      _syntaxWarnings = warnings;

      // Update editor state with parsed document and warnings
      await Future.microtask(() {
        if (mounted) {
          ref.read(editorStateProvider.notifier).updateParsedDocument(document);
          ref.read(editorStateProvider.notifier).updateSyntaxWarnings(warnings);
        }
      });

      setState(() {});
    } catch (e) {
      _syntaxWarnings = ['Parse error: $e'];
      await Future.microtask(() {
        if (mounted) {
          ref
              .read(editorStateProvider.notifier)
              .updateSyntaxWarnings(['Parse error: $e']);
        }
      });
      setState(() {});
    }
  }

  Future<void> _saveFile() async {
    if (_currentFilePath == null) return;

    try {
      final fileRepository = ref.read(fileRepositoryProvider);
      await fileRepository.writeFile(_currentFilePath!, _controller.text);

      // Re-parse if it's a Blox file
      if (_isBloxFile) {
        await _parseBloxContent(_controller.text);
      }

      // Mark tab as not dirty
      await Future.microtask(() {
        if (mounted) {
          ref
              .read(tabProvider.notifier)
              .updateTab(_currentFilePath!, isDirty: false);
        }
      });

      // Mark changes as saved for auto-save
      _autoSaveService.markChangesSaved(_currentFilePath!);

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
      Future.microtask(() {
        if (mounted) {
          ref
              .read(tabProvider.notifier)
              .updateTab(_currentFilePath!, isDirty: true);
        }
      });

      // Update editor state with new content
      Future.microtask(() {
        if (mounted) {
          ref
              .read(editorStateProvider.notifier)
              .updateContent(_controller.text);
        }
      });

      // Add current state to undo history
      _editHistoryService.addState(_controller.text);

      // Mark unsaved changes for auto-save
      _autoSaveService.markUnsavedChanges(_currentFilePath!);
    }

    // Update code folding regions
    _foldingManager = CodeFoldingManager(_controller.text);

    // Debounced parsing for Blox files
    if (_isBloxFile) {
      _debounceParse();
    }
  }

  void _undo() {
    final previousState = _editHistoryService.undo();
    if (previousState != null) {
      _controller.text = previousState;
      // Mark as dirty if the content changed
      if (_currentFilePath != null) {
        Future.microtask(() {
          if (mounted) {
            ref
                .read(tabProvider.notifier)
                .updateTab(_currentFilePath!, isDirty: true);
          }
        });
      }
    }
  }

  void _redo() {
    final nextState = _editHistoryService.redo();
    if (nextState != null) {
      _controller.text = nextState;
      // Mark as dirty if the content changed
      if (_currentFilePath != null) {
        Future.microtask(() {
          if (mounted) {
            ref
                .read(tabProvider.notifier)
                .updateTab(_currentFilePath!, isDirty: true);
          }
        });
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
      final newText =
          _controller.text.replaceRange(selection.start, selection.end, '');
      _controller.text = newText;
      final newSelection = TextSelection.collapsed(offset: selection.start);
      _controller.selection = newSelection;

      // Mark as dirty
      if (_currentFilePath != null) {
        Future.microtask(() {
          if (mounted) {
            ref
                .read(tabProvider.notifier)
                .updateTab(_currentFilePath!, isDirty: true);
          }
        });
      }
    }
  }

  Future<void> _pasteFromClipboard() async {
    final clipboardText = await ClipboardService.pasteFromClipboard();
    if (clipboardText != null && clipboardText.isNotEmpty) {
      final selection = _controller.selection;

      if (selection.isValid && !selection.isCollapsed) {
        // Replace selected text
        final newText = _controller.text.replaceRange(
          selection.start,
          selection.end,
          clipboardText,
        );
        _controller.text = newText;
        final newSelection = TextSelection.collapsed(
          offset: selection.start + clipboardText.length,
        );
        _controller.selection = newSelection;
      } else {
        // Insert at cursor position
        final cursorPosition = selection.baseOffset;
        final newText = _controller.text.replaceRange(
          cursorPosition,
          cursorPosition,
          clipboardText,
        );
        _controller.text = newText;
        final newSelection = TextSelection.collapsed(
          offset: cursorPosition + clipboardText.length,
        );
        _controller.selection = newSelection;
      }

      // Mark as dirty
      if (_currentFilePath != null) {
        await Future.microtask(() {
          if (mounted) {
            ref
                .read(tabProvider.notifier)
                .updateTab(_currentFilePath!, isDirty: true);
          }
        });
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
      final newText = text.replaceRange(cursorPosition, cursorPosition, '\t');
      _controller.text = newText;
      final newSelection = TextSelection.collapsed(offset: cursorPosition + 1);
      _controller.selection = newSelection;
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
      final newText = beforeSelection + newSelectedText + afterSelection;
      _controller.text = newText;

      // Update selection to cover the indented text
      final newSelection = TextSelection(
        baseOffset: start,
        extentOffset: start + newSelectedText.length,
      );
      _controller.selection = newSelection;
    }

    // Mark as dirty
    if (_currentFilePath != null) {
      Future.microtask(() {
        if (mounted) {
          ref
              .read(tabProvider.notifier)
              .updateTab(_currentFilePath!, isDirty: true);
        }
      });
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
        final newSelection =
            TextSelection.collapsed(offset: cursorPosition - 1);
        _controller.selection = newSelection;
      } else if (line.startsWith('    ')) {
        // Remove 4 spaces (common indent)
        lines[lineIndex] = line.substring(4);
        _controller.text = lines.join('\n');
        final newSelection =
            TextSelection.collapsed(offset: cursorPosition - 4);
        _controller.selection = newSelection;
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
      final newText = beforeSelection + newSelectedText + afterSelection;
      _controller.text = newText;

      // Update selection to cover the dedented text
      final newSelection = TextSelection(
        baseOffset: start,
        extentOffset: start + newSelectedText.length,
      );
      _controller.selection = newSelection;
    }

    // Mark as dirty
    if (_currentFilePath != null) {
      Future.microtask(() {
        if (mounted) {
          ref
              .read(tabProvider.notifier)
              .updateTab(_currentFilePath!, isDirty: true);
        }
      });
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

  void _scrollToPosition(double position) {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        position,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    }
  }

  void _debounceParse() {
    // Simple debounce - in a real app, you'd use a proper debouncer
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted && _isBloxFile) {
        _parseBloxContent(_controller.text);
      }
    });
  }

  double _calculateMinWidth() {
    if (_controller.text.isEmpty) return 2000;

    final lines = _controller.text.split('\n');
    final longestLine = lines.reduce((a, b) => a.length > b.length ? a : b);

    // Estimate width based on character count (rough estimate)
    const charWidth = 8.0; // Approximate width per character in monospace
    final estimatedWidth = longestLine.length * charWidth + 100; // Add padding

    return max(2000, estimatedWidth); // Minimum width of 2000
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
              ).withHoverAnimation().withPressAnimation(),

              // Minimap toggle
              IconButton(
                icon: Icon(
                  _showMinimap ? Icons.map : Icons.map_outlined,
                ),
                onPressed: () => setState(() => _showMinimap = !_showMinimap),
                tooltip: 'Toggle minimap',
              ).withHoverAnimation().withPressAnimation(),

              // Preview toggle for Blox files
              if (_isBloxFile)
                IconButton(
                  icon: Icon(
                    _showPreview ? Icons.visibility : Icons.visibility_outlined,
                  ),
                  onPressed: () => setState(() => _showPreview = !_showPreview),
                  tooltip: _showPreview ? 'Show editor' : 'Show preview',
                ).withHoverAnimation().withPressAnimation(),

              // Syntax validation for Blox files
              if (_isBloxFile && _syntaxWarnings.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.warning, color: Colors.orange),
                  onPressed: () => _showSyntaxWarnings(context),
                  tooltip: '${_syntaxWarnings.length} syntax warnings',
                ).withHoverAnimation().withPressAnimation(),

              IconButton(
                icon: const Icon(Icons.undo),
                onPressed: _editHistoryService.canUndo ? _undo : null,
                tooltip: 'Undo (Ctrl+Z)',
              ).withHoverAnimation().withPressAnimation(),

              IconButton(
                icon: const Icon(Icons.redo),
                onPressed: _editHistoryService.canRedo ? _redo : null,
                tooltip: 'Redo (Ctrl+Y)',
              ).withHoverAnimation().withPressAnimation(),

              const SizedBox(width: 8),

              IconButton(
                icon: const Icon(Icons.content_cut),
                onPressed: _controller.selection.isValid &&
                        !_controller.selection.isCollapsed
                    ? _cutSelection
                    : null,
                tooltip: 'Cut (Ctrl+X)',
              ).withHoverAnimation().withPressAnimation(),

              IconButton(
                icon: const Icon(Icons.content_copy),
                onPressed: _controller.selection.isValid &&
                        !_controller.selection.isCollapsed
                    ? _copySelection
                    : null,
                tooltip: 'Copy (Ctrl+C)',
              ).withHoverAnimation().withPressAnimation(),

              IconButton(
                icon: const Icon(Icons.content_paste),
                onPressed: _pasteFromClipboard,
                tooltip: 'Paste (Ctrl+V)',
              ).withHoverAnimation().withPressAnimation(),

              const SizedBox(width: 8),

              IconButton(
                icon: const Icon(Icons.unfold_less),
                onPressed: _foldingManager.regions.isNotEmpty ? _foldAll : null,
                tooltip: 'Fold All (Ctrl+Shift+[)',
              ).withHoverAnimation().withPressAnimation(),

              IconButton(
                icon: const Icon(Icons.unfold_more),
                onPressed:
                    _foldingManager.regions.isNotEmpty ? _unfoldAll : null,
                tooltip: 'Unfold All (Ctrl+Shift+])',
              ).withHoverAnimation().withPressAnimation(),

              const SizedBox(width: 8),

              IconButton(
                icon: const Icon(Icons.file_download),
                onPressed: _showExportDialog,
                tooltip: 'Export (Ctrl+E)',
              ).withHoverAnimation().withPressAnimation(),
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
                // Disable editing shortcuts in preview mode
                if (_showPreview) return;

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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Line numbers (optional)
                  if (_showLineNumbers) _buildLineNumbers(theme),

                  // Text editor with syntax highlighting
                  Expanded(
                    child: _buildEditor(theme),
                  ),

                  // Minimap (optional)
                  if (_showMinimap)
                    SizedBox(
                      width: 200, // Fixed width for minimap
                      child: MinimapWidget(
                        text: _controller.text,
                        scrollPosition: _scrollController.hasClients
                            ? _scrollController.position.pixels
                            : 0,
                        maxScrollExtent: _scrollController.hasClients
                            ? _scrollController.position.maxScrollExtent
                            : 0,
                        viewportHeight: _scrollController.hasClients
                            ? _scrollController.position.viewportDimension
                            : 0,
                        onScrollToPosition: _scrollToPosition,
                        isBloxFile: _isBloxFile,
                        showLineNumbers: _showLineNumbers,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),

        // Status bar
        if (_isBloxFile &&
            (_parsedDocument != null ||
                _syntaxWarnings.isNotEmpty ||
                _showPreview))
          Container(
            height: 24,
            padding: AppSpacing.paddingMd,
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
                if (_showPreview)
                  Row(
                    children: [
                      Icon(
                        Icons.visibility,
                        size: 14,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Preview Mode',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  )
                else if (_parsedDocument != null)
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
    if (_isBloxFile && _showPreview && _parsedDocument != null) {
      return _buildBloxPreview(theme);
    } else if (_isBloxFile &&
        _enableSyntaxHighlighting &&
        _bloxHighlighter != null) {
      return _buildBloxEditor(theme);
    } else {
      return _buildPlainEditor(theme);
    }
  }

  // Cache for line numbers to prevent unnecessary rebuilds
  List<String>? _cachedLogicalLines;
  int? _cachedTextHash;
  List<UIFoldableRegion>? _cachedFoldableRegions;
  int? _cachedFoldingHash;

  Widget _buildLineNumbers(ThemeData theme) {
    // Calculate current text hash
    final currentTextHash = _controller.text.hashCode;
    final currentLogicalLines =
        _controller.text.isEmpty ? [''] : _controller.text.split('\n');

    // Calculate folding hash based on regions
    final currentFoldingHash = _foldingManager.regions.fold(
      0,
      (hash, region) =>
          hash ^ region.startLine ^ region.endLine ^ (region.isFolded ? 1 : 0),
    );

    // Only rebuild if text or folding has actually changed
    if (_cachedLogicalLines == null ||
        _cachedTextHash != currentTextHash ||
        _cachedLogicalLines!.length != currentLogicalLines.length ||
        _cachedFoldableRegions == null ||
        _cachedFoldingHash != currentFoldingHash) {
      _cachedLogicalLines = currentLogicalLines;
      _cachedTextHash = currentTextHash;
      _cachedFoldableRegions = List.from(_foldingManager.regions);
      _cachedFoldingHash = currentFoldingHash;
    }

    final lines = _cachedLogicalLines!;
    final foldableRegions = _cachedFoldableRegions!;

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
        controller: _lineNumbersScrollController,
        physics: const NeverScrollableScrollPhysics(), // Sync with main content
        child: Padding(
          padding: const EdgeInsets.only(
            top: AppSpacing.md,
            bottom: AppSpacing.sm,
            left: AppSpacing.sm,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: lines.asMap().entries.map((entry) {
              final lineNumber = entry.key + 1;

              // Check if this line starts a foldable region (using cached regions)
              final foldableRegion = foldableRegions.firstWhere(
                (region) => region.startLine == entry.key,
                orElse: () => UIFoldableRegion(
                  startLine: -1,
                  endLine: -1,
                  title: '',
                  type: UIFoldableRegionType.codeBlock,
                  level: 0,
                ),
              );

              return Container(
                height: actualLineHeight,
                alignment: Alignment.centerRight,
                padding: AppSpacing.paddingRightSm,
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
                    SizedBox(
                      width: 30, // Fixed width for line numbers
                      child: Text(
                        '$lineNumber',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant
                              .withOpacity(0.6),
                          fontFamily: 'monospace',
                          fontSize: fontSize,
                          height: lineHeight,
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

  Widget _buildBloxEditor(ThemeData theme) {
    // Update highlighter text and theme
    _bloxHighlighter!.text = _controller.text;
    _bloxHighlighter!.updateTheme(theme);

    return Stack(
      children: [
        // Syntax highlighted display (background)
        SingleChildScrollView(
          controller: _syntaxScrollController,
          scrollDirection: Axis.horizontal, // Allow horizontal scrolling
          physics:
              const NeverScrollableScrollPhysics(), // Let TextField handle scrolling
          child: Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.md,
              right: AppSpacing.md,
              top: AppSpacing.md,
              bottom: AppSpacing.sm,
            ),
            child: SizedBox(
              width: _calculateMinWidth(), // Dynamic width based on content
              child: SelectableText.rich(
                _bloxHighlighter!.getHighlightedText(),
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontFamily: 'monospace',
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ),

        // Editable TextField (foreground)
        Positioned.fill(
          child: Scrollbar(
            controller: _scrollController,
            child: SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal, // Allow horizontal scrolling
              child: Padding(
                padding: const EdgeInsets.only(
                  top: AppSpacing.md,
                  bottom: AppSpacing.sm,
                ),
                child: SizedBox(
                  width: _calculateMinWidth(), // Dynamic width based on content
                  child: TextField(
                    controller: _controller,
                    maxLines: null, // Allow multiple logical lines
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontFamily: 'monospace',
                      fontSize: 14,
                      height: 1.5,
                      color: Colors.transparent, // Make text invisible
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: AppSpacing.paddingHorizontalMd,
                    ),
                    onChanged: (_) => _onTextChanged(),
                    focusNode: _textFieldFocusNode,
                    cursorColor: theme.colorScheme.primary,
                    showCursor: true,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlainEditor(ThemeData theme) {
    return Scrollbar(
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal, // Allow horizontal scrolling
        child: Padding(
          padding:
              const EdgeInsets.only(top: AppSpacing.md, bottom: AppSpacing.sm),
          child: SizedBox(
            width: _calculateMinWidth(), // Dynamic width based on content
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
        ),
      ),
    );
  }

  Widget _buildBloxPreview(ThemeData theme) {
    if (_parsedDocument == null) {
      return const Center(
        child: Text('No content to preview'),
      );
    }

    return BloxViewer(
      blocks: _parsedDocument!.blocks,
      scrollController: _scrollController,
      isDark: theme.brightness == Brightness.dark,
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

  void _performFind(
    String searchText, {
    required bool caseSensitive,
    required bool useRegex,
  }) {
    {
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
  }

  void _performReplace(
    String findText,
    String replaceText, {
    required bool caseSensitive,
    required bool useRegex,
  }) {
    {
      final selection = _controller.selection;
      if (selection.isValid && !selection.isCollapsed) {
        final selectedText =
            _controller.text.substring(selection.start, selection.end);
        final match = caseSensitive
            ? selectedText == findText
            : selectedText.toLowerCase() == findText.toLowerCase();

        if (match) {
          final newText = _controller.text.replaceRange(
            selection.start,
            selection.end,
            replaceText,
          );
          _controller.text = newText;
          final newSelection = TextSelection.collapsed(
            offset: selection.start + replaceText.length,
          );
          _controller.selection = newSelection;
        }
      }

      // Find next occurrence
      _performFind(findText, caseSensitive: caseSensitive, useRegex: useRegex);
    }
  }

  void _performReplaceAll(
    String findText,
    String replaceText, {
    required bool caseSensitive,
    required bool useRegex,
  }) {
    {
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
}

/// Code folding region information
class UIFoldableRegion {
  UIFoldableRegion({
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
  final UIFoldableRegionType type;
  final int level; // Nesting level
  bool isFolded;
}

/// Types of foldable regions
enum UIFoldableRegionType {
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
  final List<UIFoldableRegion> _regions = [];
  final String _text;

  List<UIFoldableRegion> get regions => _regions;

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
            UIFoldableRegion(
              startLine: startLine,
              endLine: endLine,
              title: title,
              type: UIFoldableRegionType.codeBlock,
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
              UIFoldableRegion(
                startLine: i,
                endLine: endLine - 1,
                title: title,
                type: UIFoldableRegionType.section,
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
        orElse: () => UIFoldableRegion(
          startLine: -1,
          endLine: -1,
          title: '',
          type: UIFoldableRegionType.codeBlock,
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
