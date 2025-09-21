import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Loom - Wissensdatenbank';

  @override
  String get uiPolishShowcase => 'UI-Polish Demo';

  @override
  String get enhancedUiAnimations => 'Erweiterte UI-Animationen';

  @override
  String get loadingIndicators => 'Lade-Anzeigen';

  @override
  String get smoothLoading => 'Sanftes Laden';

  @override
  String get skeletonLoader => 'Platzhalter-Lader';

  @override
  String get interactiveElements => 'Interaktive Elemente';

  @override
  String get hoverAnimation => 'Hover-Animation';

  @override
  String get pressAnimation => 'Drück-Animation';

  @override
  String get pulseAnimation => 'Puls-Animation';

  @override
  String get shimmerEffects => 'Schimmer-Effekte';

  @override
  String get successAnimations => 'Erfolgs-Animationen';

  @override
  String get taskCompleted => 'Aufgabe abgeschlossen!';

  @override
  String get animationCombinations => 'Animationskombinationen';

  @override
  String get interactiveButton => 'Interaktiver Button';

  @override
  String get animatedCard => 'Animierte Karte';

  @override
  String get animatedCardDescription => 'Diese Karte demonstriert Fade-in- und Slide-in-Animationen kombiniert.';

  @override
  String get general => 'Allgemein';

  @override
  String get generalDescription => 'Allgemeine Einstellungen und Verhalten der Anwendung';

  @override
  String get autoSave => 'Automatisches Speichern';

  @override
  String get autoSaveDescription => 'Änderungen automatisch in regelmäßigen Abständen speichern';

  @override
  String get confirmOnExit => 'Beim Beenden bestätigen';

  @override
  String get confirmOnExitDescription => 'Bei Schließen mit ungespeicherten Änderungen nachfragen';

  @override
  String get language => 'Sprache';

  @override
  String get languageDescription => 'Sprache der Anwendung';

  @override
  String get followSystemLanguage => 'Systemsprache verwenden';

  @override
  String get manualLanguageSelection => 'Sprache manuell wählen';

  @override
  String get english => 'Englisch';

  @override
  String get spanish => 'Spanisch';

  @override
  String get french => 'Französisch';

  @override
  String get german => 'Deutsch (Sprache)';

  @override
  String get chinese => 'Chinesisch';

  @override
  String get japanese => '日本語';

  @override
  String get korean => '한국어';

  @override
  String get autoSaveInterval => 'Auto-Speicher-Intervall';

  @override
  String lastSaved(Object time) {
    return 'Zuletzt gespeichert: ';
  }

  @override
  String get justNow => 'gerade eben';

  @override
  String minutesAgo(int count) {
    return 'vor ${count}m';
  }

  @override
  String hoursAgo(int count) {
    return 'vor ${count}h';
  }

  @override
  String daysAgo(int count) {
    return 'vor $count Tagen';
  }

  @override
  String get commandExecutedSuccessfully => 'Befehl erfolgreich ausgeführt';

  @override
  String commandFailed(String error) {
    return 'Befehl fehlgeschlagen: $error';
  }

  @override
  String failedToExecuteCommand(String error) {
    return 'Befehl konnte nicht ausgeführt werden: $error';
  }

  @override
  String get about => 'Über';

  @override
  String get aboutDescription => 'Informationen über Loom';

  @override
  String get version => 'Version (aktuell)';

  @override
  String get licenses => 'Lizenzen';

  @override
  String get viewOpenSourceLicenses => 'Open-Source-Lizenzen anzeigen';

  @override
  String get loom => 'Loom App';

  @override
  String get build => 'Build-Nummer';

  @override
  String get loomDescription => 'Loom ist ein moderner Editor, entwickelt mit Flutter, optimiert für Produktivität.';

  @override
  String get copyright => '© 2024 Loom-Team';

  @override
  String get close => 'Schließen';

  @override
  String get openSourceLicenses => 'Open-Source-Lizenzen';

  @override
  String get usesFollowingLibraries => 'Loom verwendet folgende Open-Source-Bibliotheken:';

  @override
  String get fullLicenseTexts => 'Vollständige Lizenztexte finden Sie in den jeweiligen Repository-Ordnern.';

  @override
  String get enterPath => 'Pfad eingeben';

  @override
  String get directoryPath => 'Verzeichnispfad';

  @override
  String get pathHint => '/home/benutzer/ordner';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get go => 'Los';

  @override
  String get select => 'Auswählen';

  @override
  String get apply => 'Anwenden';

  @override
  String get preview => 'Vorschau';

  @override
  String selectColorLabel(String label) {
    return '$label-Farbe wählen';
  }

  @override
  String get fontFamilyLabel => 'Schriftart';

  @override
  String get fontSizeLabel => 'Schriftgröße';

  @override
  String get previewSampleText => 'Vorschau: Der schnelle braune Fuchs springt über den faulen Hund';

  @override
  String get searchFilesAndCommands => 'Dateien und Befehle durchsuchen...';

  @override
  String get commandKeyShortcut => 'Befehl: ⌘K';

  @override
  String get menu => 'Menü';

  @override
  String get file => 'Datei';

  @override
  String get newFile => 'Neue Datei';

  @override
  String get openFolder => 'Ordner öffnen';

  @override
  String get save => 'Speichern';

  @override
  String get saveAs => 'Speichern unter';

  @override
  String get export => 'Exportieren';

  @override
  String get exit => 'Beenden';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get undo => 'Rückgängig';

  @override
  String get redo => 'Wiederholen';

  @override
  String get cut => 'Ausschneiden';

  @override
  String get copy => 'Kopieren';

  @override
  String get paste => 'Einfügen';

  @override
  String get view => 'Ansicht';

  @override
  String get toggleSidebar => 'Seitenleiste umschalten';

  @override
  String get togglePanel => 'Panel umschalten';

  @override
  String get fullScreen => 'Vollbild';

  @override
  String get help => 'Hilfe';

  @override
  String get documentation => 'Dokumentation';

  @override
  String get plugins => 'Erweiterungen';

  @override
  String get pluginManager => 'Plugin-Verwaltung';

  @override
  String get noPluginsLoaded => 'Keine Plugins geladen';

  @override
  String get openFolderFirst => 'Öffnen Sie zuerst einen Ordner';

  @override
  String get noFileOpenToSave => 'Keine Datei geöffnet zum Speichern';

  @override
  String fileSaved(String filename) {
    return 'Datei \"$filename\" gespeichert';
  }

  @override
  String get noContentToExport => 'Kein Inhalt zum Exportieren';

  @override
  String get exitApplication => 'Anwendung beenden';

  @override
  String get confirmExit => 'Sind Sie sicher, dass Sie Loom beenden möchten?';

  @override
  String get openInNewTab => 'In neuem Tab öffnen';

  @override
  String get rename => 'Umbenennen';

  @override
  String get delete => 'Löschen';

  @override
  String get deleteItem => 'Element löschen';

  @override
  String get cancelButton => 'Abbrechen';

  @override
  String get enterPathPrompt => 'Pfad eingeben:';

  @override
  String get folderPathLabel => 'Ordnerpfad';

  @override
  String get folderPathHint => '/home/user/ordner';

  @override
  String get enterFolderNameHint => 'Ordnername eingeben';

  @override
  String get browse => 'Durchsuchen';

  @override
  String get selectFolderLocation => 'Speicherort auswählen';

  @override
  String failedToSelectLocation(String error) {
    return 'Auswahl des Speicherorts fehlgeschlagen: $error';
  }

  @override
  String folderCreatedSuccess(String folderName) {
    return 'Ordner \"$folderName\" erfolgreich erstellt!';
  }

  @override
  String failedToCreateFolder(String error) {
    return 'Ordner konnte nicht erstellt werden: $error';
  }

  @override
  String get enterFileNameHint => 'Dateinamen eingeben';

  @override
  String get enterInitialFileContentHint => '(Optional) Anfangsinhalt für die Datei eingeben';

  @override
  String get enterNewNameHint => 'Neuen Namen eingeben';

  @override
  String get closeFolder => 'Ordner schließen';

  @override
  String get openFolderMenu => 'Ordner-Menü öffnen';

  @override
  String get createFolder => 'Ordner erstellen';

  @override
  String get filterFileExtensions => 'Dateitypen filtern';

  @override
  String get showHiddenFiles => 'Versteckte Dateien anzeigen';

  @override
  String failedToOpenFolder(String error) {
    return 'Ordner konnte nicht geöffnet werden: $error';
  }

  @override
  String failedToCreateFile(String error) {
    return 'Datei konnte nicht erstellt werden: $error';
  }

  @override
  String failedToDeleteItem(String error) {
    return 'Löschen des Elements fehlgeschlagen: $error';
  }

  @override
  String failedToRenameItem(String error) {
    return 'Umbenennen des Elements fehlgeschlagen: $error';
  }

  @override
  String renameSuccess(String name) {
    return 'Umbenannt in $name';
  }

  @override
  String deleteSuccess(String itemType) {
    return '$itemType erfolgreich gelöscht';
  }

  @override
  String get searchFilesHint => 'Dateinamen oder Inhalt eingeben';

  @override
  String get newFolderPlaceholder => 'Neuer Ordner';

  @override
  String get openInNewTabLabel => 'In neuem Tab öffnen';

  @override
  String get closeLabel => 'Schließen';

  @override
  String get closeOthersLabel => 'Andere schließen';

  @override
  String get closeAllLabel => 'Alle schließen';

  @override
  String get commentBlockTitle => 'Kommentarblock';

  @override
  String get systemDefault => 'Systemstandard';

  @override
  String get systemDefaultSubtitle => 'Folgen Sie den Systemeinstellungen';

  @override
  String get defaultLight => 'Standard (Hell)';

  @override
  String get defaultLightSubtitle => 'Helles Thema';

  @override
  String get defaultDark => 'Standard (Dunkel)';

  @override
  String get defaultDarkSubtitle => 'Dunkles Thema';

  @override
  String get minimizeTooltip => 'Minimieren';

  @override
  String get maximizeTooltip => 'Maximieren';

  @override
  String get closeTooltip => 'Schließen';

  @override
  String get zoomTooltip => 'Zoomen';

  @override
  String get toggleLineNumbersTooltip => 'Zeilennummern umschalten';

  @override
  String get toggleMinimapTooltip => 'Miniaturansicht umschalten';

  @override
  String syntaxWarningsTooltip(int count) {
    return '$count Syntax-Warnungen';
  }

  @override
  String get undoTooltip => 'Rückgängig';

  @override
  String get redoTooltip => 'Wiederholen';

  @override
  String get cutTooltip => 'Ausschneiden';

  @override
  String get copyTooltip => 'Kopieren';

  @override
  String get pasteTooltip => 'Einfügen';

  @override
  String get foldAllTooltip => 'Alle falten';

  @override
  String get unfoldAllTooltip => 'Alle entfalten';

  @override
  String get exportTooltip => 'Exportieren';

  @override
  String get moreActionsTooltip => 'Weitere Aktionen';

  @override
  String get newFileTooltip => 'Neue Datei erstellen';

  @override
  String get newFolderTooltip => 'Neuen Ordner erstellen';

  @override
  String get refreshTooltip => 'Aktualisieren';

  @override
  String get fileSystemTooltip => 'Dateisystem';

  @override
  String get collectionsTooltip => 'Sammlungen';

  @override
  String get removeFromCollectionTooltip => 'Aus Sammlung entfernen';

  @override
  String failedToCloneRepository(String error) {
    return 'Fehler beim Klonen des Repositories: $error';
  }

  @override
  String get openInNewTabAction => 'In neuem Tab öffnen';

  @override
  String get nothingToUndo => 'Nichts zum Rückgängig machen';

  @override
  String get nothingToRedo => 'Nichts zum Wiederherstellen';

  @override
  String get contentCutToClipboard => 'Inhalt ausgeschnitten und in Zwischenablage kopiert';

  @override
  String get noContentToCut => 'Kein Inhalt zum Ausschneiden';

  @override
  String get contentCopiedToClipboard => 'Inhalt in Zwischenablage kopiert';

  @override
  String get noContentToCopy => 'Kein Inhalt zum Kopieren';

  @override
  String get contentPastedFromClipboard => 'Inhalt aus Zwischenablage eingefügt';

  @override
  String get noTextInClipboard => 'Keine Textdaten in der Zwischenablage';

  @override
  String get selectSidebarItemFirst => 'Wählen Sie zuerst ein Element in der Seitenleiste aus';

  @override
  String get loomDocumentation => 'Loom Dokumentation';

  @override
  String get welcomeToLoom => 'Willkommen bei Loom';

  @override
  String get loomDescriptionFull => 'Loom ist ein moderner, auf Flutter basierender Editor, der für Produktivität entwickelt wurde.';

  @override
  String get keyFeatures => 'Hauptfunktionen';

  @override
  String get fileExplorerFeature => '• Datei-Explorer: Ihre Dateien durchsuchen und verwalten';

  @override
  String get richTextEditorFeature => 'Reicher Texteditor';

  @override
  String get searchFeature => 'Leistungsstarke Suche';

  @override
  String get settingsFeature => 'Umfangreiche Einstellungen';

  @override
  String get keyboardShortcuts => 'Tastenkürzel';

  @override
  String get saveShortcut => 'Speichern: ⌘S';

  @override
  String get globalSearchShortcut => 'Globale Suche: ⌘P';

  @override
  String get undoShortcut => 'Rückgängig: ⌘Z';

  @override
  String get redoShortcut => 'Wiederholen: ⇧⌘Z';

  @override
  String get fileName => 'Dateiname';

  @override
  String get enterFileName => 'Dateiname eingeben (z.B. beispiel.blox)';

  @override
  String get create => 'Erstellen';

  @override
  String get invalidFileName => 'Ungültiger Dateiname';

  @override
  String get invalidCharactersInFileName => 'Ungültige Zeichen im Dateinamen';

  @override
  String fileCreated(String filename) {
    return 'Datei \"$filename\" erstellt';
  }

  @override
  String get exportFile => 'Datei exportieren';

  @override
  String get enterExportLocation => 'Export-Speicherort eingeben';

  @override
  String get formatHint => 'Wählen Sie ein Exportformat';

  @override
  String fileExportedAs(String filename) {
    return 'Datei exportiert als \"$filename\"';
  }

  @override
  String failedToExportFile(String error) {
    return 'Datei konnte nicht exportiert werden: $error';
  }

  @override
  String get enterSaveLocation => 'Speicherort eingeben';

  @override
  String fileSavedAs(String filename) {
    return 'Datei gespeichert als \"$filename\"';
  }

  @override
  String failedToSaveFile(String error) {
    return 'Datei konnte nicht gespeichert werden: $error';
  }

  @override
  String get installed => 'Installiert';

  @override
  String get active => 'Aktiv';

  @override
  String get inactive => 'Inaktiv';

  @override
  String versionState(String version, String state) {
    return '$version ($state)';
  }

  @override
  String commandsCount(int count) {
    return '$count Befehle';
  }

  @override
  String failedToEnablePlugin(String error) {
    return 'Plugin konnte nicht aktiviert werden: $error';
  }

  @override
  String failedToDisablePlugin(String error) {
    return 'Plugin konnte nicht deaktiviert werden: $error';
  }

  @override
  String get disablePlugin => 'Plugin deaktivieren';

  @override
  String get enablePlugin => 'Plugin aktivieren';

  @override
  String get noPluginsCurrentlyLoaded => 'Derzeit keine Plugins geladen';

  @override
  String get settings => 'Einstellungen';

  @override
  String get allSettings => 'Alle Einstellungen';

  @override
  String get appearance => 'Erscheinungsbild';

  @override
  String get appearanceDescription => 'Erscheinungsbild-Einstellungen';

  @override
  String get appearanceSubtitle => 'Thema, Farben, Layout';

  @override
  String get interface => 'Oberfläche';

  @override
  String get interfaceSubtitle => 'Anzeigen und Verhalten anpassen';

  @override
  String get generalSubtitle => 'Allgemeine Optionen';

  @override
  String get aboutSubtitle => 'Version, Lizenzen';

  @override
  String get openLink => 'Link öffnen';

  @override
  String openLinkConfirmation(String url) {
    return 'Möchten Sie diesen Link öffnen? $url';
  }

  @override
  String urlCopiedToClipboard(String url) {
    return 'URL in die Zwischenablage kopiert $url';
  }

  @override
  String get copyUrl => 'URL kopieren';

  @override
  String footnote(String id) {
    return 'Fußnote $id';
  }

  @override
  String imageAlt(String src) {
    return 'Bildbeschreibung $src';
  }

  @override
  String get find => 'Suchen';

  @override
  String get findAndReplace => 'Suchen und ersetzen';

  @override
  String get hideReplace => 'Ersetzen ausblenden';

  @override
  String get showReplace => 'Ersetzen anzeigen';

  @override
  String get findLabel => 'Suchen';

  @override
  String get replaceWith => 'Ersetzen durch';

  @override
  String get matchCase => 'Groß-/Kleinschreibung beachten';

  @override
  String get useRegex => 'Regex verwenden';

  @override
  String get replace => 'Ersetzen';

  @override
  String get replaceAll => 'Alle ersetzen';

  @override
  String get findNext => 'Weitersuchen';

  @override
  String get goToLine => 'Gehe zu Zeile';

  @override
  String get pleaseEnterLineNumber => 'Bitte Zeilennummer eingeben';

  @override
  String get invalidLineNumber => 'Ungültige Zeilennummer';

  @override
  String get lineNumberMustBeGreaterThanZero => 'Die Zeilennummer muss größer als 0 sein';

  @override
  String lineNumberExceedsMaximum(int maxLines) {
    return 'Zeilennummer überschreitet Maximum $maxLines';
  }

  @override
  String lineNumberLabel(int maxLines) {
    return 'Zeilennummer $maxLines';
  }

  @override
  String get enterLineNumber => 'Zeilennummer eingeben';

  @override
  String totalLines(int count) {
    return 'Gesamtzeilen: $count';
  }

  @override
  String get share => 'Teilen';

  @override
  String get newDocument => 'Neues Dokument';

  @override
  String get newFolder => 'Neuer Ordner';

  @override
  String get scanDocument => 'Dokument scannen';

  @override
  String get total => 'Gesamt';

  @override
  String get noActivePlugins => 'Keine aktiven Plugins';

  @override
  String get searchYourKnowledgeBase => 'Durchsuche deine Wissensdatenbank';

  @override
  String get searchResultsWillAppearHere => 'Suchergebnisse werden hier angezeigt';

  @override
  String get collectionsViewForMobile => 'Sammlungsansicht für Mobilgeräte';

  @override
  String get searchEverything => 'Alles durchsuchen';

  @override
  String get mobileSearchInterface => 'Mobile Suche';

  @override
  String get exportDocument => 'Dokument exportieren';

  @override
  String fileLabel(String fileName) {
    return 'Datei: $fileName';
  }

  @override
  String get exportFormat => 'Export-Format';

  @override
  String get options => 'Optionen';

  @override
  String get includeLineNumbers => 'Zeilennummern einbeziehen';

  @override
  String get includeSyntaxHighlighting => 'Syntaxhervorhebung einschließen';

  @override
  String get includeHeader => 'Kopfzeile einschließen';

  @override
  String get headerText => 'Kopfzeilentext';

  @override
  String get documentTitle => 'Dokumenttitel';

  @override
  String get saveLocation => 'Speicherort';

  @override
  String get choose => 'Auswählen...';

  @override
  String get exporting => 'Exportiere...';

  @override
  String get saveExport => 'Export speichern';

  @override
  String get createCollection => 'Sammlung erstellen';

  @override
  String get collectionName => 'Sammlungsname';

  @override
  String get myCollection => 'Meine Sammlung';

  @override
  String get chooseTemplateOptional => 'Vorlage auswählen (optional)';

  @override
  String get empty => 'Leer';

  @override
  String get noCollections => 'Keine Sammlungen';

  @override
  String get createCollectionsToOrganize => 'Erstellen Sie Sammlungen, um Ihre Dateien zu organisieren';

  @override
  String deleteCollection(String collectionName) {
    return '\"$collectionName\" löschen';
  }

  @override
  String get deleteCollectionConfirmation => 'Sind Sie sicher, dass Sie diese Sammlung löschen möchten? Dies löscht nicht die eigentlichen Dateien.';

  @override
  String get smartSuggestion => 'Intelligente Vorschläge';

  @override
  String get keepHere => 'Hier aufbewahren';

  @override
  String get invalidFolderName => 'Ungültiger Ordnername';

  @override
  String get invalidCharactersInFolderName => 'Ungültige Zeichen im Ordnernamen';

  @override
  String folderCreated(String folderName) {
    return 'Ordner erstellt $folderName';
  }

  @override
  String get useFileOpenToOpenFolder => 'Verwenden Sie Datei > Öffnen, um einen Ordner zu öffnen';

  @override
  String get useWelcomeScreenToCreateFile => 'Verwenden Sie den Begrüßungsbildschirm, um eine Datei zu erstellen';

  @override
  String get settingsPanelComingSoon => 'Einstellungs-Panel bald verfügbar';

  @override
  String openedFile(String fileName) {
    return 'Geöffnete Datei $fileName';
  }

  @override
  String get includeHiddenFiles => 'Versteckte Dateien einbeziehen';

  @override
  String get fileSavedSuccessfully => 'Datei erfolgreich gespeichert';

  @override
  String errorSavingFile(String error) {
    return 'Fehler beim Speichern der Datei: $error';
  }

  @override
  String get noContentToPreview => 'Kein Inhalt zur Vorschau';

  @override
  String get syntaxWarnings => 'Syntax-Warnungen';

  @override
  String noMatchesFound(String searchText) {
    return 'Keine Treffer gefunden $searchText';
  }

  @override
  String replacedOccurrences(int count) {
    return 'Ersetzte Vorkommen: $count';
  }

  @override
  String get createNewFolder => 'Neuer Ordner erstellen';

  @override
  String createdFolder(String folderName) {
    return 'Ordner erstellt: $folderName';
  }

  @override
  String get pleaseOpenWorkspaceFirst => 'Bitte öffnen Sie zuerst einen Arbeitsbereich';

  @override
  String get createNewFile => 'Neue Datei erstellen';

  @override
  String createdAndOpenedFile(String fileName) {
    return 'Erstellt und geöffnet: $fileName';
  }

  @override
  String get searchPanelPlaceholder => 'Suchen...';

  @override
  String get sourceControlPanelPlaceholder => 'Quellcodeverwaltung...';

  @override
  String get debugPanelPlaceholder => 'Debug-Panel\n(Noch nicht implementiert)';

  @override
  String get extensionsPanelPlaceholder => 'Erweiterungen-Panel\n(Noch nicht implementiert)';

  @override
  String get settingsPanelPlaceholder => 'Einstellungen...';

  @override
  String get selectPanelFromSidebar => 'Wählen Sie ein Panel aus der Seitenleiste';

  @override
  String get settingsTooltip => 'Einstellungen';

  @override
  String get explorerTooltip => 'Datei-Explorer';

  @override
  String get searchTooltip => 'Suche';

  @override
  String get flutterLicense => 'Flutter Lizenz';

  @override
  String get riverpodLicense => 'Riverpod Lizenz';

  @override
  String get adaptiveThemeLicense => 'Adaptive Theme Lizenz';

  @override
  String get filePickerLicense => 'File Picker Lizenz';

  @override
  String get sharedPreferencesLicense => 'Shared Preferences Lizenz';

  @override
  String get pdf => 'PDF-Dokument';

  @override
  String get html => 'HTML-Dokument';

  @override
  String get markdown => 'Markdown-Dokument';

  @override
  String get plainText => 'Klartext';

  @override
  String get loomAppTitle => 'Loom – Wissensdatenbank';

  @override
  String get loomKnowledgeBase => 'Loom Wissensdatenbank';

  @override
  String get yourWorkspace => 'Ihr Arbeitsbereich';

  @override
  String get recentFiles => 'Zuletzt geöffnet';

  @override
  String get favorites => 'Favoriten';

  @override
  String get history => 'Verlauf';

  @override
  String get helpAndSupport => 'Hilfe & Support';

  @override
  String get darkMode => 'Dunkelmodus';

  @override
  String get documents => 'Dokumente';

  @override
  String get search => 'Suche';

  @override
  String get editor => 'Text-Editor';

  @override
  String get collections => 'Sammlungen';

  @override
  String get welcomeToYourKnowledgeBase => 'Willkommen in Ihrer Wissensdatenbank';

  @override
  String get developmentDocumentation => 'Entwicklungsdokumentation';

  @override
  String get welcomeToLoomTitle => 'Willkommen bei Loom';

  @override
  String get yourNextGenerationKnowledgeBase => 'Ihre nächste Generation Wissensdatenbank';

  @override
  String get openFolderTitle => 'Arbeitsbereich öffnen';

  @override
  String get openAnExistingWorkspace => 'Einen bestehenden Arbeitsbereich öffnen';

  @override
  String get newFileTitle => 'Neue Datei erstellen';

  @override
  String get createANewDocument => 'Neues Dokument erstellen';

  @override
  String get cloneRepositoryTitle => 'Repository klonen';

  @override
  String get cloneFromGit => 'Von Git klonen';

  @override
  String openedWorkspace(String workspaceName) {
    return 'Geöffneter Arbeitsbereich $workspaceName';
  }

  @override
  String get cloningRepository => 'Repository wird geklont...';

  @override
  String successfullyClonedRepository(String path) {
    return 'Repository erfolgreich geklont $path';
  }

  @override
  String get repositoryUrl => 'Repository-URL';

  @override
  String get enterGitRepositoryUrl => 'Git-Repository-URL eingeben';

  @override
  String get targetDirectoryOptional => 'Zielverzeichnis (optional)';

  @override
  String get leaveEmptyToUseRepositoryName => 'Leer lassen, um den Repository-Namen zu verwenden';

  @override
  String editingFile(String filePath) {
    return 'Datei bearbeiten $filePath';
  }

  @override
  String get editorContentPlaceholder => 'Beginnen Sie mit der Eingabe...';

  @override
  String get replacing => 'Ersetze';

  @override
  String get replacingAll => 'Ersetze alle';

  @override
  String searchError(Object error) {
    return 'Fehler bei der Suche';
  }

  @override
  String get recentSearches => 'Letzte Suchanfragen';

  @override
  String get selectFolder => 'Ordner auswählen';

  @override
  String get goUp => 'Nach oben';

  @override
  String get quickAccess => 'Schnellzugriff';

  @override
  String get home => 'Start';

  @override
  String get workspaces => 'Arbeitsbereiche';

  @override
  String get folders => 'Ordner';

  @override
  String get noFoldersFound => 'Keine Ordner gefunden';

  @override
  String searchResultsSummary(int matches, int files, int time) {
    return '$matches Ergebnisse in $files Dateien (${time}ms)';
  }

  @override
  String matchesInFile(int count) {
    return 'Treffer in Datei $count';
  }

  @override
  String linePrefix(int number) {
    return 'Zeile $number';
  }

  @override
  String get typeToSearchFilesAndCommands => 'Tippe zum Durchsuchen von Dateien & Befehlen';

  @override
  String get noResultsFound => 'Keine Ergebnisse gefunden';

  @override
  String get navigateUpDown => 'Nach oben/unten navigieren';

  @override
  String get selectEnter => 'Wählen (Enter)';

  @override
  String get closeEscape => 'Schließen (Esc)';

  @override
  String get findFile => 'Datei finden';

  @override
  String get typeToSearchFiles => 'Tippe zum Durchsuchen von Dateien';

  @override
  String get noFilesFoundInWorkspace => 'Keine Dateien im Arbeitsbereich gefunden';

  @override
  String get noFilesMatchSearch => 'Keine Dateien passen zur Suche';

  @override
  String get navigateOpenClose => 'Öffnen/Schließen';

  @override
  String get switchTheme => 'Thema wechseln';

  @override
  String get layoutAndVisual => 'Layout & Darstellung';

  @override
  String get compactMode => 'Kompaktmodus';

  @override
  String get compactModeDescription => 'Reduziert Abstände für kompaktere Ansicht';

  @override
  String get showIconsInMenu => 'Symbole im Menü anzeigen';

  @override
  String get showIconsInMenuDescription => 'Zeigt Symbole neben Menüeinträgen an';

  @override
  String get animationSpeed => 'Animationsgeschwindigkeit';

  @override
  String get animationSpeedDescription => 'Anpassen der Geschwindigkeit für UI-Animationen';

  @override
  String get slow => 'Langsam';

  @override
  String get normal => 'Normal (Standard)';

  @override
  String get fast => 'Schnell';

  @override
  String get disabled => 'Deaktiviert';

  @override
  String get sidebarTransparency => 'Seitenleisten-Transparenz';

  @override
  String get sidebarTransparencyDescription => 'Transparenz-Level der Seitenleiste einstellen';

  @override
  String get interfaceDescription => 'Einstellungen für das Interface';

  @override
  String get currentVersion => 'Aktuelle Version';

  @override
  String get currentBuild => 'Aktueller Build';

  @override
  String get theme => 'Thema';

  @override
  String get currentTheme => 'Aktuelles Thema';

  @override
  String get currentThemeDescription => 'Das aktuell ausgewählte Thema';

  @override
  String get colorScheme => 'Farbpalette';

  @override
  String get primary => 'Primär';

  @override
  String get secondary => 'Sekundär';

  @override
  String get surface => 'Hintergrund';

  @override
  String get themePresets => 'Thema-Vorlagen';

  @override
  String get themePresetsDescription => 'Vordefinierte Thema-Presets auswählen';

  @override
  String get systemThemes => 'Systemthemen';

  @override
  String get lightThemes => 'Helle Themen';

  @override
  String get darkThemes => 'Dunkle Themen';

  @override
  String get customizeColors => 'Farben anpassen';

  @override
  String get customizeColorsDescription => 'Eigene Farben für das Thema auswählen';

  @override
  String get primaryColor => 'Primärfarbe';

  @override
  String get secondaryColor => 'Sekundärfarbe';

  @override
  String get surfaceColor => 'Oberflächenfarbe';

  @override
  String get typography => 'Typografie';

  @override
  String get typographyDescription => 'Schriftarten und Größen konfigurieren';

  @override
  String get windowControls => 'Fenstersteuerung';

  @override
  String get showWindowControls => 'Fenstersteuerung anzeigen';

  @override
  String get showWindowControlsDescription => 'Zeigt die Minimise/Maximise/Close-Buttons';

  @override
  String get controlsPlacement => 'Position der Fenstersteuerung';

  @override
  String get controlsPlacementDescription => 'Bestimmt die Reihenfolge der Steuerungsbuttons';

  @override
  String get controlsOrder => 'Steuerungsreihenfolge';

  @override
  String get controlsOrderDescription => 'Anordnung der Fenstersteuerungsbuttons';

  @override
  String get auto => 'Automatisch';

  @override
  String get left => 'Links';

  @override
  String get right => 'Rechts';

  @override
  String get minimizeMaximizeClose => 'Minimieren/Maximieren/Schließen';

  @override
  String get closeMinimizeMaximize => 'Schließen/Minimieren/Maximieren';

  @override
  String get closeMaximizeMinimize => 'Schließen/Maximieren/Minimieren';

  @override
  String get closeButtonPositions => 'Positionen der Schließen-Buttons';

  @override
  String get closeButtonPositionsDescription => 'Anpassung der Schließen-Button-Positionen';

  @override
  String get quickSettings => 'Schnelleinstellungen';

  @override
  String get quickSettingsDescription => 'Schnellzugriff auf häufige Einstellungen';

  @override
  String get autoDescription => 'Automatische Auswahl basierend auf System';

  @override
  String get allLeft => 'Alle links';

  @override
  String get allLeftDescription => 'Alle Steuerungen links anordnen';

  @override
  String get allRight => 'Alle rechts';

  @override
  String get allRightDescription => 'Alle Steuerungen rechts anordnen';

  @override
  String get individualSettings => 'Individuelle Einstellungen';

  @override
  String get individualSettingsDescription => 'Positionen individuell einstellen';

  @override
  String get tabCloseButtons => 'Tab-Schließen-Buttons';

  @override
  String get tabCloseButtonsDescription => 'Schließen-Button auf Tabs anzeigen';

  @override
  String get panelCloseButtons => 'Panel-Schließen-Buttons';

  @override
  String get panelCloseButtonsDescription => 'Schließen-Button in Panels anzeigen';

  @override
  String get currently => 'Derzeit';

  @override
  String get sidebarSearchPlaceholder => 'Dateien und Befehle durchsuchen...';

  @override
  String get sidebarSearchOptions => 'Suchoptionen für Seitenleiste';

  @override
  String get settingsAppearanceDetail => 'Anpassen von Thema und Farben';

  @override
  String get settingsInterfaceDetail => 'Anpassen von Layout und Verhalten';

  @override
  String get topbarSearchDialogPlaceholder => 'Befehl oder Datei suchen...';

  @override
  String get showAppTitle => 'Anwendungstitel anzeigen';

  @override
  String get showAppTitleSubtitle => 'Zeigt den Titel der Anwendung in der Titelleiste';

  @override
  String get applicationTitleLabel => 'Anwendungstitel';

  @override
  String get applicationTitleHint => 'Geben Sie den Titel der Anwendung ein';

  @override
  String get showSearchBarTitle => 'Suchleiste anzeigen';

  @override
  String get showSearchBarSubtitle => 'Zeigt die globale Suchleiste oben an';

  @override
  String get animationSpeedTestTitle => 'Animationstest';

  @override
  String get hoverMeFastAnimation => 'Hover mich (schnell)';

  @override
  String get fadeInNormalSpeed => 'Einblenden (normal)';

  @override
  String get gettingStartedTitle => 'Erste Schritte';

  @override
  String get projectNotesTitle => 'Projektnotizen';

  @override
  String get searchOptionFilesTitle => 'Dateien durchsuchen';

  @override
  String get searchOptionFilesSubtitle => 'Suche nur Dateinamen';

  @override
  String get searchOptionContentTitle => 'Inhalt durchsuchen';

  @override
  String get searchOptionContentSubtitle => 'Suche im Dateiinhalt';

  @override
  String get searchOptionSymbolsTitle => 'Symbole durchsuchen';

  @override
  String get searchOptionSymbolsSubtitle => 'Suche nach Symbolnamen';

  @override
  String moreMatches(int count) {
    return 'Weitere Treffer $count';
  }

  @override
  String get noCommandsAvailable => 'Keine Befehle verfügbar';

  @override
  String get commandPaletteSearchFilesTitle => 'Dateien suchen';

  @override
  String get commandPaletteSearchFilesSubtitle => 'Dateien in Projekt durchsuchen';

  @override
  String get commandPaletteSearchInFilesTitle => 'In Dateien suchen';

  @override
  String get commandPaletteSearchInFilesSubtitle => 'Suche innerhalb von Dateien';

  @override
  String footerFilesCount(int count) {
    return '$count Dateien';
  }
}
