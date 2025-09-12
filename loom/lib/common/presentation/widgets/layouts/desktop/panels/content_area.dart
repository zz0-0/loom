import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/common/presentation/providers/theme_provider.dart';
import 'package:loom/features/core/explorer/presentation/providers/workspace_provider.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ContentArea extends ConsumerWidget {
  const ContentArea({
    super.key,
    this.openedFile,
  });
  final String? openedFile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
      ),
      child: Column(
        children: [
          // Tab bar
          if (openedFile != null)
            Container(
              height: 35,
              decoration: BoxDecoration(
                color:
                    theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
                border: Border(
                  bottom: BorderSide(
                    color: theme.dividerColor,
                  ),
                ),
              ),
              child: Row(
                children: [
                  _FileTab(
                    fileName: _getFileName(openedFile!),
                    filePath: openedFile!,
                    isActive: true,
                    onTap: () {
                      ref
                          .read(fileOpeningServiceProvider)
                          .openFile(openedFile!);
                    },
                    onClose: () {
                      // Close file
                      ref.read(fileOpeningServiceProvider).closeFile();
                    },
                  ),
                ],
              ),
            ),

          // Editor content
          Expanded(
            child: openedFile != null
                ? _EditorView(filePath: openedFile!)
                : _WelcomeView(),
          ),
        ],
      ),
    );
  }

  String _getFileName(String filePath) {
    return filePath.split('/').last;
  }
}

class _FileTab extends StatelessWidget {
  const _FileTab({
    required this.fileName,
    required this.filePath,
    this.isActive = false,
    this.onClose,
    this.onTap,
  });
  final String fileName;
  final String filePath;
  final bool isActive;
  final VoidCallback? onClose;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      constraints: const BoxConstraints(maxWidth: 200),
      decoration: BoxDecoration(
        color: isActive ? theme.colorScheme.surface : Colors.transparent,
        border: Border(
          right: BorderSide(
            color: theme.dividerColor,
          ),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getFileIcon(fileName),
                  size: 14,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    fileName,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isActive
                          ? theme.colorScheme.onSurface
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 6),
                InkWell(
                  onTap: onClose,
                  borderRadius: BorderRadius.circular(4),
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    child: Icon(
                      LucideIcons.x,
                      size: 12,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getFileIcon(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'dart':
        return LucideIcons.fileCode;
      case 'yaml':
      case 'yml':
        return LucideIcons.fileCode2;
      case 'json':
        return LucideIcons.braces;
      case 'md':
        return LucideIcons.fileText;
      default:
        return LucideIcons.file;
    }
  }
}

class _WelcomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer(
      builder: (context, ref, child) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              LucideIcons.book,
              size: 64,
              color: theme.colorScheme.primary.withOpacity(0.6),
            ),
            const SizedBox(height: 16),
            Text(
              'Welcome to Loom',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your next-generation knowledge base',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _WelcomeAction(
                  icon: LucideIcons.folderOpen,
                  title: 'Open Folder',
                  subtitle: 'Open an existing workspace',
                  onTap: () => _openFolder(context, ref),
                ),
                const SizedBox(width: 24),
                _WelcomeAction(
                  icon: LucideIcons.filePlus,
                  title: 'New File',
                  subtitle: 'Create a new document',
                  onTap: () => _createNewFile(context, ref),
                ),
                const SizedBox(width: 24),
                _WelcomeAction(
                  icon: LucideIcons.gitBranch,
                  title: 'Clone Repository',
                  subtitle: 'Clone from Git',
                  onTap: () => _cloneRepository(context, ref),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openFolder(BuildContext context, WidgetRef ref) async {
    try {
      final selectedDirectory = await FilePicker.platform.getDirectoryPath();

      if (selectedDirectory != null && selectedDirectory.isNotEmpty) {
        await ref
            .read(currentWorkspaceProvider.notifier)
            .openWorkspace(selectedDirectory);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Opened workspace: ${selectedDirectory.split('/').last}',
              ),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to open folder: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _createNewFile(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New File'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Enter file name (e.g., document.md)',
            suffixText: '.md',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final fileName = controller.text.trim();
              if (fileName.isNotEmpty) {
                Navigator.of(context).pop(fileName);
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );

    if (result != null && context.mounted) {
      final workspace = ref.read(currentWorkspaceProvider);
      if (workspace != null) {
        final fileName = result.endsWith('.md') ? result : '$result.md';
        final filePath = '${workspace.rootPath}/$fileName';

        try {
          await ref
              .read(currentWorkspaceProvider.notifier)
              .createFile(filePath);

          // Open the newly created file
          await ref.read(fileOpeningServiceProvider).openFile(filePath);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Created and opened: $fileName'),
              duration: const Duration(seconds: 2),
            ),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to create file: $e'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please open a workspace first'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  Future<void> _cloneRepository(BuildContext context, WidgetRef ref) async {
    final urlController = TextEditingController();
    final directoryController = TextEditingController();

    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clone Git Repository'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: urlController,
              decoration: const InputDecoration(
                labelText: 'Repository URL',
                hintText: 'https://github.com/user/repo.git',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: directoryController,
              decoration: const InputDecoration(
                labelText: 'Target Directory (optional)',
                hintText: 'Leave empty to use repository name',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final url = urlController.text.trim();
              final directory = directoryController.text.trim();
              if (url.isNotEmpty) {
                Navigator.of(context).pop({
                  'url': url,
                  'directory': directory.isEmpty ? null : directory,
                });
              }
            },
            child: const Text('Clone'),
          ),
        ],
      ),
    );

    if (result != null && context.mounted) {
      try {
        final url = result['url']!;
        final targetDir = result['directory'];

        // For now, show a message that Git clone is not fully implemented
        // In a real implementation, this would run: git clone <url> [directory]
        final message = targetDir != null
            ? 'Cloning from: $url to $targetDir'
            : 'Cloning from: $url';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            duration: const Duration(seconds: 2),
          ),
        );

        // TODO(user): Implement actual Git clone using Process.run
        // Example:
        // final result = await Process.run('git', ['clone', url, targetDir ?? '']);
        // if (result.exitCode == 0) {
        //   // Open the cloned directory as workspace
        //   final cloneDir = targetDir ?? url.split('/').last.replaceAll('.git', '');
        //   await ref.read(currentWorkspaceProvider.notifier).openWorkspace(cloneDir);
        // }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to clone repository: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }
}

class _WelcomeAction extends StatelessWidget {
  const _WelcomeAction({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 160,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.2),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 32,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EditorView extends StatelessWidget {
  const _EditorView({required this.filePath});
  final String filePath;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Editing: $filePath',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color:
                    theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: theme.colorScheme.outline.withOpacity(0.2),
                ),
              ),
              child: Text(
                'Editor content will be implemented here.\n\nThis is where your innovative knowledge base editing experience will live!',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
