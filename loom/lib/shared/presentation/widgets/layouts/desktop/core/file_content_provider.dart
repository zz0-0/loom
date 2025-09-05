import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/shared/presentation/providers/tab_provider.dart';
import 'package:loom/shared/presentation/widgets/layouts/desktop/core/ui_registry.dart';

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

/// File editor widget that displays file content
class FileEditor extends ConsumerStatefulWidget {
  const FileEditor({super.key});

  @override
  ConsumerState<FileEditor> createState() => _FileEditorState();
}

class _FileEditorState extends ConsumerState<FileEditor> {
  final TextEditingController _controller = TextEditingController();
  String? _currentFilePath;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadCurrentFile();
  }

  @override
  void didUpdateWidget(FileEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    _loadCurrentFile();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _loadCurrentFile() {
    final tabState = ref.read(tabProvider);
    final activeTab = tabState.activeTab;

    if (activeTab != null && activeTab.contentType == 'file') {
      final filePath = activeTab.id;

      // Only reload if the file path has changed
      if (_currentFilePath != filePath) {
        _currentFilePath = filePath;
        _loadFileContent(filePath);
      }
    } else {
      // Clear current file if no valid tab is selected
      _currentFilePath = null;
      _controller.clear();
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
      final file = File(filePath);
      if (file.existsSync()) {
        final content = await file.readAsString();
        _controller.text = content;
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

  Future<void> _saveFile() async {
    if (_currentFilePath == null) return;

    try {
      final file = File(_currentFilePath!);
      await file.writeAsString(_controller.text);

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

  void _onTextChanged(String value) {
    if (_currentFilePath != null) {
      // Mark tab as dirty when content changes
      ref
          .read(tabProvider.notifier)
          .updateTab(_currentFilePath!, isDirty: true);
    }
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
              const Spacer(),
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
          child: KeyboardListener(
            focusNode: FocusNode(),
            onKeyEvent: (event) {
              if (HardwareKeyboard.instance.isControlPressed &&
                  event.logicalKey == LogicalKeyboardKey.keyS) {
                _saveFile();
              }
            },
            child: TextField(
              controller: _controller,
              maxLines: null,
              expands: true,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontFamily: 'monospace',
                fontSize: 14,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(16),
              ),
              onChanged: _onTextChanged,
            ),
          ),
        ),
      ],
    );
  }
}
