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

  @override
  Future<void> initialize(PluginContext context) async {
    _context = context;

    // Initialize services
    final workspacePath = context.settings.get('workspacePath', '.');
    _statusManager = GitStatusManager(workspacePath);
    _operations = GitOperations(workspacePath);
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

    // Check if current workspace is a Git repository
    await _statusManager.checkGitStatus();
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
    // Could check if new workspace is a Git repository
    _statusManager = GitStatusManager(workspacePath);
    _operations = GitOperations(workspacePath);
    _statusManager.checkGitStatus();
  }
}
