import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A dialog for find and replace functionality
class FindReplaceDialog extends StatefulWidget {
  const FindReplaceDialog({
    required this.onFind,
    required this.onReplace,
    required this.onReplaceAll,
    super.key,
    this.initialSearchText = '',
  });

  final void Function(String text, bool caseSensitive, bool useRegex) onFind;
  final void Function(
    String findText,
    String replaceText,
    bool caseSensitive,
    bool useRegex,
  ) onReplace;
  final void Function(
    String findText,
    String replaceText,
    bool caseSensitive,
    bool useRegex,
  ) onReplaceAll;
  final String initialSearchText;

  @override
  State<FindReplaceDialog> createState() => _FindReplaceDialogState();
}

class _FindReplaceDialogState extends State<FindReplaceDialog> {
  final TextEditingController _findController = TextEditingController();
  final TextEditingController _replaceController = TextEditingController();
  final FocusNode _findFocusNode = FocusNode();

  bool _caseSensitive = false;
  bool _useRegex = false;
  bool _showReplace = false;

  @override
  void initState() {
    super.initState();
    _findController.text = widget.initialSearchText;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _findFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _findController.dispose();
    _replaceController.dispose();
    _findFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      child: Container(
        width: 450,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Text(
                  _showReplace ? 'Find & Replace' : 'Find',
                  style: theme.textTheme.titleLarge,
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(_showReplace ? Icons.search : Icons.find_replace),
                  onPressed: () => setState(() => _showReplace = !_showReplace),
                  tooltip: _showReplace ? 'Hide Replace' : 'Show Replace',
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Find field
            TextField(
              controller: _findController,
              focusNode: _findFocusNode,
              decoration: const InputDecoration(
                labelText: 'Find',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onSubmitted: (_) => _performFind(),
            ),

            // Replace field (if visible)
            if (_showReplace) ...[
              const SizedBox(height: 12),
              TextField(
                controller: _replaceController,
                decoration: const InputDecoration(
                  labelText: 'Replace with',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.find_replace),
                ),
                onSubmitted: (_) => _performReplace(),
              ),
            ],

            const SizedBox(height: 16),

            // Options
            Wrap(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Checkbox(
                      value: _caseSensitive,
                      onChanged: (value) =>
                          setState(() => _caseSensitive = value ?? false),
                    ),
                    const Text('Match case'),
                  ],
                ),
                const SizedBox(width: 16),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Checkbox(
                      value: _useRegex,
                      onChanged: (value) =>
                          setState(() => _useRegex = value ?? false),
                    ),
                    const Text('Use regex'),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Buttons
            Wrap(
              alignment: WrapAlignment.end,
              spacing: 8,
              children: [
                if (_showReplace) ...[
                  TextButton(
                    onPressed: _performReplace,
                    child: const Text('Replace'),
                  ),
                  TextButton(
                    onPressed: _performReplaceAll,
                    child: const Text('Replace All'),
                  ),
                ],
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close'),
                ),
                ElevatedButton(
                  onPressed: _performFind,
                  child: const Text('Find Next'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _performFind() {
    final searchText = _findController.text;
    if (searchText.isNotEmpty) {
      widget.onFind(searchText, _caseSensitive, _useRegex);
    }
  }

  void _performReplace() {
    final findText = _findController.text;
    final replaceText = _replaceController.text;
    if (findText.isNotEmpty) {
      widget.onReplace(findText, replaceText, _caseSensitive, _useRegex);
    }
  }

  void _performReplaceAll() {
    final findText = _findController.text;
    final replaceText = _replaceController.text;
    if (findText.isNotEmpty) {
      widget.onReplaceAll(findText, replaceText, _caseSensitive, _useRegex);
    }
  }
}

/// Keyboard shortcut helper for find/replace
class FindReplaceShortcuts extends StatelessWidget {
  const FindReplaceShortcuts({
    required this.child,
    required this.onFind,
    required this.onReplace,
    super.key,
  });

  final Widget child;
  final VoidCallback onFind;
  final VoidCallback onReplace;

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyF):
            const _FindIntent(),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyH):
            const _ReplaceIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          _FindIntent: CallbackAction<_FindIntent>(onInvoke: (_) => onFind()),
          _ReplaceIntent:
              CallbackAction<_ReplaceIntent>(onInvoke: (_) => onReplace()),
        },
        child: child,
      ),
    );
  }
}

class _FindIntent extends Intent {
  const _FindIntent();
}

class _ReplaceIntent extends Intent {
  const _ReplaceIntent();
}
