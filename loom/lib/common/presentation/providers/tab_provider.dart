import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Represents a tab in the main content area
@immutable
class ContentTab {
  const ContentTab({
    required this.id,
    required this.title,
    required this.contentType,
    this.icon,
    this.isDirty = false,
    this.canClose = true,
  });

  final String id;
  final String title;
  final String contentType; // 'settings', 'file', etc.
  final String? icon;
  final bool isDirty; // For showing unsaved changes indicator
  final bool canClose;

  ContentTab copyWith({
    String? id,
    String? title,
    String? contentType,
    String? icon,
    bool? isDirty,
    bool? canClose,
  }) {
    return ContentTab(
      id: id ?? this.id,
      title: title ?? this.title,
      contentType: contentType ?? this.contentType,
      icon: icon ?? this.icon,
      isDirty: isDirty ?? this.isDirty,
      canClose: canClose ?? this.canClose,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContentTab && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// State for managing tabs in the main content area
class TabState {
  const TabState({
    this.tabs = const [],
    this.activeTabId,
  });

  final List<ContentTab> tabs;
  final String? activeTabId;

  TabState copyWith({
    List<ContentTab>? tabs,
    String? activeTabId,
    bool clearActiveTab = false,
  }) {
    return TabState(
      tabs: tabs ?? this.tabs,
      activeTabId: clearActiveTab ? null : (activeTabId ?? this.activeTabId),
    );
  }

  ContentTab? get activeTab => tabs.isEmpty || activeTabId == null
      ? null
      : tabs.firstWhere(
          (tab) => tab.id == activeTabId,
          orElse: () => tabs.first,
        );

  bool get hasMultipleTabs => tabs.length > 1;
  bool get hasAnyTabs => tabs.isNotEmpty;
}

/// Notifier for managing tab state
class TabNotifier extends StateNotifier<TabState> {
  TabNotifier() : super(const TabState());

  /// Opens a new tab or activates existing one
  void openTab({
    required String id,
    required String title,
    required String contentType,
    String? icon,
    bool? isDirty,
    bool? canClose,
  }) {
    final existingTabIndex = state.tabs.indexWhere((tab) => tab.id == id);

    if (existingTabIndex != -1) {
      // Tab already exists, just activate it
      state = state.copyWith(activeTabId: id);
    } else {
      // Create new tab
      final newTab = ContentTab(
        id: id,
        title: title,
        contentType: contentType,
        icon: icon,
        isDirty: isDirty ?? false,
        canClose: canClose ?? true,
      );

      state = state.copyWith(
        tabs: [...state.tabs, newTab],
        activeTabId: id,
      );
    }
  }

  /// Closes a tab by ID
  void closeTab(String tabId) {
    final tabIndex = state.tabs.indexWhere((tab) => tab.id == tabId);
    if (tabIndex == -1) return;

    final tab = state.tabs[tabIndex];
    if (!tab.canClose) return;

    final newTabs = List<ContentTab>.from(state.tabs)..removeAt(tabIndex);

    var newActiveTabId = state.activeTabId;

    // If we're closing the active tab, determine new active tab
    if (state.activeTabId == tabId) {
      if (newTabs.isEmpty) {
        newActiveTabId = null;
      } else if (tabIndex < newTabs.length) {
        // Activate the tab that took the place of the closed tab
        newActiveTabId = newTabs[tabIndex].id;
      } else {
        // We closed the last tab, activate the new last tab
        newActiveTabId = newTabs.last.id;
      }
    }

    state = state.copyWith(
      tabs: newTabs,
      activeTabId: newActiveTabId,
      clearActiveTab: newActiveTabId == null,
    );
  }

  /// Activates a tab by ID
  void activateTab(String tabId) {
    if (state.tabs.any((tab) => tab.id == tabId)) {
      state = state.copyWith(activeTabId: tabId);
    }
  }

  /// Updates a tab's properties
  void updateTab(
    String tabId, {
    String? title,
    String? icon,
    bool? isDirty,
    bool? canClose,
  }) {
    final tabIndex = state.tabs.indexWhere((tab) => tab.id == tabId);
    if (tabIndex == -1) return;

    final updatedTabs = List<ContentTab>.from(state.tabs);
    updatedTabs[tabIndex] = updatedTabs[tabIndex].copyWith(
      title: title,
      icon: icon,
      isDirty: isDirty,
      canClose: canClose,
    );

    state = state.copyWith(tabs: updatedTabs);
  }

  /// Update titles of tabs based on a mapping function. Useful when
  /// localizations change and tab titles need to be refreshed.
  void updateTabTitles(String Function(ContentTab) titleMapper) {
    final updatedTabs = state.tabs
        .map((t) => t.copyWith(title: titleMapper(t)))
        .toList(growable: false);
    state = state.copyWith(tabs: updatedTabs);
  }

  /// Closes all tabs
  void closeAllTabs() {
    state = const TabState();
  }

  /// Closes all tabs except the specified one
  void closeOtherTabs(String keepTabId) {
    final tabToKeep = state.tabs.firstWhere(
      (tab) => tab.id == keepTabId,
      orElse: () => throw ArgumentError('Tab not found: $keepTabId'),
    );

    state = state.copyWith(
      tabs: [tabToKeep],
      activeTabId: keepTabId,
    );
  }

  /// Closes all tabs to the right of the specified tab
  void closeTabsToRight(String tabId) {
    final tabIndex = state.tabs.indexWhere((tab) => tab.id == tabId);
    if (tabIndex == -1) return;

    final tabsToKeep = state.tabs.sublist(0, tabIndex + 1);
    final newActiveTabId = state.activeTabId;

    // If active tab is being closed, keep the current tab active
    state = state.copyWith(
      tabs: tabsToKeep,
      activeTabId: newActiveTabId,
    );
  }

  /// Reorders tabs
  void reorderTabs(int oldIndex, int newIndex) {
    if (oldIndex == newIndex) return;

    final tabs = List<ContentTab>.from(state.tabs);
    final tab = tabs.removeAt(oldIndex);

    // Adjust newIndex if it was after the removed element
    final adjustedNewIndex = newIndex > oldIndex ? newIndex - 1 : newIndex;

    tabs.insert(adjustedNewIndex, tab);

    state = state.copyWith(tabs: tabs);
  }
}

/// Provider for tab management
final tabProvider = StateNotifierProvider<TabNotifier, TabState>(
  (ref) => TabNotifier(),
);
