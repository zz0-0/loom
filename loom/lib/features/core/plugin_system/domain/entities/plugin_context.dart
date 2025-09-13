import 'package:flutter/material.dart';
import 'package:loom/features/core/plugin_system/domain/entities/plugin_event_bus.dart';
import 'package:loom/features/core/plugin_system/domain/entities/plugin_permissions.dart';
import 'package:loom/features/core/plugin_system/domain/entities/plugin_registry.dart';
import 'package:loom/features/core/plugin_system/domain/entities/plugin_settings.dart';

/// Context provided to plugins during initialization
class PluginContext {
  const PluginContext({
    required this.registry,
    required this.settings,
    required this.eventBus,
    required this.permissions,
    required this.theme,
  });

  /// Registry for registering UI components
  final PluginRegistry registry;

  /// Settings storage for the plugin
  final PluginSettings settings;

  /// Event bus for plugin communication
  final PluginEventBus eventBus;

  /// Permission manager
  final PluginPermissions permissions;

  /// Current theme data
  final ThemeData theme;
}
