import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/common/index.dart';
import 'package:loom/features/core/explorer/index.dart';
import 'package:loom/flutter_gen/gen_l10n/app_localizations.dart';
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
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.smd,
              vertical: AppSpacing.sm,
            ),
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
                    padding: AppSpacing.paddingSm,
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
    final localizations = AppLocalizations.of(context);

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
              localizations.welcomeToLoomTitle,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              localizations.yourNextGenerationKnowledgeBase,
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
                  title: localizations.openFolderTitle,
                  subtitle: localizations.openAnExistingWorkspace,
                  onTap: () => _openFolder(context, ref),
                ),
                const SizedBox(width: 24),
                _WelcomeAction(
                  icon: LucideIcons.filePlus,
                  title: localizations.newFileTitle,
                  subtitle: localizations.createANewDocument,
                  onTap: () => _createNewFile(context, ref),
                ),
                const SizedBox(width: 24),
                _WelcomeAction(
                  icon: LucideIcons.gitBranch,
                  title: localizations.cloneRepositoryTitle,
                  subtitle: localizations.cloneFromGit,
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
    final localizations = AppLocalizations.of(context);
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
                localizations
                    .openedWorkspace(selectedDirectory.split('/').last),
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
            content: Text(localizations.failedToOpenFolder(e.toString())),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _createNewFile(BuildContext context, WidgetRef ref) async {
    final localizations = AppLocalizations.of(context);
    final controller = TextEditingController();
    final theme = Theme.of(context);

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.createNewFile),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: localizations.enterFileNameHint,
            hintStyle: TextStyle(
              color: theme.colorScheme.onSurface.withOpacity(0.4),
            ),
            suffixText: '.md',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(localizations.cancel),
          ),
          TextButton(
            onPressed: () {
              final fileName = controller.text.trim();
              if (fileName.isNotEmpty) {
                Navigator.of(context).pop(fileName);
              }
            },
            child: Text(localizations.create),
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

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(localizations.createdAndOpenedFile(fileName)),
                duration: const Duration(seconds: 2),
              ),
            );
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(localizations.failedToCreateFolder(e.toString())),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localizations.pleaseOpenWorkspaceFirst),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  Future<void> _cloneRepository(BuildContext context, WidgetRef ref) async {
    final localizations = AppLocalizations.of(context);
    final urlController = TextEditingController();
    final directoryController = TextEditingController();
    final theme = Theme.of(context);

    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.cloneRepositoryTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: urlController,
              decoration: InputDecoration(
                labelText: localizations.repositoryUrl,
                hintText: localizations.enterGitRepositoryUrl,
                hintStyle: TextStyle(
                  color: theme.colorScheme.onSurface.withOpacity(0.4),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: directoryController,
              decoration: InputDecoration(
                labelText: localizations.targetDirectoryOptional,
                hintText: localizations.leaveEmptyToUseRepositoryName,
                hintStyle: TextStyle(
                  color: theme.colorScheme.onSurface.withOpacity(0.4),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(localizations.cancel),
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
            child: Text(localizations.create),
          ),
        ],
      ),
    );

    if (result != null && context.mounted) {
      try {
        final url = result['url']!;
        final targetDir = result['directory'];

        // Show loading indicator
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localizations.cloningRepository),
            duration: const Duration(seconds: 1),
          ),
        );

        // Implement actual Git clone using Process.run
        final cloneArgs = targetDir != null ? [url, targetDir] : [url];
        final process = await Process.run('git', ['clone', ...cloneArgs]);

        if (process.exitCode == 0) {
          // Determine the cloned directory name
          final cloneDir =
              targetDir ?? url.split('/').last.replaceAll('.git', '');
          final fullClonePath = targetDir ?? cloneDir;

          // Open the cloned directory as workspace
          await ref
              .read(currentWorkspaceProvider.notifier)
              .openWorkspace(fullClonePath);

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    localizations.successfullyClonedRepository(fullClonePath),),
                duration: const Duration(seconds: 3),
              ),
            );
          }
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(localizations
                    .failedToCloneRepository(process.stderr.toString()),),
                backgroundColor: Theme.of(context).colorScheme.error,
                duration: const Duration(seconds: 5),
              ),
            );
          }
        }
      } catch (e) {
        if (context.mounted) {
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
          padding: AppSpacing.paddingMd,
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
    final localizations = AppLocalizations.of(context);

    return Container(
      padding: AppSpacing.paddingMd,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations.editingFile(filePath),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: AppSpacing.paddingMd,
              decoration: BoxDecoration(
                color:
                    theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: theme.colorScheme.outline.withOpacity(0.2),
                ),
              ),
              child: Text(
                localizations.editorContentPlaceholder,
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
