import 'package:flutter/material.dart';

/// Command handler function type
typedef CommandHandler = Future<void> Function(
    BuildContext context, Map<String, dynamic> args,);

/// Command definition
class Command {
  const Command({
    required this.id,
    required this.title,
    required this.handler,
    this.description,
    this.icon,
    this.shortcut,
    this.category,
    this.when,
  });

  final String id;
  final String title;
  final CommandHandler handler;
  final String? description;
  final IconData? icon;
  final String? shortcut;
  final String? category;
  final String? when; // Condition when command is available
}

/// Command registry for plugins
class CommandRegistry {
  final Map<String, Command> _commands = {};
  final Map<String, List<String>> _pluginCommands = {};

  /// Register a command for a plugin
  void registerCommand(String pluginId, Command command) {
    _commands[command.id] = command;
    _pluginCommands.putIfAbsent(pluginId, () => []).add(command.id);
  }

  /// Unregister all commands for a plugin
  void unregisterPluginCommands(String pluginId) {
    final commandIds = _pluginCommands[pluginId];
    if (commandIds != null) {
      for (final commandId in commandIds) {
        _commands.remove(commandId);
      }
      _pluginCommands.remove(pluginId);
    }
  }

  /// Get a command by ID
  Command? getCommand(String commandId) {
    return _commands[commandId];
  }

  /// Get all commands
  Map<String, Command> get commands => Map.unmodifiable(_commands);

  /// Get commands by category
  List<Command> getCommandsByCategory(String category) {
    return _commands.values.where((cmd) => cmd.category == category).toList();
  }

  /// Execute a command
  Future<void> executeCommand(
    String commandId,
    BuildContext context, [
    Map<String, dynamic> args = const {},
  ]) async {
    final command = _commands[commandId];
    if (command != null) {
      await command.handler(context, args);
    }
  }

  /// Check if a command is available
  bool isCommandAvailable(String commandId) {
    return _commands.containsKey(commandId);
  }
}

/// Command palette for quick command access
class CommandPalette {

  CommandPalette(this._registry);
  final CommandRegistry _registry;

  /// Get filtered commands based on search query
  List<Command> getFilteredCommands(String query) {
    if (query.isEmpty) {
      return _registry.commands.values.toList();
    }

    final lowerQuery = query.toLowerCase();
    return _registry.commands.values.where((command) {
      return command.title.toLowerCase().contains(lowerQuery) ||
          (command.description?.toLowerCase().contains(lowerQuery) ?? false);
    }).toList();
  }

  /// Execute command by ID
  Future<void> executeCommand(
    String commandId,
    BuildContext context, [
    Map<String, dynamic> args = const {},
  ]) async {
    await _registry.executeCommand(commandId, context, args);
  }
}

/// Predefined command categories
class CommandCategories {
  static const String file = 'File';
  static const String edit = 'Edit';
  static const String view = 'View';
  static const String navigation = 'Navigation';
  static const String search = 'Search';
  static const String tools = 'Tools';
  static const String help = 'Help';
}
