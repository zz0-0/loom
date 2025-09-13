import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Settings storage for plugins
class PluginSettings {
  PluginSettings(this.pluginId);
  final String pluginId;
  final Map<String, dynamic> _settings = {};

  /// Get a setting value
  T get<T>(String key, T defaultValue) {
    final value = _settings[key];
    return value is T ? value : defaultValue;
  }

  /// Set a setting value
  void set<T>(String key, T value) {
    _settings[key] = value;
  }

  /// Save settings (persistence would be implemented here)
  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'plugin_settings_$pluginId';
    await prefs.setString(key, jsonEncode(_settings));
  }

  /// Load settings (persistence would be implemented here)
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'plugin_settings_$pluginId';
    final settingsJson = prefs.getString(key);
    if (settingsJson != null) {
      try {
        final decoded = jsonDecode(settingsJson) as Map<String, dynamic>;
        _settings
          ..clear()
          ..addAll(decoded);
      } catch (e) {
        // If parsing fails, keep empty settings
      }
    }
  }

  /// Get all settings as a map
  Map<String, dynamic> get allSettings => Map.unmodifiable(_settings);

  /// Clear all settings
  void clear() {
    _settings.clear();
  }

  /// Check if a setting exists
  bool hasSetting(String key) {
    return _settings.containsKey(key);
  }

  /// Remove a setting
  void removeSetting(String key) {
    _settings.remove(key);
  }
}
