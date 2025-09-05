import 'package:flutter/material.dart';

/// A text field that supports rich text formatting and syntax highlighting
class SyntaxHighlightingTextField extends StatefulWidget {
  const SyntaxHighlightingTextField({
    required this.controller,
    super.key,
    this.style,
    this.decoration,
    this.maxLines,
    this.onChanged,
    this.focusNode,
    this.scrollController,
    this.syntaxHighlighter,
  });

  final TextEditingController controller;
  final TextStyle? style;
  final InputDecoration? decoration;
  final int? maxLines;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;
  final ScrollController? scrollController;
  final TextSpan Function(String text, TextStyle? baseStyle)? syntaxHighlighter;

  @override
  State<SyntaxHighlightingTextField> createState() =>
      _SyntaxHighlightingTextFieldState();
}

class _SyntaxHighlightingTextFieldState
    extends State<SyntaxHighlightingTextField> {
  late FocusNode _focusNode;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _scrollController = widget.scrollController ?? ScrollController();
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    if (widget.scrollController == null) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // If no syntax highlighter is provided, use regular TextField
    if (widget.syntaxHighlighter == null) {
      return TextField(
        controller: widget.controller,
        style: widget.style,
        decoration: widget.decoration,
        maxLines: widget.maxLines,
        onChanged: widget.onChanged,
        focusNode: _focusNode,
        scrollController: _scrollController,
      );
    }

    // Use a custom implementation with syntax highlighting
    return _buildSyntaxHighlightedField();
  }

  Widget _buildSyntaxHighlightedField() {
    return Stack(
      children: [
        // Syntax highlighted text (read-only, positioned behind)
        Positioned.fill(
          child: IgnorePointer(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              child: SingleChildScrollView(
                controller: _scrollController,
                child: SelectableText.rich(
                  widget.syntaxHighlighter!(
                    widget.controller.text,
                    widget.style,
                  ),
                  style: widget.style,
                ),
              ),
            ),
          ),
        ),
        // Transparent editable text field (on top)
        TextField(
          controller: widget.controller,
          style: widget.style?.copyWith(color: Colors.transparent),
          decoration: widget.decoration?.copyWith(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ) ??
              const InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
          maxLines: widget.maxLines,
          onChanged: (text) {
            setState(() {}); // Rebuild to update syntax highlighting
            widget.onChanged?.call(text);
          },
          focusNode: _focusNode,
          scrollController: _scrollController,
          cursorColor: Theme.of(context).colorScheme.primary,
        ),
      ],
    );
  }
}
