import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/shared/presentation/providers/theme_provider.dart';
import 'package:lucide_icons/lucide_icons.dart';

class SidePanel extends ConsumerWidget {
  final String? selectedItem;
  final VoidCallback? onClose;

  const SidePanel({
    super.key,
    this.selectedItem,
    this.onClose,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          right: BorderSide(
            color: theme.dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            height: 35,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: theme.dividerColor,
                  width: 1,
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
          padding: const EdgeInsets.all(8),
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
                icon: const Icon(LucideIcons.folderPlus, size: 16),
                onPressed: () {
                  // TODO: Add folder
                },
                splashRadius: 12,
              ),
              IconButton(
                icon: const Icon(LucideIcons.filePlus, size: 16),
                onPressed: () {
                  // TODO: Add file
                },
                splashRadius: 12,
              ),
              IconButton(
                icon: const Icon(LucideIcons.refreshCw, size: 16),
                onPressed: () {
                  // TODO: Refresh
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
                  ref.read(uiStateProvider.notifier).openFile('pubspec.yaml');
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FileTreeItem extends StatelessWidget {
  final IconData icon;
  final String name;
  final bool isExpanded;
  final VoidCallback? onTap;
  final List<_FileTreeItem>? children;
  final int depth;

  const _FileTreeItem({
    required this.icon,
    required this.name,
    this.isExpanded = false,
    this.onTap,
    this.children,
    this.depth = 0,
  });

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
                left: 8.0 + (depth * 16.0),
                right: 8.0,
                top: 4.0,
                bottom: 4.0,
              ),
              child: Row(
                children: [
                  if (hasChildren)
                    Icon(
                      isExpanded
                          ? LucideIcons.chevronDown
                          : LucideIcons.chevronRight,
                      size: 12,
                      color: theme.colorScheme.onSurfaceVariant,
                    )
                  else
                    const SizedBox(width: 12),
                  const SizedBox(width: 4),
                  Icon(
                    icon,
                    size: 14,
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
          ...children!.map((child) => _FileTreeItem(
                icon: child.icon,
                name: child.name,
                isExpanded: child.isExpanded,
                onTap: child.onTap,
                children: child.children,
                depth: depth + 1,
              )),
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
        child: Text('Source Control Panel\n(To be implemented)'));
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
