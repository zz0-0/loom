import 'dart:io';

import 'package:flutter/material.dart';
import 'package:loom/common/presentation/widgets/layouts/desktop/core/bottom_bar_registry.dart';
import 'package:loom/features/core/plugin_system/domain/plugin.dart';
import 'package:loom/features/core/plugin_system/presentation/command_api.dart';
import 'package:loom/features/core/plugin_system/presentation/settings_api.dart';
import 'package:loom/features/core/plugin_system/presentation/ui_api.dart';

/// Git Plugin - Provides Git integration and version control features
class GitPlugin implements Plugin {
  @override
  String get id => 'loom.git';

  @override
  String get name => 'Git Integration';

  @override
  String get version => '1.0.0';

  @override
  String get description =>
      'Git version control integration with commit, push, pull, and branch management';

  @override
  String get author => 'Loom Team';

  PluginContext? _context;
  bool _isGitRepository = false;
  String _currentBranch = 'main';
  List<String> _changedFiles = [];

  @override
  Future<void> initialize(PluginContext context) async {
    _context = context;

    // Register UI components
    _registerUIComponents();

    // Register commands
    _registerCommands();

    // Register settings
    _registerSettings();

    // Check if current workspace is a Git repository
    await _checkGitStatus();
  }

  @override
  Future<void> dispose() async {
    // Save settings
    await _context?.settings.save();
  }

  void _registerUIComponents() {
    final uiApi = PluginUIApi(_context!.registry);

    // Register sidebar item for Git panel
    final sidebarItem = PluginUIComponents.createSidebarItem(
      pluginId: id,
      id: 'git',
      icon: Icons.account_tree,
      tooltip: 'Git',
      buildPanel: _buildGitPanel,
    );
    uiApi.registerSidebarItem(id, sidebarItem);

    // Register bottom bar status
    final bottomBarItem = _GitStatusBarItem(
      pluginId: id,
      currentBranch: _currentBranch,
    );
    uiApi.registerBottomBarItem(id, bottomBarItem);
  }

  void _registerCommands() {
    // Git commands
    CommandRegistry()
      ..registerCommand(
        id,
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
        id,
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
        id,
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
        id,
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

  void _registerSettings() {
    final settingsRegistry = PluginSettingsRegistry();
    final settingsPage = PluginSettingsPage(
      title: 'Git',
      category: SettingsCategories.general,
      icon: Icons.account_tree,
      builder: _buildSettingsPage,
    );
    settingsRegistry.registerSettingsPage(id, settingsPage);
  }

  Future<void> _checkGitStatus() async {
    try {
      // Check if we're in a Git repository
      final gitDirResult = await Process.run(
        'git',
        ['rev-parse', '--git-dir'],
        workingDirectory: _context?.settings.get('workspacePath', '.'),
      );

      _isGitRepository = gitDirResult.exitCode == 0;

      if (_isGitRepository) {
        // Get current branch
        final branchResult = await Process.run(
          'git',
          ['rev-parse', '--abbrev-ref', 'HEAD'],
          workingDirectory: _context?.settings.get('workspacePath', '.'),
        );

        if (branchResult.exitCode == 0) {
          _currentBranch = branchResult.stdout.toString().trim();
        }

        // Get changed files
        final statusResult = await Process.run(
          'git',
          ['status', '--porcelain'],
          workingDirectory: _context?.settings.get('workspacePath', '.'),
        );

        if (statusResult.exitCode == 0) {
          final statusLines = statusResult.stdout.toString().split('\n');
          _changedFiles = statusLines
              .where((line) => line.isNotEmpty)
              .map((line) => line.substring(3).trim()) // Remove status codes
              .toList();
        }
      } else {
        _currentBranch = '';
        _changedFiles = [];
      }
    } catch (e) {
      // Git not available or other error
      _isGitRepository = false;
      _currentBranch = '';
      _changedFiles = [];
    }
  }

  Widget? _buildGitPanel(BuildContext context) {
    if (!_isGitRepository) {
      return const Center(
        child: Text('Not a Git repository'),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Branch info
          Row(
            children: [
              const Icon(Icons.account_tree, size: 16),
              const SizedBox(width: 8),
              Text(
                _currentBranch,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Changed files
          Text(
            'Changed Files',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: _changedFiles.length,
              itemBuilder: (context, index) {
                final file = _changedFiles[index];
                return ListTile(
                  dense: true,
                  leading: const Icon(Icons.insert_drive_file, size: 16),
                  title: Text(
                    file,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.add, size: 16),
                        onPressed: () => _stageFile(file),
                        tooltip: 'Stage file',
                      ),
                      IconButton(
                        icon: const Icon(Icons.remove, size: 16),
                        onPressed: () => _unstageFile(file),
                        tooltip: 'Unstage file',
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.check_circle, size: 16),
                  label: const Text('Commit'),
                  onPressed: _showCommitDialog,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.upload, size: 16),
                  label: const Text('Push'),
                  onPressed: _pushChanges,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsPage(BuildContext context, PluginSettingsApi settings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Git Settings',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),

        // Git executable path setting
        TextFormField(
          initialValue: settings.get('gitPath', '/usr/bin/git'),
          decoration: const InputDecoration(
            labelText: 'Git Executable Path',
            hintText: 'Path to git executable',
          ),
          onChanged: (value) => settings.set('gitPath', value),
        ),
        const SizedBox(height: 16),

        // Auto-fetch setting
        SwitchListTile(
          title: const Text('Auto-fetch'),
          subtitle: const Text('Automatically fetch changes from remote'),
          value: settings.get('autoFetch', false),
          onChanged: (value) => settings.set('autoFetch', value),
        ),

        // Default branch setting
        TextFormField(
          initialValue: settings.get('defaultBranch', 'main'),
          decoration: const InputDecoration(
            labelText: 'Default Branch',
            hintText: 'Default branch name for new repositories',
          ),
          onChanged: (value) => settings.set('defaultBranch', value),
        ),
      ],
    );
  }

  Future<void> _handleCommitCommand(
    BuildContext context,
    Map<String, dynamic> args,
  ) async {
    await _showCommitDialog();
  }

  Future<void> _handlePushCommand(
    BuildContext context,
    Map<String, dynamic> args,
  ) async {
    await _pushChanges();
  }

  Future<void> _handlePullCommand(
    BuildContext context,
    Map<String, dynamic> args,
  ) async {
    await _pullChanges();
  }

  Future<void> _handleStatusCommand(
    BuildContext context,
    Map<String, dynamic> args,
  ) async {
    await _showGitStatus();
  }

  Future<void> _stageFile(String file) async {
    try {
      final result = await Process.run(
        'git',
        ['add', file],
        workingDirectory: _context?.settings.get('workspacePath', '.'),
      );

      if (result.exitCode == 0) {
        // Refresh status after staging
        await _checkGitStatus();
      } else {}
    } catch (e) {
      // Handle error
      debugPrint('Failed to stage file: $e');
    }
  }

  Future<void> _unstageFile(String file) async {
    try {
      final result = await Process.run(
        'git',
        ['reset', 'HEAD', file],
        workingDirectory: _context?.settings.get('workspacePath', '.'),
      );

      if (result.exitCode == 0) {
        // Refresh status after unstaging
        await _checkGitStatus();
      } else {}
    } catch (e) {
      // Handle error
      debugPrint('Failed to unstage file: $e');
    }
  }

  Future<void> _showCommitDialog() async {
    // For now, use a simple default commit message
    // In a real implementation, this would show a dialog
    const commitMessage = 'Updated files';

    try {
      final result = await Process.run(
        'git',
        ['commit', '-m', commitMessage],
        workingDirectory: _context?.settings.get('workspacePath', '.'),
      );

      if (result.exitCode == 0) {
        // Refresh status after commit
        await _checkGitStatus();
      } else {}
    } catch (e) {
      // Handle error
      debugPrint('Failed to commit changes: $e');
    }
  }

  Future<void> _pushChanges() async {
    try {
      final result = await Process.run(
        'git',
        ['push'],
        workingDirectory: _context?.settings.get('workspacePath', '.'),
      );

      if (result.exitCode == 0) {
      } else {}
    } catch (e) {
      // Handle error
      debugPrint('Failed to push changes: $e');
    }
  }

  Future<void> _pullChanges() async {
    try {
      final result = await Process.run(
        'git',
        ['pull'],
        workingDirectory: _context?.settings.get('workspacePath', '.'),
      );

      if (result.exitCode == 0) {
        // Refresh status after pull
        await _checkGitStatus();
      } else {}
    } catch (e) {
      // Handle error
      debugPrint('Failed to pull changes: $e');
    }
  }

  Future<void> _showGitStatus() async {
    try {
      final result = await Process.run(
        'git',
        ['status', '--porcelain'],
        workingDirectory: _context?.settings.get('workspacePath', '.'),
      );

      if (result.exitCode == 0) {
        final statusOutput = result.stdout.toString();
        if (statusOutput.isEmpty) {
        } else {
          final lines = statusOutput.split('\n');
          for (final line in lines) {
            if (line.isNotEmpty) {}
          }
        }
      } else {}
    } catch (e) {
      // Handle error
      debugPrint('Failed to get git status: $e');
    }
  }

  @override
  void onEditorLoad() {
    // Plugin-specific initialization when editor loads
  }

  @override
  void onActivate() {
    // Plugin activation logic
  }

  @override
  void onDeactivate() {
    // Plugin deactivation logic
  }

  @override
  void onFileOpen(String path) {
    // Handle file open events
    // Could update Git status, etc.
  }

  @override
  void onWorkspaceChange(String workspacePath) {
    // Handle workspace change events
    // Could check if new workspace is a Git repository
    _checkGitStatus();
  }
}

/// Git status bar item for bottom bar
class _GitStatusBarItem extends BottomBarItem {
  _GitStatusBarItem({
    required this.pluginId,
    required this.currentBranch,
  });

  final String pluginId;
  final String currentBranch;

  @override
  String get id => 'git_status';

  @override
  int get priority => 10;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.account_tree, size: 14),
          const SizedBox(width: 4),
          Text(
            currentBranch,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
