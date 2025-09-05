import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/features/explorer/presentation/providers/workspace_provider.dart';
import 'package:loom/features/explorer/presentation/widgets/collections_widget.dart';
import 'package:loom/features/explorer/presentation/widgets/create_project_dialog.dart';
import 'package:loom/features/explorer/presentation/widgets/file_tree_widget.dart';
import 'package:loom/features/explorer/presentation/widgets/workspace_toolbar.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Main explorer panel that contains both file system and collections view
class ExplorerPanel extends ConsumerWidget {
  const ExplorerPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
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
            ref.read(explorerViewModeProvider.notifier).setViewMode(mode);
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
      padding: const EdgeInsets.all(16),
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
                onTap: () => _showOpenFolderDialog(context, ref),
              ),
              const SizedBox(height: 12),
              _WelcomeAction(
                icon: LucideIcons.folderPlus,
                title: 'Create Project',
                subtitle: 'Create a new workspace',
                onTap: () => _showCreateProjectDialog(context, ref),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showOpenFolderDialog(BuildContext context, WidgetRef ref) {
    // TODO: Implement folder picker
    // For now, show a simple dialog
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Open Folder'),
        content: const Text('Folder picker will be implemented here'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Example: open current project directory
              ref
                  .read(currentWorkspaceProvider.notifier)
                  .openWorkspace('/workspaces/loom');
            },
            child: const Text('Open Current Project'),
          ),
        ],
      ),
    );
  }

  void _showCreateProjectDialog(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (context) => const CreateProjectDialog(),
    );
  }

  void _showNewFileDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New File'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'File name',
            hintText: 'example.md',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                // TODO: Create file
                Navigator.of(context).pop();
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showNewFolderDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Folder'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Folder name',
            hintText: 'new-folder',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                // TODO: Create folder
                Navigator.of(context).pop();
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
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.2),
            ),
            borderRadius: BorderRadius.circular(8),
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
