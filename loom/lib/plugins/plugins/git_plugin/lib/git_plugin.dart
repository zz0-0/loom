import 'dart:io';
import 'dart:isolate';
import 'package:loom/plugins/api/plugin_api.dart';
import 'package:loom/plugins/api/plugin_manifest.dart';

/// Git Integration Plugin for Loom v2.0
/// Provides comprehensive Git version control functionality
class GitPlugin implements Plugin, CommandPlugin, FilePlugin, LifecyclePlugin {
  late PluginManifest _manifest;
  late SendPort _mainSendPort;
  late ReceivePort _receivePort;
  bool _initialized = false;

  String _currentWorkspacePath = '';
  bool _isGitRepository = false;
  String _currentBranch = 'main';
  List<String> _changedFiles = [];
  List<String> _stagedFiles = [];

  @override
  PluginManifest get manifest => _manifest;

  @override
  Future<void> initialize() async {
    if (_initialized) return;

    _log('Initializing Git Integration Plugin v${_manifest.version}');

    // Set up communication
    _receivePort = ReceivePort();
    _receivePort.listen(_handleMessage);

    // Send port back to main isolate
    _mainSendPort.send(_receivePort.sendPort);

    _initialized = true;
    _log('Git Integration Plugin initialized successfully');
  }

  @override
  Future<void> shutdown() async {
    if (!_initialized) return;

    _log('Shutting down Git Integration Plugin');
    _receivePort.close();
    _initialized = false;
  }

  @override
  Future<dynamic> handleMessage(String type, dynamic data) async {
    _log('Received message: $type with data: $data');

    switch (type) {
      case 'command.execute':
        return _handleCommand(data);
      case 'file.operation':
        return _handleFileOperation(data);
      case 'lifecycle.event':
        return _handleLifecycleEvent(data);
      case 'ui.event':
        return _handleUIEvent(data);
      default:
        return {'status': 'unknown_message_type', 'type': type};
    }
  }

  // CommandPlugin implementation
  @override
  List<PluginCommand> get commands => [
        const PluginCommand(
          id: 'git.init',
          name: 'Initialize Git Repository',
          description:
              'Initialize a new Git repository in the current workspace',
          parameters: {},
        ),
        const PluginCommand(
          id: 'git.status',
          name: 'Git Status',
          description: 'Show the current Git status',
          parameters: {},
        ),
        const PluginCommand(
          id: 'git.add',
          name: 'Stage Files',
          description: 'Stage files for commit',
          parameters: {
            'files': CommandParameter(
              name: 'files',
              type: 'array',
              description: 'Files to stage (leave empty for all)',
              required: false,
            ),
          },
        ),
        const PluginCommand(
          id: 'git.commit',
          name: 'Commit Changes',
          description: 'Commit staged changes with a message',
          parameters: {
            'message': CommandParameter(
              name: 'message',
              type: 'string',
              description: 'Commit message',
              required: true,
            ),
          },
        ),
        const PluginCommand(
          id: 'git.push',
          name: 'Push Changes',
          description: 'Push committed changes to remote repository',
          parameters: {},
        ),
        const PluginCommand(
          id: 'git.pull',
          name: 'Pull Changes',
          description: 'Pull latest changes from remote repository',
          parameters: {},
        ),
        const PluginCommand(
          id: 'git.log',
          name: 'Git Log',
          description: 'Show commit history',
          parameters: {
            'count': CommandParameter(
              name: 'count',
              type: 'number',
              description: 'Number of commits to show',
              required: false,
              defaultValue: 10,
            ),
          },
        ),
        const PluginCommand(
          id: 'git.branch',
          name: 'List Branches',
          description: 'List all branches',
          parameters: {},
        ),
        const PluginCommand(
          id: 'git.checkout',
          name: 'Checkout Branch',
          description: 'Switch to a different branch',
          parameters: {
            'branch': CommandParameter(
              name: 'branch',
              type: 'string',
              description: 'Branch name to checkout',
              required: true,
            ),
          },
        ),
        const PluginCommand(
          id: 'git.diff',
          name: 'Show Diff',
          description:
              'Show differences between working directory and last commit',
          parameters: {
            'file': CommandParameter(
              name: 'file',
              type: 'string',
              description: 'Specific file to diff (optional)',
              required: false,
            ),
          },
        ),
      ];

  @override
  Future<CommandResult> executeCommand(
    String commandId,
    Map<String, dynamic> args,
  ) async {
    if (_currentWorkspacePath.isEmpty) {
      return CommandResult.error('No workspace is currently open');
    }

    switch (commandId) {
      case 'git.init':
        return _executeGitInit();
      case 'git.status':
        return _executeGitStatus();
      case 'git.add':
        return _executeGitAdd(args);
      case 'git.commit':
        return _executeGitCommit(args);
      case 'git.push':
        return _executeGitPush();
      case 'git.pull':
        return _executeGitPull();
      case 'git.log':
        return _executeGitLog(args);
      case 'git.branch':
        return _executeGitBranch();
      case 'git.checkout':
        return _executeGitCheckout(args);
      case 'git.diff':
        return _executeGitDiff(args);
      default:
        return CommandResult.error('Unknown Git command: $commandId');
    }
  }

  // FilePlugin implementation
  @override
  List<String> get supportedExtensions =>
      ['.gitignore', '.gitattributes', '.gitmodules'];

  @override
  Future<FileOperationResult> handleFileOperation(
    String operation,
    String filePath,
    dynamic data,
  ) async {
    _log('File operation: $operation on $filePath');

    switch (operation) {
      case 'read':
        return _readGitFile(filePath);
      case 'write':
        return _writeGitFile(filePath, data);
      case 'analyze':
        return _analyzeGitFile(filePath);
      default:
        return FileOperationResult.error('Unsupported operation: $operation');
    }
  }

  // LifecyclePlugin implementation
  @override
  Future<void> onApplicationStart() async {
    _log('Git Integration Plugin started');
  }

  @override
  Future<void> onApplicationClose() async {
    _log('Git Integration Plugin shutting down');
  }

  @override
  Future<void> onWorkspaceOpen(String workspacePath) async {
    _currentWorkspacePath = workspacePath;
    _log('Workspace opened: $workspacePath');

    // Check if it's a Git repository
    await _checkGitRepository();

    // Refresh status
    await _refreshGitStatus();
  }

  @override
  Future<void> onWorkspaceClose(String workspacePath) async {
    _log('Workspace closed: $workspacePath');
    _currentWorkspacePath = '';
    _isGitRepository = false;
    _currentBranch = 'main';
    _changedFiles = [];
    _stagedFiles = [];
  }

  // Private helper methods
  Future<dynamic> _handleCommand(dynamic data) async {
    if (data is Map<String, dynamic>) {
      final commandId = data['commandId'] as String?;
      final args = data['args'] as Map<String, dynamic>? ?? {};

      if (commandId != null) {
        final result = await executeCommand(commandId, args);
        return {
          'success': result.success,
          'data': result.data,
          'error': result.error,
        };
      }
    }
    return {'error': 'Invalid command data'};
  }

  Future<dynamic> _handleFileOperation(dynamic data) async {
    if (data is Map<String, dynamic>) {
      final operation = data['operation'] as String?;
      final filePath = data['filePath'] as String?;
      final fileData = data['data'];

      if (operation != null && filePath != null) {
        final result = await handleFileOperation(operation, filePath, fileData);
        return {
          'success': result.success,
          'newPath': result.newPath,
          'data': result.data,
          'error': result.error,
        };
      }
    }
    return {'error': 'Invalid file operation data'};
  }

  Future<dynamic> _handleLifecycleEvent(dynamic data) async {
    if (data is Map<String, dynamic>) {
      final eventType = data['eventType'] as String?;
      final eventData = data['data'];

      switch (eventType) {
        case 'app.startup':
          await onApplicationStart();
        case 'app.shutdown':
          await onApplicationClose();
        case 'workspace.open':
          final workspacePath = eventData as String?;
          if (workspacePath != null) {
            await onWorkspaceOpen(workspacePath);
          }
        case 'workspace.close':
          final closePath = eventData as String?;
          if (closePath != null) {
            await onWorkspaceClose(closePath);
          }
      }
    }
    return {'status': 'lifecycle_event_handled'};
  }

  Future<dynamic> _handleUIEvent(dynamic data) async {
    if (data is Map<String, dynamic>) {
      final eventType = data['eventType'] as String?;
      _log('UI Event: $eventType with data: $data');
    }
    return {'status': 'ui_event_handled'};
  }

  void _handleMessage(dynamic message) {
    if (message is Map<String, dynamic>) {
      final type = message['type'] as String?;
      final data = message['data'];
      final responsePort = message['responsePort'] as SendPort?;

      if (type != null && responsePort != null) {
        handleMessage(type, data)
            .then(responsePort.send)
            .catchError((Object error) {
          responsePort.send({'error': error.toString()});
        });
      }
    }
  }

  // Git command implementations
  Future<CommandResult> _executeGitInit() async {
    try {
      final result = await _runGitCommand(['init']);
      if (result['success'] == true) {
        await _checkGitRepository();
        return CommandResult.success(
          {'message': 'Git repository initialized successfully'},
        );
      } else {
        return CommandResult.error(
          (result['error'] as String?) ?? 'Failed to initialize Git repository',
        );
      }
    } catch (e) {
      return CommandResult.error('Failed to initialize Git repository: $e');
    }
  }

  Future<CommandResult> _executeGitStatus() async {
    try {
      await _refreshGitStatus();
      return CommandResult.success({
        'isGitRepository': _isGitRepository,
        'currentBranch': _currentBranch,
        'changedFiles': _changedFiles,
        'stagedFiles': _stagedFiles,
      });
    } catch (e) {
      return CommandResult.error('Failed to get Git status: $e');
    }
  }

  Future<CommandResult> _executeGitAdd(Map<String, dynamic> args) async {
    try {
      final files = args['files'] as List<dynamic>? ?? ['.'];
      final fileArgs = files.map((f) => f.toString()).toList();

      final result = await _runGitCommand(['add', ...fileArgs]);
      if (result['success'] == true) {
        await _refreshGitStatus();
        return CommandResult.success({'message': 'Files staged successfully'});
      } else {
        return CommandResult.error(
          (result['error'] as String?) ?? 'Failed to stage files',
        );
      }
    } catch (e) {
      return CommandResult.error('Failed to stage files: $e');
    }
  }

  Future<CommandResult> _executeGitCommit(Map<String, dynamic> args) async {
    try {
      final message = args['message'] as String?;
      if (message == null || message.isEmpty) {
        return CommandResult.error('Commit message is required');
      }

      final result = await _runGitCommand(['commit', '-m', message]);
      if (result['success'] == true) {
        await _refreshGitStatus();
        return CommandResult.success(
          {'message': 'Changes committed successfully'},
        );
      } else {
        return CommandResult.error(
          (result['error'] as String?) ?? 'Failed to commit changes',
        );
      }
    } catch (e) {
      return CommandResult.error('Failed to commit changes: $e');
    }
  }

  Future<CommandResult> _executeGitPush() async {
    try {
      final result = await _runGitCommand(['push']);
      if (result['success'] == true) {
        return CommandResult.success(
          {'message': 'Changes pushed successfully'},
        );
      } else {
        return CommandResult.error(
          (result['error'] as String?) ?? 'Failed to push changes',
        );
      }
    } catch (e) {
      return CommandResult.error('Failed to push changes: $e');
    }
  }

  Future<CommandResult> _executeGitPull() async {
    try {
      final result = await _runGitCommand(['pull']);
      if (result['success'] == true) {
        await _refreshGitStatus();
        return CommandResult.success(
          {'message': 'Changes pulled successfully'},
        );
      } else {
        return CommandResult.error(
          (result['error'] as String?) ?? 'Failed to pull changes',
        );
      }
    } catch (e) {
      return CommandResult.error('Failed to pull changes: $e');
    }
  }

  Future<CommandResult> _executeGitLog(Map<String, dynamic> args) async {
    try {
      final count = args['count'] as int? ?? 10;
      final result =
          await _runGitCommand(['log', '--oneline', '-n', count.toString()]);

      if (result['success'] == true) {
        final logOutput = result['output'] as String? ?? '';
        final commits =
            logOutput.split('\n').where((line) => line.isNotEmpty).toList();
        return CommandResult.success({'commits': commits});
      } else {
        return CommandResult.error(
          (result['error'] as String?) ?? 'Failed to get Git log',
        );
      }
    } catch (e) {
      return CommandResult.error('Failed to get Git log: $e');
    }
  }

  Future<CommandResult> _executeGitBranch() async {
    try {
      final result = await _runGitCommand(['branch', '-a']);
      if (result['success'] == true) {
        final branchOutput = result['output'] as String? ?? '';
        final branches =
            branchOutput.split('\n').where((line) => line.isNotEmpty).toList();
        return CommandResult.success({'branches': branches});
      } else {
        return CommandResult.error(
          (result['error'] as String?) ?? 'Failed to list branches',
        );
      }
    } catch (e) {
      return CommandResult.error('Failed to list branches: $e');
    }
  }

  Future<CommandResult> _executeGitCheckout(Map<String, dynamic> args) async {
    try {
      final branch = args['branch'] as String?;
      if (branch == null || branch.isEmpty) {
        return CommandResult.error('Branch name is required');
      }

      final result = await _runGitCommand(['checkout', branch]);
      if (result['success'] == true) {
        await _refreshGitStatus();
        return CommandResult.success(
          {'message': 'Switched to branch: $branch'},
        );
      } else {
        return CommandResult.error(
          (result['error'] as String?) ?? 'Failed to checkout branch',
        );
      }
    } catch (e) {
      return CommandResult.error('Failed to checkout branch: $e');
    }
  }

  Future<CommandResult> _executeGitDiff(Map<String, dynamic> args) async {
    try {
      final file = args['file'] as String?;
      final command = file != null ? ['diff', file] : ['diff'];

      final result = await _runGitCommand(command);
      if (result['success'] == true) {
        return CommandResult.success({
          'diff': result['output'] as String? ?? '',
        });
      } else {
        return CommandResult.error(
          (result['error'] as String?) ?? 'Failed to get diff',
        );
      }
    } catch (e) {
      return CommandResult.error('Failed to get diff: $e');
    }
  }

  // File operation implementations
  Future<FileOperationResult> _readGitFile(String filePath) async {
    try {
      final content = await File(filePath).readAsString();
      return FileOperationResult.success(data: content);
    } catch (e) {
      return FileOperationResult.error('Failed to read file: $e');
    }
  }

  Future<FileOperationResult> _writeGitFile(
    String filePath,
    dynamic data,
  ) async {
    try {
      final content = data as String? ?? '';
      await File(filePath).writeAsString(content);
      return FileOperationResult.success();
    } catch (e) {
      return FileOperationResult.error('Failed to write file: $e');
    }
  }

  Future<FileOperationResult> _analyzeGitFile(String filePath) async {
    try {
      final content = await File(filePath).readAsString();
      final analysis = {
        'file': filePath,
        'size': content.length,
        'lines': content.split('\n').length,
        'type': filePath.split('.').last,
      };
      return FileOperationResult.success(data: analysis);
    } catch (e) {
      return FileOperationResult.error('Failed to analyze file: $e');
    }
  }

  // Git utility methods
  Future<Map<String, dynamic>> _runGitCommand(List<String> args) async {
    if (_currentWorkspacePath.isEmpty) {
      return {'success': false, 'error': 'No workspace is currently open'};
    }

    try {
      final result = await Process.run(
        'git',
        args,
        workingDirectory: _currentWorkspacePath,
      );

      return {
        'success': result.exitCode == 0,
        'output': result.stdout.toString(),
        'error': result.stderr.toString(),
        'exitCode': result.exitCode,
      };
    } catch (e) {
      return {'success': false, 'error': 'Failed to execute Git command: $e'};
    }
  }

  Future<void> _checkGitRepository() async {
    if (_currentWorkspacePath.isEmpty) {
      _isGitRepository = false;
      return;
    }

    try {
      final result = await _runGitCommand(['rev-parse', '--git-dir']);
      _isGitRepository = result['success'] == true;
    } catch (e) {
      _isGitRepository = false;
    }
  }

  Future<void> _refreshGitStatus() async {
    if (!_isGitRepository || _currentWorkspacePath.isEmpty) {
      _currentBranch = 'main';
      _changedFiles = [];
      _stagedFiles = [];
      return;
    }

    try {
      // Get current branch
      final branchResult =
          await _runGitCommand(['rev-parse', '--abbrev-ref', 'HEAD']);
      if (branchResult['success'] == true) {
        _currentBranch = (branchResult['output'] as String).trim();
      }

      // Get status
      final statusResult = await _runGitCommand(['status', '--porcelain']);
      if (statusResult['success'] == true) {
        final statusLines = (statusResult['output'] as String).split('\n');
        _changedFiles = [];
        _stagedFiles = [];

        for (final line in statusLines) {
          if (line.isNotEmpty && line.length >= 3) {
            final status = line.substring(0, 2);
            final file = line.substring(3).trim();

            if (status[0] != ' ') {
              _stagedFiles.add(file);
            }
            if (status[1] != ' ') {
              _changedFiles.add(file);
            }
          }
        }
      }
    } catch (e) {
      _log('Failed to refresh Git status: $e');
    }
  }

  void _log(String message) {
    // Send log message to main isolate
    _mainSendPort.send({
      'type': 'log',
      'data': '[GitPlugin] $message',
    });
  }
}

/// Factory function to create the Git plugin instance
Plugin createGitPlugin(PluginManifest manifest, SendPort mainSendPort) {
  final plugin = GitPlugin()
    .._manifest = manifest
    .._mainSendPort = mainSendPort;
  return plugin;
}
