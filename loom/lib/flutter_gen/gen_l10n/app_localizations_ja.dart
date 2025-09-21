import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'Loom - ナレッジベース';

  @override
  String get uiPolishShowcase => 'UI-Politur-Showcase';

  @override
  String get enhancedUiAnimations => 'Erweiterte UI-Animationen';

  @override
  String get loadingIndicators => 'Lade-Indikatoren';

  @override
  String get smoothLoading => 'Sanftes Laden';

  @override
  String get skeletonLoader => 'Skelett-Loader';

  @override
  String get interactiveElements => 'Interaktive Elemente';

  @override
  String get hoverAnimation => 'Hover-Animation';

  @override
  String get pressAnimation => 'Druck-Animation';

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
  String get animatedCardDescription => 'このカードはフェードインとスライドインのアニメーションの組み合わせを示します。';

  @override
  String get general => 'Allgemein';

  @override
  String get generalDescription => 'Allgemeine Einstellungen und Anwendungsverhalten';

  @override
  String get autoSave => 'Automatisches Speichern';

  @override
  String get autoSaveDescription => '変更を定期的に自動保存します';

  @override
  String get confirmOnExit => '終了時に確認する';

  @override
  String get confirmOnExitDescription => '保存されていない変更がある場合に終了時に確認します';

  @override
  String get language => '言語';

  @override
  String get languageDescription => 'アプリの表示言語';

  @override
  String get followSystemLanguage => 'Systemsprache folgen';

  @override
  String get manualLanguageSelection => 'Manuelle Sprachauswahl';

  @override
  String get english => 'Englisch';

  @override
  String get spanish => 'Spanisch';

  @override
  String get french => 'Französisch';

  @override
  String get german => 'Alemán';

  @override
  String get chinese => 'Chinesisch';

  @override
  String get japanese => 'Japanisch';

  @override
  String get korean => 'Koreanisch';

  @override
  String get autoSaveInterval => 'Auto-Speicher-Intervall';

  @override
  String lastSaved(Object time) {
    return 'Zuletzt gespeichert:';
  }

  @override
  String get justNow => 'gerade eben';

  @override
  String minutesAgo(int count) {
    return 'vor $count Minuten';
  }

  @override
  String hoursAgo(int count) {
    return 'vor $count Stunden';
  }

  @override
  String daysAgo(int count) {
    return 'vor $count Tagen';
  }

  @override
  String get commandExecutedSuccessfully => 'コマンドが正常に実行されました';

  @override
  String commandFailed(String error) {
    return 'コマンドの実行に失敗しました：$error';
  }

  @override
  String failedToExecuteCommand(String error) {
    return 'Befehl konnte nicht ausgeführt werden: $error';
  }

  @override
  String get about => 'Über';

  @override
  String get aboutDescription => 'Loomに関する情報';

  @override
  String get version => 'バージョン';

  @override
  String get licenses => 'Lizenzen';

  @override
  String get viewOpenSourceLicenses => 'Open-Source-Lizenzen anzeigen';

  @override
  String get loom => 'ルーム';

  @override
  String get build => 'ビルド';

  @override
  String get loomDescription => 'Loom は Flutter で作られたモダンなコードエディタで、生産性と使いやすさに重点を置いています。';

  @override
  String get copyright => '© 2024 Equipo de Loom';

  @override
  String get close => 'Schließen';

  @override
  String get openSourceLicenses => 'Open-Source-Lizenzen';

  @override
  String get usesFollowingLibraries => 'Loom verwendet die folgenden Open-Source-Bibliotheken:';

  @override
  String get fullLicenseTexts => 'Für vollständige Lizenztexte besuchen Sie bitte die entsprechenden Ordner-Repositorys auf GitHub.';

  @override
  String get enterPath => 'Pfad eingeben';

  @override
  String get directoryPath => 'Verzeichnispfad';

  @override
  String get pathHint => '/home/user/ordner';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get go => 'Gehe zu';

  @override
  String get select => 'Auswählen';

  @override
  String get apply => '適用';

  @override
  String get preview => 'プレビュー';

  @override
  String selectColorLabel(String label) {
    return '色を選択';
  }

  @override
  String get fontFamilyLabel => 'フォントファミリー';

  @override
  String get fontSizeLabel => 'フォントサイズ';

  @override
  String get previewSampleText => 'サンプルテキスト';

  @override
  String get searchFilesAndCommands => 'Dateien und Befehle durchsuchen...';

  @override
  String get commandKeyShortcut => 'コマンド: ⌘K';

  @override
  String get menu => 'Menü';

  @override
  String get file => 'Datei';

  @override
  String get newFile => 'Neue Datei';

  @override
  String get openFolder => 'Open Folder';

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
  String get undo => 'Rückgängigmachen';

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
  String get plugins => '플러그인';

  @override
  String get pluginManager => 'Plugin-Manager';

  @override
  String get noPluginsLoaded => 'Keine Plugins geladen';

  @override
  String get openFolderFirst => 'Bitte öffnen Sie zuerst einen Ordner, um eine neue Datei zu erstellen';

  @override
  String get noFileOpenToSave => 'Keine Datei ist derzeit zum Speichern geöffnet';

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
  String get openInNewTab => '新しいタブで開く';

  @override
  String get rename => '名前を変更';

  @override
  String get delete => 'Löschen';

  @override
  String get deleteItem => '項目を削除';

  @override
  String get cancelButton => 'キャンセル';

  @override
  String get enterPathPrompt => '開きたいフォルダのパスを入力してください：';

  @override
  String get folderPathLabel => 'フォルダパス';

  @override
  String get folderPathHint => 'フォルダパスを入力してください（例: /workspaces/my-folder）';

  @override
  String get enterFolderNameHint => 'フォルダ名を入力してください';

  @override
  String get browse => '参照';

  @override
  String get selectFolderLocation => 'フォルダの場所を選択';

  @override
  String failedToSelectLocation(String error) {
    return '場所の選択に失敗しました: $error';
  }

  @override
  String folderCreatedSuccess(String folderName) {
    return 'フォルダ \"$folderName\" が作成されました！';
  }

  @override
  String failedToCreateFolder(String error) {
    return 'フォルダの作成に失敗しました：$error';
  }

  @override
  String get enterFileNameHint => 'Dateiname eingeben (z.B. dokument.md)';

  @override
  String get enterInitialFileContentHint => '初期ファイルの内容を入力してください...';

  @override
  String get enterNewNameHint => '新しい名前を入力してください';

  @override
  String get closeFolder => 'フォルダを閉じる';

  @override
  String get openFolderMenu => 'フォルダを開く';

  @override
  String get createFolder => 'フォルダを作成';

  @override
  String get filterFileExtensions => 'ファイル拡張子をフィルタ';

  @override
  String get showHiddenFiles => '隠しファイルを表示';

  @override
  String failedToOpenFolder(String error) {
    return 'フォルダを開く際にエラーが発生しました：$error';
  }

  @override
  String failedToCreateFile(String error) {
    return 'Datei konnte nicht erstellt werden: $error';
  }

  @override
  String failedToDeleteItem(String error) {
    return '項目の削除に失敗しました: $error';
  }

  @override
  String failedToRenameItem(String error) {
    return '名前の変更に失敗しました: $error';
  }

  @override
  String renameSuccess(String name) {
    return '$name に名前を変更しました';
  }

  @override
  String deleteSuccess(String itemType) {
    return '$itemType は正常に削除されました';
  }

  @override
  String get searchFilesHint => 'ファイルを検索...';

  @override
  String get newFolderPlaceholder => '新しいフォルダ';

  @override
  String get openInNewTabLabel => '新しいタブで開く';

  @override
  String get closeLabel => '閉じる';

  @override
  String get closeOthersLabel => '他を閉じる';

  @override
  String get closeAllLabel => 'すべて閉じる';

  @override
  String get commentBlockTitle => 'ブロックにコメント';

  @override
  String get systemDefault => 'システムのデフォルト';

  @override
  String get systemDefaultSubtitle => 'システムのテーマに合わせる';

  @override
  String get defaultLight => 'デフォルトライト';

  @override
  String get defaultLightSubtitle => 'ライトテーマ';

  @override
  String get defaultDark => 'デフォルトダーク';

  @override
  String get defaultDarkSubtitle => 'ダークテーマ';

  @override
  String get minimizeTooltip => '最小化';

  @override
  String get maximizeTooltip => '最大化';

  @override
  String get closeTooltip => '閉じる';

  @override
  String get zoomTooltip => 'ズーム';

  @override
  String get toggleLineNumbersTooltip => '行番号の切り替え';

  @override
  String get toggleMinimapTooltip => 'ミニマップの切り替え';

  @override
  String syntaxWarningsTooltip(int count) {
    return '$count 件の構文警告';
  }

  @override
  String get undoTooltip => '元に戻す (Ctrl+Z)';

  @override
  String get redoTooltip => 'やり直し (Ctrl+Y)';

  @override
  String get cutTooltip => '切り取り (Ctrl+X)';

  @override
  String get copyTooltip => 'コピー (Ctrl+C)';

  @override
  String get pasteTooltip => '貼り付け (Ctrl+V)';

  @override
  String get foldAllTooltip => 'すべて折りたたむ (Ctrl+Shift+[)';

  @override
  String get unfoldAllTooltip => 'すべて展開 (Ctrl+Shift+])';

  @override
  String get exportTooltip => 'エクスポート (Ctrl+E)';

  @override
  String get moreActionsTooltip => 'その他のアクション';

  @override
  String get newFileTooltip => '新しいファイル';

  @override
  String get newFolderTooltip => '新しいフォルダ';

  @override
  String get refreshTooltip => '更新';

  @override
  String get fileSystemTooltip => 'ファイルシステム';

  @override
  String get collectionsTooltip => 'コレクション';

  @override
  String get removeFromCollectionTooltip => 'コレクションから削除';

  @override
  String failedToCloneRepository(String error) {
    return 'Fehler beim Klonen des Repository: $error';
  }

  @override
  String get openInNewTabAction => '新しいタブで開く';

  @override
  String get nothingToUndo => 'Nichts zum Rückgängigmachen';

  @override
  String get nothingToRedo => 'Nichts zum Wiederholen';

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
  String get noTextInClipboard => 'Kein Text in der Zwischenablage zum Einfügen';

  @override
  String get selectSidebarItemFirst => 'Bitte wählen Sie zuerst ein Element aus der Seitenleiste aus';

  @override
  String get loomDocumentation => 'Loom-Dokumentation';

  @override
  String get welcomeToLoom => 'Willkommen bei Loom!';

  @override
  String get loomDescriptionFull => 'Loom ist eine Wissensdatenbank-Anwendung zum Organisieren und Bearbeiten von Dokumenten.';

  @override
  String get keyFeatures => 'Hauptmerkmale:';

  @override
  String get fileExplorerFeature => '• Datei-Explorer: Ihre Dateien durchsuchen und verwalten';

  @override
  String get richTextEditorFeature => '• Rich-Text-Editor: Dokumente mit Syntaxhervorhebung bearbeiten';

  @override
  String get searchFeature => '• Suche: Dateien und Inhalte schnell finden';

  @override
  String get settingsFeature => '• Einstellungen: Passen Sie Ihre Erfahrung an';

  @override
  String get keyboardShortcuts => 'Tastenkürzel:';

  @override
  String get saveShortcut => '• Strg+S: Datei speichern';

  @override
  String get globalSearchShortcut => '• Strg+Umschalt+F: Globale Suche';

  @override
  String get undoShortcut => '• Strg+Z: Rückgängigmachen';

  @override
  String get redoShortcut => '• Strg+Y: Wiederholen';

  @override
  String get fileName => 'Dateiname';

  @override
  String get enterFileName => 'Dateiname eingげる (z.B. beispiel.blox)';

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
  String get formatHint => 'txt, md, html, usw.';

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
    return 'Version: $version • Status: $state';
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
  String get noPluginsCurrentlyLoaded => 'Derzeit sind keine Plugins geladen';

  @override
  String get settings => 'Einstellungen';

  @override
  String get allSettings => 'Alle Einstellungen';

  @override
  String get appearance => 'Erscheinungsbild';

  @override
  String get appearanceDescription => 'アプリケーションの外観と使用感をカスタマイズします';

  @override
  String get appearanceSubtitle => 'Thema, Farben, Layout';

  @override
  String get interface => 'Benutzeroberfläche';

  @override
  String get interfaceSubtitle => 'Fenstersteuerung, Layout';

  @override
  String get generalSubtitle => 'Einstellungen, Verhalten';

  @override
  String get aboutSubtitle => 'Version, Lizenzen';

  @override
  String get openLink => 'Link öffnen';

  @override
  String openLinkConfirmation(String url) {
    return 'Diesen Link in Ihrem Browser öffnen?\n\n$url';
  }

  @override
  String urlCopiedToClipboard(String url) {
    return 'URL in Zwischenablage kopiert: $url';
  }

  @override
  String get copyUrl => 'URL kopieren';

  @override
  String footnote(String id) {
    return 'Fußnote $id';
  }

  @override
  String imageAlt(String src) {
    return 'Bild: $src';
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
  String get pleaseEnterLineNumber => 'Bitte geben Sie eine Zeilennummer ein';

  @override
  String get invalidLineNumber => 'Ungültige Zeilennummer';

  @override
  String get lineNumberMustBeGreaterThanZero => 'Zeilennummer muss größer als 0 sein';

  @override
  String lineNumberExceedsMaximum(int maxLines) {
    return 'Zeilennummer überschreitet Maximum ($maxLines)';
  }

  @override
  String lineNumberLabel(int maxLines) {
    return 'Zeilennummer (1 - $maxLines)';
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
  String get searchYourKnowledgeBase => 'Ihre Wissensdatenbank durchsuchen...';

  @override
  String get searchResultsWillAppearHere => 'Suchergebnisse werden hier angezeigt';

  @override
  String get collectionsViewForMobile => 'Sammlungsansicht für Mobilgeräte';

  @override
  String get searchEverything => 'Alles durchsuchen...';

  @override
  String get mobileSearchInterface => 'Mobile Suchoberfläche';

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
  String get includeLineNumbers => 'Zeilennummern einschließen';

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
  String get smartSuggestion => 'Intelligenter Vorschlag';

  @override
  String get keepHere => 'ここに保持';

  @override
  String get invalidFolderName => 'Ungültiger Ordnername';

  @override
  String get invalidCharactersInFolderName => 'Ungültige Zeichen im Ordnernamen';

  @override
  String folderCreated(String folderName) {
    return 'Ordner \"$folderName\" erstellt';
  }

  @override
  String get useFileOpenToOpenFolder => 'Verwenden Sie Datei > Öffnen, um einen Ordner zu öffnen';

  @override
  String get useWelcomeScreenToCreateFile => 'Verwenden Sie den Willkommensbildschirm, um eine neue Datei zu erstellen';

  @override
  String get settingsPanelComingSoon => 'Einstellungen-Panel bald verfügbar';

  @override
  String openedFile(String fileName) {
    return 'Geöffnet: $fileName';
  }

  @override
  String get includeHiddenFiles => 'Versteckte Dateien einschließen';

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
    return 'Keine Übereinstimmungen gefunden für \"$searchText\"';
  }

  @override
  String replacedOccurrences(int count) {
    return '$count Vorkommen ersetzt';
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
  String get searchPanelPlaceholder => '検索パネル\n（未実装）';

  @override
  String get sourceControlPanelPlaceholder => 'ソース管理パネル\n（未実装）';

  @override
  String get debugPanelPlaceholder => 'デバッグパネル\n（未実装）';

  @override
  String get extensionsPanelPlaceholder => '拡張機能パネル\n（未実装）';

  @override
  String get settingsPanelPlaceholder => '設定パネル\n（未実装）';

  @override
  String get selectPanelFromSidebar => 'サイドバーからパネルを選択';

  @override
  String get settingsTooltip => 'Einstellungen';

  @override
  String get explorerTooltip => 'Explorador';

  @override
  String get searchTooltip => 'Suche';

  @override
  String get flutterLicense => 'Flutter - BSD Lizenz';

  @override
  String get riverpodLicense => 'Riverpod - MIT Lizenz';

  @override
  String get adaptiveThemeLicense => 'Adaptive Theme - MIT Lizenz';

  @override
  String get filePickerLicense => 'File Picker - MIT Lizenz';

  @override
  String get sharedPreferencesLicense => 'Shared Preferences - BSD Lizenz';

  @override
  String get pdf => 'PDFドキュメント';

  @override
  String get html => 'HTMLドキュメント';

  @override
  String get markdown => 'マークダウン';

  @override
  String get plainText => 'プレーンテキスト';

  @override
  String get loomAppTitle => 'ルーム';

  @override
  String get loomKnowledgeBase => 'Loom Wissensdatenbank';

  @override
  String get yourWorkspace => 'Ihr Arbeitsbereich';

  @override
  String get recentFiles => 'Zuletzt verwendete Dateien';

  @override
  String get favorites => 'Favoriten';

  @override
  String get history => 'Verlauf';

  @override
  String get helpAndSupport => 'Hilfe & Support';

  @override
  String get darkMode => 'Dunkler Modus';

  @override
  String get documents => 'Dokumente';

  @override
  String get search => 'Suche';

  @override
  String get editor => 'エディタ';

  @override
  String get collections => 'Sammlungen';

  @override
  String get welcomeToYourKnowledgeBase => 'Willkommen in Ihrer Wissensdatenbank';

  @override
  String get developmentDocumentation => 'Entwicklungsdokumentation';

  @override
  String get welcomeToLoomTitle => 'Willkommen bei Loom';

  @override
  String get yourNextGenerationKnowledgeBase => 'Ihre Wissensdatenbank der nächsten Generation';

  @override
  String get openFolderTitle => 'Ordner öffnen';

  @override
  String get openAnExistingWorkspace => 'Einen bestehenden Arbeitsbereich öffnen';

  @override
  String get newFileTitle => 'Neue Datei';

  @override
  String get createANewDocument => 'Ein neues Dokument erstellen';

  @override
  String get cloneRepositoryTitle => 'Repository klonen';

  @override
  String get cloneFromGit => 'Von Git klonen';

  @override
  String openedWorkspace(String workspaceName) {
    return 'Arbeitsbereich geöffnet: $workspaceName';
  }

  @override
  String get cloningRepository => 'Repository wird geklont...';

  @override
  String successfullyClonedRepository(String path) {
    return 'Repository erfolgreich geklont nach: $path';
  }

  @override
  String get repositoryUrl => 'Repository-URL';

  @override
  String get enterGitRepositoryUrl => 'Git-Repository-URL eingeben (z.B. https://github.com/user/repo.git)';

  @override
  String get targetDirectoryOptional => 'Zielverzeichnis (optional)';

  @override
  String get leaveEmptyToUseRepositoryName => 'Leer lassen, um Repository-Namen zu verwenden';

  @override
  String editingFile(String filePath) {
    return 'Bearbeiten: $filePath';
  }

  @override
  String get editorContentPlaceholder => 'Editor-Inhalt wird hier implementiert。\n\nHier wird Ihre innovative Wissensdatenbank-Bearbeitungserfahrung leben!';

  @override
  String get replacing => 'Ersetzen...';

  @override
  String get replacingAll => 'Alle ersetzen...';

  @override
  String searchError(Object error) {
    return 'Suchfehler';
  }

  @override
  String get recentSearches => 'Letzte Suchen';

  @override
  String get selectFolder => 'Ordner auswählen';

  @override
  String get goUp => 'Nach oben';

  @override
  String get quickAccess => 'Schnellzugriff';

  @override
  String get home => 'Startseite';

  @override
  String get workspaces => 'Arbeitsbereiche';

  @override
  String get folders => 'Ordner';

  @override
  String get noFoldersFound => 'Keine Ordner gefunden';

  @override
  String searchResultsSummary(int matches, int files, int time) {
    return '$matches Treffer in $files Dateien (${time}ms)';
  }

  @override
  String matchesInFile(int count) {
    return '$count Treffer';
  }

  @override
  String linePrefix(int number) {
    return 'Zeile $number';
  }

  @override
  String get typeToSearchFilesAndCommands => 'Tippen, um Dateien und Befehle zu suchen...';

  @override
  String get noResultsFound => 'Keine Ergebnisse gefunden';

  @override
  String get navigateUpDown => '↑↓ Navigieren';

  @override
  String get selectEnter => '↵ Auswählen';

  @override
  String get closeEscape => 'Esc Schließen';

  @override
  String get findFile => 'Datei suchen';

  @override
  String get typeToSearchFiles => 'Tippen, um Dateienを検索...';

  @override
  String get noFilesFoundInWorkspace => 'Keine Dateien im Arbeitsbereich gefunden';

  @override
  String get noFilesMatchSearch => 'Keine Dateien entsprechen Ihrer Suche';

  @override
  String get navigateOpenClose => '↑↓ Navigieren • ↵ Öffnen • Esc Schließen';

  @override
  String get switchTheme => 'テーマを切り替え';

  @override
  String get layoutAndVisual => 'レイアウトとビジュアル';

  @override
  String get compactMode => 'コンパクトモード';

  @override
  String get compactModeDescription => 'UI要素を小さくして余白を減らします';

  @override
  String get showIconsInMenu => 'メニューにアイコンを表示';

  @override
  String get showIconsInMenuDescription => 'メニュー項目の横にアイコンを表示します';

  @override
  String get animationSpeed => 'アニメーション速度';

  @override
  String get animationSpeedDescription => 'UIアニメーションと遷移の速度';

  @override
  String get slow => '遅い';

  @override
  String get normal => '通常';

  @override
  String get fast => '速い';

  @override
  String get disabled => '無効';

  @override
  String get sidebarTransparency => 'サイドバーの透明度';

  @override
  String get sidebarTransparencyDescription => 'サイドバーの背景を半透明にします';

  @override
  String get interfaceDescription => 'ウィンドウコントロールとレイアウトを設定します';

  @override
  String get currentVersion => 'バージョン 1.0.0';

  @override
  String get currentBuild => 'ビルド 20241201';

  @override
  String get theme => 'テーマ';

  @override
  String get currentTheme => '現在のテーマ';

  @override
  String get currentThemeDescription => '現在有効なテーマ';

  @override
  String get colorScheme => 'カラースキーム:';

  @override
  String get primary => '主要';

  @override
  String get secondary => '副';

  @override
  String get surface => 'サーフェス';

  @override
  String get themePresets => 'テーマプリセット';

  @override
  String get themePresetsDescription => '事前にデザインされたテーマから選択します。システムテーマは自動的にシステム設定に適応します。';

  @override
  String get systemThemes => 'システムテーマ';

  @override
  String get lightThemes => 'ライトテーマ';

  @override
  String get darkThemes => 'ダークテーマ';

  @override
  String get customizeColors => '色をカスタマイズ';

  @override
  String get customizeColorsDescription => 'テーマカラーを個人仕様に合わせます';

  @override
  String get primaryColor => '主要色';

  @override
  String get secondaryColor => '副次色';

  @override
  String get surfaceColor => 'サーフェス色';

  @override
  String get typography => 'タイポグラフィ';

  @override
  String get typographyDescription => 'フォントやテキスト表示をカスタマイズします';

  @override
  String get windowControls => 'ウィンドウコントロール';

  @override
  String get showWindowControls => 'ウィンドウコントロールを表示';

  @override
  String get showWindowControlsDescription => '最小化、最大化、閉じるボタンを表示します';

  @override
  String get controlsPlacement => 'コントロールの配置';

  @override
  String get controlsPlacementDescription => 'ウィンドウコントロールボタンの位置';

  @override
  String get controlsOrder => 'コントロールの順序';

  @override
  String get controlsOrderDescription => 'ウィンドウコントロールボタンの順序';

  @override
  String get auto => '自動';

  @override
  String get left => '左';

  @override
  String get right => '右';

  @override
  String get minimizeMaximizeClose => '最小化、最大化、閉じる';

  @override
  String get closeMinimizeMaximize => '閉じる、最小化、最大化';

  @override
  String get closeMaximizeMinimize => '閉じる、最大化、最小化';

  @override
  String get closeButtonPositions => '閉じるボタンの位置';

  @override
  String get closeButtonPositionsDescription => 'タブやパネルに閉じるボタンを配置する場所を設定します';

  @override
  String get quickSettings => 'クイック設定';

  @override
  String get quickSettingsDescription => 'すべての閉じるボタンを一度に設定します';

  @override
  String get autoDescription => '閉じボタンのデフォルト設定に従う';

  @override
  String get allLeft => 'すべて左';

  @override
  String get allLeftDescription => '閉じるボタンとウィンドウコントロールを左に配置';

  @override
  String get allRight => 'すべて右';

  @override
  String get allRightDescription => '閉じるボタンとウィンドウコントロールを右に配置';

  @override
  String get individualSettings => '個別設定';

  @override
  String get individualSettingsDescription => '各閉じるボタンの位置を微調整します';

  @override
  String get tabCloseButtons => 'タブの閉じるボタン';

  @override
  String get tabCloseButtonsDescription => 'タブ内の閉じるボタンの位置';

  @override
  String get panelCloseButtons => 'パネルの閉じるボタン';

  @override
  String get panelCloseButtonsDescription => 'パネル内の閉じるボタンの位置';

  @override
  String get currently => '現在';

  @override
  String get sidebarSearchPlaceholder => '検索...';

  @override
  String get sidebarSearchOptions => 'オプション';

  @override
  String get settingsAppearanceDetail => '外観設定';

  @override
  String get settingsInterfaceDetail => 'インターフェース設定';

  @override
  String get topbarSearchDialogPlaceholder => '検索するテキストを入力...';

  @override
  String get showAppTitle => 'アプリタイトルを表示';

  @override
  String get showAppTitleSubtitle => '上部バーにアプリ名を表示する';

  @override
  String get applicationTitleLabel => 'アプリケーションのタイトル';

  @override
  String get applicationTitleHint => 'カスタムアプリタイトルを入力';

  @override
  String get showSearchBarTitle => '検索バーを表示';

  @override
  String get showSearchBarSubtitle => '上部バーに検索機能を表示';

  @override
  String get animationSpeedTestTitle => 'アニメーション速度テスト';

  @override
  String get hoverMeFastAnimation => 'ホバーしてください（高速アニメーション）';

  @override
  String get fadeInNormalSpeed => 'フェードイン（通常速度）';

  @override
  String get gettingStartedTitle => 'はじめに';

  @override
  String get projectNotesTitle => 'プロジェクトノート';

  @override
  String get searchOptionFilesTitle => 'ファイル';

  @override
  String get searchOptionFilesSubtitle => 'ファイル名を検索';

  @override
  String get searchOptionContentTitle => '内容';

  @override
  String get searchOptionContentSubtitle => 'ファイルの内容を検索';

  @override
  String get searchOptionSymbolsTitle => 'シンボル';

  @override
  String get searchOptionSymbolsSubtitle => '関数、クラスを検索';

  @override
  String moreMatches(int count) {
    return '+$count 件の一致';
  }

  @override
  String get noCommandsAvailable => '利用可能なコマンドはありません';

  @override
  String get commandPaletteSearchFilesTitle => 'ファイルを検索';

  @override
  String get commandPaletteSearchFilesSubtitle => '名前でファイルを検索';

  @override
  String get commandPaletteSearchInFilesTitle => 'ファイル内を検索';

  @override
  String get commandPaletteSearchInFilesSubtitle => 'ファイル内のテキストを検索';

  @override
  String footerFilesCount(int count) {
    return '$count ファイル';
  }
}
