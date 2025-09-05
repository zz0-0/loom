import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/features/settings/presentation/providers/close_button_settings_provider.dart';
import 'package:loom/shared/presentation/providers/tab_provider.dart';

/// Tab bar widget that displays and manages tabs in the main content area
class ContentTabBar extends ConsumerStatefulWidget {
  const ContentTabBar({
    super.key,
    this.height = 35,
  });

  final double height;

  @override
  ConsumerState<ContentTabBar> createState() => _ContentTabBarState();
}

class _ContentTabBarState extends ConsumerState<ContentTabBar> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tabState = ref.watch(tabProvider);
    final closeButtonSettings = ref.watch(closeButtonSettingsProvider);

    if (!tabState.hasAnyTabs) {
      return const SizedBox.shrink();
    }

    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
        border: Border(
          bottom: BorderSide(
            color: theme.dividerColor,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Listener(
              onPointerSignal: (pointerSignal) {
                if (pointerSignal is PointerScrollEvent) {
                  // Handle horizontal scrolling with mouse wheel
                  final delta = pointerSignal.scrollDelta.dy;
                  if (_scrollController.hasClients) {
                    final newOffset = (_scrollController.offset + delta).clamp(
                      0.0,
                      _scrollController.position.maxScrollExtent,
                    );
                    _scrollController.animateTo(
                      newOffset,
                      duration: const Duration(milliseconds: 100),
                      curve: Curves.easeOut,
                    );
                  }
                }
              },
              child: Scrollbar(
                controller: _scrollController,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: tabState.tabs.map((tab) {
                      final isActive = tab.id == tabState.activeTabId;
                      return _TabItem(
                        tab: tab,
                        isActive: isActive,
                        closeButtonPosition:
                            closeButtonSettings.effectiveTabPosition,
                        onTap: () {
                          ref.read(tabProvider.notifier).activateTab(tab.id);
                          _ensureTabVisible(tab.id);
                        },
                        onClose: tab.canClose
                            ? () =>
                                ref.read(tabProvider.notifier).closeTab(tab.id)
                            : null,
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Ensures the specified tab is visible by scrolling to it if necessary
  void _ensureTabVisible(String tabId) {
    // This is a simple implementation - in a more complex scenario,
    // you might want to calculate the exact position of the tab
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        final tabIndex =
            ref.read(tabProvider).tabs.indexWhere((tab) => tab.id == tabId);
        if (tabIndex != -1) {
          // Rough estimation: each tab is about 150 pixels wide
          const tabWidth = 150.0;
          final targetPosition = tabIndex * tabWidth;
          final maxScroll = _scrollController.position.maxScrollExtent;
          final viewportWidth = _scrollController.position.viewportDimension;

          if (targetPosition >
              _scrollController.offset + viewportWidth - tabWidth) {
            // Tab is to the right of visible area
            _scrollController.animateTo(
              (targetPosition - viewportWidth + tabWidth).clamp(0.0, maxScroll),
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
            );
          } else if (targetPosition < _scrollController.offset) {
            // Tab is to the left of visible area
            _scrollController.animateTo(
              targetPosition.clamp(0.0, maxScroll),
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
            );
          }
        }
      }
    });
  }
}

/// Individual tab item widget
class _TabItem extends StatefulWidget {
  const _TabItem({
    required this.tab,
    required this.isActive,
    required this.onTap,
    required this.closeButtonPosition,
    this.onClose,
  });

  final ContentTab tab;
  final bool isActive;
  final VoidCallback onTap;
  final CloseButtonPosition closeButtonPosition;
  final VoidCallback? onClose;

  @override
  State<_TabItem> createState() => _TabItemState();
}

class _TabItemState extends State<_TabItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final backgroundColor = widget.isActive
        ? theme.colorScheme.surface
        : _isHovered
            ? theme.colorScheme.surfaceContainerHighest.withOpacity(0.5)
            : Colors.transparent;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          constraints: const BoxConstraints(
            minWidth: 120,
            maxWidth: 200,
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            border: widget.isActive
                ? Border(
                    left: BorderSide(color: theme.dividerColor),
                    right: BorderSide(color: theme.dividerColor),
                    top: BorderSide(
                      color: theme.colorScheme.primary,
                      width: 2,
                    ),
                  )
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: _buildTabChildren(theme),
            ),
          ),
        ),
      ),
    );
  }

  /// Build tab children based on close button position
  List<Widget> _buildTabChildren(ThemeData theme) {
    final closeButton =
        widget.onClose != null && (_isHovered || widget.isActive)
            ? InkWell(
                onTap: widget.onClose,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(2),
                  child: Icon(
                    Icons.close,
                    size: 14,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              )
            : null;

    final icon = widget.tab.icon != null
        ? Icon(
            _getIconData(widget.tab.icon ?? ''),
            size: 16,
            color: theme.colorScheme.onSurfaceVariant,
          )
        : null;

    final title = Expanded(
      child: Text(
        widget.tab.title,
        style: theme.textTheme.bodySmall?.copyWith(
          fontWeight: widget.isActive ? FontWeight.w500 : FontWeight.w400,
          color: widget.isActive
              ? theme.colorScheme.onSurface
              : theme.colorScheme.onSurfaceVariant,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );

    final dirtyIndicator = widget.tab.isDirty
        ? Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
          )
        : null;

    // Build children list based on close button position
    final children = <Widget>[];

    if (widget.closeButtonPosition == CloseButtonPosition.left) {
      // Left layout: Close button | Icon | Title | Dirty
      if (closeButton != null) {
        children.addAll([closeButton, const SizedBox(width: 4)]);
      }
      if (icon != null) {
        children.addAll([icon, const SizedBox(width: 8)]);
      }
      children.add(title);
      if (dirtyIndicator != null) {
        children.addAll([const SizedBox(width: 4), dirtyIndicator]);
      }
    } else {
      // Right layout: Icon | Title | Dirty | Close button
      if (icon != null) {
        children.addAll([icon, const SizedBox(width: 8)]);
      }
      children.add(title);
      if (dirtyIndicator != null) {
        children.addAll([const SizedBox(width: 4), dirtyIndicator]);
      }
      if (closeButton != null) {
        children.addAll([const SizedBox(width: 4), closeButton]);
      }
    }

    return children;
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'settings':
        return Icons.settings;
      case 'file':
        return Icons.description;
      case 'folder':
        return Icons.folder;
      default:
        return Icons.description;
    }
  }
}
