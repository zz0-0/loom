import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/shared/presentation/providers/tab_provider.dart';
import 'package:loom/shared/presentation/widgets/editor/blox_syntax_highlighter.dart';
import 'package:loom/shared/presentation/widgets/editor/find_replace_dialog.dart';
import 'package:loom/shared/presentation/widgets/layouts/desktop/core/ui_registry.dart';
import 'package:loom/src/rust/api/blox_api.dart';

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

  // Syntax highlighting
  BloxSyntaxHighlighter? _bloxHighlighter;
  final bool _enableSyntaxHighlighting = true;

  String? _currentFilePath;
  bool _isLoading = false;
  String? _error;
  bool _showLineNumbers = true;
  bool _isBloxFile = false;
  bool _isLoadingFile = false; // Flag to track if we're loading a file

  // Blox-specific state
  BloxDocument? _parsedDocument;
  List<String> _syntaxWarnings = [];
  @override
  void initState() {
    super.initState();
    _loadCurrentFile();
    _controller.addListener(_onTextChanged);
    _initializeSyntaxHighlighter();
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
    }

    // Debounced parsing for Blox files
    if (_isBloxFile) {
      _debounceParse();
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
                icon: const Icon(Icons.save),
                onPressed: _saveFile,
                tooltip: 'Save (Ctrl+S)',
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
                if (HardwareKeyboard.instance.isControlPressed &&
                    event.logicalKey == LogicalKeyboardKey.keyS) {
                  _saveFile();
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
      width: 60,
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
              return Container(
                height: actualLineHeight,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 8),
                child: Text(
                  '$lineNumber',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant.withOpacity(0.6),
                    fontFamily: 'monospace',
                    fontSize: fontSize,
                    height: lineHeight,
                  ),
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
