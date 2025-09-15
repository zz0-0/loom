import 'package:flutter/material.dart';
import 'package:loom/common/index.dart';
import 'package:loom/features/core/plugin_system/index.dart';
import 'package:loom/features/plugins/git_plugin/index.dart';

/// Handles UI components for the Git plugin
class GitUIComponents {
  GitUIComponents({
    required this.pluginId,
    required this.statusManager,
    required this.operations,
    required this.context,
    this.currentWorkspacePath = '',
  });

  final String pluginId;
  final GitStatusManager statusManager;
  final GitOperations operations;
  final PluginContext context;
  final String currentWorkspacePath;

  /// Register UI components with the plugin system
  void registerComponents() {
    final uiApi = PluginUIApi(context.registry);

    // Register sidebar item for Git panel
    final sidebarItem = PluginUIComponents.createSidebarItem(
      pluginId: pluginId,
      id: 'git',
      icon: Icons.account_tree,
      tooltip: 'Git',
      buildPanel: _buildGitPanel,
    );
    uiApi.registerSidebarItem(pluginId, sidebarItem);

    // Register bottom bar status
    final bottomBarItem = _GitStatusBarItem(
      pluginId: pluginId,
      currentBranch: statusManager.currentBranch,
    );
    uiApi.registerBottomBarItem(pluginId, bottomBarItem);
  }

  Widget? _buildGitPanel(BuildContext context) {
    // Check if workspace is open
    if (currentWorkspacePath.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.folder_open, size: 48, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'No folder open',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Open a folder to use Git version control',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    // Check if it's a Git repository
    if (!statusManager.isGitRepository) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.account_tree, size: 48, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'Not a Git repository',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Initialize Git repository in this folder?',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Initialize Git Repository'),
              onPressed: _initializeGitRepository,
            ),
          ],
        ),
      );
    }

    return Container(
      padding: AppSpacing.paddingMd,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Branch info
          Row(
            children: [
              const Icon(Icons.account_tree, size: 16),
              const SizedBox(width: 8),
              Text(
                statusManager.currentBranch,
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
              itemCount: statusManager.changedFiles.length,
              itemBuilder: (context, index) {
                final file = statusManager.changedFiles[index];
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

  Future<void> _stageFile(String file) async {
    final success = await operations.stageFile(file);
    if (success) {
      await statusManager.refreshStatus();
    }
  }

  Future<void> _unstageFile(String file) async {
    final success = await operations.unstageFile(file);
    if (success) {
      await statusManager.refreshStatus();
    }
  }

  Future<void> _showCommitDialog() async {
    // For now, use a simple default commit message
    // In a real implementation, this would show a dialog
    const commitMessage = 'Updated files';

    final success = await operations.commitChanges(commitMessage);
    if (success) {
      await statusManager.refreshStatus();
    }
  }

  Future<void> _pushChanges() async {
    await operations.pushChanges();
  }

  Future<void> _initializeGitRepository() async {
    final success = await operations.initializeRepository();
    if (success) {
      await statusManager.refreshStatus();
    }
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
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
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
