import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/common/index.dart';

/// Extensible sidebar that displays registered sidebar items
class ExtensibleSidebar extends ConsumerWidget {
  const ExtensibleSidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final uiState = ref.watch(uiStateProvider);
    final registry = UIRegistry();

    return AnimatedBuilder(
      animation: registry,
      builder: (context, child) => Container(
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
            ...registry.sidebarItems.where((item) => item.id != 'settings').map(
                  (item) => _SidebarButton(
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
                  ),
                ),

            // Spacer to push settings to bottom
            const Spacer(),

            // Settings at the bottom
            ...registry.sidebarItems.where((item) => item.id == 'settings').map(
                  (item) => _SidebarButton(
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
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

class _SidebarButton extends StatefulWidget {
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
  State<_SidebarButton> createState() => _SidebarButtonState();
}

class _SidebarButtonState extends State<_SidebarButton> {
  bool _isHovered = false;

  /// Get filled version of common icons
  IconData _getFilledIcon(IconData originalIcon) {
    // Map hollow icons to their filled variants
    final iconMap = {
      Icons.settings: Icons.settings,
      Icons.home: Icons.home,
      Icons.folder: Icons.folder,
      Icons.search: Icons.search,
      Icons.star: Icons.star,
      Icons.favorite: Icons.favorite,
      Icons.bookmark: Icons.bookmark,
      Icons.notifications: Icons.notifications,
      Icons.mail: Icons.mail,
      Icons.person: Icons.person,
      Icons.dashboard: Icons.dashboard,
      Icons.file_copy: Icons.file_copy,
      Icons.edit: Icons.edit,
      Icons.delete: Icons.delete,
      Icons.add: Icons.add,
      Icons.remove: Icons.remove,
      Icons.close: Icons.close,
      Icons.check: Icons.check,
      Icons.arrow_back: Icons.arrow_back,
      Icons.arrow_forward: Icons.arrow_forward,
      Icons.expand_more: Icons.expand_more,
      Icons.expand_less: Icons.expand_less,
      Icons.menu: Icons.menu,
      Icons.more_vert: Icons.more_vert,
      Icons.more_horiz: Icons.more_horiz,
      Icons.account_tree: Icons.account_tree,
    };

    // Get filled version if available, otherwise return original
    return iconMap[originalIcon] ?? originalIcon;
  }

  /// Get outlined version of common icons
  IconData _getOutlinedIcon(IconData originalIcon) {
    // Map filled icons to their outlined variants
    final iconMap = {
      Icons.settings: Icons.settings_outlined,
      Icons.home: Icons.home_outlined,
      Icons.folder: Icons.folder_outlined,
      Icons.search: Icons.search_outlined,
      Icons.star: Icons.star_outline,
      Icons.favorite: Icons.favorite_border,
      Icons.bookmark: Icons.bookmark_border,
      Icons.notifications: Icons.notifications_outlined,
      Icons.mail: Icons.mail_outlined,
      Icons.person: Icons.person_outline,
      Icons.dashboard: Icons.dashboard_outlined,
      Icons.file_copy: Icons.file_copy_outlined,
      Icons.edit: Icons.edit_outlined,
      Icons.delete: Icons.delete_outlined,
      Icons.add: Icons.add_outlined,
      Icons.remove: Icons.remove_outlined,
      Icons.close: Icons.close_outlined,
      Icons.check: Icons.check_outlined,
      Icons.arrow_back: Icons.arrow_back_outlined,
      Icons.arrow_forward: Icons.arrow_forward_outlined,
      Icons.expand_more: Icons.expand_more_outlined,
      Icons.expand_less: Icons.expand_less_outlined,
      Icons.menu: Icons.menu_outlined,
      Icons.more_vert: Icons.more_vert_outlined,
      Icons.more_horiz: Icons.more_horiz_outlined,
      Icons.account_tree: Icons.account_tree_outlined,
    };

    // Get outlined version if available, otherwise return original
    return iconMap[originalIcon] ?? originalIcon;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Use filled icon when selected or hovered, outlined when not
    final displayIcon = widget.isSelected || _isHovered
        ? _getFilledIcon(widget.icon)
        : _getOutlinedIcon(widget.icon);

    return Container(
      margin: AppSpacing.marginVerticalXs,
      child: Material(
        color: widget.isSelected
            ? theme.colorScheme.primary.withOpacity(0.12)
            : _isHovered
                ? theme.colorScheme.onSurface.withOpacity(0.08)
                : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: Tooltip(
          message: widget.tooltip ?? '',
          child: InkWell(
            onTap: widget.onPressed,
            onHover: (hovering) {
              setState(() {
                _isHovered = hovering;
              });
            },
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: Icon(
                displayIcon,
                size: 20,
                color: widget.isSelected
                    ? theme.colorScheme.primary
                    : _isHovered
                        ? theme.colorScheme.onSurface
                        : theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
