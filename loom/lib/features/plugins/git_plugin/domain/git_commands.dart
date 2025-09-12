import 'package:flutter/material.dart';
import 'package:loom/features/core/plugin_system/index.dart';
import 'package:loom/features/plugins/git_plugin/index.dart';

/// Handles command registration and execution for the Git plugin
class GitCommands {
  GitCommands({
    required this.pluginId,
    required this.operations,
    required this.statusManager,
  });

  final String pluginId;
  final GitOperations operations;
  final GitStatusManager statusManager;

  /// Register Git commands with the command system
  void registerCommands() {
    CommandRegistry()
      ..registerCommand(
        pluginId,
        Command(
          id: 'git.commit',
          title: 'Commit Changes',
          description: 'Commit staged changes with a message',
          icon: Icons.check_circle,
          shortcut: 'Ctrl+Enter',
          category: CommandCategories.file,
          handler: _handleCommitCommand,
        ),
      )
      ..registerCommand(
        pluginId,
        Command(
          id: 'git.push',
          title: 'Push Changes',
          description: 'Push committed changes to remote repository',
          icon: Icons.upload,
          shortcut: 'Ctrl+Shift+P',
          category: CommandCategories.file,
          handler: _handlePushCommand,
        ),
      )
      ..registerCommand(
        pluginId,
        Command(
          id: 'git.pull',
          title: 'Pull Changes',
          description: 'Pull latest changes from remote repository',
          icon: Icons.download,
          shortcut: 'Ctrl+Shift+L',
          category: CommandCategories.file,
          handler: _handlePullCommand,
        ),
      )
      ..registerCommand(
        pluginId,
        Command(
          id: 'git.status',
          title: 'Git Status',
          description: 'Show current Git status',
          icon: Icons.info,
          shortcut: 'Ctrl+Shift+S',
          category: CommandCategories.view,
          handler: _handleStatusCommand,
        ),
      );
  }

  Future<void> _handleCommitCommand(
    BuildContext context,
    Map<String, dynamic> args,
  ) async {
    await _showCommitDialog(context);
  }

  Future<void> _handlePushCommand(
    BuildContext context,
    Map<String, dynamic> args,
  ) async {
    await operations.pushChanges();
  }

  Future<void> _handlePullCommand(
    BuildContext context,
    Map<String, dynamic> args,
  ) async {
    final success = await operations.pullChanges();
    if (success) {
      await statusManager.refreshStatus();
    }
  }

  Future<void> _handleStatusCommand(
    BuildContext context,
    Map<String, dynamic> args,
  ) async {
    final status = await operations.getStatus();
    if (status != null) {
      // In a real implementation, this would show a dialog or update UI
      debugPrint('Git status: $status');
    }
  }

  Future<void> _showCommitDialog(BuildContext context) async {
    // For now, use a simple default commit message
    // In a real implementation, this would show a dialog
    const commitMessage = 'Updated files';

    final success = await operations.commitChanges(commitMessage);
    if (success) {
      await statusManager.refreshStatus();
    }
  }
}
