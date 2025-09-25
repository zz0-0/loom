import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/common/index.dart';
import 'package:loom/features/core/settings/index.dart';

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
  double _availableWidth = 0;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Calculates which tabs fit in the available space and which overflow
  _TabLayout _calculateTabLayout(
    List<ContentTab> tabs,
    CloseButtonPosition closeButtonPosition,
  ) {
    if (tabs.isEmpty) return const _TabLayout(<ContentTab>[], <ContentTab>[]);

    final visibleTabs = <ContentTab>[];
    final overflowTabs = <ContentTab>[];
    var usedWidth = 0.0;
    const dropdownWidth = 40.0; // Space for overflow dropdown
    final effectiveWidth =
        _availableWidth - (tabs.length > 1 ? dropdownWidth : 0);

    for (final tab in tabs) {
      final tabWidth = _estimateTabWidth(tab, closeButtonPosition);
      if (usedWidth + tabWidth <= effectiveWidth || visibleTabs.isEmpty) {
        visibleTabs.add(tab);
        usedWidth += tabWidth;
      } else {
        overflowTabs.add(tab);
      }
    }

    return _TabLayout(visibleTabs, overflowTabs);
  }

  /// Estimates the width of a tab based on its content
  double _estimateTabWidth(
    ContentTab tab,
    CloseButtonPosition closeButtonPosition,
  ) {
    const baseWidth = 120.0; // Minimum width
    const charWidth = 8.0; // Approximate width per character
    const iconWidth = 24.0; // Space for icon
    const closeButtonWidth = 20.0; // Space for close button
    const padding = 24.0; // Horizontal padding

    var width = baseWidth;
    width += tab.title.length * charWidth;

    if (tab.icon != null) {
      width += iconWidth;
    }

    if (closeButtonPosition == CloseButtonPosition.left ||
        closeButtonPosition == CloseButtonPosition.right) {
      width += closeButtonWidth;
    }

    return width + padding;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tabState = ref.watch(tabProvider);
    final closeButtonSettings = ref.watch(closeButtonSettingsProvider);

    if (!tabState.hasAnyTabs) {
      return const SizedBox.shrink();
    }

    return KeyboardListener(
      focusNode: FocusNode(),
      onKeyEvent: (event) {
        if (HardwareKeyboard.instance.isControlPressed) {
          if (event.logicalKey == LogicalKeyboardKey.tab) {
            // Ctrl+Tab: Next tab
            _switchToNextTab(tabState);
          } else if (event.logicalKey == LogicalKeyboardKey.pageUp) {
            // Ctrl+PageUp: Previous tab
            _switchToPreviousTab(tabState);
          } else if (event.logicalKey == LogicalKeyboardKey.keyW) {
            // Ctrl+W: Close current tab
            _closeCurrentTab(tabState);
          }
        } else if (HardwareKeyboard.instance.isShiftPressed &&
            HardwareKeyboard.instance.isControlPressed) {
          if (event.logicalKey == LogicalKeyboardKey.tab) {
            // Ctrl+Shift+Tab: Previous tab
            _switchToPreviousTab(tabState);
          } else if (event.logicalKey == LogicalKeyboardKey.pageDown) {
            // Ctrl+Shift+PageDown: Next tab
            _switchToNextTab(tabState);
          }
        }
      },
      child: Container(
        height: widget.height,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
          border: Border(
            bottom: BorderSide(
              color: theme.dividerColor,
            ),
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            _availableWidth = constraints.maxWidth;
            final tabLayout = _calculateTabLayout(
              tabState.tabs,
              closeButtonSettings.effectiveTabPosition,
            );

            return Row(
              children: [
                // Visible tabs in scrollable area
                Expanded(
                  child: Listener(
                    onPointerSignal: (pointerSignal) {
                      if (pointerSignal is PointerScrollEvent) {
                        // Handle horizontal scrolling with mouse wheel
                        final delta = pointerSignal.scrollDelta.dy;
                        if (_scrollController.hasClients) {
                          final newOffset =
                              (_scrollController.offset + delta).clamp(
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
                          children: _buildTabRow(
                            tabLayout.visibleTabs,
                            closeButtonSettings.effectiveTabPosition,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Overflow dropdown
                if (tabLayout.overflowTabs.isNotEmpty)
                  _TabOverflowDropdown(
                    overflowTabs: tabLayout.overflowTabs,
                    activeTabId: tabState.activeTabId,
                    onTabSelected: (String tabId) {
                      ref.read(tabProvider.notifier).activateTab(tabId);
                    },
                    onTabClosed: (String tabId) {
                      ref.read(tabProvider.notifier).closeTab(tabId);
                    },
                  ),
              ],
            );
          },
        ),
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

  void _switchToNextTab(TabState tabState) {
    if (tabState.tabs.isEmpty) return;

    final currentIndex =
        tabState.tabs.indexWhere((tab) => tab.id == tabState.activeTabId);
    final nextIndex = (currentIndex + 1) % tabState.tabs.length;
    final nextTab = tabState.tabs[nextIndex];

    ref.read(tabProvider.notifier).activateTab(nextTab.id);
    _ensureTabVisible(nextTab.id);
  }

  void _switchToPreviousTab(TabState tabState) {
    if (tabState.tabs.isEmpty) return;

    final currentIndex =
        tabState.tabs.indexWhere((tab) => tab.id == tabState.activeTabId);
    final previousIndex =
        currentIndex <= 0 ? tabState.tabs.length - 1 : currentIndex - 1;
    final previousTab = tabState.tabs[previousIndex];

    ref.read(tabProvider.notifier).activateTab(previousTab.id);
    _ensureTabVisible(previousTab.id);
  }

  List<Widget> _buildTabRow(
    List<ContentTab> visibleTabs,
    CloseButtonPosition closeButtonPosition,
  ) {
    final tabState = ref.watch(tabProvider);
    final children = <Widget>[];

    for (var i = 0; i < visibleTabs.length; i++) {
      final tab = visibleTabs[i];
      final tabIndexInFullList = tabState.tabs.indexOf(tab);

      // Add drag target before each tab (except the first)
      if (i > 0) {
        children.add(
          _TabDragTarget(
            tabIndex: tabIndexInFullList,
            onAccept: (draggedIndex) {
              ref
                  .read(tabProvider.notifier)
                  .reorderTabs(draggedIndex, tabIndexInFullList);
            },
          ),
        );
      }

      // Add the tab itself
      final isActive = tab.id == tabState.activeTabId;
      children.add(
        _TabItem(
          tab: tab,
          isActive: isActive,
          closeButtonPosition: closeButtonPosition,
          onTap: () {
            ref.read(tabProvider.notifier).activateTab(tab.id);
            _ensureTabVisible(tab.id);
          },
          onClose: tab.canClose
              ? () => ref.read(tabProvider.notifier).closeTab(tab.id)
              : null,
          onCloseOtherTabs: tabState.hasMultipleTabs
              ? () => ref.read(tabProvider.notifier).closeOtherTabs(tab.id)
              : null,
          onCloseTabsToRight: i < visibleTabs.length - 1
              ? () => ref.read(tabProvider.notifier).closeTabsToRight(tab.id)
              : null,
          onCloseAllTabs: tabState.hasAnyTabs
              ? () => ref.read(tabProvider.notifier).closeAllTabs()
              : null,
        ),
      );
    }

    // Add drag target after the last tab
    if (visibleTabs.isNotEmpty) {
      final lastVisibleTabIndex = tabState.tabs.indexOf(visibleTabs.last);
      children.add(
        _TabDragTarget(
          tabIndex: lastVisibleTabIndex + 1,
          onAccept: (draggedIndex) {
            ref
                .read(tabProvider.notifier)
                .reorderTabs(draggedIndex, lastVisibleTabIndex + 1);
          },
        ),
      );
    }

    return children;
  }

  void _closeCurrentTab(TabState tabState) {
    final activeTab = tabState.activeTab;
    if (activeTab != null && activeTab.canClose) {
      ref.read(tabProvider.notifier).closeTab(activeTab.id);
    }
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
    this.onCloseOtherTabs,
    this.onCloseTabsToRight,
    this.onCloseAllTabs,
  });

  final ContentTab tab;
  final bool isActive;
  final VoidCallback onTap;
  final CloseButtonPosition closeButtonPosition;
  final VoidCallback? onClose;
  final VoidCallback? onCloseOtherTabs;
  final VoidCallback? onCloseTabsToRight;
  final VoidCallback? onCloseAllTabs;

  @override
  State<_TabItem> createState() => _TabItemState();
}

class _TabItemState extends State<_TabItem>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late final AnimationController _activeController;
  late final Animation<double> _activeAnimation;

  @override
  void initState() {
    super.initState();
    _activeController = AnimationController(
      duration: AppAnimations.normal,
      vsync: this,
    );

    _activeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _activeController, curve: Curves.easeInOut),
    );

    if (widget.isActive) {
      _activeController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(_TabItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _activeController.forward();
      } else {
        _activeController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _activeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedBuilder(
        animation: _activeAnimation,
        builder: (context, child) {
          final backgroundColor = Color.lerp(
            _isHovered
                ? theme.colorScheme.surfaceContainerHighest.withOpacity(0.5)
                : Colors.transparent,
            theme.colorScheme.surface,
            _activeAnimation.value,
          )!;

          final scale = _isHovered ? AppAnimations.scaleHover : 1.0;

          return AnimatedScale(
            scale: scale,
            duration: AppAnimations.fast,
            curve: AppAnimations.scaleCurve,
            child: Draggable<int>(
              data: widget.tab.id.hashCode,
              onDragEnd: (details) {
                // Ensure drag operation completes
              },
              feedback: Transform.translate(
                offset: const Offset(0, -10),
                child: Material(
                  type: MaterialType.transparency,
                  child: Container(
                    constraints: const BoxConstraints(
                      minWidth: AppDimensions.tabBaseWidth,
                      maxWidth: AppDimensions.tabMaxWidth,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.smd,
                      vertical: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: theme.colorScheme.primary,
                        width: AppDimensions.borderWidthMedium,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: _buildTabChildren(theme, isFeedback: true),
                    ),
                  ),
                ),
              ),
              childWhenDragging: Opacity(
                opacity: 0.3,
                child: Container(
                  constraints: const BoxConstraints(
                    minWidth: AppDimensions.tabBaseWidth,
                    maxWidth: AppDimensions.tabMaxWidth,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: widget.isActive
                        ? Border(
                            left: BorderSide(color: theme.dividerColor),
                            right: BorderSide(color: theme.dividerColor),
                            top: BorderSide(
                              color: theme.colorScheme.primary,
                              width: AppDimensions.borderWidthMedium,
                            ),
                          )
                        : null,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.smd,
                      vertical: AppSpacing.sm,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: _buildTabChildren(theme),
                    ),
                  ),
                ),
              ),
              child: GestureDetector(
                onTap: widget.onTap,
                onSecondaryTapDown: (details) =>
                    _showTabContextMenu(context, details),
                child: Container(
                  constraints: const BoxConstraints(
                    minWidth: AppDimensions.tabBaseWidth,
                    maxWidth: AppDimensions.tabMaxWidth,
                  ),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4 * _activeAnimation.value),
                      topRight: Radius.circular(4 * _activeAnimation.value),
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Top border indicator for active tab
                      if (widget.isActive)
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 2 * _activeAnimation.value,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              borderRadius: BorderRadius.only(
                                topLeft:
                                    Radius.circular(4 * _activeAnimation.value),
                                topRight:
                                    Radius.circular(4 * _activeAnimation.value),
                              ),
                            ),
                          ),
                        ),
                      // Side borders for active tab
                      if (widget.isActive) ...[
                        Positioned(
                          top: 2 * _activeAnimation.value,
                          bottom: 0,
                          left: 0,
                          child: Container(
                            width: AppDimensions.borderWidthThin,
                            color: theme.dividerColor,
                          ),
                        ),
                        Positioned(
                          top: 2 * _activeAnimation.value,
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: AppDimensions.borderWidthThin,
                            color: theme.dividerColor,
                          ),
                        ),
                      ],
                      // Content
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: _buildTabChildren(theme),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Build tab children based on close button position
  List<Widget> _buildTabChildren(ThemeData theme, {bool isFeedback = false}) {
    final closeButton = widget.onClose != null &&
            ((_isHovered || widget.isActive) || isFeedback)
        ? InkWell(
            onTap: widget.onClose,
            borderRadius: AppRadius.radiusXl,
            child: Container(
              padding: AppSpacing.paddingXs,
              child: Icon(
                Icons.close,
                size: AppDimensions.iconMedium,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          )
        : null;

    final icon = widget.tab.icon != null
        ? Icon(
            _getIconData(widget.tab.icon ?? ''),
            size: AppDimensions.iconLarge,
            color: theme.colorScheme.onSurfaceVariant,
          )
        : null;

    final title = isFeedback
        ? Flexible(
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
          )
        : Expanded(
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
            width: AppDimensions.iconTiny,
            height: AppDimensions.iconTiny,
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
        children.addAll([closeButton, const SizedBox(width: AppSpacing.xs)]);
      }
      if (icon != null) {
        children.addAll([icon, const SizedBox(width: AppSpacing.sm)]);
      }
      children.add(title);
      if (dirtyIndicator != null) {
        children.addAll([const SizedBox(width: AppSpacing.xs), dirtyIndicator]);
      }
    } else {
      // Right layout: Icon | Title | Dirty | Close button
      if (icon != null) {
        children.addAll([icon, const SizedBox(width: AppSpacing.sm)]);
      }
      children.add(title);
      if (dirtyIndicator != null) {
        children.addAll([const SizedBox(width: AppSpacing.xs), dirtyIndicator]);
      }
      if (closeButton != null) {
        children.addAll([const SizedBox(width: AppSpacing.xs), closeButton]);
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

  void _showTabContextMenu(BuildContext context, TapDownDetails details) {
    final theme = Theme.of(context);
    final overlay =
        Overlay.of(context).context.findRenderObject()! as RenderBox;
    final position = RelativeRect.fromRect(
      details.globalPosition & const Size(40, 40),
      Offset.zero & overlay.size,
    );

    showMenu<String>(
      context: context,
      position: position,
      items: [
        if (widget.onClose != null)
          PopupMenuItem<String>(
            value: 'close',
            child: Row(
              children: [
                Icon(
                  Icons.close,
                  size: AppDimensions.iconLarge,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text('Close', style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
        if (widget.onCloseOtherTabs != null)
          PopupMenuItem<String>(
            value: 'close_others',
            child: Row(
              children: [
                Icon(
                  Icons.clear_all,
                  size: AppDimensions.iconLarge,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text('Close Others', style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
        if (widget.onCloseTabsToRight != null)
          PopupMenuItem<String>(
            value: 'close_right',
            child: Row(
              children: [
                Icon(
                  Icons.keyboard_arrow_right,
                  size: AppDimensions.iconLarge,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Close Tabs to the Right',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        if (widget.onCloseAllTabs != null)
          PopupMenuItem<String>(
            value: 'close_all',
            child: Row(
              children: [
                Icon(
                  Icons.close,
                  size: AppDimensions.iconLarge,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text('Close All', style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
      ],
    ).then((value) {
      if (value == null) return;

      switch (value) {
        case 'close':
          widget.onClose?.call();
        case 'close_others':
          widget.onCloseOtherTabs?.call();
        case 'close_right':
          widget.onCloseTabsToRight?.call();
        case 'close_all':
          widget.onCloseAllTabs?.call();
      }
    });
  }
}

/// Drag target widget for tab reordering
class _TabDragTarget extends StatelessWidget {
  const _TabDragTarget({
    required this.tabIndex,
    required this.onAccept,
  });

  final int tabIndex;
  final void Function(int draggedIndex) onAccept;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final theme = Theme.of(context);

        return DragTarget<int>(
          onWillAcceptWithDetails: (details) => true,
          onAcceptWithDetails: (details) {
            // Find the original index of the dragged tab
            final tabState = ref.read(tabProvider);
            final draggedIndex = tabState.tabs.indexWhere(
              (ContentTab tab) => tab.id.hashCode == details.data,
            );

            if (draggedIndex != -1) {
              onAccept(draggedIndex);
            }
          },
          builder: (context, candidateData, rejectedData) {
            final isHovered = candidateData.isNotEmpty;
            return Container(
              width: isHovered ? 60 : 12,
              height: 35,
              decoration: BoxDecoration(
                color: isHovered
                    ? theme.colorScheme.primary.withOpacity(0.3)
                    : Colors.transparent,
                border: isHovered
                    ? Border.all(
                        color: theme.colorScheme.primary,
                        width: 2,
                      )
                    : null,
                borderRadius: BorderRadius.circular(4),
              ),
              child: isHovered
                  ? Center(
                      child: Icon(
                        Icons.arrow_forward,
                        size: 20,
                        color: theme.colorScheme.primary,
                      ),
                    )
                  : null,
            );
          },
        );
      },
    );
  }
}

/// Data class for tab layout calculation results
class _TabLayout {
  const _TabLayout(this.visibleTabs, this.overflowTabs);

  final List<ContentTab> visibleTabs;
  final List<ContentTab> overflowTabs;
}

/// Dropdown widget for overflow tabs
class _TabOverflowDropdown extends StatelessWidget {
  const _TabOverflowDropdown({
    required this.overflowTabs,
    required this.activeTabId,
    required this.onTabSelected,
    required this.onTabClosed,
  });

  final List<ContentTab> overflowTabs;
  final String? activeTabId;
  final void Function(String) onTabSelected;
  final void Function(String) onTabClosed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopupMenuButton<String>(
      icon: Icon(
        Icons.more_horiz,
        size: 16,
        color: theme.colorScheme.onSurfaceVariant,
      ),
      itemBuilder: (context) => overflowTabs.map((tab) {
        final isActive = tab.id == activeTabId;
        return PopupMenuItem<String>(
          value: tab.id,
          child: Row(
            children: [
              // Tab icon
              if (tab.icon != null)
                Icon(
                  _getIconData(tab.icon!),
                  size: 16,
                  color: theme.colorScheme.onSurfaceVariant,
                ),

              // Tab title
              Expanded(
                child: Text(
                  tab.title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: isActive ? FontWeight.w500 : FontWeight.w400,
                    color: isActive
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Dirty indicator
              if (tab.isDirty)
                Container(
                  width: 6,
                  height: 6,
                  margin: AppSpacing.marginLeftSm,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),

              // Close button
              if (tab.canClose)
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop(); // Close the menu
                    onTabClosed(tab.id);
                  },
                  borderRadius: AppRadius.radiusSm,
                  child: Container(
                    padding: AppSpacing.paddingXs,
                    margin: AppSpacing.marginLeftSm,
                    child: Icon(
                      Icons.close,
                      size: 14,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
            ],
          ),
        );
      }).toList(),
      onSelected: onTabSelected,
    );
  }

  static IconData _getIconData(String iconName) {
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
