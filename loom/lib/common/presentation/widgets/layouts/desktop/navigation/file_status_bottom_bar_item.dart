import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/common/presentation/providers/editor_state_provider.dart';
import 'package:loom/common/presentation/widgets/layouts/desktop/core/bottom_bar_registry.dart';
import 'package:path/path.dart' as path;

/// File status item for the bottom bar that shows current file information
class FileStatusBottomBarItem implements BottomBarItem {
  const FileStatusBottomBarItem();

  @override
  String get id => 'file_status';

  @override
  int get priority => 2;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return _buildContent(context, ref);
      },
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final editorState = ref.watch(editorStateProvider);

    if (editorState.filePath == null) {
      return const SizedBox.shrink();
    }

    final filePath = editorState.filePath!;
    final fileExtension = path.extension(filePath).toLowerCase();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // File type icon
          Icon(
            _getFileIcon(fileExtension),
            size: 14,
            // color: _getFileColor(fileExtension, theme),
          ),
          const SizedBox(width: 4),

          // File type badge
          Text(
            fileExtension.isNotEmpty
                ? fileExtension
                : _getFileTypeLabel(fileExtension),
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              // color: _getFileColor(fileExtension, theme),
            ),
          ),

          const SizedBox(width: 8),

          // File name
          // Text(
          //   fileName,
          //   style: theme.textTheme.bodySmall?.copyWith(
          //     fontWeight: FontWeight.w500,
          //   ),
          // ),

          // Dirty indicator
          // if (isDirty) ...[
          //   const SizedBox(width: 4),
          //   Icon(
          //     Icons.circle,
          //     size: 6,
          //     color: theme.colorScheme.primary,
          //   ),
          // ],
        ],
      ),
    );
  }

  IconData _getFileIcon(String extension) {
    switch (extension) {
      case '.blox':
        return Icons.article_outlined;
      case '.md':
      case '.markdown':
        return Icons.description_outlined;
      case '.txt':
        return Icons.text_snippet_outlined;
      case '.json':
        return Icons.data_object_outlined;
      case '.yaml':
      case '.yml':
        return Icons.code_outlined;
      case '.dart':
        return Icons.flutter_dash_outlined;
      case '.js':
      case '.ts':
        return Icons.code_outlined;
      case '.py':
        return Icons.code_outlined;
      case '.html':
      case '.css':
        return Icons.web_outlined;
      default:
        return Icons.insert_drive_file_outlined;
    }
  }

  Color _getFileColor(String extension, ThemeData theme) {
    switch (extension) {
      case '.blox':
        return theme.colorScheme.primary;
      case '.md':
      case '.markdown':
        return Colors.blue;
      case '.txt':
        return theme.colorScheme.onSurfaceVariant;
      case '.json':
        return Colors.orange;
      case '.yaml':
      case '.yml':
        return Colors.purple;
      case '.dart':
        return Colors.blue;
      case '.js':
      case '.ts':
        return Colors.yellow;
      case '.py':
        return Colors.green;
      case '.html':
      case '.css':
        return Colors.red;
      default:
        return theme.colorScheme.onSurfaceVariant;
    }
  }

  String _getFileTypeLabel(String extension) {
    switch (extension) {
      case '.blox':
        return 'Blox';
      case '.md':
      case '.markdown':
        return 'Markdown';
      case '.txt':
        return 'Text';
      case '.json':
        return 'JSON';
      case '.yaml':
      case '.yml':
        return 'YAML';
      case '.dart':
        return 'Dart';
      case '.js':
        return 'JavaScript';
      case '.ts':
        return 'TypeScript';
      case '.py':
        return 'Python';
      case '.html':
        return 'HTML';
      case '.css':
        return 'CSS';
      default:
        return extension.substring(1).toUpperCase();
    }
  }
}

/// Cursor position item for the bottom bar
class CursorPositionBottomBarItem implements BottomBarItem {
  const CursorPositionBottomBarItem();

  @override
  String get id => 'cursor_position';

  @override
  int get priority => 50;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return _buildContent(context, ref);
      },
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final editorState = ref.watch(editorStateProvider);

    if (editorState.filePath == null) {
      return const SizedBox.shrink();
    }

    // TODO(user): Get actual cursor position from the text controller
    // For now, we'll show the stored cursor position
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Text(
        editorState.cursorPosition.toString(),
        style: theme.textTheme.bodySmall,
      ),
    );
  }
}

/// Blox document info item for the bottom bar
class BloxDocumentInfoBottomBarItem implements BottomBarItem {
  const BloxDocumentInfoBottomBarItem();

  @override
  String get id => 'blox_info';

  @override
  int get priority => 51;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return _buildContent(context, ref);
      },
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final editorState = ref.watch(editorStateProvider);

    if (!editorState.isBloxFile || editorState.filePath == null) {
      return const SizedBox.shrink();
    }

    final blockCount = editorState.parsedDocument?.blocks.length ?? 0;
    final hasWarnings = editorState.syntaxWarnings.isNotEmpty;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.article,
            size: 14,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 4),
          Text(
            '$blockCount blocks',
            style: theme.textTheme.bodySmall,
          ),
          if (hasWarnings) ...[
            const SizedBox(width: 8),
            const Icon(
              Icons.warning,
              size: 14,
              color: Colors.orange,
            ),
            const SizedBox(width: 2),
            Text(
              '${editorState.syntaxWarnings.length}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.orange,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
