import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/github.dart';
import 'package:flutter_highlight/themes/vs2015.dart';
import 'package:loom/shared/presentation/widgets/editor/blox_syntax_highlighter.dart';
import 'package:path/path.dart' as path;

/// A syntax-highlighted code editor widget
class SyntaxHighlightedEditor extends StatefulWidget {
  const SyntaxHighlightedEditor({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    super.key,
    this.filePath,
    this.style,
    this.showLineNumbers = true,
    this.isDarkTheme = false,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onChanged;
  final String? filePath;
  final TextStyle? style;
  final bool showLineNumbers;
  final bool isDarkTheme;

  @override
  State<SyntaxHighlightedEditor> createState() =>
      _SyntaxHighlightedEditorState();
}

class _SyntaxHighlightedEditorState extends State<SyntaxHighlightedEditor> {
  late ScrollController _scrollController;
  late ScrollController _lineNumberScrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _lineNumberScrollController = ScrollController();

    // Sync scroll controllers
    _scrollController.addListener(_syncScrollControllers);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_syncScrollControllers)
      ..dispose();
    _lineNumberScrollController.dispose();
    super.dispose();
  }

  void _syncScrollControllers() {
    if (_lineNumberScrollController.hasClients) {
      _lineNumberScrollController.jumpTo(_scrollController.offset);
    }
  }

  String _getLanguageFromFilePath(String? filePath) {
    if (filePath == null) return 'plaintext';

    final extension = path.extension(filePath).toLowerCase();

    switch (extension) {
      case '.blox':
        return 'blox'; // Custom Blox language support
      case '.dart':
        return 'dart';
      case '.js':
      case '.jsx':
        return 'javascript';
      case '.ts':
      case '.tsx':
        return 'typescript';
      case '.py':
        return 'python';
      case '.java':
        return 'java';
      case '.cpp':
      case '.cc':
      case '.cxx':
        return 'cpp';
      case '.c':
        return 'c';
      case '.cs':
        return 'csharp';
      case '.go':
        return 'go';
      case '.rs':
        return 'rust';
      case '.php':
        return 'php';
      case '.rb':
        return 'ruby';
      case '.swift':
        return 'swift';
      case '.kt':
        return 'kotlin';
      case '.html':
      case '.htm':
        return 'xml';
      case '.css':
        return 'css';
      case '.scss':
        return 'scss';
      case '.json':
        return 'json';
      case '.yaml':
      case '.yml':
        return 'yaml';
      case '.xml':
        return 'xml';
      case '.md':
      case '.markdown':
        return 'markdown';
      case '.sql':
        return 'sql';
      case '.sh':
      case '.bash':
        return 'bash';
      case '.ps1':
        return 'powershell';
      case '.dockerfile':
        return 'dockerfile';
      default:
        return 'plaintext';
    }
  }

  List<String> _getLines(String text) {
    return text.isEmpty ? [''] : text.split('\n');
  }

  Widget _buildLineNumbers(List<String> lines) {
    final theme = Theme.of(context);
    final lineNumberStyle = widget.style?.copyWith(
          color: theme.colorScheme.onSurfaceVariant.withOpacity(0.6),
          fontSize: 14,
          fontFamily: 'monospace',
        ) ??
        TextStyle(
          color: theme.colorScheme.onSurfaceVariant.withOpacity(0.6),
          fontSize: 14,
          fontFamily: 'monospace',
        );

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
        controller: _lineNumberScrollController,
        child: Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: lines.asMap().entries.map((entry) {
              final lineNumber = entry.key + 1;
              return Container(
                height: 24, // Match line height
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 8),
                child: Text(
                  '$lineNumber',
                  style: lineNumberStyle,
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final language = _getLanguageFromFilePath(widget.filePath);
    final lines = _getLines(widget.controller.text);

    // Choose theme based on dark/light mode
    final highlightTheme = widget.isDarkTheme ? vs2015Theme : githubTheme;

    // Use custom Blox highlighter for .blox files
    if (language == 'blox') {
      return _buildBloxEditor(theme, lines);
    }

    return Row(
      children: [
        // Line numbers
        if (widget.showLineNumbers) _buildLineNumbers(lines),

        // Code editor
        Expanded(
          child: Stack(
            children: [
              // Syntax highlighted display
              SingleChildScrollView(
                controller: _scrollController,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 16,
                    bottom: 8,
                  ),
                  child: HighlightView(
                    widget.controller.text,
                    language: language,
                    theme: highlightTheme,
                    padding: EdgeInsets.zero,
                    textStyle: widget.style?.copyWith(
                          fontFamily: 'monospace',
                          fontSize: 14,
                          height: 1.5,
                        ) ??
                        TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 14,
                          height: 1.5,
                          color: theme.colorScheme.onSurface,
                        ),
                  ),
                ),
              ),

              // Invisible TextField for input handling
              SingleChildScrollView(
                controller: _scrollController,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 16,
                    bottom: 8,
                  ),
                  child: TextField(
                    controller: widget.controller,
                    focusNode: widget.focusNode,
                    maxLines: null,
                    style: widget.style?.copyWith(
                          fontFamily: 'monospace',
                          fontSize: 14,
                          height: 1.5,
                          color: Colors.transparent, // Make text invisible
                        ) ??
                        const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 14,
                          height: 1.5,
                          color: Colors.transparent,
                        ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    onChanged: (_) => widget.onChanged(),
                    cursorColor: theme.colorScheme.primary,
                    selectionControls: MaterialTextSelectionControls(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBloxEditor(ThemeData theme, List<String> lines) {
    final bloxController = BloxSyntaxHighlighter(text: widget.controller.text);
    bloxController.updateTheme(theme);

    return Row(
      children: [
        // Line numbers
        if (widget.showLineNumbers) _buildLineNumbers(lines),

        // Blox editor
        Expanded(
          child: Stack(
            children: [
              // Syntax highlighted display
              SingleChildScrollView(
                controller: _scrollController,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 16,
                    bottom: 8,
                  ),
                  child: SelectableText.rich(
                    bloxController.getHighlightedText(),
                    style: widget.style?.copyWith(
                          fontFamily: 'monospace',
                          fontSize: 14,
                          height: 1.5,
                        ) ??
                        TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 14,
                          height: 1.5,
                          color: theme.colorScheme.onSurface,
                        ),
                  ),
                ),
              ),

              // Invisible TextField for input handling
              SingleChildScrollView(
                controller: _scrollController,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 16,
                    bottom: 8,
                  ),
                  child: TextField(
                    controller: widget.controller,
                    focusNode: widget.focusNode,
                    maxLines: null,
                    style: widget.style?.copyWith(
                          fontFamily: 'monospace',
                          fontSize: 14,
                          height: 1.5,
                          color: Colors.transparent, // Make text invisible
                        ) ??
                        const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 14,
                          height: 1.5,
                          color: Colors.transparent,
                        ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    onChanged: (_) => widget.onChanged(),
                    cursorColor: theme.colorScheme.primary,
                    selectionControls: MaterialTextSelectionControls(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
