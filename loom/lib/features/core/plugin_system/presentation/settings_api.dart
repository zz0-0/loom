import 'package:flutter/material.dart';
import 'package:loom/features/core/plugin_system/domain/plugin.dart';

/// Settings API for plugins
class PluginSettingsApi {
  PluginSettingsApi(this._settings);
  final PluginSettings _settings;

  /// Get a setting value
  T get<T>(String key, T defaultValue) {
    return _settings.get(key, defaultValue);
  }

  /// Set a setting value
  void set<T>(String key, T value) {
    _settings.set(key, value);
  }

  /// Save settings
  Future<void> save() async {
    await _settings.save();
  }

  /// Load settings
  Future<void> load() async {
    await _settings.load();
  }

  /// Get all settings as a map
  Map<String, dynamic> get allSettings => _settings.allSettings;

  /// Clear all settings
  void clear() {
    _settings.clear();
  }

  /// Check if a setting exists
  bool hasSetting(String key) {
    return _settings.hasSetting(key);
  }

  /// Remove a setting
  void removeSetting(String key) {
    _settings.removeSetting(key);
  }
}

/// Settings page builder for plugins
typedef SettingsPageBuilder = Widget Function(
  BuildContext context,
  PluginSettingsApi settings,
);

/// Plugin settings page definition
class PluginSettingsPage {
  const PluginSettingsPage({
    required this.title,
    required this.builder,
    this.icon,
    this.category,
  });

  final String title;
  final SettingsPageBuilder builder;
  final IconData? icon;
  final String? category;
}

/// Settings registry for plugins
class PluginSettingsRegistry {
  final Map<String, PluginSettingsPage> _settingsPages = {};
  final Map<String, List<String>> _pluginSettings = {};

  /// Register a settings page for a plugin
  void registerSettingsPage(String pluginId, PluginSettingsPage page) {
    final pageId = '$pluginId.${page.title.toLowerCase().replaceAll(' ', '_')}';
    _settingsPages[pageId] = page;
    _pluginSettings.putIfAbsent(pluginId, () => []).add(pageId);
  }

  /// Unregister all settings pages for a plugin
  void unregisterPluginSettings(String pluginId) {
    final pageIds = _pluginSettings[pluginId];
    if (pageIds != null) {
      for (final pageId in pageIds) {
        _settingsPages.remove(pageId);
      }
      _pluginSettings.remove(pluginId);
    }
  }

  /// Get a settings page by ID
  PluginSettingsPage? getSettingsPage(String pageId) {
    return _settingsPages[pageId];
  }

  /// Get all settings pages
  Map<String, PluginSettingsPage> get settingsPages =>
      Map.unmodifiable(_settingsPages);

  /// Get settings pages by category
  List<PluginSettingsPage> getSettingsPagesByCategory(String category) {
    return _settingsPages.values
        .where((page) => page.category == category)
        .toList();
  }

  /// Get settings pages for a plugin
  List<PluginSettingsPage> getPluginSettingsPages(String pluginId) {
    final pageIds = _pluginSettings[pluginId] ?? [];
    return pageIds
        .map((id) => _settingsPages[id])
        .whereType<PluginSettingsPage>()
        .toList();
  }
}

/// Predefined settings categories
class SettingsCategories {
  static const String general = 'General';
  static const String appearance = 'Appearance';
  static const String editor = 'Editor';
  static const String extensions = 'Extensions';
  static const String advanced = 'Advanced';
}
