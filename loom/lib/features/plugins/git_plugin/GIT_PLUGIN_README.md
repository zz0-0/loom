# Git Plugin for Loom

A comprehensive Git integration plugin that demonstrates the enhanced plugin system capabilities in Loom.

## Features

### Core Git Functionality
- **Git Status Panel**: Sidebar panel showing current branch, changed files, and repository status
- **File Management**: Stage and unstage individual files with visual indicators
- **Commit Interface**: User-friendly commit dialog with message input
- **Push/Pull Operations**: Direct integration with remote repositories
- **Branch Management**: Display and switch between branches

### Plugin System Integration
- **Command System**: Keyboard shortcuts for common Git operations
  - `Ctrl+Enter`: Commit changes
  - `Ctrl+Shift+P`: Push changes
  - `Ctrl+Shift+L`: Pull changes
  - `Ctrl+Shift+S`: Show Git status
- **UI Components**: Registers sidebar panel and bottom bar status indicator
- **Settings Integration**: Plugin-specific settings page
- **Event Handling**: Responds to file open and workspace change events

### Data Persistence
- **Settings Storage**: Plugin settings persisted using shared_preferences
- **Metadata Storage**: Git repository metadata and user preferences
- **Permission Management**: Granular permission system for plugin capabilities

## Architecture

The Git plugin follows Clean Architecture principles and demonstrates:

### Domain Layer
- `GitPlugin`: Main plugin implementation
- Plugin lifecycle management
- Business logic for Git operations

### Presentation Layer
- `GitPluginExample`: Demonstration widget
- UI components for Git operations
- Settings page integration

### Data Layer
- Repository pattern for Git operations
- Settings persistence
- File system integration

## Usage

### Registration
```dart
import 'package:loom/features/git_plugin/domain/git_plugin_registration.dart';

// Register the plugin
await GitPluginRegistration.register(context);
```

### Plugin Features
Once registered, the Git plugin provides:

1. **Sidebar Panel**: Access via the Git icon in the sidebar
2. **Bottom Bar**: Shows current branch status
3. **Commands**: Use keyboard shortcuts or command palette
4. **Settings**: Configure Git preferences in settings

## Plugin System Capabilities Demonstrated

### 1. UI Registration
```dart
// Register sidebar item
uiApi.registerSidebarItem(id, sidebarItem);

// Register bottom bar item
uiApi.registerBottomBarItem(id, bottomBarItem);
```

### 2. Command Registration
```dart
// Register Git commands with shortcuts
commandRegistry.registerCommand(id, Command(
  id: 'git.commit',
  title: 'Commit Changes',
  shortcut: 'Ctrl+Enter',
  handler: _handleCommitCommand,
));
```

### 3. Settings Integration
```dart
// Register settings page
settingsRegistry.registerSettingsPage(id, settingsPage);
```

### 4. Data Persistence
```dart
// Settings automatically persisted
await _context?.settings.save();
```

### 5. Event Handling
```dart
// Respond to workspace changes
@override
void onWorkspaceChange(String workspacePath) {
  _checkGitStatus();
}
```

## Development Status

### Implemented ✅
- Plugin architecture and lifecycle
- UI component registration
- Command system with shortcuts
- Settings integration
- Data persistence layer
- Event handling framework

### TODO 🚧
- Actual Git command execution (currently simulated)
- Branch switching UI
- Conflict resolution interface
- Git history visualization
- Remote repository management

## File Structure

```
lib/features/git_plugin/
├── domain/
│   ├── git_plugin.dart              # Main plugin implementation
│   └── git_plugin_registration.dart # Plugin registration utility
├── presentation/
│   └── git_plugin_example.dart      # Usage demonstration
└── data/
    └── (future Git repositories)
```

## Dependencies

- `shared_preferences`: For data persistence
- Flutter core libraries
- Plugin system APIs

## Testing

The plugin includes comprehensive examples and can be tested by:

1. Running the example app
2. Registering the Git plugin
3. Accessing Git features via sidebar and commands
4. Verifying settings persistence

## Future Enhancements

- Real Git command execution using `git` CLI
- Advanced Git operations (rebase, merge, etc.)
- Git history timeline visualization
- Collaboration features (PR reviews, etc.)
- Integration with Git hosting services (GitHub, GitLab)

## Contributing

This plugin serves as a template for building other plugins. Key patterns to follow:

1. Implement the `Plugin` interface
2. Use the provided APIs for UI, commands, and settings
3. Follow Clean Architecture principles
4. Handle plugin lifecycle properly
5. Provide comprehensive error handling

## Related Files

- `lib/features/plugin_system/`: Core plugin system APIs
- `lib/shared/presentation/widgets/layouts/desktop/core/`: UI registries
- `lib/features/plugin_system/data/plugin_repositories.dart`: Data persistence
