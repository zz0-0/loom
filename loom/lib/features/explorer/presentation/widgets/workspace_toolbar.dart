import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/features/explorer/domain/entities/workspace_entities.dart'
    as domain;
import 'package:loom/features/explorer/presentation/providers/workspace_provider.dart';
import 'package:loom/features/explorer/presentation/widgets/create_project_dialog.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Toolbar for the workspace explorer with view toggle and actions
class WorkspaceToolbar extends ConsumerWidget {
  const WorkspaceToolbar({
    required this.workspace,
    required this.viewMode,
    required this.onViewModeChanged,
    required this.onRefresh,
    required this.onNewFile,
    required this.onNewFolder,
    super.key,
  });

  final domain.Workspace workspace;
  final String viewMode;
  final ValueChanged<String> onViewModeChanged;
  final VoidCallback onRefresh;
  final VoidCallback onNewFile;
  final VoidCallback onNewFolder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final settings = ref.watch(workspaceSettingsProvider);

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.dividerColor,
          ),
        ),
      ),
      child: Column(
        children: [
          // Workspace name and view mode toggle
          Row(
            children: [
              Expanded(
                child: Text(
                  workspace.name.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurfaceVariant,
                    letterSpacing: 0.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              _ViewModeToggle(
                currentMode: viewMode,
                onModeChanged: onViewModeChanged,
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Action buttons
          Row(
            children: [
              Text(
                viewMode == 'filesystem' ? 'FILES' : 'COLLECTIONS',
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurfaceVariant,
                  letterSpacing: 0.5,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(LucideIcons.filePlus, size: 16),
                onPressed: onNewFile,
                splashRadius: 12,
                tooltip: 'New File',
              ),
              IconButton(
                icon: const Icon(LucideIcons.folderPlus, size: 16),
                onPressed: onNewFolder,
                splashRadius: 12,
                tooltip: 'New Folder',
              ),
              IconButton(
                icon: const Icon(LucideIcons.refreshCw, size: 16),
                onPressed: onRefresh,
                splashRadius: 12,
                tooltip: 'Refresh',
              ),
              _SettingsButton(settings: settings),
            ],
          ),
        ],
      ),
    );
  }
}

/// Toggle between file system and collections view
class _ViewModeToggle extends StatelessWidget {
  const _ViewModeToggle({
    required this.currentMode,
    required this.onModeChanged,
  });

  final String currentMode;
  final ValueChanged<String> onModeChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ToggleButton(
            icon: LucideIcons.folder,
            tooltip: 'File System',
            isSelected: currentMode == 'filesystem',
            onPressed: () => onModeChanged('filesystem'),
          ),
          _ToggleButton(
            icon: LucideIcons.star,
            tooltip: 'Collections',
            isSelected: currentMode == 'collections',
            onPressed: () => onModeChanged('collections'),
          ),
        ],
      ),
    );
  }
}

class _ToggleButton extends StatelessWidget {
  const _ToggleButton({
    required this.icon,
    required this.tooltip,
    required this.isSelected,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: isSelected
          ? theme.colorScheme.primary.withOpacity(0.12)
          : Colors.transparent,
      borderRadius: BorderRadius.circular(4),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          padding: const EdgeInsets.all(4),
          child: Icon(
            icon,
            size: 14,
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

/// Settings dropdown button
class _SettingsButton extends ConsumerWidget {
  const _SettingsButton({required this.settings});

  final domain.WorkspaceSettings settings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return PopupMenuButton<String>(
      icon: const Icon(LucideIcons.moreHorizontal, size: 16),
      iconSize: 16,
      splashRadius: 12,
      tooltip: 'Project Options',
      onSelected: (value) {
        switch (value) {
          case 'close_project':
            ref.read(currentWorkspaceProvider.notifier).closeWorkspace();
          case 'open_project':
            _showOpenProjectDialog(context, ref);
          case 'create_project':
            _showCreateProjectDialog(context, ref);
          case 'toggle_filter':
            ref
                .read(workspaceSettingsProvider.notifier)
                .toggleFileExtensionFilter();
          case 'toggle_hidden':
            ref
                .read(workspaceSettingsProvider.notifier)
                .toggleShowHiddenFiles();
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'close_project',
          child: Row(
            children: [
              Icon(
                LucideIcons.x,
                size: 16,
              ),
              SizedBox(width: 8),
              Text('Close Project'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'open_project',
          child: Row(
            children: [
              Icon(
                LucideIcons.folderOpen,
                size: 16,
              ),
              SizedBox(width: 8),
              Text('Open Project'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'create_project',
          child: Row(
            children: [
              Icon(
                LucideIcons.folderPlus,
                size: 16,
              ),
              SizedBox(width: 8),
              Text('Create Project'),
            ],
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          value: 'toggle_filter',
          child: Row(
            children: [
              Icon(
                settings.filterFileExtensions
                    ? LucideIcons.check
                    : LucideIcons.square,
                size: 16,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              const Text('Filter File Extensions'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'toggle_hidden',
          child: Row(
            children: [
              Icon(
                settings.showHiddenFiles
                    ? LucideIcons.check
                    : LucideIcons.square,
                size: 16,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              const Text('Show Hidden Files'),
            ],
          ),
        ),
      ],
    );
  }

  void _showOpenProjectDialog(BuildContext context, WidgetRef ref) {
    // TODO(user): Implement proper folder picker
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Open Project'),
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
}
