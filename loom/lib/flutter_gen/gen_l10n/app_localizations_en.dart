import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Loom - Knowledge Base';

  @override
  String get uiPolishShowcase => 'UI Polish Showcase';

  @override
  String get enhancedUiAnimations => 'Enhanced UI Animations';

  @override
  String get loadingIndicators => 'Loading Indicators';

  @override
  String get smoothLoading => 'Smooth Loading';

  @override
  String get skeletonLoader => 'Skeleton Loader';

  @override
  String get interactiveElements => 'Interactive Elements';

  @override
  String get hoverAnimation => 'Hover Animation';

  @override
  String get pressAnimation => 'Press Animation';

  @override
  String get pulseAnimation => 'Pulse Animation';

  @override
  String get shimmerEffects => 'Shimmer Effects';

  @override
  String get successAnimations => 'Success Animations';

  @override
  String get taskCompleted => 'Task Completed!';

  @override
  String get animationCombinations => 'Animation Combinations';

  @override
  String get interactiveButton => 'Interactive Button';

  @override
  String get animatedCard => 'Animated Card';

  @override
  String get animatedCardDescription => 'This card demonstrates fade-in and slide-in animations combined.';

  @override
  String get general => 'General';

  @override
  String get generalDescription => 'General preferences and application behavior';

  @override
  String get autoSave => 'Auto Save';

  @override
  String get autoSaveDescription => 'Automatically save changes at regular intervals';

  @override
  String get confirmOnExit => 'Confirm on Exit';

  @override
  String get confirmOnExitDescription => 'Ask for confirmation when closing with unsaved changes';

  @override
  String get language => 'Language';

  @override
  String get languageDescription => 'Application language';

  @override
  String get followSystemLanguage => 'Follow system language';

  @override
  String get manualLanguageSelection => 'Manual language selection';

  @override
  String get english => 'English';

  @override
  String get spanish => 'Español';

  @override
  String get french => 'Français';

  @override
  String get german => 'Deutsch';

  @override
  String get chinese => 'Chinese';

  @override
  String get japanese => 'Japanese';

  @override
  String get korean => 'Korean';

  @override
  String get autoSaveInterval => 'Auto-save Interval';

  @override
  String lastSaved(Object time) {
    return 'Last saved: ';
  }

  @override
  String get justNow => 'just now';

  @override
  String minutesAgo(int count) {
    return '${count}m ago';
  }

  @override
  String hoursAgo(int count) {
    return '${count}h ago';
  }

  @override
  String daysAgo(int count) {
    return '${count}d ago';
  }

  @override
  String get commandExecutedSuccessfully => 'Command executed successfully';

  @override
  String commandFailed(String error) {
    return 'Command failed: $error';
  }

  @override
  String failedToExecuteCommand(String error) {
    return 'Failed to execute command: $error';
  }

  @override
  String get about => 'About';

  @override
  String get aboutDescription => 'Information about Loom';

  @override
  String get version => 'Version';

  @override
  String get licenses => 'Licenses';

  @override
  String get viewOpenSourceLicenses => 'View open source licenses';

  @override
  String get loom => 'Loom';

  @override
  String get build => 'Build';

  @override
  String get loomDescription => 'Loom is a modern code editor built with Flutter, designed for productivity and ease of use.';

  @override
  String get copyright => '© 2024 Loom Team';

  @override
  String get close => 'Close';

  @override
  String get openSourceLicenses => 'Open Source Licenses';

  @override
  String get usesFollowingLibraries => 'Loom uses the following open source libraries:';

  @override
  String get fullLicenseTexts => 'For full license texts, please visit the respective folder repositories on GitHub.';

  @override
  String get enterPath => 'Enter Path';

  @override
  String get directoryPath => 'Directory Path';

  @override
  String get pathHint => '/home/user/folder';

  @override
  String get cancel => 'Cancel';

  @override
  String get go => 'Go';

  @override
  String get select => 'Select';

  @override
  String get apply => 'Apply';

  @override
  String get preview => 'Preview';

  @override
  String selectColorLabel(String label) {
    return 'Select $label Color';
  }

  @override
  String get fontFamilyLabel => 'Font Family';

  @override
  String get fontSizeLabel => 'Font Size';

  @override
  String get previewSampleText => 'Preview: The quick brown fox jumps over the lazy dog';

  @override
  String get searchFilesAndCommands => 'Search files and commands...';

  @override
  String get commandKeyShortcut => '⌘K';

  @override
  String get menu => 'Menu';

  @override
  String get file => 'File';

  @override
  String get newFile => 'New File';

  @override
  String get openFolder => 'Open Folder';

  @override
  String get save => 'Save';

  @override
  String get saveAs => 'Save As';

  @override
  String get export => 'Export';

  @override
  String get exit => 'Exit';

  @override
  String get edit => 'Edit';

  @override
  String get undo => 'Undo';

  @override
  String get redo => 'Redo';

  @override
  String get cut => 'Cut';

  @override
  String get copy => 'Copy';

  @override
  String get paste => 'Paste';

  @override
  String get view => 'View';

  @override
  String get toggleSidebar => 'Toggle Sidebar';

  @override
  String get togglePanel => 'Toggle Panel';

  @override
  String get fullScreen => 'Full Screen';

  @override
  String get help => 'Help';

  @override
  String get documentation => 'Documentation';

  @override
  String get plugins => 'Plugins';

  @override
  String get pluginManager => 'Plugin Manager';

  @override
  String get noPluginsLoaded => 'No plugins loaded';

  @override
  String get openFolderFirst => 'Please open a folder first to create a new file';

  @override
  String get noFileOpenToSave => 'No file is currently open to save';

  @override
  String fileSaved(String filename) {
    return 'File \"$filename\" saved';
  }

  @override
  String get noContentToExport => 'No content to export';

  @override
  String get exitApplication => 'Exit Application';

  @override
  String get confirmExit => 'Are you sure you want to exit Loom?';

  @override
  String get openInNewTab => 'Open in New Tab';

  @override
  String get rename => 'Rename';

  @override
  String get delete => 'Delete';

  @override
  String get deleteItem => 'Delete Item';

  @override
  String get cancelButton => 'Cancel';

  @override
  String get enterPathPrompt => 'Enter the path to the folder you want to open:';

  @override
  String get folderPathLabel => 'Folder Path';

  @override
  String get folderPathHint => 'Enter folder path (e.g., /workspaces/my-folder)';

  @override
  String get enterFolderNameHint => 'Enter folder name';

  @override
  String get browse => 'Browse';

  @override
  String get selectFolderLocation => 'Select Folder Location';

  @override
  String failedToSelectLocation(String error) {
    return 'Failed to select location: $error';
  }

  @override
  String folderCreatedSuccess(String folderName) {
    return 'Folder \"$folderName\" created successfully!';
  }

  @override
  String failedToCreateFolder(String error) {
    return 'Failed to create folder: $error';
  }

  @override
  String get enterFileNameHint => 'Enter file name (e.g., main.dart)';

  @override
  String get enterInitialFileContentHint => 'Enter initial file content...';

  @override
  String get enterNewNameHint => 'Enter new name';

  @override
  String get closeFolder => 'Close Folder';

  @override
  String get openFolderMenu => 'Open Folder';

  @override
  String get createFolder => 'Create Folder';

  @override
  String get filterFileExtensions => 'Filter File Extensions';

  @override
  String get showHiddenFiles => 'Show Hidden Files';

  @override
  String failedToOpenFolder(String error) {
    return 'Failed to open folder: $error';
  }

  @override
  String failedToCreateFile(String error) {
    return 'Failed to create file: $error';
  }

  @override
  String failedToDeleteItem(String error) {
    return 'Failed to delete item: $error';
  }

  @override
  String failedToRenameItem(String error) {
    return 'Failed to rename item: $error';
  }

  @override
  String renameSuccess(String name) {
    return 'Renamed to $name';
  }

  @override
  String deleteSuccess(String itemType) {
    return '$itemType deleted successfully';
  }

  @override
  String get searchFilesHint => 'Search files...';

  @override
  String get newFolderPlaceholder => 'new-folder';

  @override
  String get openInNewTabLabel => 'Open in New Tab';

  @override
  String get closeLabel => 'Close';

  @override
  String get closeOthersLabel => 'Close Others';

  @override
  String get closeAllLabel => 'Close All';

  @override
  String get commentBlockTitle => 'Comment Block';

  @override
  String get systemDefault => 'System Default';

  @override
  String get systemDefaultSubtitle => 'Adapts to system theme';

  @override
  String get defaultLight => 'Default Light';

  @override
  String get defaultLightSubtitle => 'Light theme';

  @override
  String get defaultDark => 'Default Dark';

  @override
  String get defaultDarkSubtitle => 'Dark theme';

  @override
  String get minimizeTooltip => 'Minimize';

  @override
  String get maximizeTooltip => 'Maximize';

  @override
  String get closeTooltip => 'Close';

  @override
  String get zoomTooltip => 'Zoom';

  @override
  String get toggleLineNumbersTooltip => 'Toggle line numbers';

  @override
  String get toggleMinimapTooltip => 'Toggle minimap';

  @override
  String syntaxWarningsTooltip(int count) {
    return '$count syntax warnings';
  }

  @override
  String get undoTooltip => 'Undo (Ctrl+Z)';

  @override
  String get redoTooltip => 'Redo (Ctrl+Y)';

  @override
  String get cutTooltip => 'Cut (Ctrl+X)';

  @override
  String get copyTooltip => 'Copy (Ctrl+C)';

  @override
  String get pasteTooltip => 'Paste (Ctrl+V)';

  @override
  String get foldAllTooltip => 'Fold All (Ctrl+Shift+[)';

  @override
  String get unfoldAllTooltip => 'Unfold All (Ctrl+Shift+])';

  @override
  String get exportTooltip => 'Export (Ctrl+E)';

  @override
  String get moreActionsTooltip => 'More actions';

  @override
  String get newFileTooltip => 'New File';

  @override
  String get newFolderTooltip => 'New Folder';

  @override
  String get refreshTooltip => 'Refresh';

  @override
  String get fileSystemTooltip => 'File System';

  @override
  String get collectionsTooltip => 'Collections';

  @override
  String get removeFromCollectionTooltip => 'Remove from collection';

  @override
  String failedToCloneRepository(String error) {
    return 'Failed to clone repository: $error';
  }

  @override
  String get openInNewTabAction => 'Open in New Tab';

  @override
  String get nothingToUndo => 'Nothing to undo';

  @override
  String get nothingToRedo => 'Nothing to redo';

  @override
  String get contentCutToClipboard => 'Content cut to clipboard';

  @override
  String get noContentToCut => 'No content to cut';

  @override
  String get contentCopiedToClipboard => 'Content copied to clipboard';

  @override
  String get noContentToCopy => 'No content to copy';

  @override
  String get contentPastedFromClipboard => 'Content pasted from clipboard';

  @override
  String get noTextInClipboard => 'No text in clipboard to paste';

  @override
  String get selectSidebarItemFirst => 'Please select an item from the sidebar first';

  @override
  String get loomDocumentation => 'Loom Documentation';

  @override
  String get welcomeToLoom => 'Welcome to Loom!';

  @override
  String get loomDescriptionFull => 'Loom is a knowledge base application for organizing and editing documents.';

  @override
  String get keyFeatures => 'Key Features:';

  @override
  String get fileExplorerFeature => '• File Explorer: Browse and manage your files';

  @override
  String get richTextEditorFeature => '• Rich Text Editor: Edit documents with syntax highlighting';

  @override
  String get searchFeature => '• Search: Find files and content quickly';

  @override
  String get settingsFeature => '• Settings: Customize your experience';

  @override
  String get keyboardShortcuts => 'Keyboard Shortcuts:';

  @override
  String get saveShortcut => '• Ctrl+S: Save file';

  @override
  String get globalSearchShortcut => '• Ctrl+Shift+F: Global search';

  @override
  String get undoShortcut => '• Ctrl+Z: Undo';

  @override
  String get redoShortcut => '• Ctrl+Y: Redo';

  @override
  String get fileName => 'File name';

  @override
  String get enterFileName => 'Enter file name (e.g., example.blox)';

  @override
  String get create => 'Create';

  @override
  String get invalidFileName => 'Invalid file name';

  @override
  String get invalidCharactersInFileName => 'Invalid characters in file name';

  @override
  String fileCreated(String filename) {
    return 'File \"$filename\" created';
  }

  @override
  String get exportFile => 'Export File';

  @override
  String get enterExportLocation => 'Enter export location';

  @override
  String get formatHint => 'txt, md, html, etc.';

  @override
  String fileExportedAs(String filename) {
    return 'File exported as \"$filename\"';
  }

  @override
  String failedToExportFile(String error) {
    return 'Failed to export file: $error';
  }

  @override
  String get enterSaveLocation => 'Enter save location';

  @override
  String fileSavedAs(String filename) {
    return 'File saved as \"$filename\"';
  }

  @override
  String failedToSaveFile(String error) {
    return 'Failed to save file: $error';
  }

  @override
  String get installed => 'Installed';

  @override
  String get active => 'Active';

  @override
  String get inactive => 'Inactive';

  @override
  String versionState(String version, String state) {
    return 'Version: $version • State: $state';
  }

  @override
  String commandsCount(int count) {
    return '$count commands';
  }

  @override
  String failedToEnablePlugin(String error) {
    return 'Failed to enable plugin: $error';
  }

  @override
  String failedToDisablePlugin(String error) {
    return 'Failed to disable plugin: $error';
  }

  @override
  String get disablePlugin => 'Disable Plugin';

  @override
  String get enablePlugin => 'Enable Plugin';

  @override
  String get noPluginsCurrentlyLoaded => 'No plugins are currently loaded';

  @override
  String get settings => 'Settings';

  @override
  String get allSettings => 'All settings';

  @override
  String get appearance => 'Appearance';

  @override
  String get appearanceDescription => 'Customize the look and feel of the application';

  @override
  String get appearanceSubtitle => 'Theme, colors, layout';

  @override
  String get interface => 'Interface';

  @override
  String get interfaceSubtitle => 'Window controls, layout';

  @override
  String get generalSubtitle => 'Preferences, behavior';

  @override
  String get aboutSubtitle => 'Version, licenses';

  @override
  String get openLink => 'Open Link';

  @override
  String openLinkConfirmation(String url) {
    return 'Open this link in your browser?\n\n$url';
  }

  @override
  String urlCopiedToClipboard(String url) {
    return 'URL copied to clipboard: $url';
  }

  @override
  String get copyUrl => 'Copy URL';

  @override
  String footnote(String id) {
    return 'Footnote $id';
  }

  @override
  String imageAlt(String src) {
    return 'Image: $src';
  }

  @override
  String get find => 'Find';

  @override
  String get findAndReplace => 'Find & Replace';

  @override
  String get hideReplace => 'Hide Replace';

  @override
  String get showReplace => 'Show Replace';

  @override
  String get findLabel => 'Find';

  @override
  String get replaceWith => 'Replace with';

  @override
  String get matchCase => 'Match case';

  @override
  String get useRegex => 'Use regex';

  @override
  String get replace => 'Replace';

  @override
  String get replaceAll => 'Replace All';

  @override
  String get findNext => 'Find Next';

  @override
  String get goToLine => 'Go to Line';

  @override
  String get pleaseEnterLineNumber => 'Please enter a line number';

  @override
  String get invalidLineNumber => 'Invalid line number';

  @override
  String get lineNumberMustBeGreaterThanZero => 'Line number must be greater than 0';

  @override
  String lineNumberExceedsMaximum(int maxLines) {
    return 'Line number exceeds maximum ($maxLines)';
  }

  @override
  String lineNumberLabel(int maxLines) {
    return 'Line number (1 - $maxLines)';
  }

  @override
  String get enterLineNumber => 'Enter line number';

  @override
  String totalLines(int count) {
    return 'Total lines: $count';
  }

  @override
  String get share => 'Share';

  @override
  String get newDocument => 'New Document';

  @override
  String get newFolder => 'New Folder';

  @override
  String get scanDocument => 'Scan Document';

  @override
  String get total => 'Total';

  @override
  String get noActivePlugins => 'No active plugins';

  @override
  String get searchYourKnowledgeBase => 'Search your knowledge base...';

  @override
  String get searchResultsWillAppearHere => 'Search results will appear here';

  @override
  String get collectionsViewForMobile => 'Collections view for mobile';

  @override
  String get searchEverything => 'Search everything...';

  @override
  String get mobileSearchInterface => 'Mobile search interface';

  @override
  String get exportDocument => 'Export Document';

  @override
  String fileLabel(String fileName) {
    return 'File: $fileName';
  }

  @override
  String get exportFormat => 'Export Format';

  @override
  String get options => 'Options';

  @override
  String get includeLineNumbers => 'Include line numbers';

  @override
  String get includeSyntaxHighlighting => 'Include syntax highlighting';

  @override
  String get includeHeader => 'Include header';

  @override
  String get headerText => 'Header text';

  @override
  String get documentTitle => 'Document title';

  @override
  String get saveLocation => 'Save Location';

  @override
  String get choose => 'Choose...';

  @override
  String get exporting => 'Exporting...';

  @override
  String get saveExport => 'Save Export';

  @override
  String get createCollection => 'Create Collection';

  @override
  String get collectionName => 'Collection name';

  @override
  String get myCollection => 'My Collection';

  @override
  String get chooseTemplateOptional => 'Choose a template (optional)';

  @override
  String get empty => 'Empty';

  @override
  String get noCollections => 'No Collections';

  @override
  String get createCollectionsToOrganize => 'Create collections to organize your files';

  @override
  String deleteCollection(String collectionName) {
    return 'Delete \"$collectionName\"';
  }

  @override
  String get deleteCollectionConfirmation => 'Are you sure you want to delete this collection? This will not delete the actual files.';

  @override
  String get smartSuggestion => 'Smart Suggestion';

  @override
  String get keepHere => 'Keep Here';

  @override
  String get invalidFolderName => 'Invalid folder name';

  @override
  String get invalidCharactersInFolderName => 'Invalid characters in folder name';

  @override
  String folderCreated(String folderName) {
    return 'Folder \"$folderName\" created';
  }

  @override
  String get useFileOpenToOpenFolder => 'Use File > Open to open a folder';

  @override
  String get useWelcomeScreenToCreateFile => 'Use the welcome screen to create a new file';

  @override
  String get settingsPanelComingSoon => 'Settings panel coming soon';

  @override
  String openedFile(String fileName) {
    return 'Opened: $fileName';
  }

  @override
  String get includeHiddenFiles => 'Include hidden files';

  @override
  String get fileSavedSuccessfully => 'File saved successfully';

  @override
  String errorSavingFile(String error) {
    return 'Error saving file: $error';
  }

  @override
  String get noContentToPreview => 'No content to preview';

  @override
  String get syntaxWarnings => 'Syntax Warnings';

  @override
  String noMatchesFound(String searchText) {
    return 'No matches found for \"$searchText\"';
  }

  @override
  String replacedOccurrences(int count) {
    return 'Replaced $count occurrences';
  }

  @override
  String get createNewFolder => 'Create New Folder';

  @override
  String createdFolder(String folderName) {
    return 'Created folder: $folderName';
  }

  @override
  String get pleaseOpenWorkspaceFirst => 'Please open a workspace first';

  @override
  String get createNewFile => 'Create New File';

  @override
  String createdAndOpenedFile(String fileName) {
    return 'Created and opened: $fileName';
  }

  @override
  String get searchPanelPlaceholder => 'Search Panel\n(To be implemented)';

  @override
  String get sourceControlPanelPlaceholder => 'Source Control Panel\n(To be implemented)';

  @override
  String get debugPanelPlaceholder => 'Debug Panel\n(To be implemented)';

  @override
  String get extensionsPanelPlaceholder => 'Extensions Panel\n(To be implemented)';

  @override
  String get settingsPanelPlaceholder => 'Settings Panel\n(To be implemented)';

  @override
  String get selectPanelFromSidebar => 'Select a panel from the sidebar';

  @override
  String get settingsTooltip => 'Settings';

  @override
  String get explorerTooltip => 'Explorer';

  @override
  String get searchTooltip => 'Search';

  @override
  String get flutterLicense => 'Flutter - BSD License';

  @override
  String get riverpodLicense => 'Riverpod - MIT License';

  @override
  String get adaptiveThemeLicense => 'Adaptive Theme - MIT License';

  @override
  String get filePickerLicense => 'File Picker - MIT License';

  @override
  String get sharedPreferencesLicense => 'Shared Preferences - BSD License';

  @override
  String get pdf => 'PDF';

  @override
  String get html => 'HTML';

  @override
  String get markdown => 'Markdown';

  @override
  String get plainText => 'Plain Text';

  @override
  String get loomAppTitle => 'Loom';

  @override
  String get loomKnowledgeBase => 'Loom Knowledge Base';

  @override
  String get yourWorkspace => 'Your workspace';

  @override
  String get recentFiles => 'Recent Files';

  @override
  String get favorites => 'Favorites';

  @override
  String get history => 'History';

  @override
  String get helpAndSupport => 'Help & Support';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get documents => 'Documents';

  @override
  String get search => 'Search';

  @override
  String get editor => 'Editor';

  @override
  String get collections => 'Collections';

  @override
  String get welcomeToYourKnowledgeBase => 'Welcome to your knowledge base';

  @override
  String get developmentDocumentation => 'Development documentation';

  @override
  String get welcomeToLoomTitle => 'Welcome to Loom';

  @override
  String get yourNextGenerationKnowledgeBase => 'Your next-generation knowledge base';

  @override
  String get openFolderTitle => 'Open Folder';

  @override
  String get openAnExistingWorkspace => 'Open an existing workspace';

  @override
  String get newFileTitle => 'New File';

  @override
  String get createANewDocument => 'Create a new document';

  @override
  String get cloneRepositoryTitle => 'Clone Repository';

  @override
  String get cloneFromGit => 'Clone from Git';

  @override
  String openedWorkspace(String workspaceName) {
    return 'Opened workspace: $workspaceName';
  }

  @override
  String get cloningRepository => 'Cloning repository...';

  @override
  String successfullyClonedRepository(String path) {
    return 'Successfully cloned repository to: $path';
  }

  @override
  String get repositoryUrl => 'Repository URL';

  @override
  String get enterGitRepositoryUrl => 'Enter Git repository URL (e.g., https://github.com/user/repo.git)';

  @override
  String get targetDirectoryOptional => 'Target Directory (optional)';

  @override
  String get leaveEmptyToUseRepositoryName => 'Leave empty to use repository name';

  @override
  String editingFile(String filePath) {
    return 'Editing: $filePath';
  }

  @override
  String get editorContentPlaceholder => 'Editor content will be implemented here.\n\nThis is where your innovative knowledge base editing experience will live!';

  @override
  String get replacing => 'Replacing...';

  @override
  String get replacingAll => 'Replacing All...';

  @override
  String searchError(Object error) {
    return 'Search Error';
  }

  @override
  String get recentSearches => 'Recent Searches';

  @override
  String get selectFolder => 'Select Folder';

  @override
  String get goUp => 'Go up';

  @override
  String get quickAccess => 'Quick Access';

  @override
  String get home => 'Home';

  @override
  String get workspaces => 'Workspaces';

  @override
  String get folders => 'Folders';

  @override
  String get noFoldersFound => 'No folders found';

  @override
  String searchResultsSummary(int matches, int files, int time) {
    return '$matches matches in $files files (${time}ms)';
  }

  @override
  String matchesInFile(int count) {
    return '$count matches';
  }

  @override
  String linePrefix(int number) {
    return 'Line $number';
  }

  @override
  String get typeToSearchFilesAndCommands => 'Type to search files and commands...';

  @override
  String get noResultsFound => 'No results found';

  @override
  String get navigateUpDown => '↑↓ Navigate';

  @override
  String get selectEnter => '↵ Select';

  @override
  String get closeEscape => 'Esc Close';

  @override
  String get findFile => 'Find File';

  @override
  String get typeToSearchFiles => 'Type to search files...';

  @override
  String get noFilesFoundInWorkspace => 'No files found in workspace';

  @override
  String get noFilesMatchSearch => 'No files match your search';

  @override
  String get navigateOpenClose => '↑↓ Navigate • ↵ Open • Esc Close';

  @override
  String get switchTheme => 'Switch Theme';

  @override
  String get layoutAndVisual => 'Layout & Visual';

  @override
  String get compactMode => 'Compact Mode';

  @override
  String get compactModeDescription => 'Use smaller UI elements and reduced spacing';

  @override
  String get showIconsInMenu => 'Show Icons in Menu';

  @override
  String get showIconsInMenuDescription => 'Display icons next to menu items';

  @override
  String get animationSpeed => 'Animation Speed';

  @override
  String get animationSpeedDescription => 'Speed of UI animations and transitions';

  @override
  String get slow => 'Slow';

  @override
  String get normal => 'Normal';

  @override
  String get fast => 'Fast';

  @override
  String get disabled => 'Disabled';

  @override
  String get sidebarTransparency => 'Sidebar Transparency';

  @override
  String get sidebarTransparencyDescription => 'Make sidebar background semi-transparent';

  @override
  String get interfaceDescription => 'Configure window controls and layout options';

  @override
  String get currentVersion => '1.0.0';

  @override
  String get currentBuild => '20241201';

  @override
  String get theme => 'Theme';

  @override
  String get currentTheme => 'Current Theme';

  @override
  String get currentThemeDescription => 'Your currently active theme';

  @override
  String get colorScheme => 'Color Scheme:';

  @override
  String get primary => 'Primary';

  @override
  String get secondary => 'Secondary';

  @override
  String get surface => 'Surface';

  @override
  String get themePresets => 'Theme Presets';

  @override
  String get themePresetsDescription => 'Choose from pre-designed themes. System themes automatically adapt to your system settings.';

  @override
  String get systemThemes => 'System Themes';

  @override
  String get lightThemes => 'Light Themes';

  @override
  String get darkThemes => 'Dark Themes';

  @override
  String get customizeColors => 'Customize Colors';

  @override
  String get customizeColorsDescription => 'Personalize your theme colors';

  @override
  String get primaryColor => 'Primary Color';

  @override
  String get secondaryColor => 'Secondary Color';

  @override
  String get surfaceColor => 'Surface Color';

  @override
  String get typography => 'Typography';

  @override
  String get typographyDescription => 'Customize fonts and text appearance';

  @override
  String get windowControls => 'Window Controls';

  @override
  String get showWindowControls => 'Show Window Controls';

  @override
  String get showWindowControlsDescription => 'Display minimize, maximize, and close buttons';

  @override
  String get controlsPlacement => 'Controls Placement';

  @override
  String get controlsPlacementDescription => 'Position of window control buttons';

  @override
  String get controlsOrder => 'Controls Order';

  @override
  String get controlsOrderDescription => 'Order of window control buttons';

  @override
  String get auto => 'Auto';

  @override
  String get left => 'Left';

  @override
  String get right => 'Right';

  @override
  String get minimizeMaximizeClose => 'Minimize, Maximize, Close';

  @override
  String get closeMinimizeMaximize => 'Close, Minimize, Maximize';

  @override
  String get closeMaximizeMinimize => 'Close, Maximize, Minimize';

  @override
  String get closeButtonPositions => 'Close Button Positions';

  @override
  String get closeButtonPositionsDescription => 'Configure where close buttons appear in tabs and panels';

  @override
  String get quickSettings => 'Quick Settings';

  @override
  String get quickSettingsDescription => 'Set all close buttons at once';

  @override
  String get autoDescription => 'Follow platform default settings for the close button';

  @override
  String get allLeft => 'All Left';

  @override
  String get allLeftDescription => 'Close buttons and window controls on left';

  @override
  String get allRight => 'All Right';

  @override
  String get allRightDescription => 'Close buttons and window controls on right';

  @override
  String get individualSettings => 'Individual Settings';

  @override
  String get individualSettingsDescription => 'Fine-tune each close button position';

  @override
  String get tabCloseButtons => 'Tab Close Buttons';

  @override
  String get tabCloseButtonsDescription => 'Position of close buttons in tabs';

  @override
  String get panelCloseButtons => 'Panel Close Buttons';

  @override
  String get panelCloseButtonsDescription => 'Position of close buttons in panels';

  @override
  String get currently => 'Currently';

  @override
  String get sidebarSearchPlaceholder => 'Search...';

  @override
  String get sidebarSearchOptions => 'Options';

  @override
  String get settingsAppearanceDetail => 'Appearance Settings';

  @override
  String get settingsInterfaceDetail => 'Interface Settings';

  @override
  String get topbarSearchDialogPlaceholder => 'Type to search...';

  @override
  String get showAppTitle => 'Show App Title';

  @override
  String get showAppTitleSubtitle => 'Display application name in the top bar';

  @override
  String get applicationTitleLabel => 'Application Title';

  @override
  String get applicationTitleHint => 'Enter custom app title';

  @override
  String get showSearchBarTitle => 'Show Search Bar';

  @override
  String get showSearchBarSubtitle => 'Display search functionality in top bar';

  @override
  String get animationSpeedTestTitle => 'Animation Speed Test';

  @override
  String get hoverMeFastAnimation => 'Hover Me (Fast Animation)';

  @override
  String get fadeInNormalSpeed => 'Fade In Animation (Normal Speed)';

  @override
  String get gettingStartedTitle => 'Getting Started';

  @override
  String get projectNotesTitle => 'Project Notes';

  @override
  String get searchOptionFilesTitle => 'Files';

  @override
  String get searchOptionFilesSubtitle => 'Search in file names';

  @override
  String get searchOptionContentTitle => 'Content';

  @override
  String get searchOptionContentSubtitle => 'Search in file content';

  @override
  String get searchOptionSymbolsTitle => 'Symbols';

  @override
  String get searchOptionSymbolsSubtitle => 'Search for functions, classes';

  @override
  String moreMatches(int count) {
    return '+$count more matches';
  }

  @override
  String get noCommandsAvailable => 'No commands available';

  @override
  String get commandPaletteSearchFilesTitle => 'Search Files';

  @override
  String get commandPaletteSearchFilesSubtitle => 'Search for files by name';

  @override
  String get commandPaletteSearchInFilesTitle => 'Search in Files';

  @override
  String get commandPaletteSearchInFilesSubtitle => 'Search for text content in files';

  @override
  String footerFilesCount(int count) {
    return '$count files';
  }
}
