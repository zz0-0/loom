import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/common/index.dart';
import 'package:loom/features/core/explorer/index.dart';
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
            height: 35,
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
                    _getPanelTitle(selectedItem),
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(LucideIcons.x, size: 14),
                  onPressed: onClose,
                  splashRadius: 12,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 24,
                    minHeight: 24,
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

  String _getPanelTitle(String? item) {
    switch (item) {
      case 'explorer':
        return 'EXPLORER';
      case 'search':
        return 'SEARCH';
      case 'source_control':
        return 'SOURCE CONTROL';
      case 'debug':
        return 'RUN AND DEBUG';
      case 'extensions':
        return 'EXTENSIONS';
      case 'settings':
        return 'SETTINGS';
      default:
        return 'PANEL';
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
                'WORKSPACE',
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(LucideIcons.folderPlus, size: 14),
                onPressed: () => _createNewFolder(context, ref),
                splashRadius: 12,
              ),
              IconButton(
                icon: const Icon(LucideIcons.filePlus, size: 14),
                onPressed: () => _createNewFile(context, ref),
                splashRadius: 12,
              ),
              IconButton(
                icon: const Icon(LucideIcons.refreshCw, size: 14),
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
        title: const Text('Create New Folder'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Enter folder name',
            hintStyle: TextStyle(
              color: theme.colorScheme.onSurface.withOpacity(0.4),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final folderName = controller.text.trim();
              if (folderName.isNotEmpty) {
                Navigator.of(context).pop(folderName);
              }
            },
            child: const Text('Create'),
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
                content: Text('Created folder: $result'),
                duration: const Duration(seconds: 2),
              ),
            );
          }
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please open a workspace first'),
                backgroundColor: Colors.orange,
              ),
            );
          }
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
  }

  Future<void> _createNewFile(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController();
    final theme = Theme.of(context);

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New File'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Enter file name (e.g., document.md)',
            hintStyle: TextStyle(
              color: theme.colorScheme.onSurface.withOpacity(0.4),
            ),
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
                content: Text('Created and opened: $result'),
                duration: const Duration(seconds: 2),
              ),
            );
          }
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please open a workspace first'),
                backgroundColor: Colors.orange,
              ),
            );
          }
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
                left: 6.0 + (depth * 12.0),
                right: 6,
                top: 2,
                bottom: 2,
              ),
              child: Row(
                children: [
                  if (hasChildren)
                    Icon(
                      isExpanded
                          ? LucideIcons.chevronDown
                          : LucideIcons.chevronRight,
                      size: 10,
                      color: theme.colorScheme.onSurfaceVariant,
                    )
                  else
                    const SizedBox(width: 12),
                  const SizedBox(width: 4),
                  Icon(
                    icon,
                    size: 12,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 6),
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
    return const Center(child: Text('Search Panel\n(To be implemented)'));
  }
}

class _SourceControlPanel extends StatelessWidget {
  const _SourceControlPanel();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Source Control Panel\n(To be implemented)'),
    );
  }
}

class _DebugPanel extends StatelessWidget {
  const _DebugPanel();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Debug Panel\n(To be implemented)'));
  }
}

class _ExtensionsPanel extends StatelessWidget {
  const _ExtensionsPanel();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Extensions Panel\n(To be implemented)'));
  }
}

class _SettingsPanel extends StatelessWidget {
  const _SettingsPanel();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Settings Panel\n(To be implemented)'));
  }
}

class _DefaultPanel extends StatelessWidget {
  const _DefaultPanel();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Select a panel from the sidebar'));
  }
}
