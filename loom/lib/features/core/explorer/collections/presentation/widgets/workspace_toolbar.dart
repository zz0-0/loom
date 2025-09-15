import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/common/index.dart';
import 'package:loom/features/core/explorer/index.dart';
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

  final Workspace workspace;
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
      padding: AppSpacing.paddingSm,
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
          LayoutBuilder(
            builder: (context, constraints) {
              final actions = _getToolbarActions(settings);
              final layout =
                  _calculateToolbarLayout(actions, constraints.maxWidth);

              return Row(
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
                  // Visible actions
                  ...layout.visibleActions
                      .map((action) => action.build(context)),
                  // Combined overflow menu with settings
                  _CombinedOverflowMenu(
                    overflowActions: layout.overflowActions,
                    settings: settings,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  List<_ToolbarAction> _getToolbarActions(WorkspaceSettings settings) {
    return [
      _ToolbarAction(
        key: 'new_file',
        icon: LucideIcons.filePlus,
        tooltip: 'New File',
        onPressed: onNewFile,
      ),
      _ToolbarAction(
        key: 'new_folder',
        icon: LucideIcons.folderPlus,
        tooltip: 'New Folder',
        onPressed: onNewFolder,
      ),
      _ToolbarAction(
        key: 'refresh',
        icon: LucideIcons.refreshCw,
        tooltip: 'Refresh',
        onPressed: onRefresh,
      ),
    ];
  }

  _ToolbarLayout _calculateToolbarLayout(
    List<_ToolbarAction> actions,
    double availableWidth,
  ) {
    const overflowMenuWidth = 40.0; // Space for overflow menu
    const textLabelWidth =
        60.0; // Approximate width for "FILES" or "COLLECTIONS" text
    final effectiveWidth = availableWidth - textLabelWidth - overflowMenuWidth;

    final visibleActions = <_ToolbarAction>[];
    final overflowActions = <_ToolbarAction>[];
    var usedWidth = 0.0;

    for (final action in actions) {
      final actionWidth = action.estimatedWidth;
      if (usedWidth + actionWidth <= effectiveWidth || visibleActions.isEmpty) {
        visibleActions.add(action);
        usedWidth += actionWidth;
      } else {
        overflowActions.add(action);
      }
    }

    return _ToolbarLayout(visibleActions, overflowActions);
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
        borderRadius: AppRadius.radiusSm,
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

    return AnimatedContainer(
      duration: AppAnimations.fast,
      curve: AppAnimations.scaleCurve,
      decoration: BoxDecoration(
        color: isSelected
            ? theme.colorScheme.primary.withOpacity(0.12)
            : Colors.transparent,
        borderRadius: AppRadius.radiusSm,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: AppRadius.radiusSm,
        child: InkWell(
          onTap: onPressed,
          borderRadius: AppRadius.radiusSm,
          child: AnimatedContainer(
            duration: AppAnimations.fast,
            curve: AppAnimations.scaleCurve,
            padding: AppSpacing.paddingSm,
            child: AnimatedScale(
              scale: isSelected ? 1.1 : 1.0,
              duration: AppAnimations.fast,
              curve: AppAnimations.scaleCurve,
              child: Icon(
                icon,
                size: 14,
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ),
    ).withHoverAnimation();
  }
}

/// Toolbar action data class
class _ToolbarAction {
  const _ToolbarAction({
    required this.key,
    this.icon,
    this.tooltip,
    this.onPressed,
    this.child,
  }) : assert(
          icon != null || child != null,
          'Either icon or child must be provided',
        );

  final String key;
  final IconData? icon;
  final String? tooltip;
  final VoidCallback? onPressed;
  final Widget? child;

  double get estimatedWidth {
    if (child != null) {
      // Settings button is typically wider
      return 32;
    }
    // Icon buttons are typically 32-40 pixels wide
    return 32;
  }

  Widget build(BuildContext context) {
    if (child != null) {
      return child!;
    }

    return IconButton(
      icon: Icon(icon, size: 16),
      onPressed: onPressed,
      splashRadius: 12,
      tooltip: tooltip,
    ).withHoverAnimation().withPressAnimation();
  }
}

/// Toolbar layout result
class _ToolbarLayout {
  const _ToolbarLayout(this.visibleActions, this.overflowActions);

  final List<_ToolbarAction> visibleActions;
  final List<_ToolbarAction> overflowActions;
}

/// Combined overflow menu with toolbar actions and settings
class _CombinedOverflowMenu extends ConsumerWidget {
  const _CombinedOverflowMenu({
    required this.overflowActions,
    required this.settings,
  });

  final List<_ToolbarAction> overflowActions;
  final WorkspaceSettings settings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, size: 16),
      splashRadius: 12,
      tooltip: 'More actions',
      onSelected: (value) {
        // Handle overflowed toolbar actions
        final action = overflowActions.firstWhere(
          (a) => a.key == value,
          orElse: () =>
              _ToolbarAction(key: '', icon: Icons.error, onPressed: () {}),
        );
        if (action.key.isNotEmpty && action.onPressed != null) {
          action.onPressed!();
          return;
        }

        // Handle settings actions
        switch (value) {
          case 'close_folder':
            ref.read(currentWorkspaceProvider.notifier).closeWorkspace();
          case 'open_folder':
            ref.read(currentFolderProvider.notifier).openFolder(context);
          case 'create_folder':
            ref.read(currentFolderProvider.notifier).createFolder(context);
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
      itemBuilder: (context) {
        final items = <PopupMenuEntry<String>>[];

        // Add overflowed toolbar actions
        if (overflowActions.isNotEmpty) {
          for (final action in overflowActions) {
            items.add(
              PopupMenuItem<String>(
                value: action.key,
                child: Row(
                  children: [
                    if (action.icon != null) Icon(action.icon, size: 16),
                    if (action.icon != null) const SizedBox(width: 8),
                    Text(action.tooltip ?? action.key),
                  ],
                ),
              ),
            );
          }
          items.add(const PopupMenuDivider());
        }

        // Add settings options
        items.addAll([
          const PopupMenuItem(
            value: 'close_folder',
            child: Row(
              children: [
                Icon(
                  LucideIcons.x,
                  size: 16,
                ),
                SizedBox(width: 8),
                Text('Close Folder'),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'open_folder',
            child: Row(
              children: [
                Icon(
                  LucideIcons.folderOpen,
                  size: 16,
                ),
                SizedBox(width: 8),
                Text('Open Folder'),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'create_folder',
            child: Row(
              children: [
                Icon(
                  LucideIcons.folderPlus,
                  size: 16,
                ),
                SizedBox(width: 8),
                Text('Create Folder'),
              ],
            ),
          ),
          const PopupMenuDivider(),
          PopupMenuItem(
            value: 'toggle_filter',
            child: Row(
              children: [
                AnimatedSwitcher(
                  duration: AppAnimations.fast,
                  child: Icon(
                    settings.filterFileExtensions
                        ? LucideIcons.check
                        : LucideIcons.square,
                    size: 16,
                    color: theme.colorScheme.onSurfaceVariant,
                    key: ValueKey(settings.filterFileExtensions),
                  ),
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
                AnimatedSwitcher(
                  duration: AppAnimations.fast,
                  child: Icon(
                    settings.showHiddenFiles
                        ? LucideIcons.check
                        : LucideIcons.square,
                    size: 16,
                    color: theme.colorScheme.onSurfaceVariant,
                    key: ValueKey(settings.showHiddenFiles),
                  ),
                ),
                const SizedBox(width: 8),
                const Text('Show Hidden Files'),
              ],
            ),
          ),
        ]);

        return items;
      },
    );
  }
}
