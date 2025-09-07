import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/shared/presentation/providers/theme_provider.dart';
import 'package:loom/shared/presentation/theme/app_animations.dart';

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
            icon: Icons.folder_outlined,
            filledIcon: Icons.folder_open,
            label: 'Explorer',
            isSelected: uiState.selectedSidebarItem == 'explorer',
            onPressed: () {
              ref.read(uiStateProvider.notifier).selectSidebarItem('explorer');
            },
          ),

          _SidebarButton(
            icon: Icons.search_outlined,
            filledIcon: Icons.search,
            label: 'Search',
            isSelected: uiState.selectedSidebarItem == 'search',
            onPressed: () {
              ref.read(uiStateProvider.notifier).selectSidebarItem('search');
            },
          ),

          _SidebarButton(
            icon: Icons.account_tree_outlined,
            filledIcon: Icons.account_tree,
            label: 'Source Control',
            isSelected: uiState.selectedSidebarItem == 'source_control',
            onPressed: () {
              ref
                  .read(uiStateProvider.notifier)
                  .selectSidebarItem('source_control');
            },
          ),

          _SidebarButton(
            icon: Icons.bug_report_outlined,
            filledIcon: Icons.bug_report,
            label: 'Debug',
            isSelected: uiState.selectedSidebarItem == 'debug',
            onPressed: () {
              ref.read(uiStateProvider.notifier).selectSidebarItem('debug');
            },
          ),

          _SidebarButton(
            icon: Icons.extension_outlined,
            filledIcon: Icons.extension,
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
            icon: Icons.settings_outlined,
            filledIcon: Icons.settings,
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

class _SidebarButton extends StatefulWidget {
  const _SidebarButton({
    required this.icon,
    required this.filledIcon,
    required this.label,
    this.isSelected = false,
    this.onPressed,
  });

  final IconData icon;
  final IconData filledIcon;
  final String label;
  final bool isSelected;
  final VoidCallback? onPressed;

  @override
  State<_SidebarButton> createState() => _SidebarButtonState();
}

class _SidebarButtonState extends State<_SidebarButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final shouldShowFilled = widget.isSelected || _isHovered;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 1),
      child: AnimatedContainer(
        duration: AppAnimations.fast,
        curve: AppAnimations.scaleCurve,
        decoration: BoxDecoration(
          color: widget.isSelected
              ? theme.colorScheme.primary.withOpacity(0.2)
              : _isHovered
                  ? theme.colorScheme.primary.withOpacity(0.1)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          child: InkWell(
            onTap: widget.onPressed,
            onHover: (hovered) {
              setState(() {
                _isHovered = hovered;
              });
            },
            borderRadius: BorderRadius.circular(6),
            child: AnimatedContainer(
              duration: AppAnimations.fast,
              curve: AppAnimations.scaleCurve,
              width: double.infinity,
              height: 48,
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedScale(
                    scale: _isHovered ? AppAnimations.scaleHover : 1.0,
                    duration: AppAnimations.fast,
                    curve: AppAnimations.scaleCurve,
                    child: Icon(
                      shouldShowFilled ? widget.filledIcon : widget.icon,
                      size: 20,
                      color: widget.isSelected
                          ? theme.colorScheme.primary
                          : _isHovered
                              ? theme.colorScheme.primary.withOpacity(0.8)
                              : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 2),
                  AnimatedDefaultTextStyle(
                    duration: AppAnimations.fast,
                    curve: AppAnimations.scaleCurve,
                    style: theme.textTheme.labelSmall!.copyWith(
                      fontSize: 9,
                      color: widget.isSelected
                          ? theme.colorScheme.primary
                          : _isHovered
                              ? theme.colorScheme.primary.withOpacity(0.8)
                              : theme.colorScheme.onSurfaceVariant,
                      fontWeight:
                          _isHovered ? FontWeight.w600 : FontWeight.w400,
                    ),
                    child: Text(
                      widget.label,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
