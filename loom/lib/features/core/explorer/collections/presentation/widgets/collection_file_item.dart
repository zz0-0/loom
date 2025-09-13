import 'package:flutter/material.dart';
import 'package:loom/common/index.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:path/path.dart' as path;

/// Individual file item within a collection
class CollectionFileItem extends StatelessWidget {
  const CollectionFileItem({
    required this.filePath,
    required this.onSelected,
    required this.onRemove,
    required this.collectionName,
    required this.onFileMoved,
    super.key,
  });

  final String filePath;
  final VoidCallback onSelected;
  final VoidCallback onRemove;
  final String collectionName;
  final ValueChanged<String>
      onFileMoved; // Called when file is moved to another collection

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fileName = path.basename(filePath);

    return Draggable<Map<String, String>>(
      data: {
        'filePath': filePath,
        'sourceCollection': collectionName,
      },
      feedback: Material(
        elevation: 4,
        borderRadius: AppRadius.radiusSm,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          constraints: const BoxConstraints(maxWidth: 200),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: AppRadius.radiusSm,
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.5),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _getFileIcon(fileName),
                size: 14,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  fileName,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.5,
        child: _buildFileItem(context, theme, fileName),
      ),
      child: _buildFileItem(context, theme, fileName),
    );
  }

  Widget _buildFileItem(
    BuildContext context,
    ThemeData theme,
    String fileName,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onSelected,
        child: Container(
          padding: const EdgeInsets.only(
            left: AppSpacing.xl,
            right: AppSpacing.sm,
            top: AppSpacing.xs,
            bottom: AppSpacing.xs,
          ),
          child: Row(
            children: [
              Icon(
                _getFileIcon(fileName),
                size: 14,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  fileName,
                  style: theme.textTheme.bodySmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: const Icon(LucideIcons.x, size: 12),
                onPressed: onRemove,
                splashRadius: 8,
                tooltip: 'Remove from collection',
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getFileIcon(String fileName) {
    final extension = path.extension(fileName).toLowerCase();
    switch (extension) {
      case '.md':
      case '.markdown':
        return LucideIcons.fileText;
      case '.blox':
        return LucideIcons.box;
      case '.txt':
        return LucideIcons.fileText;
      case '.json':
        return LucideIcons.braces;
      case '.yaml':
      case '.yml':
        return LucideIcons.fileCode2;
      case '.dart':
        return LucideIcons.fileCode;
      default:
        return LucideIcons.file;
    }
  }
}
