import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/common/index.dart';
import 'package:loom/features/core/explorer/index.dart';
import 'package:loom/flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lucide_icons/lucide_icons.dart';

class SidePanel extends ConsumerWidget {
  const SidePanel({
    super.key,
    this.selectedItem,
    this.onClose,
  });
  final String? selectedItem;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          right: BorderSide(
            color: theme.dividerColor,
          ),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            height: AppDimensions.topBarHeight,
            padding: AppSpacing.paddingSm,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: theme.dividerColor,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _getPanelTitle(context, selectedItem),
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  icon:
                      const Icon(LucideIcons.x, size: AppDimensions.iconMedium),
                  onPressed: onClose,
                  splashRadius: AppDimensions.buttonSplashRadius,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: AppDimensions.buttonMinWidth,
                    minHeight: AppDimensions.buttonMinHeight,
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: _buildPanelContent(context, selectedItem),
          ),
        ],
      ),
    );
  }

  String _getPanelTitle(BuildContext context, String? item) {
    // Use localizations where possible so titles update when locale changes
    final loc = AppLocalizations.of(context);
    switch (item) {
      case 'explorer':
        return loc.explorerTooltip.toUpperCase();
      case 'search':
        return loc.searchTooltip.toUpperCase();
      case 'source_control':
        return loc.sourceControlPanelPlaceholder.toUpperCase();
      case 'debug':
        return loc.debugPanelPlaceholder.toUpperCase();
      case 'extensions':
        return loc.extensionsPanelPlaceholder.toUpperCase();
      case 'settings':
        return loc.settings.toUpperCase();
      default:
        return (item ?? 'PANEL').toUpperCase();
    }
  }

  Widget _buildPanelContent(BuildContext context, String? item) {
    switch (item) {
      case 'explorer':
        return const _ExplorerPanel();
      case 'search':
        return const _SearchPanel();
      case 'source_control':
        return const _SourceControlPanel();
      case 'debug':
        return const _DebugPanel();
      case 'extensions':
        return const _ExtensionsPanel();
      case 'settings':
        return const _SettingsPanel();
      default:
        return const _DefaultPanel();
    }
  }
}

class _ExplorerPanel extends ConsumerWidget {
  const _ExplorerPanel();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Toolbar
        Container(
          padding: AppSpacing.paddingSm,
          child: Row(
            children: [
              Text(
                AppLocalizations.of(context).yourWorkspace.toUpperCase(),
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(
                  LucideIcons.folderPlus,
                  size: AppDimensions.iconMedium,
                ),
                onPressed: () => _createNewFolder(context, ref),
                splashRadius: AppDimensions.buttonSplashRadius,
              ),
              IconButton(
                icon: const Icon(
                  LucideIcons.filePlus,
                  size: AppDimensions.iconMedium,
                ),
                onPressed: () => _createNewFile(context, ref),
                splashRadius: AppDimensions.buttonSplashRadius,
              ),
              IconButton(
                icon: const Icon(
                  LucideIcons.refreshCw,
                  size: AppDimensions.iconMedium,
                ),
                onPressed: () {
                  // TODO(user): Refresh
                },
                splashRadius: 12,
              ),
            ],
          ),
        ),

        // File tree
        Expanded(
          child: ListView(
            children: [
              _FileTreeItem(
                icon: LucideIcons.folder,
                name: 'lib',
                isExpanded: true,
                onTap: () {},
                children: [
                  _FileTreeItem(
                    icon: LucideIcons.file,
                    name: 'main.dart',
                    onTap: () {
                      ref
                          .read(uiStateProvider.notifier)
                          .openFile('lib/main.dart');
                    },
                  ),
                  _FileTreeItem(
                    icon: LucideIcons.folder,
                    name: 'shared',
                    isExpanded: true,
                    onTap: () {},
                    children: [
                      _FileTreeItem(
                        icon: LucideIcons.file,
                        name: 'theme.dart',
                        onTap: () {
                          ref
                              .read(uiStateProvider.notifier)
                              .openFile('lib/shared/theme.dart');
                        },
                      ),
                    ],
                  ),
                ],
              ),
              _FileTreeItem(
                icon: LucideIcons.file,
                name: 'pubspec.yaml',
                onTap: () {
                  ref.read(fileOpeningServiceProvider).openFile('pubspec.yaml');
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _createNewFolder(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController();
    final theme = Theme.of(context);

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          AppLocalizations.of(context).createNewFolder,
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context).enterFolderNameHint,
            hintStyle: TextStyle(
              color: theme.colorScheme.onSurface.withOpacity(0.4),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              AppLocalizations.of(context).cancel,
            ),
          ),
          TextButton(
            onPressed: () {
              final folderName = controller.text.trim();
              if (folderName.isNotEmpty) {
                Navigator.of(context).pop(folderName);
              }
            },
            child: Text(
              AppLocalizations.of(context).create,
            ),
          ),
        ],
      ),
    );

    if (result != null && context.mounted) {
      try {
        final workspace = ref.read(currentWorkspaceProvider);
        if (workspace != null) {
          final folderPath = '${workspace.rootPath}/$result';
          await ref
              .read(currentWorkspaceProvider.notifier)
              .createDirectory(folderPath);

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  AppLocalizations.of(context).createdFolder(result),
                ),
                duration: const Duration(seconds: 2),
              ),
            );
          }
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  AppLocalizations.of(context).pleaseOpenWorkspaceFirst,
                ),
                backgroundColor: Colors.orange,
              ),
            );
          }
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context).failedToCreateFolder(e.toString()),
              ),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
    }
  }

  Future<void> _createNewFile(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController();
    final theme = Theme.of(context);

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          AppLocalizations.of(context).createNewFile,
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context).enterFileNameHint,
            hintStyle: TextStyle(
              color: theme.colorScheme.onSurface.withOpacity(0.4),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              AppLocalizations.of(context).cancel,
            ),
          ),
          TextButton(
            onPressed: () {
              final fileName = controller.text.trim();
              if (fileName.isNotEmpty) {
                Navigator.of(context).pop(fileName);
              }
            },
            child: Text(
              AppLocalizations.of(context).create,
            ),
          ),
        ],
      ),
    );

    if (result != null && context.mounted) {
      try {
        final workspace = ref.read(currentWorkspaceProvider);
        if (workspace != null) {
          final filePath = '${workspace.rootPath}/$result';
          await ref
              .read(currentWorkspaceProvider.notifier)
              .createFile(filePath);

          // Open the newly created file
          await ref.read(fileOpeningServiceProvider).openFile(filePath);

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  AppLocalizations.of(context).createdAndOpenedFile(result),
                ),
                duration: const Duration(seconds: 2),
              ),
            );
          }
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  AppLocalizations.of(context).pleaseOpenWorkspaceFirst,
                ),
                backgroundColor: Colors.orange,
              ),
            );
          }
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context).failedToCreateFile(e.toString()),
              ),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
    }
  }
}

class _FileTreeItem extends StatelessWidget {
  const _FileTreeItem({
    required this.icon,
    required this.name,
    this.isExpanded = false,
    this.onTap,
    this.children,
    this.depth = 0,
  });
  final IconData icon;
  final String name;
  final bool isExpanded;
  final VoidCallback? onTap;
  final List<_FileTreeItem>? children;
  final int depth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasChildren = children != null && children!.isNotEmpty;

    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Container(
              padding: EdgeInsets.only(
                left: AppSpacing.xs + (depth * AppDimensions.listIndentWidth),
                right: AppSpacing.xs,
                top: AppSpacing.paddingVerticalXs.top,
                bottom: AppSpacing.paddingVerticalXs.bottom,
              ),
              child: Row(
                children: [
                  if (hasChildren)
                    Icon(
                      isExpanded
                          ? LucideIcons.chevronDown
                          : LucideIcons.chevronRight,
                      size: AppDimensions.iconTiny,
                      color: theme.colorScheme.onSurfaceVariant,
                    )
                  else
                    const SizedBox(width: AppDimensions.listIndentWidth),
                  const SizedBox(width: AppSpacing.xs),
                  Icon(
                    icon,
                    size: AppDimensions.iconSmall,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Text(
                      name,
                      style: theme.textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (hasChildren && isExpanded)
          ...children!.map(
            (child) => _FileTreeItem(
              icon: child.icon,
              name: child.name,
              isExpanded: child.isExpanded,
              onTap: child.onTap,
              depth: depth + 1,
              children: child.children,
            ),
          ),
      ],
    );
  }
}

// Placeholder panels
class _SearchPanel extends StatelessWidget {
  const _SearchPanel();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        AppLocalizations.of(context).searchPanelPlaceholder,
      ),
    );
  }
}

class _SourceControlPanel extends StatelessWidget {
  const _SourceControlPanel();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        AppLocalizations.of(context).sourceControlPanelPlaceholder,
      ),
    );
  }
}

class _DebugPanel extends StatelessWidget {
  const _DebugPanel();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        AppLocalizations.of(context).debugPanelPlaceholder,
      ),
    );
  }
}

class _ExtensionsPanel extends StatelessWidget {
  const _ExtensionsPanel();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        AppLocalizations.of(context).extensionsPanelPlaceholder,
      ),
    );
  }
}

class _SettingsPanel extends StatelessWidget {
  const _SettingsPanel();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        AppLocalizations.of(context).settingsPanelPlaceholder,
      ),
    );
  }
}

class _DefaultPanel extends StatelessWidget {
  const _DefaultPanel();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        AppLocalizations.of(context).selectPanelFromSidebar,
      ),
    );
  }
}
