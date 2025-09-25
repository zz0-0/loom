import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/common/index.dart';
import 'package:loom/features/core/export/index.dart';
import 'package:loom/features/core/settings/index.dart';
import 'package:loom/flutter_gen/gen_l10n/app_localizations.dart';

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
    // Get the current content ID from the context or provider
    // Since this is called from ExtensibleContentArea, we need to get the content ID
    final contentId = _getCurrentContentId(context);
    return FileEditor(key: ValueKey(contentId));
  }

  String? _getCurrentContentId(BuildContext context) {
    // Try to get the content ID from the widget tree or providers
    // This is a bit of a hack, but we need the content ID to create unique keys
    try {
      final ref = ProviderScope.containerOf(context, listen: false);
      final tabState = ref.read(tabProvider);
      return tabState.activeTab?.id;
    } catch (e) {
      // Fallback - try to get from UI state
      try {
        final ref = ProviderScope.containerOf(context, listen: false);
        final uiState = ref.read(uiStateProvider);
        return uiState.openedFile;
      } catch (e) {
        return null;
      }
    }
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

  String? _currentFilePath;
  bool _isLoading = false;
  String? _error;
  bool _showLineNumbers = true;
  bool _showMinimap = false;
  bool _isBloxFile = false;
  bool _isLoadingFile = false; // Flag to track if we're loading a file
  String _previousContent =
      ''; // Track previous content to detect actual changes

  // Code folding
  late CodeFoldingManager _foldingManager;
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

    // Clean up auto-save for current file
    if (_currentFilePath != null) {
      _autoSaveService.cleanupFile(_currentFilePath!);
    }

    super.dispose();
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
      _previousContent = content; // Update previous content tracker
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
        // Blox parsing removed - keeping only editing functionality
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

  Future<void> _saveFile() async {
    if (_currentFilePath == null) return;

    try {
      final fileRepository = ref.read(fileRepositoryProvider);
      await fileRepository.writeFile(_currentFilePath!, _controller.text);

      // Re-parse if it's a Blox file
      if (_isBloxFile) {
        // Blox parsing removed - keeping only editing functionality
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
          SnackBar(
            content: Text(
              AppLocalizations.of(context).fileSavedSuccessfully,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context).errorSavingFile(e.toString()),
            ),
          ),
        );
      }
    }
  }

  void _onTextChanged() {
    // Don't mark as dirty if we're currently loading a file
    if (_currentFilePath != null && !_isLoadingFile) {
      // Only mark as dirty if content actually changed
      final currentContent = _controller.text;
      if (currentContent != _previousContent) {
        _previousContent = currentContent;

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
                .updateContent(currentContent);
          }
        });

        // Add current state to undo history
        _editHistoryService.addState(currentContent);

        // Mark unsaved changes for auto-save
        _autoSaveService.markUnsavedChanges(_currentFilePath!);
      }
    }

    // Update code folding regions, preserving existing fold states
    final oldFoldStates =
        _foldingManager.regions.map((r) => r.isFolded).toList();
    _foldingManager = CodeFoldingManager(_controller.text, oldFoldStates);
  }

  void _undo() {
    final previousState = _editHistoryService.undo();
    if (previousState != null) {
      _controller.text = previousState;
      _previousContent = previousState; // Update previous content tracker
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
      _previousContent = nextState; // Update previous content tracker
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

  List<_EditorToolbarAction> _getToolbarActions() {
    return [
      // Line numbers toggle only for non-Blox files
      if (!_isBloxFile)
        _EditorToolbarAction(
          key: 'line_numbers',
          icon: _showLineNumbers
              ? Icons.format_list_numbered
              : Icons.format_list_numbered_outlined,
          tooltip: 'Toggle line numbers',
          onPressed: () => setState(() => _showLineNumbers = !_showLineNumbers),
        ),
      // Minimap toggle only for non-Blox files
      if (!_isBloxFile)
        _EditorToolbarAction(
          key: 'minimap',
          icon: _showMinimap ? Icons.map : Icons.map_outlined,
          tooltip: 'Toggle minimap',
          onPressed: () => setState(() => _showMinimap = !_showMinimap),
        ),
      _EditorToolbarAction(
        key: 'undo',
        icon: Icons.undo,
        tooltip: 'Undo (Ctrl+Z)',
        onPressed: _editHistoryService.canUndo ? _undo : null,
      ),
      _EditorToolbarAction(
        key: 'redo',
        icon: Icons.redo,
        tooltip: 'Redo (Ctrl+Y)',
        onPressed: _editHistoryService.canRedo ? _redo : null,
      ),
      _EditorToolbarAction(
        key: 'cut',
        icon: Icons.content_cut,
        tooltip: 'Cut (Ctrl+X)',
        onPressed:
            _controller.selection.isValid && !_controller.selection.isCollapsed
                ? _cutSelection
                : null,
      ),
      _EditorToolbarAction(
        key: 'copy',
        icon: Icons.content_copy,
        tooltip: 'Copy (Ctrl+C)',
        onPressed:
            _controller.selection.isValid && !_controller.selection.isCollapsed
                ? _copySelection
                : null,
      ),
      _EditorToolbarAction(
        key: 'paste',
        icon: Icons.content_paste,
        tooltip: 'Paste (Ctrl+V)',
        onPressed: _pasteFromClipboard,
      ),
      _EditorToolbarAction(
        key: 'fold_all',
        icon: Icons.unfold_less,
        tooltip: 'Fold All (Ctrl+Shift+[)',
        onPressed: _foldingManager.regions.isNotEmpty ? _foldAll : null,
      ),
      _EditorToolbarAction(
        key: 'unfold_all',
        icon: Icons.unfold_more,
        tooltip: 'Unfold All (Ctrl+Shift+])',
        onPressed: _foldingManager.regions.isNotEmpty ? _unfoldAll : null,
      ),
      _EditorToolbarAction(
        key: 'export',
        icon: Icons.file_download,
        tooltip: 'Export (Ctrl+E)',
        onPressed: _showExportDialog,
      ),
    ];
  }

  _EditorToolbarLayout _calculateToolbarLayout(
    List<_EditorToolbarAction> actions,
    double availableWidth,
  ) {
    const overflowMenuWidth = 40.0; // Space for overflow menu
    final effectiveWidth = availableWidth - overflowMenuWidth;

    final visibleActions = <_EditorToolbarAction>[];
    final overflowActions = <_EditorToolbarAction>[];
    var usedWidth = 0.0;

    for (final action in actions) {
      final actionWidth = action.estimatedWidth;
      if (usedWidth + actionWidth <= effectiveWidth || visibleActions.isEmpty) {
        visibleActions.add(action);
        usedWidth += actionWidth;
      } else {
        overflowActions.add(action);
      }
    }

    return _EditorToolbarLayout(visibleActions, overflowActions);
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
              size: AppDimensions.iconMassive,
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
          child: LayoutBuilder(
            builder: (context, constraints) {
              final actions = _getToolbarActions();
              final layout =
                  _calculateToolbarLayout(actions, constraints.maxWidth);

              return Row(
                children: [
                  const Spacer(),
                  // Visible actions
                  ...layout.visibleActions
                      .map((action) => action.build(context)),
                  // Overflow menu
                  if (layout.overflowActions.isNotEmpty)
                    _EditorOverflowMenu(actions: layout.overflowActions),
                ],
              );
            },
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
              child: LayoutBuilder(
                builder: (context, constraints) => Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Line numbers and minimap are handled by BloxEditor for Blox files
                    if (!_isBloxFile && _showLineNumbers)
                      _buildLineNumbers(theme, constraints.maxWidth),

                    // Text editor with syntax highlighting
                    Expanded(
                      child: _buildEditor(theme),
                    ),

                    // Minimap is handled by BloxEditor for Blox files
                    if (!_isBloxFile && _showMinimap)
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
        ),
      ],
    );
  }

  Widget _buildEditor(ThemeData theme) {
    if (_isBloxFile) {
      return BloxEditor(
        controller: _controller,
        focusNode: _textFieldFocusNode,
        onChanged: _onTextChanged,
        filePath: _currentFilePath,
        showLineNumbers: _showLineNumbers,
        showMinimap: _showMinimap,
      );
    } else {
      return _buildPlainEditor(theme);
    }
  }

  // Cache for line numbers to prevent unnecessary rebuilds
  int? _cachedFoldingHash;
  double? _cachedMaxWidth;
  bool? _cachedShowLineNumbers;

  // New cached variables for folded text with line mapping
  int? _cachedFoldedTextHash;
  List<String>? _cachedFoldedLines;
  // ignore: use_late_for_private_fields_and_variables
  List<double>? _cachedFoldedLineHeights;
  List<int>?
      // ignore: lines_longer_than_80_chars, use_late_for_private_fields_and_variables
      _cachedFoldedLineNumbers; // Maps folded line index to original line number
  bool? _cachedIsUsingFoldedText;

  Widget _buildLineNumbers(ThemeData theme, double maxWidth) {
    // Calculate folding hash based on regions
    final currentFoldingHash = _foldingManager.regions.fold(
      0,
      (hash, region) =>
          hash ^ region.startLine ^ region.endLine ^ (region.isFolded ? 1 : 0),
    );

    // Get current folded text for caching
    final currentFoldedText = _foldingManager.regions.isNotEmpty &&
            _foldingManager.regions.any((r) => r.isFolded)
        ? _foldingManager.getFoldedText()
        : _controller.text;
    final currentFoldedLines = currentFoldedText.split('\n');
    final currentFoldedTextHash = currentFoldedText.hashCode;

    // Generate line number mapping for folded text
    final isUsingFoldedText = _foldingManager.regions.isNotEmpty &&
        _foldingManager.regions.any((r) => r.isFolded);
    final currentFoldedLineNumbers = isUsingFoldedText
        ? (_foldingManager._lastLineMapping ??
            List.generate(currentFoldedLines.length, (i) => i + 1))
        : List.generate(currentFoldedLines.length, (i) => i + 1);

    // Only rebuild if folded text, folding, width, or line numbers visibility has actually changed
    if (_cachedFoldedTextHash == null ||
        _cachedFoldedTextHash != currentFoldedTextHash ||
        _cachedFoldedLines == null ||
        _cachedFoldedLines!.length != currentFoldedLines.length ||
        _cachedFoldingHash != currentFoldingHash ||
        _cachedMaxWidth != maxWidth ||
        _cachedShowLineNumbers != _showLineNumbers ||
        _cachedIsUsingFoldedText == null ||
        _cachedIsUsingFoldedText != isUsingFoldedText) {
      _cachedFoldedTextHash = currentFoldedTextHash;
      _cachedFoldedLines = currentFoldedLines;
      _cachedFoldedLineNumbers = currentFoldedLineNumbers;
      _cachedFoldingHash = currentFoldingHash;
      _cachedMaxWidth = maxWidth;
      _cachedShowLineNumbers = _showLineNumbers;
      _cachedIsUsingFoldedText = isUsingFoldedText;

      // Calculate the available width for text wrapping
      final availableWidth = maxWidth;
      final minimapWidth = _showMinimap ? 200 : 0;
      final textWidth = availableWidth -
          80 -
          32 -
          minimapWidth; // Subtract line number width, padding, and minimap width

      // Calculate heights for folded lines
      _cachedFoldedLineHeights =
          _calculateWrappedLineHeights(currentFoldedLines, textWidth, theme);
    }

    final foldedLines = _cachedFoldedLines!;
    final foldedLineHeights = _cachedFoldedLineHeights!;
    final foldedLineNumbers = _cachedFoldedLineNumbers!;

    return Container(
      width: AppDimensions
          .lineNumbersWidth, // Increased width for folding controls
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
            children: foldedLines.asMap().entries.map((entry) {
              final lineNumber =
                  foldedLineNumbers[entry.key]; // Use original line number
              final lineHeight = foldedLineHeights[entry.key];
              final foldedLine = entry.value;

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
                            entry.key,
                            foldedLines,
                          );
                          if (regionIndex != -1) {
                            _foldingManager.toggleFold(regionIndex);
                            setState(() {});
                          }
                        },
                        child: Icon(
                          isFolded
                              ? Icons.chevron_right // Folded state
                              : Icons.expand_more, // Unfolded state
                          size: AppDimensions.iconMedium,
                          color: theme.colorScheme.onSurfaceVariant
                              .withOpacity(0.6),
                        ),
                      )
                    else
                      const SizedBox(width: AppDimensions.iconMedium),

                    // Line number
                    SizedBox(
                      width: AppDimensions
                          .lineNumbersMinWidth, // Fixed width for line numbers
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
    for (var i = 0; i < _foldingManager.regions.length; i++) {
      if (_foldingManager.regions[i].title == title) {
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
        return _foldingManager.regions.any((region) => region.title == title);
      }
    }

    // For code blocks, check the full line text
    return _foldingManager.regions.any((region) => region.title == lineText);
  }

  bool _isFoldedRegionLine(String foldedLine) {
    // A line is folded if it contains "..." and "folded"
    return foldedLine.contains('...') && foldedLine.contains('folded');
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

  Widget _buildPlainEditor(ThemeData theme) {
    return Scrollbar(
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Padding(
          padding:
              const EdgeInsets.only(top: AppSpacing.md, bottom: AppSpacing.sm),
          child: TextField(
            controller: _controller,
            maxLines: null,
            style: AppTypography.editorTextStyle,
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
          SnackBar(
            content: Text(
              AppLocalizations.of(context).noMatchesFound(searchText),
            ),
          ),
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
      SnackBar(
        content: Text(
          AppLocalizations.of(context).replacedOccurrences(replacements),
        ),
      ),
    );
  }
}

/// Editor toolbar action data class
class _EditorToolbarAction {
  const _EditorToolbarAction({
    required this.key,
    required this.icon,
    this.tooltip,
    this.onPressed,
  });

  final String key;
  final IconData icon;
  final String? tooltip;
  final VoidCallback? onPressed;

  double get estimatedWidth =>
      AppDimensions.buttonMinWidth +
      8; // Icon buttons are typically buttonMinWidth + padding wide

  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon),
      onPressed: onPressed,
      splashRadius: AppDimensions.buttonSplashRadius,
      tooltip: tooltip,
    ).withHoverAnimation().withPressAnimation();
  }
}

/// Editor toolbar layout result
class _EditorToolbarLayout {
  const _EditorToolbarLayout(this.visibleActions, this.overflowActions);

  final List<_EditorToolbarAction> visibleActions;
  final List<_EditorToolbarAction> overflowActions;
}

/// Overflow menu for editor toolbar actions
class _EditorOverflowMenu extends StatelessWidget {
  const _EditorOverflowMenu({required this.actions});

  final List<_EditorToolbarAction> actions;

  @override
  Widget build(BuildContext context) {
    Theme.of(context);

    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, size: AppDimensions.iconLarge),
      splashRadius: AppDimensions.buttonSplashRadius,
      tooltip: 'More actions',
      itemBuilder: (context) => actions.map((action) {
        return PopupMenuItem<String>(
          value: action.key,
          child: Row(
            children: [
              Icon(action.icon, size: AppDimensions.iconLarge),
              const SizedBox(width: AppSpacing.sm),
              Text(action.tooltip ?? action.key),
            ],
          ),
        );
      }).toList(),
      onSelected: (value) {
        final action = actions.firstWhere((a) => a.key == value);
        action.onPressed?.call();
      },
    );
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
  CodeFoldingManager(this._text, [List<bool>? preservedFoldStates]) {
    _parseRegions();
    // Restore folding states if provided
    if (preservedFoldStates != null) {
      for (var i = 0;
          i < _regions.length && i < preservedFoldStates.length;
          i++) {
        _regions[i].isFolded = preservedFoldStates[i];
      }
    }
  }
  final List<UIFoldableRegion> _regions = [];
  final String _text;

  List<UIFoldableRegion> get regions => _regions;

  List<int>? get lastLineMapping => _lastLineMapping;

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
            RegExp(r'^(#{1,6})\s*(.*)$').firstMatch(line.trim());
        if (headerMatch != null) {
          final level = headerMatch.group(1)!.length;
          final title = headerMatch.group(2) ?? '';

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

          // Exclude trailing empty lines from the region
          var actualEndLine = endLine - 1;
          while (actualEndLine > i && lines[actualEndLine].trim().isEmpty) {
            actualEndLine--;
          }

          // Always add the region for headers, even if they have no content
          _regions.add(
            UIFoldableRegion(
              startLine: i,
              endLine: actualEndLine,
              title: title,
              type: UIFoldableRegionType.section,
              level: level - 1, // 0-based level
            ),
          );
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
    final lineMapping =
        <int>[]; // Maps folded line index to original line number

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
        // Count only content lines (non-empty lines after header, excluding trailing empty lines)
        var contentLines = 0;
        for (var j = foldedRegion.startLine + 1;
            j <= foldedRegion.endLine;
            j++) {
          if (j < lines.length && lines[j].trim().isNotEmpty) {
            contentLines++;
          }
        }

        // Add the folded line with indicator
        result.add(
          '${lines[i]} ... ($contentLines lines with content folded)',
        );
        lineMapping
            .add(i + 1); // This folded line corresponds to original line i+1
        i = foldedRegion.endLine; // Skip to end of folded region
      } else {
        result.add(lines[i]);
        lineMapping
            .add(i + 1); // This folded line corresponds to original line i+1
      }
    }

    // Store the mapping for later use
    _lastLineMapping = lineMapping;
    return result.join('\n');
  }

  List<int>? _lastLineMapping;
}
