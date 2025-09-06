import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loom/shared/presentation/theme/app_animations.dart';

/// Dialog for navigating to a specific line or block in the editor
class GoToLineDialog extends StatefulWidget {
  const GoToLineDialog({
    required this.controller,
    required this.onGoToLine,
    super.key,
    this.maxLines,
  });

  final TextEditingController controller;
  final void Function(int lineNumber) onGoToLine;
  final int? maxLines;

  @override
  State<GoToLineDialog> createState() => _GoToLineDialogState();
}

class _GoToLineDialogState extends State<GoToLineDialog> {
  final TextEditingController _lineController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _lineController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleGoToLine() {
    final text = _lineController.text.trim();
    if (text.isEmpty) {
      setState(() => _errorText = 'Please enter a line number');
      return;
    }

    final lineNumber = int.tryParse(text);
    if (lineNumber == null) {
      setState(() => _errorText = 'Invalid line number');
      return;
    }

    if (lineNumber < 1) {
      setState(() => _errorText = 'Line number must be greater than 0');
      return;
    }

    final maxLines = widget.maxLines ?? _getMaxLines();
    if (lineNumber > maxLines) {
      setState(() => _errorText = 'Line number exceeds maximum ($maxLines)');
      return;
    }

    widget.onGoToLine(lineNumber);
    Navigator.of(context).pop();
  }

  int _getMaxLines() {
    final text = widget.controller.text;
    if (text.isEmpty) return 1;
    return text.split('\n').length;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final maxLines = widget.maxLines ?? _getMaxLines();

    return AlertDialog(
      title: const Text('Go to Line'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _lineController,
            focusNode: _focusNode,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              labelText: 'Line number (1 - $maxLines)',
              hintText: 'Enter line number',
              errorText: _errorText,
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.format_list_numbered),
            ),
            onSubmitted: (_) => _handleGoToLine(),
            onChanged: (_) {
              if (_errorText != null) {
                setState(() => _errorText = null);
              }
            },
          ),
          const SizedBox(height: 8),
          Text(
            'Total lines: $maxLines',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ).withHoverAnimation(),
        FilledButton(
          onPressed: _handleGoToLine,
          child: const Text('Go to Line'),
        ).withHoverAnimation().withPressAnimation(),
      ],
    );
  }
}

/// Shows the Go to Line dialog
Future<void> showGoToLineDialog({
  required BuildContext context,
  required TextEditingController controller,
  required void Function(int lineNumber) onGoToLine,
  int? maxLines,
}) {
  return showDialog(
    context: context,
    builder: (context) => GoToLineDialog(
      controller: controller,
      onGoToLine: onGoToLine,
      maxLines: maxLines,
    ),
  );
}
