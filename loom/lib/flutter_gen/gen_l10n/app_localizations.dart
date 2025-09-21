import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen_l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('ja'),
    Locale('ko'),
    Locale('zh')
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Loom - Knowledge Base'**
  String get appTitle;

  /// Title for the UI polish showcase demo
  ///
  /// In en, this message translates to:
  /// **'UI Polish Showcase'**
  String get uiPolishShowcase;

  /// Header for enhanced UI animations section
  ///
  /// In en, this message translates to:
  /// **'Enhanced UI Animations'**
  String get enhancedUiAnimations;

  /// Section title for loading indicators
  ///
  /// In en, this message translates to:
  /// **'Loading Indicators'**
  String get loadingIndicators;

  /// Label for smooth loading indicator
  ///
  /// In en, this message translates to:
  /// **'Smooth Loading'**
  String get smoothLoading;

  /// Label for skeleton loader
  ///
  /// In en, this message translates to:
  /// **'Skeleton Loader'**
  String get skeletonLoader;

  /// Section title for interactive elements
  ///
  /// In en, this message translates to:
  /// **'Interactive Elements'**
  String get interactiveElements;

  /// Label for hover animation demo
  ///
  /// In en, this message translates to:
  /// **'Hover Animation'**
  String get hoverAnimation;

  /// Label for press animation demo
  ///
  /// In en, this message translates to:
  /// **'Press Animation'**
  String get pressAnimation;

  /// Label for pulse animation demo
  ///
  /// In en, this message translates to:
  /// **'Pulse Animation'**
  String get pulseAnimation;

  /// Section title for shimmer effects
  ///
  /// In en, this message translates to:
  /// **'Shimmer Effects'**
  String get shimmerEffects;

  /// Section title for success animations
  ///
  /// In en, this message translates to:
  /// **'Success Animations'**
  String get successAnimations;

  /// Success message for completed task
  ///
  /// In en, this message translates to:
  /// **'Task Completed!'**
  String get taskCompleted;

  /// Section title for animation combinations
  ///
  /// In en, this message translates to:
  /// **'Animation Combinations'**
  String get animationCombinations;

  /// Label for interactive button demo
  ///
  /// In en, this message translates to:
  /// **'Interactive Button'**
  String get interactiveButton;

  /// Title for animated card demo
  ///
  /// In en, this message translates to:
  /// **'Animated Card'**
  String get animatedCard;

  /// Description text for animated card demo
  ///
  /// In en, this message translates to:
  /// **'This card demonstrates fade-in and slide-in animations combined.'**
  String get animatedCardDescription;

  /// General settings title
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// Description for general settings
  ///
  /// In en, this message translates to:
  /// **'General preferences and application behavior'**
  String get generalDescription;

  /// Auto save setting label
  ///
  /// In en, this message translates to:
  /// **'Auto Save'**
  String get autoSave;

  /// Description for auto save setting
  ///
  /// In en, this message translates to:
  /// **'Automatically save changes at regular intervals'**
  String get autoSaveDescription;

  /// Confirm on exit setting label
  ///
  /// In en, this message translates to:
  /// **'Confirm on Exit'**
  String get confirmOnExit;

  /// Description for confirm on exit setting
  ///
  /// In en, this message translates to:
  /// **'Ask for confirmation when closing with unsaved changes'**
  String get confirmOnExitDescription;

  /// Language setting label
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Description for language setting
  ///
  /// In en, this message translates to:
  /// **'Application language'**
  String get languageDescription;

  /// Option to follow system language
  ///
  /// In en, this message translates to:
  /// **'Follow system language'**
  String get followSystemLanguage;

  /// Option for manual language selection
  ///
  /// In en, this message translates to:
  /// **'Manual language selection'**
  String get manualLanguageSelection;

  /// English language name
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// Spanish language name
  ///
  /// In en, this message translates to:
  /// **'Español'**
  String get spanish;

  /// French language name
  ///
  /// In en, this message translates to:
  /// **'Français'**
  String get french;

  /// German language name
  ///
  /// In en, this message translates to:
  /// **'Deutsch'**
  String get german;

  /// Chinese language name
  ///
  /// In en, this message translates to:
  /// **'Chinese'**
  String get chinese;

  /// Japanese language name
  ///
  /// In en, this message translates to:
  /// **'Japanese'**
  String get japanese;

  /// Korean language name
  ///
  /// In en, this message translates to:
  /// **'Korean'**
  String get korean;

  /// Label for auto-save interval setting
  ///
  /// In en, this message translates to:
  /// **'Auto-save Interval'**
  String get autoSaveInterval;

  /// Prefix for last saved time display
  ///
  /// In en, this message translates to:
  /// **'Last saved: '**
  String lastSaved(Object time);

  /// Text for when something was saved just now
  ///
  /// In en, this message translates to:
  /// **'just now'**
  String get justNow;

  /// Time format for minutes ago
  ///
  /// In en, this message translates to:
  /// **'{count}m ago'**
  String minutesAgo(int count);

  /// Time format for hours ago
  ///
  /// In en, this message translates to:
  /// **'{count}h ago'**
  String hoursAgo(int count);

  /// Time format for days ago
  ///
  /// In en, this message translates to:
  /// **'{count}d ago'**
  String daysAgo(int count);

  /// Success message when a plugin command executes successfully
  ///
  /// In en, this message translates to:
  /// **'Command executed successfully'**
  String get commandExecutedSuccessfully;

  /// Error message when a plugin command fails
  ///
  /// In en, this message translates to:
  /// **'Command failed: {error}'**
  String commandFailed(String error);

  /// Error message when command execution fails
  ///
  /// In en, this message translates to:
  /// **'Failed to execute command: {error}'**
  String failedToExecuteCommand(String error);

  /// About settings title
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// Description for about page
  ///
  /// In en, this message translates to:
  /// **'Information about Loom'**
  String get aboutDescription;

  /// Version label
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// Licenses label
  ///
  /// In en, this message translates to:
  /// **'Licenses'**
  String get licenses;

  /// Description for licenses section
  ///
  /// In en, this message translates to:
  /// **'View open source licenses'**
  String get viewOpenSourceLicenses;

  /// Application name
  ///
  /// In en, this message translates to:
  /// **'Loom'**
  String get loom;

  /// Build label
  ///
  /// In en, this message translates to:
  /// **'Build'**
  String get build;

  /// Application description
  ///
  /// In en, this message translates to:
  /// **'Loom is a modern code editor built with Flutter, designed for productivity and ease of use.'**
  String get loomDescription;

  /// Copyright notice
  ///
  /// In en, this message translates to:
  /// **'© 2024 Loom Team'**
  String get copyright;

  /// Close button text
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Open source licenses dialog title
  ///
  /// In en, this message translates to:
  /// **'Open Source Licenses'**
  String get openSourceLicenses;

  /// Text introducing the list of libraries
  ///
  /// In en, this message translates to:
  /// **'Loom uses the following open source libraries:'**
  String get usesFollowingLibraries;

  /// Text about where to find full license texts
  ///
  /// In en, this message translates to:
  /// **'For full license texts, please visit the respective folder repositories on GitHub.'**
  String get fullLicenseTexts;

  /// Dialog title for entering a custom path
  ///
  /// In en, this message translates to:
  /// **'Enter Path'**
  String get enterPath;

  /// Label for directory path input field
  ///
  /// In en, this message translates to:
  /// **'Directory Path'**
  String get directoryPath;

  /// Hint text for path input field
  ///
  /// In en, this message translates to:
  /// **'/home/user/folder'**
  String get pathHint;

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Go button text
  ///
  /// In en, this message translates to:
  /// **'Go'**
  String get go;

  /// Select button text
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// Apply button text
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// Preview label for theme/color previews
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get preview;

  /// Dialog title for selecting a color
  ///
  /// In en, this message translates to:
  /// **'Select {label} Color'**
  String selectColorLabel(String label);

  /// Label for font family selector
  ///
  /// In en, this message translates to:
  /// **'Font Family'**
  String get fontFamilyLabel;

  /// Label for font size selector
  ///
  /// In en, this message translates to:
  /// **'Font Size'**
  String get fontSizeLabel;

  /// Sample preview text for fonts
  ///
  /// In en, this message translates to:
  /// **'Preview: The quick brown fox jumps over the lazy dog'**
  String get previewSampleText;

  /// Search bar placeholder text
  ///
  /// In en, this message translates to:
  /// **'Search files and commands...'**
  String get searchFilesAndCommands;

  /// Keyboard shortcut display
  ///
  /// In en, this message translates to:
  /// **'⌘K'**
  String get commandKeyShortcut;

  /// Menu tooltip
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu;

  /// File menu label
  ///
  /// In en, this message translates to:
  /// **'File'**
  String get file;

  /// New file dialog title
  ///
  /// In en, this message translates to:
  /// **'New File'**
  String get newFile;

  /// Open folder menu item
  ///
  /// In en, this message translates to:
  /// **'Open Folder'**
  String get openFolder;

  /// Save menu item
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Save as menu item
  ///
  /// In en, this message translates to:
  /// **'Save As'**
  String get saveAs;

  /// Export menu item
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get export;

  /// Exit menu item
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exit;

  /// Edit menu label
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// Undo menu item
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// Redo menu item
  ///
  /// In en, this message translates to:
  /// **'Redo'**
  String get redo;

  /// Cut menu item
  ///
  /// In en, this message translates to:
  /// **'Cut'**
  String get cut;

  /// Copy menu item
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// Paste menu item
  ///
  /// In en, this message translates to:
  /// **'Paste'**
  String get paste;

  /// View menu label
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// Toggle sidebar menu item
  ///
  /// In en, this message translates to:
  /// **'Toggle Sidebar'**
  String get toggleSidebar;

  /// Toggle panel menu item
  ///
  /// In en, this message translates to:
  /// **'Toggle Panel'**
  String get togglePanel;

  /// Full screen menu item
  ///
  /// In en, this message translates to:
  /// **'Full Screen'**
  String get fullScreen;

  /// Help menu label
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// Documentation menu item
  ///
  /// In en, this message translates to:
  /// **'Documentation'**
  String get documentation;

  /// Plugins menu label
  ///
  /// In en, this message translates to:
  /// **'Plugins'**
  String get plugins;

  /// Plugin manager menu item
  ///
  /// In en, this message translates to:
  /// **'Plugin Manager'**
  String get pluginManager;

  /// Message when no plugins are loaded
  ///
  /// In en, this message translates to:
  /// **'No plugins loaded'**
  String get noPluginsLoaded;

  /// Message when trying to create file without workspace
  ///
  /// In en, this message translates to:
  /// **'Please open a folder first to create a new file'**
  String get openFolderFirst;

  /// Message when trying to save without open file
  ///
  /// In en, this message translates to:
  /// **'No file is currently open to save'**
  String get noFileOpenToSave;

  /// Success message when file is saved
  ///
  /// In en, this message translates to:
  /// **'File \"{filename}\" saved'**
  String fileSaved(String filename);

  /// Message when trying to export empty content
  ///
  /// In en, this message translates to:
  /// **'No content to export'**
  String get noContentToExport;

  /// Exit confirmation dialog title
  ///
  /// In en, this message translates to:
  /// **'Exit Application'**
  String get exitApplication;

  /// Exit confirmation dialog message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to exit Loom?'**
  String get confirmExit;

  /// Auto-added metadata for openInNewTab
  ///
  /// In en, this message translates to:
  /// **'Open in New Tab'**
  String get openInNewTab;

  /// Auto-added metadata for rename
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get rename;

  /// Delete button text
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Auto-added metadata for deleteItem
  ///
  /// In en, this message translates to:
  /// **'Delete Item'**
  String get deleteItem;

  /// Auto-added metadata for cancelButton
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelButton;

  /// Auto-added metadata for enterPathPrompt
  ///
  /// In en, this message translates to:
  /// **'Enter the path to the folder you want to open:'**
  String get enterPathPrompt;

  /// Auto-added metadata for folderPathLabel
  ///
  /// In en, this message translates to:
  /// **'Folder Path'**
  String get folderPathLabel;

  /// Auto-added metadata for folderPathHint
  ///
  /// In en, this message translates to:
  /// **'Enter folder path (e.g., /workspaces/my-folder)'**
  String get folderPathHint;

  /// Auto-added metadata for enterFolderNameHint
  ///
  /// In en, this message translates to:
  /// **'Enter folder name'**
  String get enterFolderNameHint;

  /// Auto-added metadata for browse
  ///
  /// In en, this message translates to:
  /// **'Browse'**
  String get browse;

  /// Auto-added metadata for selectFolderLocation
  ///
  /// In en, this message translates to:
  /// **'Select Folder Location'**
  String get selectFolderLocation;

  /// Auto-added metadata for failedToSelectLocation
  ///
  /// In en, this message translates to:
  /// **'Failed to select location: {error}'**
  String failedToSelectLocation(String error);

  /// Auto-added metadata for folderCreatedSuccess
  ///
  /// In en, this message translates to:
  /// **'Folder \"{folderName}\" created successfully!'**
  String folderCreatedSuccess(String folderName);

  /// Error message when folder creation fails
  ///
  /// In en, this message translates to:
  /// **'Failed to create folder: {error}'**
  String failedToCreateFolder(String error);

  /// File name input hint in create file dialog
  ///
  /// In en, this message translates to:
  /// **'Enter file name (e.g., main.dart)'**
  String get enterFileNameHint;

  /// Auto-added metadata for enterInitialFileContentHint
  ///
  /// In en, this message translates to:
  /// **'Enter initial file content...'**
  String get enterInitialFileContentHint;

  /// Auto-added metadata for enterNewNameHint
  ///
  /// In en, this message translates to:
  /// **'Enter new name'**
  String get enterNewNameHint;

  /// Auto-added metadata for closeFolder
  ///
  /// In en, this message translates to:
  /// **'Close Folder'**
  String get closeFolder;

  /// Auto-added metadata for openFolderMenu
  ///
  /// In en, this message translates to:
  /// **'Open Folder'**
  String get openFolderMenu;

  /// Auto-added metadata for createFolder
  ///
  /// In en, this message translates to:
  /// **'Create Folder'**
  String get createFolder;

  /// Auto-added metadata for filterFileExtensions
  ///
  /// In en, this message translates to:
  /// **'Filter File Extensions'**
  String get filterFileExtensions;

  /// Auto-added metadata for showHiddenFiles
  ///
  /// In en, this message translates to:
  /// **'Show Hidden Files'**
  String get showHiddenFiles;

  /// Error message when folder opening fails
  ///
  /// In en, this message translates to:
  /// **'Failed to open folder: {error}'**
  String failedToOpenFolder(String error);

  /// Error message when file creation fails
  ///
  /// In en, this message translates to:
  /// **'Failed to create file: {error}'**
  String failedToCreateFile(String error);

  /// Auto-added metadata for failedToDeleteItem
  ///
  /// In en, this message translates to:
  /// **'Failed to delete item: {error}'**
  String failedToDeleteItem(String error);

  /// Auto-added metadata for failedToRenameItem
  ///
  /// In en, this message translates to:
  /// **'Failed to rename item: {error}'**
  String failedToRenameItem(String error);

  /// Auto-added metadata for renameSuccess
  ///
  /// In en, this message translates to:
  /// **'Renamed to {name}'**
  String renameSuccess(String name);

  /// Auto-added metadata for deleteSuccess
  ///
  /// In en, this message translates to:
  /// **'{itemType} deleted successfully'**
  String deleteSuccess(String itemType);

  /// Auto-added metadata for searchFilesHint
  ///
  /// In en, this message translates to:
  /// **'Search files...'**
  String get searchFilesHint;

  /// Auto-added metadata for newFolderPlaceholder
  ///
  /// In en, this message translates to:
  /// **'new-folder'**
  String get newFolderPlaceholder;

  /// Auto-added metadata for openInNewTabLabel
  ///
  /// In en, this message translates to:
  /// **'Open in New Tab'**
  String get openInNewTabLabel;

  /// Auto-added metadata for closeLabel
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get closeLabel;

  /// Auto-added metadata for closeOthersLabel
  ///
  /// In en, this message translates to:
  /// **'Close Others'**
  String get closeOthersLabel;

  /// Auto-added metadata for closeAllLabel
  ///
  /// In en, this message translates to:
  /// **'Close All'**
  String get closeAllLabel;

  /// Auto-added metadata for commentBlockTitle
  ///
  /// In en, this message translates to:
  /// **'Comment Block'**
  String get commentBlockTitle;

  /// Auto-added metadata for systemDefault
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get systemDefault;

  /// Auto-added metadata for systemDefaultSubtitle
  ///
  /// In en, this message translates to:
  /// **'Adapts to system theme'**
  String get systemDefaultSubtitle;

  /// Auto-added metadata for defaultLight
  ///
  /// In en, this message translates to:
  /// **'Default Light'**
  String get defaultLight;

  /// Auto-added metadata for defaultLightSubtitle
  ///
  /// In en, this message translates to:
  /// **'Light theme'**
  String get defaultLightSubtitle;

  /// Auto-added metadata for defaultDark
  ///
  /// In en, this message translates to:
  /// **'Default Dark'**
  String get defaultDark;

  /// Auto-added metadata for defaultDarkSubtitle
  ///
  /// In en, this message translates to:
  /// **'Dark theme'**
  String get defaultDarkSubtitle;

  /// Auto-added metadata for minimizeTooltip
  ///
  /// In en, this message translates to:
  /// **'Minimize'**
  String get minimizeTooltip;

  /// Auto-added metadata for maximizeTooltip
  ///
  /// In en, this message translates to:
  /// **'Maximize'**
  String get maximizeTooltip;

  /// Auto-added metadata for closeTooltip
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get closeTooltip;

  /// Auto-added metadata for zoomTooltip
  ///
  /// In en, this message translates to:
  /// **'Zoom'**
  String get zoomTooltip;

  /// Auto-added metadata for toggleLineNumbersTooltip
  ///
  /// In en, this message translates to:
  /// **'Toggle line numbers'**
  String get toggleLineNumbersTooltip;

  /// Auto-added metadata for toggleMinimapTooltip
  ///
  /// In en, this message translates to:
  /// **'Toggle minimap'**
  String get toggleMinimapTooltip;

  /// Auto-added metadata for syntaxWarningsTooltip
  ///
  /// In en, this message translates to:
  /// **'{count} syntax warnings'**
  String syntaxWarningsTooltip(int count);

  /// Auto-added metadata for undoTooltip
  ///
  /// In en, this message translates to:
  /// **'Undo (Ctrl+Z)'**
  String get undoTooltip;

  /// Auto-added metadata for redoTooltip
  ///
  /// In en, this message translates to:
  /// **'Redo (Ctrl+Y)'**
  String get redoTooltip;

  /// Auto-added metadata for cutTooltip
  ///
  /// In en, this message translates to:
  /// **'Cut (Ctrl+X)'**
  String get cutTooltip;

  /// Auto-added metadata for copyTooltip
  ///
  /// In en, this message translates to:
  /// **'Copy (Ctrl+C)'**
  String get copyTooltip;

  /// Auto-added metadata for pasteTooltip
  ///
  /// In en, this message translates to:
  /// **'Paste (Ctrl+V)'**
  String get pasteTooltip;

  /// Auto-added metadata for foldAllTooltip
  ///
  /// In en, this message translates to:
  /// **'Fold All (Ctrl+Shift+[)'**
  String get foldAllTooltip;

  /// Auto-added metadata for unfoldAllTooltip
  ///
  /// In en, this message translates to:
  /// **'Unfold All (Ctrl+Shift+])'**
  String get unfoldAllTooltip;

  /// Auto-added metadata for exportTooltip
  ///
  /// In en, this message translates to:
  /// **'Export (Ctrl+E)'**
  String get exportTooltip;

  /// Auto-added metadata for moreActionsTooltip
  ///
  /// In en, this message translates to:
  /// **'More actions'**
  String get moreActionsTooltip;

  /// Auto-added metadata for newFileTooltip
  ///
  /// In en, this message translates to:
  /// **'New File'**
  String get newFileTooltip;

  /// Auto-added metadata for newFolderTooltip
  ///
  /// In en, this message translates to:
  /// **'New Folder'**
  String get newFolderTooltip;

  /// Auto-added metadata for refreshTooltip
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refreshTooltip;

  /// Auto-added metadata for fileSystemTooltip
  ///
  /// In en, this message translates to:
  /// **'File System'**
  String get fileSystemTooltip;

  /// Auto-added metadata for collectionsTooltip
  ///
  /// In en, this message translates to:
  /// **'Collections'**
  String get collectionsTooltip;

  /// Auto-added metadata for removeFromCollectionTooltip
  ///
  /// In en, this message translates to:
  /// **'Remove from collection'**
  String get removeFromCollectionTooltip;

  /// Error message when repository cloning fails
  ///
  /// In en, this message translates to:
  /// **'Failed to clone repository: {error}'**
  String failedToCloneRepository(String error);

  /// Auto-added metadata for openInNewTabAction
  ///
  /// In en, this message translates to:
  /// **'Open in New Tab'**
  String get openInNewTabAction;

  /// Message when undo is not available
  ///
  /// In en, this message translates to:
  /// **'Nothing to undo'**
  String get nothingToUndo;

  /// Message when redo is not available
  ///
  /// In en, this message translates to:
  /// **'Nothing to redo'**
  String get nothingToRedo;

  /// Success message for cut operation
  ///
  /// In en, this message translates to:
  /// **'Content cut to clipboard'**
  String get contentCutToClipboard;

  /// Message when trying to cut empty content
  ///
  /// In en, this message translates to:
  /// **'No content to cut'**
  String get noContentToCut;

  /// Success message for copy operation
  ///
  /// In en, this message translates to:
  /// **'Content copied to clipboard'**
  String get contentCopiedToClipboard;

  /// Message when trying to copy empty content
  ///
  /// In en, this message translates to:
  /// **'No content to copy'**
  String get noContentToCopy;

  /// Success message for paste operation
  ///
  /// In en, this message translates to:
  /// **'Content pasted from clipboard'**
  String get contentPastedFromClipboard;

  /// Message when clipboard is empty
  ///
  /// In en, this message translates to:
  /// **'No text in clipboard to paste'**
  String get noTextInClipboard;

  /// Message when trying to show panel without selection
  ///
  /// In en, this message translates to:
  /// **'Please select an item from the sidebar first'**
  String get selectSidebarItemFirst;

  /// Documentation dialog title
  ///
  /// In en, this message translates to:
  /// **'Loom Documentation'**
  String get loomDocumentation;

  /// Welcome message in documentation
  ///
  /// In en, this message translates to:
  /// **'Welcome to Loom!'**
  String get welcomeToLoom;

  /// Full description of Loom
  ///
  /// In en, this message translates to:
  /// **'Loom is a knowledge base application for organizing and editing documents.'**
  String get loomDescriptionFull;

  /// Key features section header
  ///
  /// In en, this message translates to:
  /// **'Key Features:'**
  String get keyFeatures;

  /// File explorer feature description
  ///
  /// In en, this message translates to:
  /// **'• File Explorer: Browse and manage your files'**
  String get fileExplorerFeature;

  /// Rich text editor feature description
  ///
  /// In en, this message translates to:
  /// **'• Rich Text Editor: Edit documents with syntax highlighting'**
  String get richTextEditorFeature;

  /// Search feature description
  ///
  /// In en, this message translates to:
  /// **'• Search: Find files and content quickly'**
  String get searchFeature;

  /// Settings feature description
  ///
  /// In en, this message translates to:
  /// **'• Settings: Customize your experience'**
  String get settingsFeature;

  /// Keyboard shortcuts section header
  ///
  /// In en, this message translates to:
  /// **'Keyboard Shortcuts:'**
  String get keyboardShortcuts;

  /// Save keyboard shortcut
  ///
  /// In en, this message translates to:
  /// **'• Ctrl+S: Save file'**
  String get saveShortcut;

  /// Global search keyboard shortcut
  ///
  /// In en, this message translates to:
  /// **'• Ctrl+Shift+F: Global search'**
  String get globalSearchShortcut;

  /// Undo keyboard shortcut
  ///
  /// In en, this message translates to:
  /// **'• Ctrl+Z: Undo'**
  String get undoShortcut;

  /// Redo keyboard shortcut
  ///
  /// In en, this message translates to:
  /// **'• Ctrl+Y: Redo'**
  String get redoShortcut;

  /// File name input label
  ///
  /// In en, this message translates to:
  /// **'File name'**
  String get fileName;

  /// File name input hint
  ///
  /// In en, this message translates to:
  /// **'Enter file name (e.g., example.blox)'**
  String get enterFileName;

  /// Create button text
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// Error message for invalid file name
  ///
  /// In en, this message translates to:
  /// **'Invalid file name'**
  String get invalidFileName;

  /// Error message for invalid characters in file name
  ///
  /// In en, this message translates to:
  /// **'Invalid characters in file name'**
  String get invalidCharactersInFileName;

  /// Success message when file is created
  ///
  /// In en, this message translates to:
  /// **'File \"{filename}\" created'**
  String fileCreated(String filename);

  /// Export file dialog title
  ///
  /// In en, this message translates to:
  /// **'Export File'**
  String get exportFile;

  /// Export location input hint
  ///
  /// In en, this message translates to:
  /// **'Enter export location'**
  String get enterExportLocation;

  /// Format input hint
  ///
  /// In en, this message translates to:
  /// **'txt, md, html, etc.'**
  String get formatHint;

  /// Success message when file is exported
  ///
  /// In en, this message translates to:
  /// **'File exported as \"{filename}\"'**
  String fileExportedAs(String filename);

  /// Error message when file export fails
  ///
  /// In en, this message translates to:
  /// **'Failed to export file: {error}'**
  String failedToExportFile(String error);

  /// Save location input hint
  ///
  /// In en, this message translates to:
  /// **'Enter save location'**
  String get enterSaveLocation;

  /// Success message when file is saved as
  ///
  /// In en, this message translates to:
  /// **'File saved as \"{filename}\"'**
  String fileSavedAs(String filename);

  /// Error message when file save fails
  ///
  /// In en, this message translates to:
  /// **'Failed to save file: {error}'**
  String failedToSaveFile(String error);

  /// Installed plugins count label
  ///
  /// In en, this message translates to:
  /// **'Installed'**
  String get installed;

  /// Active status label
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// Inactive plugins count label
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactive;

  /// Plugin version and state display
  ///
  /// In en, this message translates to:
  /// **'Version: {version} • State: {state}'**
  String versionState(String version, String state);

  /// Number of commands display
  ///
  /// In en, this message translates to:
  /// **'{count} commands'**
  String commandsCount(int count);

  /// Error message when plugin enable fails
  ///
  /// In en, this message translates to:
  /// **'Failed to enable plugin: {error}'**
  String failedToEnablePlugin(String error);

  /// Error message when plugin disable fails
  ///
  /// In en, this message translates to:
  /// **'Failed to disable plugin: {error}'**
  String failedToDisablePlugin(String error);

  /// Disable plugin tooltip
  ///
  /// In en, this message translates to:
  /// **'Disable Plugin'**
  String get disablePlugin;

  /// Enable plugin tooltip
  ///
  /// In en, this message translates to:
  /// **'Enable Plugin'**
  String get enablePlugin;

  /// Message when no plugins are loaded
  ///
  /// In en, this message translates to:
  /// **'No plugins are currently loaded'**
  String get noPluginsCurrentlyLoaded;

  /// Settings title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// All settings subtitle
  ///
  /// In en, this message translates to:
  /// **'All settings'**
  String get allSettings;

  /// Appearance settings title
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// Description for appearance settings
  ///
  /// In en, this message translates to:
  /// **'Customize the look and feel of the application'**
  String get appearanceDescription;

  /// Appearance settings subtitle
  ///
  /// In en, this message translates to:
  /// **'Theme, colors, layout'**
  String get appearanceSubtitle;

  /// Interface settings title
  ///
  /// In en, this message translates to:
  /// **'Interface'**
  String get interface;

  /// Interface settings subtitle
  ///
  /// In en, this message translates to:
  /// **'Window controls, layout'**
  String get interfaceSubtitle;

  /// General settings subtitle
  ///
  /// In en, this message translates to:
  /// **'Preferences, behavior'**
  String get generalSubtitle;

  /// About settings subtitle
  ///
  /// In en, this message translates to:
  /// **'Version, licenses'**
  String get aboutSubtitle;

  /// Dialog title for opening a link
  ///
  /// In en, this message translates to:
  /// **'Open Link'**
  String get openLink;

  /// Confirmation message for opening a link
  ///
  /// In en, this message translates to:
  /// **'Open this link in your browser?\n\n{url}'**
  String openLinkConfirmation(String url);

  /// Success message when URL is copied to clipboard
  ///
  /// In en, this message translates to:
  /// **'URL copied to clipboard: {url}'**
  String urlCopiedToClipboard(String url);

  /// Button text for copying URL
  ///
  /// In en, this message translates to:
  /// **'Copy URL'**
  String get copyUrl;

  /// Dialog title for footnote
  ///
  /// In en, this message translates to:
  /// **'Footnote {id}'**
  String footnote(String id);

  /// Alt text for images
  ///
  /// In en, this message translates to:
  /// **'Image: {src}'**
  String imageAlt(String src);

  /// Find dialog title
  ///
  /// In en, this message translates to:
  /// **'Find'**
  String get find;

  /// Find and replace dialog title
  ///
  /// In en, this message translates to:
  /// **'Find & Replace'**
  String get findAndReplace;

  /// Tooltip for hiding replace field
  ///
  /// In en, this message translates to:
  /// **'Hide Replace'**
  String get hideReplace;

  /// Tooltip for showing replace field
  ///
  /// In en, this message translates to:
  /// **'Show Replace'**
  String get showReplace;

  /// Label for find text field
  ///
  /// In en, this message translates to:
  /// **'Find'**
  String get findLabel;

  /// Label for replace text field
  ///
  /// In en, this message translates to:
  /// **'Replace with'**
  String get replaceWith;

  /// Checkbox label for case sensitive search
  ///
  /// In en, this message translates to:
  /// **'Match case'**
  String get matchCase;

  /// Checkbox label for regex search
  ///
  /// In en, this message translates to:
  /// **'Use regex'**
  String get useRegex;

  /// Replace button text
  ///
  /// In en, this message translates to:
  /// **'Replace'**
  String get replace;

  /// Replace all button text
  ///
  /// In en, this message translates to:
  /// **'Replace All'**
  String get replaceAll;

  /// Find next button text
  ///
  /// In en, this message translates to:
  /// **'Find Next'**
  String get findNext;

  /// Go to line dialog title
  ///
  /// In en, this message translates to:
  /// **'Go to Line'**
  String get goToLine;

  /// Error message for empty line number input
  ///
  /// In en, this message translates to:
  /// **'Please enter a line number'**
  String get pleaseEnterLineNumber;

  /// Error message for invalid line number format
  ///
  /// In en, this message translates to:
  /// **'Invalid line number'**
  String get invalidLineNumber;

  /// Error message for line number less than 1
  ///
  /// In en, this message translates to:
  /// **'Line number must be greater than 0'**
  String get lineNumberMustBeGreaterThanZero;

  /// Error message for line number exceeding maximum
  ///
  /// In en, this message translates to:
  /// **'Line number exceeds maximum ({maxLines})'**
  String lineNumberExceedsMaximum(int maxLines);

  /// Label for line number input field
  ///
  /// In en, this message translates to:
  /// **'Line number (1 - {maxLines})'**
  String lineNumberLabel(int maxLines);

  /// Hint text for line number input field
  ///
  /// In en, this message translates to:
  /// **'Enter line number'**
  String get enterLineNumber;

  /// Display text for total number of lines
  ///
  /// In en, this message translates to:
  /// **'Total lines: {count}'**
  String totalLines(int count);

  /// Share menu item
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// New document menu item
  ///
  /// In en, this message translates to:
  /// **'New Document'**
  String get newDocument;

  /// New folder menu item
  ///
  /// In en, this message translates to:
  /// **'New Folder'**
  String get newFolder;

  /// Scan document menu item
  ///
  /// In en, this message translates to:
  /// **'Scan Document'**
  String get scanDocument;

  /// Total count label
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// Message when no plugins are active
  ///
  /// In en, this message translates to:
  /// **'No active plugins'**
  String get noActivePlugins;

  /// Hint text for knowledge base search
  ///
  /// In en, this message translates to:
  /// **'Search your knowledge base...'**
  String get searchYourKnowledgeBase;

  /// Placeholder text for search results
  ///
  /// In en, this message translates to:
  /// **'Search results will appear here'**
  String get searchResultsWillAppearHere;

  /// Placeholder text for mobile collections view
  ///
  /// In en, this message translates to:
  /// **'Collections view for mobile'**
  String get collectionsViewForMobile;

  /// Hint text for global search
  ///
  /// In en, this message translates to:
  /// **'Search everything...'**
  String get searchEverything;

  /// Placeholder text for mobile search interface
  ///
  /// In en, this message translates to:
  /// **'Mobile search interface'**
  String get mobileSearchInterface;

  /// Export dialog title
  ///
  /// In en, this message translates to:
  /// **'Export Document'**
  String get exportDocument;

  /// File information display
  ///
  /// In en, this message translates to:
  /// **'File: {fileName}'**
  String fileLabel(String fileName);

  /// Export format section title
  ///
  /// In en, this message translates to:
  /// **'Export Format'**
  String get exportFormat;

  /// Options section title
  ///
  /// In en, this message translates to:
  /// **'Options'**
  String get options;

  /// Option to include line numbers in export
  ///
  /// In en, this message translates to:
  /// **'Include line numbers'**
  String get includeLineNumbers;

  /// Option to include syntax highlighting in export
  ///
  /// In en, this message translates to:
  /// **'Include syntax highlighting'**
  String get includeSyntaxHighlighting;

  /// Option to include header in export
  ///
  /// In en, this message translates to:
  /// **'Include header'**
  String get includeHeader;

  /// Label for header text input
  ///
  /// In en, this message translates to:
  /// **'Header text'**
  String get headerText;

  /// Hint text for document title input
  ///
  /// In en, this message translates to:
  /// **'Document title'**
  String get documentTitle;

  /// Save location section title
  ///
  /// In en, this message translates to:
  /// **'Save Location'**
  String get saveLocation;

  /// Choose file button text
  ///
  /// In en, this message translates to:
  /// **'Choose...'**
  String get choose;

  /// Export button text during export process
  ///
  /// In en, this message translates to:
  /// **'Exporting...'**
  String get exporting;

  /// File picker dialog title for saving export
  ///
  /// In en, this message translates to:
  /// **'Save Export'**
  String get saveExport;

  /// Create collection dialog title
  ///
  /// In en, this message translates to:
  /// **'Create Collection'**
  String get createCollection;

  /// Label for collection name input field
  ///
  /// In en, this message translates to:
  /// **'Collection name'**
  String get collectionName;

  /// Hint text for collection name input
  ///
  /// In en, this message translates to:
  /// **'My Collection'**
  String get myCollection;

  /// Text for template selection section
  ///
  /// In en, this message translates to:
  /// **'Choose a template (optional)'**
  String get chooseTemplateOptional;

  /// Label for empty template option
  ///
  /// In en, this message translates to:
  /// **'Empty'**
  String get empty;

  /// Empty state title when no collections exist
  ///
  /// In en, this message translates to:
  /// **'No Collections'**
  String get noCollections;

  /// Empty state description for collections
  ///
  /// In en, this message translates to:
  /// **'Create collections to organize your files'**
  String get createCollectionsToOrganize;

  /// Delete collection dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete \"{collectionName}\"'**
  String deleteCollection(String collectionName);

  /// Confirmation message for deleting a collection
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this collection? This will not delete the actual files.'**
  String get deleteCollectionConfirmation;

  /// Title for smart suggestion in collection item
  ///
  /// In en, this message translates to:
  /// **'Smart Suggestion'**
  String get smartSuggestion;

  /// Button text for keeping item in current position
  ///
  /// In en, this message translates to:
  /// **'Keep Here'**
  String get keepHere;

  /// Error message for invalid folder name
  ///
  /// In en, this message translates to:
  /// **'Invalid folder name'**
  String get invalidFolderName;

  /// Error message for invalid characters in folder name
  ///
  /// In en, this message translates to:
  /// **'Invalid characters in folder name'**
  String get invalidCharactersInFolderName;

  /// Success message when folder is created
  ///
  /// In en, this message translates to:
  /// **'Folder \"{folderName}\" created'**
  String folderCreated(String folderName);

  /// Message prompting user to use File > Open menu to open a folder
  ///
  /// In en, this message translates to:
  /// **'Use File > Open to open a folder'**
  String get useFileOpenToOpenFolder;

  /// Message prompting user to use welcome screen to create a new file
  ///
  /// In en, this message translates to:
  /// **'Use the welcome screen to create a new file'**
  String get useWelcomeScreenToCreateFile;

  /// Message indicating settings panel is not yet available
  ///
  /// In en, this message translates to:
  /// **'Settings panel coming soon'**
  String get settingsPanelComingSoon;

  /// Success message when a file is opened
  ///
  /// In en, this message translates to:
  /// **'Opened: {fileName}'**
  String openedFile(String fileName);

  /// Label for option to include hidden files in search
  ///
  /// In en, this message translates to:
  /// **'Include hidden files'**
  String get includeHiddenFiles;

  /// Success message when file is saved
  ///
  /// In en, this message translates to:
  /// **'File saved successfully'**
  String get fileSavedSuccessfully;

  /// Error message when file save fails
  ///
  /// In en, this message translates to:
  /// **'Error saving file: {error}'**
  String errorSavingFile(String error);

  /// Message when there is no content to preview
  ///
  /// In en, this message translates to:
  /// **'No content to preview'**
  String get noContentToPreview;

  /// Title for syntax warnings dialog
  ///
  /// In en, this message translates to:
  /// **'Syntax Warnings'**
  String get syntaxWarnings;

  /// Message when no search matches are found
  ///
  /// In en, this message translates to:
  /// **'No matches found for \"{searchText}\"'**
  String noMatchesFound(String searchText);

  /// Message showing number of replacements made
  ///
  /// In en, this message translates to:
  /// **'Replaced {count} occurrences'**
  String replacedOccurrences(int count);

  /// Title for create new folder dialog
  ///
  /// In en, this message translates to:
  /// **'Create New Folder'**
  String get createNewFolder;

  /// Success message when folder is created
  ///
  /// In en, this message translates to:
  /// **'Created folder: {folderName}'**
  String createdFolder(String folderName);

  /// Message prompting user to open a workspace
  ///
  /// In en, this message translates to:
  /// **'Please open a workspace first'**
  String get pleaseOpenWorkspaceFirst;

  /// Title for create new file dialog
  ///
  /// In en, this message translates to:
  /// **'Create New File'**
  String get createNewFile;

  /// Success message when file is created and opened
  ///
  /// In en, this message translates to:
  /// **'Created and opened: {fileName}'**
  String createdAndOpenedFile(String fileName);

  /// Placeholder text for search panel
  ///
  /// In en, this message translates to:
  /// **'Search Panel\n(To be implemented)'**
  String get searchPanelPlaceholder;

  /// Placeholder text for source control panel
  ///
  /// In en, this message translates to:
  /// **'Source Control Panel\n(To be implemented)'**
  String get sourceControlPanelPlaceholder;

  /// Placeholder text for debug panel
  ///
  /// In en, this message translates to:
  /// **'Debug Panel\n(To be implemented)'**
  String get debugPanelPlaceholder;

  /// Placeholder text for extensions panel
  ///
  /// In en, this message translates to:
  /// **'Extensions Panel\n(To be implemented)'**
  String get extensionsPanelPlaceholder;

  /// Placeholder text for settings panel
  ///
  /// In en, this message translates to:
  /// **'Settings Panel\n(To be implemented)'**
  String get settingsPanelPlaceholder;

  /// Message prompting user to select a panel from sidebar
  ///
  /// In en, this message translates to:
  /// **'Select a panel from the sidebar'**
  String get selectPanelFromSidebar;

  /// Tooltip for the settings sidebar button
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTooltip;

  /// Tooltip for the explorer sidebar button
  ///
  /// In en, this message translates to:
  /// **'Explorer'**
  String get explorerTooltip;

  /// Tooltip for the search sidebar button
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchTooltip;

  /// License information for Flutter
  ///
  /// In en, this message translates to:
  /// **'Flutter - BSD License'**
  String get flutterLicense;

  /// License information for Riverpod
  ///
  /// In en, this message translates to:
  /// **'Riverpod - MIT License'**
  String get riverpodLicense;

  /// License information for Adaptive Theme
  ///
  /// In en, this message translates to:
  /// **'Adaptive Theme - MIT License'**
  String get adaptiveThemeLicense;

  /// License information for File Picker
  ///
  /// In en, this message translates to:
  /// **'File Picker - MIT License'**
  String get filePickerLicense;

  /// License information for Shared Preferences
  ///
  /// In en, this message translates to:
  /// **'Shared Preferences - BSD License'**
  String get sharedPreferencesLicense;

  /// PDF export format name
  ///
  /// In en, this message translates to:
  /// **'PDF'**
  String get pdf;

  /// HTML export format name
  ///
  /// In en, this message translates to:
  /// **'HTML'**
  String get html;

  /// Markdown export format name
  ///
  /// In en, this message translates to:
  /// **'Markdown'**
  String get markdown;

  /// Plain text export format name
  ///
  /// In en, this message translates to:
  /// **'Plain Text'**
  String get plainText;

  /// Application name in mobile app bar
  ///
  /// In en, this message translates to:
  /// **'Loom'**
  String get loomAppTitle;

  /// Knowledge base title in mobile drawer header
  ///
  /// In en, this message translates to:
  /// **'Loom Knowledge Base'**
  String get loomKnowledgeBase;

  /// Workspace subtitle in mobile drawer header
  ///
  /// In en, this message translates to:
  /// **'Your workspace'**
  String get yourWorkspace;

  /// Recent files drawer item
  ///
  /// In en, this message translates to:
  /// **'Recent Files'**
  String get recentFiles;

  /// Favorites drawer item
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// History drawer item
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// Help and support drawer item
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpAndSupport;

  /// Dark mode toggle label
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// Documents bottom navigation label
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get documents;

  /// Search bottom navigation label
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// Editor bottom navigation label
  ///
  /// In en, this message translates to:
  /// **'Editor'**
  String get editor;

  /// Collections bottom navigation label
  ///
  /// In en, this message translates to:
  /// **'Collections'**
  String get collections;

  /// Welcome subtitle in mobile documents view
  ///
  /// In en, this message translates to:
  /// **'Welcome to your knowledge base'**
  String get welcomeToYourKnowledgeBase;

  /// Project notes subtitle in mobile documents view
  ///
  /// In en, this message translates to:
  /// **'Development documentation'**
  String get developmentDocumentation;

  /// Welcome title in desktop content area
  ///
  /// In en, this message translates to:
  /// **'Welcome to Loom'**
  String get welcomeToLoomTitle;

  /// Welcome subtitle in desktop content area
  ///
  /// In en, this message translates to:
  /// **'Your next-generation knowledge base'**
  String get yourNextGenerationKnowledgeBase;

  /// Open folder action title
  ///
  /// In en, this message translates to:
  /// **'Open Folder'**
  String get openFolderTitle;

  /// Open folder action subtitle
  ///
  /// In en, this message translates to:
  /// **'Open an existing workspace'**
  String get openAnExistingWorkspace;

  /// New file action title
  ///
  /// In en, this message translates to:
  /// **'New File'**
  String get newFileTitle;

  /// New file action subtitle
  ///
  /// In en, this message translates to:
  /// **'Create a new document'**
  String get createANewDocument;

  /// Clone repository action title
  ///
  /// In en, this message translates to:
  /// **'Clone Repository'**
  String get cloneRepositoryTitle;

  /// Clone repository action subtitle
  ///
  /// In en, this message translates to:
  /// **'Clone from Git'**
  String get cloneFromGit;

  /// Success message when workspace is opened
  ///
  /// In en, this message translates to:
  /// **'Opened workspace: {workspaceName}'**
  String openedWorkspace(String workspaceName);

  /// Loading message during repository cloning
  ///
  /// In en, this message translates to:
  /// **'Cloning repository...'**
  String get cloningRepository;

  /// Success message when repository is cloned
  ///
  /// In en, this message translates to:
  /// **'Successfully cloned repository to: {path}'**
  String successfullyClonedRepository(String path);

  /// Repository URL input label
  ///
  /// In en, this message translates to:
  /// **'Repository URL'**
  String get repositoryUrl;

  /// Repository URL input hint
  ///
  /// In en, this message translates to:
  /// **'Enter Git repository URL (e.g., https://github.com/user/repo.git)'**
  String get enterGitRepositoryUrl;

  /// Target directory input label
  ///
  /// In en, this message translates to:
  /// **'Target Directory (optional)'**
  String get targetDirectoryOptional;

  /// Target directory input hint
  ///
  /// In en, this message translates to:
  /// **'Leave empty to use repository name'**
  String get leaveEmptyToUseRepositoryName;

  /// Editor view title showing current file
  ///
  /// In en, this message translates to:
  /// **'Editing: {filePath}'**
  String editingFile(String filePath);

  /// Placeholder text in editor view
  ///
  /// In en, this message translates to:
  /// **'Editor content will be implemented here.\n\nThis is where your innovative knowledge base editing experience will live!'**
  String get editorContentPlaceholder;

  /// Button text during replace operation
  ///
  /// In en, this message translates to:
  /// **'Replacing...'**
  String get replacing;

  /// Button text during replace all operation
  ///
  /// In en, this message translates to:
  /// **'Replacing All...'**
  String get replacingAll;

  /// Title for search error dialog
  ///
  /// In en, this message translates to:
  /// **'Search Error'**
  String searchError(Object error);

  /// Section title for recent search queries
  ///
  /// In en, this message translates to:
  /// **'Recent Searches'**
  String get recentSearches;

  /// Title for folder selection dialog
  ///
  /// In en, this message translates to:
  /// **'Select Folder'**
  String get selectFolder;

  /// Tooltip for navigate up button
  ///
  /// In en, this message translates to:
  /// **'Go up'**
  String get goUp;

  /// Section title for quick access buttons
  ///
  /// In en, this message translates to:
  /// **'Quick Access'**
  String get quickAccess;

  /// Home directory quick access label
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Workspaces directory quick access label
  ///
  /// In en, this message translates to:
  /// **'Workspaces'**
  String get workspaces;

  /// Section title for folders list
  ///
  /// In en, this message translates to:
  /// **'Folders'**
  String get folders;

  /// Message when no folders are found in current directory
  ///
  /// In en, this message translates to:
  /// **'No folders found'**
  String get noFoldersFound;

  /// Summary text showing search results count and time
  ///
  /// In en, this message translates to:
  /// **'{matches} matches in {files} files ({time}ms)'**
  String searchResultsSummary(int matches, int files, int time);

  /// Number of matches in a file
  ///
  /// In en, this message translates to:
  /// **'{count} matches'**
  String matchesInFile(int count);

  /// Prefix for line number display
  ///
  /// In en, this message translates to:
  /// **'Line {number}'**
  String linePrefix(int number);

  /// Hint text for command palette search field
  ///
  /// In en, this message translates to:
  /// **'Type to search files and commands...'**
  String get typeToSearchFilesAndCommands;

  /// Message when no search results are found
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResultsFound;

  /// Keyboard shortcut hint for navigation
  ///
  /// In en, this message translates to:
  /// **'↑↓ Navigate'**
  String get navigateUpDown;

  /// Keyboard shortcut hint for selection
  ///
  /// In en, this message translates to:
  /// **'↵ Select'**
  String get selectEnter;

  /// Keyboard shortcut hint for closing
  ///
  /// In en, this message translates to:
  /// **'Esc Close'**
  String get closeEscape;

  /// Title for file search dialog
  ///
  /// In en, this message translates to:
  /// **'Find File'**
  String get findFile;

  /// Hint text for file search field
  ///
  /// In en, this message translates to:
  /// **'Type to search files...'**
  String get typeToSearchFiles;

  /// Message when no files are found in workspace
  ///
  /// In en, this message translates to:
  /// **'No files found in workspace'**
  String get noFilesFoundInWorkspace;

  /// Message when no files match the search query
  ///
  /// In en, this message translates to:
  /// **'No files match your search'**
  String get noFilesMatchSearch;

  /// Keyboard shortcuts for file search dialog
  ///
  /// In en, this message translates to:
  /// **'↑↓ Navigate • ↵ Open • Esc Close'**
  String get navigateOpenClose;

  /// Tooltip for theme switch button
  ///
  /// In en, this message translates to:
  /// **'Switch Theme'**
  String get switchTheme;

  /// Layout and visual settings section title
  ///
  /// In en, this message translates to:
  /// **'Layout & Visual'**
  String get layoutAndVisual;

  /// Compact mode setting label
  ///
  /// In en, this message translates to:
  /// **'Compact Mode'**
  String get compactMode;

  /// Description for compact mode setting
  ///
  /// In en, this message translates to:
  /// **'Use smaller UI elements and reduced spacing'**
  String get compactModeDescription;

  /// Show icons in menu setting label
  ///
  /// In en, this message translates to:
  /// **'Show Icons in Menu'**
  String get showIconsInMenu;

  /// Description for show icons in menu setting
  ///
  /// In en, this message translates to:
  /// **'Display icons next to menu items'**
  String get showIconsInMenuDescription;

  /// Animation speed setting label
  ///
  /// In en, this message translates to:
  /// **'Animation Speed'**
  String get animationSpeed;

  /// Description for animation speed setting
  ///
  /// In en, this message translates to:
  /// **'Speed of UI animations and transitions'**
  String get animationSpeedDescription;

  /// Slow animation speed option
  ///
  /// In en, this message translates to:
  /// **'Slow'**
  String get slow;

  /// Normal animation speed option
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get normal;

  /// Fast animation speed option
  ///
  /// In en, this message translates to:
  /// **'Fast'**
  String get fast;

  /// Disabled animation speed option
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get disabled;

  /// Sidebar transparency setting label
  ///
  /// In en, this message translates to:
  /// **'Sidebar Transparency'**
  String get sidebarTransparency;

  /// Description for sidebar transparency setting
  ///
  /// In en, this message translates to:
  /// **'Make sidebar background semi-transparent'**
  String get sidebarTransparencyDescription;

  /// Description for interface settings page
  ///
  /// In en, this message translates to:
  /// **'Configure window controls and layout options'**
  String get interfaceDescription;

  /// Current application version number
  ///
  /// In en, this message translates to:
  /// **'1.0.0'**
  String get currentVersion;

  /// Current application build number
  ///
  /// In en, this message translates to:
  /// **'20241201'**
  String get currentBuild;

  /// Theme settings page title
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// Current theme section title
  ///
  /// In en, this message translates to:
  /// **'Current Theme'**
  String get currentTheme;

  /// Description for current theme section
  ///
  /// In en, this message translates to:
  /// **'Your currently active theme'**
  String get currentThemeDescription;

  /// Color scheme label
  ///
  /// In en, this message translates to:
  /// **'Color Scheme:'**
  String get colorScheme;

  /// Primary color label
  ///
  /// In en, this message translates to:
  /// **'Primary'**
  String get primary;

  /// Secondary color label
  ///
  /// In en, this message translates to:
  /// **'Secondary'**
  String get secondary;

  /// Surface color label
  ///
  /// In en, this message translates to:
  /// **'Surface'**
  String get surface;

  /// Theme presets section title
  ///
  /// In en, this message translates to:
  /// **'Theme Presets'**
  String get themePresets;

  /// Description for theme presets section
  ///
  /// In en, this message translates to:
  /// **'Choose from pre-designed themes. System themes automatically adapt to your system settings.'**
  String get themePresetsDescription;

  /// System themes group title
  ///
  /// In en, this message translates to:
  /// **'System Themes'**
  String get systemThemes;

  /// Light themes group title
  ///
  /// In en, this message translates to:
  /// **'Light Themes'**
  String get lightThemes;

  /// Dark themes group title
  ///
  /// In en, this message translates to:
  /// **'Dark Themes'**
  String get darkThemes;

  /// Customize colors section title
  ///
  /// In en, this message translates to:
  /// **'Customize Colors'**
  String get customizeColors;

  /// Description for customize colors section
  ///
  /// In en, this message translates to:
  /// **'Personalize your theme colors'**
  String get customizeColorsDescription;

  /// Primary color picker label
  ///
  /// In en, this message translates to:
  /// **'Primary Color'**
  String get primaryColor;

  /// Secondary color picker label
  ///
  /// In en, this message translates to:
  /// **'Secondary Color'**
  String get secondaryColor;

  /// Surface color picker label
  ///
  /// In en, this message translates to:
  /// **'Surface Color'**
  String get surfaceColor;

  /// Typography section title
  ///
  /// In en, this message translates to:
  /// **'Typography'**
  String get typography;

  /// Description for typography section
  ///
  /// In en, this message translates to:
  /// **'Customize fonts and text appearance'**
  String get typographyDescription;

  /// Window controls settings section title
  ///
  /// In en, this message translates to:
  /// **'Window Controls'**
  String get windowControls;

  /// Show window controls toggle label
  ///
  /// In en, this message translates to:
  /// **'Show Window Controls'**
  String get showWindowControls;

  /// Description for show window controls setting
  ///
  /// In en, this message translates to:
  /// **'Display minimize, maximize, and close buttons'**
  String get showWindowControlsDescription;

  /// Window controls placement setting label
  ///
  /// In en, this message translates to:
  /// **'Controls Placement'**
  String get controlsPlacement;

  /// Description for controls placement setting
  ///
  /// In en, this message translates to:
  /// **'Position of window control buttons'**
  String get controlsPlacementDescription;

  /// Window controls order setting label
  ///
  /// In en, this message translates to:
  /// **'Controls Order'**
  String get controlsOrder;

  /// Description for controls order setting
  ///
  /// In en, this message translates to:
  /// **'Order of window control buttons'**
  String get controlsOrderDescription;

  /// Auto option for various settings
  ///
  /// In en, this message translates to:
  /// **'Auto'**
  String get auto;

  /// Left position option
  ///
  /// In en, this message translates to:
  /// **'Left'**
  String get left;

  /// Right position option
  ///
  /// In en, this message translates to:
  /// **'Right'**
  String get right;

  /// Standard window controls order
  ///
  /// In en, this message translates to:
  /// **'Minimize, Maximize, Close'**
  String get minimizeMaximizeClose;

  /// macOS style window controls order
  ///
  /// In en, this message translates to:
  /// **'Close, Minimize, Maximize'**
  String get closeMinimizeMaximize;

  /// Reverse window controls order
  ///
  /// In en, this message translates to:
  /// **'Close, Maximize, Minimize'**
  String get closeMaximizeMinimize;

  /// Close button positions settings section title
  ///
  /// In en, this message translates to:
  /// **'Close Button Positions'**
  String get closeButtonPositions;

  /// Description for close button positions settings
  ///
  /// In en, this message translates to:
  /// **'Configure where close buttons appear in tabs and panels'**
  String get closeButtonPositionsDescription;

  /// Quick settings section title
  ///
  /// In en, this message translates to:
  /// **'Quick Settings'**
  String get quickSettings;

  /// Description for quick settings section
  ///
  /// In en, this message translates to:
  /// **'Set all close buttons at once'**
  String get quickSettingsDescription;

  /// Description for auto quick setting
  ///
  /// In en, this message translates to:
  /// **'Follow platform default settings for the close button'**
  String get autoDescription;

  /// All left quick setting title
  ///
  /// In en, this message translates to:
  /// **'All Left'**
  String get allLeft;

  /// Description for all left quick setting
  ///
  /// In en, this message translates to:
  /// **'Close buttons and window controls on left'**
  String get allLeftDescription;

  /// All right quick setting title
  ///
  /// In en, this message translates to:
  /// **'All Right'**
  String get allRight;

  /// Description for all right quick setting
  ///
  /// In en, this message translates to:
  /// **'Close buttons and window controls on right'**
  String get allRightDescription;

  /// Individual settings section title
  ///
  /// In en, this message translates to:
  /// **'Individual Settings'**
  String get individualSettings;

  /// Description for individual settings section
  ///
  /// In en, this message translates to:
  /// **'Fine-tune each close button position'**
  String get individualSettingsDescription;

  /// Tab close buttons setting title
  ///
  /// In en, this message translates to:
  /// **'Tab Close Buttons'**
  String get tabCloseButtons;

  /// Description for tab close buttons setting
  ///
  /// In en, this message translates to:
  /// **'Position of close buttons in tabs'**
  String get tabCloseButtonsDescription;

  /// Panel close buttons setting title
  ///
  /// In en, this message translates to:
  /// **'Panel Close Buttons'**
  String get panelCloseButtons;

  /// Description for panel close buttons setting
  ///
  /// In en, this message translates to:
  /// **'Position of close buttons in panels'**
  String get panelCloseButtonsDescription;

  /// Currently label for effective position display
  ///
  /// In en, this message translates to:
  /// **'Currently'**
  String get currently;

  /// Placeholder text for the sidebar search field
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get sidebarSearchPlaceholder;

  /// Label for the sidebar search options
  ///
  /// In en, this message translates to:
  /// **'Options'**
  String get sidebarSearchOptions;

  /// Title for the appearance detail page in settings
  ///
  /// In en, this message translates to:
  /// **'Appearance Settings'**
  String get settingsAppearanceDetail;

  /// Title for the interface detail page in settings
  ///
  /// In en, this message translates to:
  /// **'Interface Settings'**
  String get settingsInterfaceDetail;

  /// Placeholder text for the topbar search dialog
  ///
  /// In en, this message translates to:
  /// **'Type to search...'**
  String get topbarSearchDialogPlaceholder;

  /// Auto-added metadata for showAppTitle
  ///
  /// In en, this message translates to:
  /// **'Show App Title'**
  String get showAppTitle;

  /// Auto-added metadata for showAppTitleSubtitle
  ///
  /// In en, this message translates to:
  /// **'Display application name in the top bar'**
  String get showAppTitleSubtitle;

  /// Auto-added metadata for applicationTitleLabel
  ///
  /// In en, this message translates to:
  /// **'Application Title'**
  String get applicationTitleLabel;

  /// Auto-added metadata for applicationTitleHint
  ///
  /// In en, this message translates to:
  /// **'Enter custom app title'**
  String get applicationTitleHint;

  /// Auto-added metadata for showSearchBarTitle
  ///
  /// In en, this message translates to:
  /// **'Show Search Bar'**
  String get showSearchBarTitle;

  /// Auto-added metadata for showSearchBarSubtitle
  ///
  /// In en, this message translates to:
  /// **'Display search functionality in top bar'**
  String get showSearchBarSubtitle;

  /// Auto-added metadata for animationSpeedTestTitle
  ///
  /// In en, this message translates to:
  /// **'Animation Speed Test'**
  String get animationSpeedTestTitle;

  /// Auto-added metadata for hoverMeFastAnimation
  ///
  /// In en, this message translates to:
  /// **'Hover Me (Fast Animation)'**
  String get hoverMeFastAnimation;

  /// Auto-added metadata for fadeInNormalSpeed
  ///
  /// In en, this message translates to:
  /// **'Fade In Animation (Normal Speed)'**
  String get fadeInNormalSpeed;

  /// Auto-added metadata for gettingStartedTitle
  ///
  /// In en, this message translates to:
  /// **'Getting Started'**
  String get gettingStartedTitle;

  /// Auto-added metadata for projectNotesTitle
  ///
  /// In en, this message translates to:
  /// **'Project Notes'**
  String get projectNotesTitle;

  /// Title for file search option in side panel
  ///
  /// In en, this message translates to:
  /// **'Files'**
  String get searchOptionFilesTitle;

  /// Subtitle for file search option in side panel
  ///
  /// In en, this message translates to:
  /// **'Search in file names'**
  String get searchOptionFilesSubtitle;

  /// Title for content search option in side panel
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get searchOptionContentTitle;

  /// Subtitle for content search option in side panel
  ///
  /// In en, this message translates to:
  /// **'Search in file content'**
  String get searchOptionContentSubtitle;

  /// Title for symbol search option in side panel
  ///
  /// In en, this message translates to:
  /// **'Symbols'**
  String get searchOptionSymbolsTitle;

  /// Subtitle for symbol search option in side panel
  ///
  /// In en, this message translates to:
  /// **'Search for functions, classes'**
  String get searchOptionSymbolsSubtitle;

  /// Indicator when more search matches exist in a file
  ///
  /// In en, this message translates to:
  /// **'+{count} more matches'**
  String moreMatches(int count);

  /// Shown when a plugin has no commands
  ///
  /// In en, this message translates to:
  /// **'No commands available'**
  String get noCommandsAvailable;

  /// Command palette item title for file search
  ///
  /// In en, this message translates to:
  /// **'Search Files'**
  String get commandPaletteSearchFilesTitle;

  /// Command palette item subtitle for file search
  ///
  /// In en, this message translates to:
  /// **'Search for files by name'**
  String get commandPaletteSearchFilesSubtitle;

  /// Command palette item title for content search
  ///
  /// In en, this message translates to:
  /// **'Search in Files'**
  String get commandPaletteSearchInFilesTitle;

  /// Command palette item subtitle for content search
  ///
  /// In en, this message translates to:
  /// **'Search for text content in files'**
  String get commandPaletteSearchInFilesSubtitle;

  /// Footer label showing number of files
  ///
  /// In en, this message translates to:
  /// **'{count} files'**
  String footerFilesCount(int count);
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['de', 'en', 'es', 'fr', 'ja', 'ko', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de': return AppLocalizationsDe();
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
    case 'fr': return AppLocalizationsFr();
    case 'ja': return AppLocalizationsJa();
    case 'ko': return AppLocalizationsKo();
    case 'zh': return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
