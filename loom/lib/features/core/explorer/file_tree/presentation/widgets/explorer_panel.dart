import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/common/index.dart';
import 'package:loom/features/core/explorer/index.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:path/path.dart' as path;

/// Main explorer panel that contains both file system and collections view
class ExplorerPanel extends ConsumerWidget {
  const ExplorerPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewMode = ref.watch(explorerViewModeProvider);
    final workspace = ref.watch(currentWorkspaceProvider);

    if (workspace == null) {
      return _buildWelcomeView(context, ref);
    }

    return Column(
      children: [
        // Toolbar with view mode toggle and actions
        WorkspaceToolbar(
          workspace: workspace,
          viewMode: viewMode,
          onViewModeChanged: (String mode) {
            ref.read(explorerViewModeProvider.notifier).state = mode;
          },
          onRefresh: () {
            ref.read(currentWorkspaceProvider.notifier).refreshFileTree();
          },
          onNewFile: () => _showNewFileDialog(context, ref),
          onNewFolder: () => _showNewFolderDialog(context, ref),
        ),

        // Content based on view mode
        Expanded(
          child: switch (viewMode) {
            'filesystem' => FileTreeWidget(workspace: workspace),
            'collections' => CollectionsWidget(workspace: workspace),
            _ => FileTreeWidget(workspace: workspace),
          },
        ),
      ],
    );
  }

  Widget _buildWelcomeView(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: AppSpacing.paddingMd,
      child: Column(
        children: [
          Icon(
            LucideIcons.folderOpen,
            size: 48,
            color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No Workspace Open',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Open a folder to start exploring files',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Column(
            children: [
              _WelcomeAction(
                icon: LucideIcons.folderOpen,
                title: 'Open Folder',
                subtitle: 'Open an existing workspace',
                onTap: () => ref
                    .read(currentFolderProvider.notifier)
                    .openFolder(context),
              ),
              const SizedBox(height: 12),
              _WelcomeAction(
                icon: LucideIcons.folderPlus,
                title: 'Create Folder',
                subtitle: 'Create a new workspace',
                onTap: () => ref
                    .read(currentFolderProvider.notifier)
                    .createFolder(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Future<void> _showOpenFolderDialog(
  //   BuildContext context,
  //   WidgetRef ref,
  // ) async {
  //   try {
  //     // Skip FilePicker in containerized environments and go straight to fallback
  //     if (!context.mounted) return;

  //     final selectedDirectory = await showDialog<String>(
  //       context: context,
  //       builder: (context) => const FolderBrowserDialog(
  //         initialPath: '/workspaces',
  //       ),
  //     );

  //     if (selectedDirectory != null && selectedDirectory.isNotEmpty) {
  //       await ref
  //           .read(currentWorkspaceProvider.notifier)
  //           .openWorkspace(selectedDirectory);
  //     }
  //   } catch (e) {
  //     if (context.mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('Failed to open folder: $e'),
  //           backgroundColor: Theme.of(context).colorScheme.error,
  //         ),
  //       );
  //     }
  //   }
  // }

  // void _showCreateFolderDialog(BuildContext context, WidgetRef ref) {
  //   showDialog<void>(
  //     context: context,
  //     builder: (context) => const CreateFolderDialog(),
  //   );
  // }

  void _showNewFileDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    final workspace = ref.read(currentWorkspaceProvider);
    final theme = Theme.of(context);

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New File'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: 'File name',
            hintText: 'Enter file name (e.g., example.blox)',
            hintStyle: TextStyle(
              color: theme.colorScheme.onSurface.withOpacity(0.4),
            ),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final fileName = controller.text.trim();

              if (fileName.isNotEmpty && workspace != null) {
                // Input validation
                if (fileName.isEmpty || fileName.length > 255) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Invalid file name')),
                  );
                  return;
                }

                // Prevent directory traversal
                if (fileName.contains('..') ||
                    fileName.contains('/') ||
                    fileName.contains(r'\')) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Invalid characters in file name'),
                    ),
                  );
                  return;
                }

                try {
                  final filePath = path.join(workspace.rootPath, fileName);

                  // Use repository through use case for security validation
                  final createFileUseCase =
                      ref.read(workspaceCreateFileUseCaseProvider);
                  await createFileUseCase.call(workspace.rootPath, filePath);

                  // Refresh the file tree
                  await ref
                      .read(currentWorkspaceProvider.notifier)
                      .refreshFileTree();

                  if (context.mounted) {
                    Navigator.of(context).pop();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('File "$fileName" created')),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to create file: $e'),
                        backgroundColor: Theme.of(context).colorScheme.error,
                      ),
                    );
                  }
                }
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  // void _showCreateWorkspaceDialog(BuildContext context, WidgetRef ref) {
  //   showDialog<void>(
  //     context: context,
  //     builder: (context) => const CreateProjectDialog(),
  //   );
  // }

  void _showNewFolderDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    final workspace = ref.read(currentWorkspaceProvider);
    final theme = Theme.of(context);

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Folder'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: 'Folder name',
            hintText: 'new-folder',
            hintStyle: TextStyle(
              color: theme.colorScheme.onSurface.withOpacity(0.4),
            ),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (controller.text.isNotEmpty && workspace != null) {
                final folderName = controller.text.trim();

                // Input validation
                if (folderName.isEmpty || folderName.length > 255) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Invalid folder name')),
                  );
                  return;
                }

                // Prevent directory traversal
                if (folderName.contains('..') ||
                    folderName.contains('/') ||
                    folderName.contains(r'\')) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Invalid characters in folder name'),
                    ),
                  );
                  return;
                }

                try {
                  final folderPath = path.join(workspace.rootPath, folderName);

                  // Use repository through use case for security validation
                  final createDirectoryUseCase =
                      ref.read(workspaceCreateDirectoryUseCaseProvider);
                  await createDirectoryUseCase.call(
                    workspace.rootPath,
                    folderPath,
                  );

                  // Refresh the file tree
                  await ref
                      .read(currentWorkspaceProvider.notifier)
                      .refreshFileTree();

                  if (context.mounted) {
                    Navigator.of(context).pop();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Folder "$folderName" created')),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to create folder: $e'),
                        backgroundColor: Theme.of(context).colorScheme.error,
                      ),
                    );
                  }
                }
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}

class _WelcomeAction extends StatelessWidget {
  const _WelcomeAction({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.radiusLg,
        child: Container(
          width: double.infinity,
          padding: AppSpacing.paddingMd,
          decoration: BoxDecoration(
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.2),
            ),
            borderRadius: AppRadius.radiusLg,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
