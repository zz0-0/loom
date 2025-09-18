# Git Integration Plugin

A comprehensive Git version control plugin for Loom v2.0 that provides complete Git functionality through the new plugin system.

## Features

- **Repository Management**: Initialize, clone, and manage Git repositories
- **File Operations**: Stage, unstage, and track file changes
- **Version Control**: Commit, push, pull, and merge changes
- **Branch Management**: Create, switch, and manage branches
- **History Tracking**: View commit logs and diffs
- **Status Monitoring**: Real-time Git status and repository state
- **File Support**: Special handling for `.gitignore`, `.gitattributes`, and `.gitmodules`

## Commands

### Repository Commands

#### `git.init`
Initialize a new Git repository in the current workspace.

```json
{
  "commandId": "git.init",
  "args": {}
}
```

#### `git.status`
Get the current Git status including branch, staged files, and changed files.

```json
{
  "commandId": "git.status",
  "args": {}
}
```

### File Operations

#### `git.add`
Stage files for commit. Pass an array of files or use `["."]` for all files.

```json
{
  "commandId": "git.add",
  "args": {
    "files": ["file1.txt", "file2.txt"]
  }
}
```

#### `git.commit`
Commit staged changes with a message.

```json
{
  "commandId": "git.commit",
  "args": {
    "message": "Add new feature implementation"
  }
}
```

### Remote Operations

#### `git.push`
Push committed changes to the remote repository.

```json
{
  "commandId": "git.push",
  "args": {}
}
```

#### `git.pull`
Pull latest changes from the remote repository.

```json
{
  "commandId": "git.pull",
  "args": {}
}
```

### Branch Management

#### `git.branch`
List all branches (local and remote).

```json
{
  "commandId": "git.branch",
  "args": {}
}
```

#### `git.checkout`
Switch to a different branch.

```json
{
  "commandId": "git.checkout",
  "args": {
    "branch": "feature/new-feature"
  }
}
```

### History & Diff

#### `git.log`
Show commit history.

```json
{
  "commandId": "git.log",
  "args": {
    "count": 20
  }
}
```

#### `git.diff`
Show differences between working directory and last commit.

```json
{
  "commandId": "git.diff",
  "args": {
    "file": "specific-file.txt"
  }
}
```

## File Operations

The plugin supports special operations on Git-related files:

### Read/Write/Analyze
- `.gitignore` - Repository ignore rules
- `.gitattributes` - Git attributes configuration
- `.gitmodules` - Git submodules configuration

## Lifecycle Events

The plugin responds to these application events:

- `app.startup`: Plugin initialization
- `app.shutdown`: Plugin cleanup
- `workspace.open`: Repository detection and status refresh
- `workspace.close`: Repository state cleanup
- `file.save`: Potential status updates

## Usage Examples

### Initialize Repository and Make First Commit

```dart
// Initialize Git repository
await PluginManager.instance.executeCommand('git-plugin', 'git.init', {});

// Stage all files
await PluginManager.instance.executeCommand('git-plugin', 'git.add', {
  'files': ['.']
});

// Commit changes
await PluginManager.instance.executeCommand('git-plugin', 'git.commit', {
  'message': 'Initial commit'
});
```

### Check Status and Push Changes

```dart
// Get current status
final status = await PluginManager.instance.executeCommand('git-plugin', 'git.status', {});
print('Current branch: ${status.data['currentBranch']}');
print('Changed files: ${status.data['changedFiles']}');

// Push changes
await PluginManager.instance.executeCommand('git-plugin', 'git.push', {});
```

### Work with Branches

```dart
// List all branches
final branches = await PluginManager.instance.executeCommand('git-plugin', 'git.branch', {});

// Switch to a branch
await PluginManager.instance.executeCommand('git-plugin', 'git.checkout', {
  'branch': 'main'
});
```

## Plugin Architecture

The Git plugin is built using the Loom Plugin System v2.0 with:

- **Isolate-based Execution**: Runs in its own Dart isolate for security and performance
- **IPC Communication**: Uses structured message passing for all operations
- **Lifecycle Management**: Proper initialization, cleanup, and state management
- **Error Handling**: Comprehensive error reporting and recovery
- **Workspace Awareness**: Adapts to workspace changes automatically

## Permissions

The plugin requires these permissions:

- `filesystem.read`: Read repository files and Git status
- `filesystem.write`: Write to repository and create Git files
- `system.command`: Execute Git commands

## Dependencies

- Git command-line tool (must be installed on the system)
- No additional Dart packages required

## Development

To extend or modify the Git plugin:

1. The plugin follows the standard v2.0 plugin structure
2. All Git operations are abstracted through the `_runGitCommand` method
3. Commands are defined in the `commands` getter
4. File operations are handled in `handleFileOperation`
5. Lifecycle events are managed in the lifecycle methods

## Error Handling

The plugin provides detailed error messages for:

- Git command failures
- Repository state issues
- Permission problems
- Network connectivity issues
- Invalid command parameters

All errors are returned as structured `CommandResult` objects with success status, data, and error messages.