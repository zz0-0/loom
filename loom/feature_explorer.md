### 1. Overview

This document outlines the design and specification for the File Explorer component of the Markdown Editor application. The primary goal is to create a user-centric workspace that provides a focused writing experience while maintaining full transparency and interoperability with the native filesystem.

### 2. Design Philosophy & Core Principles

1.  **Filesystem Transparency:** The user's data must remain as standard markdown or our new defined Blox files in a standard directory structure. The application is a lens through which to view and manage these files, not a cage for them.
2.  **User Autonomy:** The user is always in control. The application will provide intelligent defaults but will offer settings to override them for power users.
3.  **Focus:** The default interface should be clean and minimal, reducing cognitive load for the writer.
4.  **Abstraction through Metadata, not Obfuscation:** Advanced features will be implemented via non-destructive metadata files, never by altering the core structure or content of the user's markdown files.

### 3. Key Features & Functionality

#### 3.1. Workspace Concept
- Users will be prompted to select a root directory upon first launch ("Create/Open Project").
- This directory becomes the "Workspace." All operations within the custom explorer are scoped to this directory.
- Users can open individual files from anywhere on the system via `File > Open` (`Ctrl+O`), which will not activate the workspace-specific features.

#### 3.2. Dual-Perspective Sidebar
The application sidebar will feature two distinct, switchable views:

1.  **File System Explorer (Icon: `📁`):**
    - **Purpose:** To display the ground-truth, unaltered hierarchy of the workspace directory.
    - **Filtering:** By default, only files with supported extensions (e.g., `.md`, `.markdown`, `.blox`) are displayed. This is user-configurable via a setting.
    - **Interaction:** Standard file/folder interactions (click to select, double-click to open). Right-click context menu for `New File`, `New Folder`, `Rename`, `Delete`, `Reveal in System Explorer`.
    - **Handling Unsupported Files:** If the filter is disabled and an unsupported file is clicked, the editor pane will display a clear message: "File type not supported." with an optional `Open with Default Application` button.

2.  **Collections / Workspace View (Icon: `⭐` or `🗂️`):**
    - **Purpose:** To provide a customized, task-oriented view of the workspace, independent of the filesystem structure.
    - **Content:** Built from data in `project.json`. Includes features like:
        - **Virtual Groups:** User-defined collections of files (e.g., "Research," "Urgent") that link to files across different filesystem folders.
        - **Custom Sorting:** Manual ordering of files within a view.
        - **Pinned Files:** Quick access to important files.
    - **Persistence:** The state of this view (selected tab, expanded items) is saved per-workspace.

#### 3.3. Configuration & Settings
A **Settings** panel will allow users to configure explorer behavior:
- **`Default Sidebar View`:** Choose which view (File System or Collections) is active on startup.
- **`File Extension Filter`:** Toggle the default filtering of non-markdown files in the File System Explorer view.
- **`Reveal Hidden Files`:** Toggle the display of system-hidden files (e.g., `.git`, `.DS_Store`).

### 4. Data Architecture & Persistence

#### 4.1. `settings.json` (User Configuration)
- **Location:** `[OS-Specific App Data Directory]/[App Name]/settings.json`
- **Purpose:** Stores user-specific application preferences that are global and not tied to any single workspace.
- **Proposed Structure:**
```json
{
  "ui": {
    "theme": "dark",
    "fontSize": 14,
    "defaultSidebarView": "filesystem" // or "collections"
  },
  "explorer": {
    "filterFileExtensions": true,
    "showHiddenFiles": false
  },
  "editor": {
    "wordWrap": true
  }
}
```

#### 4.2. `project.json` (Workspace Metadata)
- **Location:** `[Workspace Root Directory]/.myeditorname/project.json`
- **Purpose:** Stores all state and customization data specific to a single workspace. The `.myeditor` directory is hidden.
- **Proposed Structure:**
```json
{
  "version": "1.0",
  "collections": {
    "Inbox": ["inbox/note1.md", "inbox/note2.md"],
    "Project X": ["projects/project_x/plan.md", "meetings/2023-10-26.md"]
  },
  "fileSystemExplorerState": {
    "expandedPaths": ["/", "/projects", "/projects/project_x"],
    "sortedPaths": ["overview.md", "chapter1.md"] // Custom sort for a folder
  },
  "session": {
    "openTabs": ["/home.md", "/projects/project_x/plan.md"],
    "lastActiveFile": "/home.md"
  }
}
```

### 5. Implementation Guidelines

1.  **Data Loading:**
    - On startup, load `settings.json`.
    - When a workspace is opened, load the corresponding `project.json`. If it doesn't exist, initialize a default one.
    - The `File System Explorer` view is populated by recursively reading the workspace directory, applying the filter from `settings.json`.
    - The `Collections` view is populated from the `project.json` file.
2.  **Data Saving:**
    - `settings.json` is saved immediately upon any user change.
    - `project.json` is saved on a debounced timer (e.g., 2 seconds after the last change) and upon application/workspace close to prevent excessive I/O.
3.  **Error Handling:** The application must gracefully handle scenarios where the `project.json` file is corrupt, missing, or contains invalid paths. It should default to a standard filesystem view.

### 6. Advanced Considerations & Enhancement Details

#### 6.1. Error Recovery & Data Integrity

**Orphaned File References:**
- **Detection:** On workspace load, validate all file paths in `project.json` collections against actual filesystem.
- **Resolution Strategies:**
  - **Auto-repair:** For moved files, attempt to locate by filename and content hash within the workspace.
  - **User Notification:** Display a "Missing Files" dialog with options to:
    - Remove from collections
    - Browse to new location
    - Keep as placeholder (grayed out) for potential recovery
- **Backup Strategy:** Maintain `.myeditorname/project.json.backup` with the last known good state.

**Corrupted Metadata Recovery:**
- **Validation:** Use JSON schema validation on load with detailed error reporting.
- **Fallback Modes:**
  1. Attempt to parse partial data (collections only, settings only)
  2. Load from backup if available
  3. Initialize clean state with user confirmation
- **Recovery UI:** Show a recovery dialog explaining what was lost and what was preserved.

#### 6.2. Performance Optimization

**Large Workspace Handling:**
- **Lazy Loading:** Implement progressive directory tree expansion:
  ```
  Initial load: Root level only
  On expand: Load immediate children
  Threshold: Warn user if directory contains >1000 items
  ```
- **Virtual Scrolling:** For directories with many files, render only visible items.
- **Search Indexing:** Maintain a searchable index of file paths and metadata for instant filtering.

**File System Watching:**
- **Strategy:** Use native file watchers (inotify/FSEvents/ReadDirectoryChangesW) with fallback to polling.
- **Throttling:** Batch filesystem events over 100ms windows to prevent UI thrashing.
- **Selective Watching:** Only watch directories currently visible in the explorer to reduce resource usage.

#### 6.3. User Onboarding Experience

**First Launch Flow:**
1. **Welcome Screen:** Brief overview of dual-perspective philosophy
2. **Workspace Creation Options:**
   - "Create New Project" → Empty folder with sample files
   - "Open Existing Folder" → File picker with markdown file detection
   - "Import from..." → Migration helpers for other editors
3. **Initial Setup Wizard:**
   - Default sidebar view preference
   - File extension filter preference
   - Quick tour of key features

**Progressive Disclosure:**
- **Beginner Mode:** Hide advanced features initially (collections, custom sorting)
- **Feature Discovery:** Contextual tooltips and "Did you know?" notifications
- **Migration Assistance:** 
  - Detect common markdown editor patterns (.obsidian, .vscode, _posts)
  - Offer to import folder structures into collections

#### 6.4. Data Migration & Versioning

**Project.json Schema Evolution:**
```json
{
  "version": "1.0",
  "schemaVersion": "2023.1",
  "migrationHistory": ["1.0→2023.1"],
  "collections": { ... }
}
```

**Migration Strategy:**
- **Backward Compatibility:** Support at least 2 previous schema versions
- **Migration Pipeline:** Step-by-step transformations with rollback capability
- **User Consent:** Always ask permission before migrating data structures
- **Migration Log:** Track what changed during migration for user review

**Export/Import Capabilities:**
- **Export Options:** JSON, markdown index, or folder structure recreation
- **Cross-Platform Portability:** Ensure collections work across different OS path separators
- **Backup Integration:** Auto-export project.json to cloud storage if configured

#### 6.5. Advanced File Management

**Bulk Operations:**
- **Multi-select Support:** Ctrl/Cmd+click and Shift+click for range selection
- **Batch Actions:** Move to collection, tag, rename pattern, bulk delete
- **Undo/Redo:** Support for file operations with detailed change descriptions

**File Conflict Resolution:**
- **External Changes:** Detect when files are modified outside the application
- **Merge Conflicts:** When collections reference the same file modified externally
- **Resolution UI:** Side-by-side diff view with merge options

**Smart File Discovery:**
- **Auto-categorization:** Suggest collections based on file location patterns
- **Content Analysis:** Basic markdown parsing to suggest tags or categories
- **Recently Modified:** Smart collections for "Today's work", "This week's files"

