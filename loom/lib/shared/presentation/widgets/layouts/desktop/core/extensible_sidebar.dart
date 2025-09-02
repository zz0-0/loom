import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/shared/presentation/providers/theme_provider.dart';
import 'package:loom/shared/presentation/widgets/layouts/desktop/core/ui_registry.dart';

/// Extensible sidebar that displays registered sidebar items
class ExtensibleSidebar extends ConsumerWidget {
  const ExtensibleSidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final uiState = ref.watch(uiStateProvider);
    final registry = UIRegistry();

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
          // Separate settings from other items
          ...registry.sidebarItems
              .where((item) => item.id != 'settings')
              .map((item) => _SidebarButton(
                    icon: item.icon,
                    tooltip: item.tooltip,
                    isSelected: uiState.selectedSidebarItem == item.id,
                    onPressed: () {
                      if (item.onPressed != null) {
                        item.onPressed!();
                      } else {
                        ref
                            .read(uiStateProvider.notifier)
                            .selectSidebarItem(item.id);
                      }
                    },
                  ),),

          // Spacer to push settings to bottom
          const Spacer(),

          // Settings at the bottom
          ...registry.sidebarItems
              .where((item) => item.id == 'settings')
              .map((item) => _SidebarButton(
                    icon: item.icon,
                    tooltip: item.tooltip,
                    isSelected: uiState.selectedSidebarItem == item.id,
                    onPressed: () {
                      if (item.onPressed != null) {
                        item.onPressed!();
                      } else {
                        ref
                            .read(uiStateProvider.notifier)
                            .selectSidebarItem(item.id);
                      }
                    },
                  ),),
        ],
      ),
    );
  }
}

class _SidebarButton extends StatelessWidget {
  const _SidebarButton({
    required this.icon,
    this.tooltip,
    this.isSelected = false,
    this.onPressed,
  });

  final IconData icon;
  final String? tooltip;
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
        child: Tooltip(
          message: tooltip ?? '',
          child: InkWell(
            onTap: onPressed,
            child: Container(
              width: double.infinity,
              height: 48,
              padding: const EdgeInsets.all(12),
              child: Icon(
                icon,
                size: 20,
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
