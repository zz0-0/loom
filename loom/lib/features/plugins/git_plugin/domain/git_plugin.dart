import 'package:loom/features/core/plugin_system/index.dart';
import 'package:loom/features/plugins/git_plugin/index.dart';

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
  late GitStatusManager _statusManager;
  late GitOperations _operations;
  late GitUIComponents _uiComponents;
  late GitCommands _commands;
  late GitSettings _settings;
  String _currentWorkspacePath = '';

  @override
  Future<void> initialize(PluginContext context) async {
    _context = context;

    // Don't initialize with a default workspace path
    // Wait for workspace change notification
    _statusManager =
        GitStatusManager('.'); // Temporary, will be updated on workspace change
    _operations =
        GitOperations('.'); // Temporary, will be updated on workspace change
    _uiComponents = GitUIComponents(
      pluginId: id,
      statusManager: _statusManager,
      operations: _operations,
      context: context,
    );
    _commands = GitCommands(
      pluginId: id,
      operations: _operations,
      statusManager: _statusManager,
    );
    _settings = GitSettings(id, context);

    // Register UI components
    _uiComponents.registerComponents();

    // Register commands
    _commands.registerCommands();

    // Register settings
    _settings.registerSettings();

    // Don't check git status initially - wait for workspace
  }

  @override
  Future<void> dispose() async {
    // Save settings
    await _context?.settings.save();
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
    _currentWorkspacePath = workspacePath;
    if (workspacePath.isNotEmpty) {
      _statusManager = GitStatusManager(workspacePath);
      _operations = GitOperations(workspacePath);
      _statusManager.checkGitStatus();
    } else {
      // No workspace open - don't do git operations
      _statusManager = GitStatusManager('.');
      _operations = GitOperations('.');
      // Don't check git status when no workspace
    }

    // Update UI components with new workspace path
    if (_context != null) {
      _uiComponents = GitUIComponents(
        pluginId: id,
        statusManager: _statusManager,
        operations: _operations,
        context: _context!,
        currentWorkspacePath: _currentWorkspacePath,
      );
      // Re-register UI components to update the panel
      _uiComponents.registerComponents();
    }
  }
}
