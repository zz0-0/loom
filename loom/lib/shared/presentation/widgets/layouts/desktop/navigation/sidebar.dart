import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/shared/presentation/providers/theme_provider.dart';
import 'package:lucide_icons/lucide_icons.dart';

class Sidebar extends ConsumerWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final uiState = ref.watch(uiStateProvider);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
        border: Border(
          right: BorderSide(
            color: theme.dividerColor,
          ),
        ),
      ),
      child: Column(
        children: [
          // Activity bar items
          _SidebarButton(
            icon: LucideIcons.files,
            label: 'Explorer',
            isSelected: uiState.selectedSidebarItem == 'explorer',
            onPressed: () {
              ref.read(uiStateProvider.notifier).selectSidebarItem('explorer');
            },
          ),

          _SidebarButton(
            icon: LucideIcons.search,
            label: 'Search',
            isSelected: uiState.selectedSidebarItem == 'search',
            onPressed: () {
              ref.read(uiStateProvider.notifier).selectSidebarItem('search');
            },
          ),

          _SidebarButton(
            icon: LucideIcons.gitBranch,
            label: 'Source Control',
            isSelected: uiState.selectedSidebarItem == 'source_control',
            onPressed: () {
              ref
                  .read(uiStateProvider.notifier)
                  .selectSidebarItem('source_control');
            },
          ),

          _SidebarButton(
            icon: LucideIcons.bug,
            label: 'Debug',
            isSelected: uiState.selectedSidebarItem == 'debug',
            onPressed: () {
              ref.read(uiStateProvider.notifier).selectSidebarItem('debug');
            },
          ),

          _SidebarButton(
            icon: LucideIcons.package,
            label: 'Extensions',
            isSelected: uiState.selectedSidebarItem == 'extensions',
            onPressed: () {
              ref
                  .read(uiStateProvider.notifier)
                  .selectSidebarItem('extensions');
            },
          ),

          const Spacer(),

          // Settings at bottom
          _SidebarButton(
            icon: LucideIcons.settings,
            label: 'Settings',
            isSelected: uiState.selectedSidebarItem == 'settings',
            onPressed: () {
              ref.read(uiStateProvider.notifier).selectSidebarItem('settings');
            },
          ),
        ],
      ),
    );
  }
}

class _SidebarButton extends StatelessWidget {
  const _SidebarButton({
    required this.icon,
    required this.label,
    this.isSelected = false,
    this.onPressed,
  });
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 1),
      child: Material(
        color: isSelected
            ? theme.colorScheme.primary.withOpacity(0.1)
            : Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          child: Container(
            width: double.infinity,
            height: 48,
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontSize: 9,
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
