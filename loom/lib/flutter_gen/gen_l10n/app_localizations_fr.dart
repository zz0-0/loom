import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Loom - Base de Connaissances';

  @override
  String get uiPolishShowcase => 'Démonstration d\'amélioration de l\'interface';

  @override
  String get enhancedUiAnimations => 'Animations UI améliorées';

  @override
  String get loadingIndicators => 'Indicateurs de chargement';

  @override
  String get smoothLoading => 'Chargement fluide';

  @override
  String get skeletonLoader => 'Chargeur squelette';

  @override
  String get interactiveElements => 'Éléments interactifs';

  @override
  String get hoverAnimation => 'Animation au survol';

  @override
  String get pressAnimation => 'Animation à la pression';

  @override
  String get pulseAnimation => 'Animation pulsée';

  @override
  String get shimmerEffects => 'Effets de scintillement';

  @override
  String get successAnimations => 'Animations de réussite';

  @override
  String get taskCompleted => 'Tâche terminée';

  @override
  String get animationCombinations => 'Combinaisons d\'animations';

  @override
  String get interactiveButton => 'Bouton interactif';

  @override
  String get animatedCard => 'Carte animée';

  @override
  String get animatedCardDescription => 'Exemple de carte avec animations';

  @override
  String get general => 'Général';

  @override
  String get generalDescription => 'Préférences générales et comportement de l\'application';

  @override
  String get autoSave => 'Sauvegarde Automatique';

  @override
  String get autoSaveDescription => 'Sauvegarder automatiquement les modifications à intervalles réguliers';

  @override
  String get confirmOnExit => 'Confirmer en Quitant';

  @override
  String get confirmOnExitDescription => 'Demander confirmation lors de la fermeture avec des modifications non sauvegardées';

  @override
  String get language => 'Langue';

  @override
  String get languageDescription => 'Langue de l\'application';

  @override
  String get followSystemLanguage => 'Suivre la langue du système';

  @override
  String get manualLanguageSelection => 'Sélection manuelle de la langue';

  @override
  String get english => 'Anglais';

  @override
  String get spanish => 'Espagnol';

  @override
  String get french => 'Langue française';

  @override
  String get german => 'Allemand';

  @override
  String get chinese => 'Chinois';

  @override
  String get japanese => 'Japonais';

  @override
  String get korean => 'Coréen';

  @override
  String get autoSaveInterval => 'Intervalle d\'auto-enregistrement';

  @override
  String lastSaved(Object time) {
    return 'Dernière sauvegarde : $time';
  }

  @override
  String get justNow => 'À l\'instant';

  @override
  String minutesAgo(int count) {
    return 'il y a $count minutes';
  }

  @override
  String hoursAgo(int count) {
    return 'il y a $count heures';
  }

  @override
  String daysAgo(int count) {
    return 'il y a $count jours';
  }

  @override
  String get commandExecutedSuccessfully => 'Commande exécutée avec succès';

  @override
  String commandFailed(String error) {
    return 'Échec de la commande : $error';
  }

  @override
  String failedToExecuteCommand(String error) {
    return 'Échec de l\'exécution : $error';
  }

  @override
  String get about => 'À propos';

  @override
  String get aboutDescription => 'Informations sur la version et les licences de Loom.';

  @override
  String get version => 'Version de l\'application';

  @override
  String get licenses => 'Licences';

  @override
  String get viewOpenSourceLicenses => 'Voir les licences open source';

  @override
  String get loom => 'Loom — application';

  @override
  String get build => 'Numéro de build';

  @override
  String get loomDescription => 'Loom est une application de base de connaissances pour organiser et éditer des documents.';

  @override
  String get copyright => '© 2024 Équipe Loom';

  @override
  String get close => 'Fermer';

  @override
  String get openSourceLicenses => 'Licences open source';

  @override
  String get usesFollowingLibraries => 'Utilise les bibliothèques suivantes :';

  @override
  String get fullLicenseTexts => 'Textes complets des licences';

  @override
  String get enterPath => 'Saisir le chemin';

  @override
  String get directoryPath => 'Chemin du dossier';

  @override
  String get pathHint => 'Chemin (ex. /workspaces/mon-dossier)';

  @override
  String get cancel => 'Annuler';

  @override
  String get go => 'Aller';

  @override
  String get select => 'Sélectionner';

  @override
  String get apply => 'Appliquer';

  @override
  String get preview => 'Aperçu';

  @override
  String selectColorLabel(String label) {
    return 'Sélectionner une couleur $label';
  }

  @override
  String get fontFamilyLabel => 'Famille de polices';

  @override
  String get fontSizeLabel => 'Taille de la police';

  @override
  String get previewSampleText => 'Texte d\'exemple';

  @override
  String get searchFilesAndCommands => 'Rechercher fichiers et commandes';

  @override
  String get commandKeyShortcut => 'Raccourci : ⌘K';

  @override
  String get menu => 'Menu principal';

  @override
  String get file => 'Fichier';

  @override
  String get newFile => 'Nouveau fichier';

  @override
  String get openFolder => 'Ouvrir un dossier';

  @override
  String get save => 'Enregistrer';

  @override
  String get saveAs => 'Enregistrer sous';

  @override
  String get export => 'Exporter';

  @override
  String get exit => 'Quitter';

  @override
  String get edit => 'Éditer';

  @override
  String get undo => 'Annuler';

  @override
  String get redo => 'Rétablir';

  @override
  String get cut => 'Couper';

  @override
  String get copy => 'Copier';

  @override
  String get paste => 'Coller';

  @override
  String get view => 'Affichage';

  @override
  String get toggleSidebar => 'Basculer la barre latérale';

  @override
  String get togglePanel => 'Basculer le panneau';

  @override
  String get fullScreen => 'Plein écran';

  @override
  String get help => 'Aide';

  @override
  String get documentation => 'Documentation du projet';

  @override
  String get plugins => 'Extensions';

  @override
  String get pluginManager => 'Gestionnaire de plugins';

  @override
  String get noPluginsLoaded => 'Aucun plugin chargé';

  @override
  String get openFolderFirst => 'Ouvrez d\'abord un dossier';

  @override
  String get noFileOpenToSave => 'Aucun fichier ouvert à enregistrer';

  @override
  String fileSaved(String filename) {
    return 'Fichier \"$filename\" enregistré';
  }

  @override
  String get noContentToExport => 'Aucun contenu à exporter';

  @override
  String get exitApplication => 'Quitter l\'application';

  @override
  String get confirmExit => 'Confirmer la fermeture';

  @override
  String get openInNewTab => 'Ouvrir dans un nouvel onglet';

  @override
  String get rename => 'Renommer';

  @override
  String get delete => 'Supprimer';

  @override
  String get deleteItem => 'Supprimer l\'élément';

  @override
  String get cancelButton => 'Annuler';

  @override
  String get enterPathPrompt => 'Entrez le chemin du dossier à ouvrir :';

  @override
  String get folderPathLabel => 'Chemin du dossier';

  @override
  String get folderPathHint => 'Entrez le chemin du dossier (ex. /workspaces/mon-dossier)';

  @override
  String get enterFolderNameHint => 'Entrez le nom du dossier';

  @override
  String get browse => 'Parcourir';

  @override
  String get selectFolderLocation => 'Sélectionner l\'emplacement du dossier';

  @override
  String failedToSelectLocation(String error) {
    return 'Erreur lors de la sélection : $error';
  }

  @override
  String folderCreatedSuccess(String folderName) {
    return 'Dossier \"$folderName\" créé avec succès !';
  }

  @override
  String failedToCreateFolder(String error) {
    return 'Échec de la création du dossier : $error';
  }

  @override
  String get enterFileNameHint => 'Entrez le nom du fichier (ex. main.dart)';

  @override
  String get enterInitialFileContentHint => 'Entrez le contenu initial du fichier...';

  @override
  String get enterNewNameHint => 'Entrez le nouveau nom';

  @override
  String get closeFolder => 'Fermer le dossier';

  @override
  String get openFolderMenu => 'Ouvrir le dossier';

  @override
  String get createFolder => 'Créer un dossier';

  @override
  String get filterFileExtensions => 'Filtrer les extensions de fichier';

  @override
  String get showHiddenFiles => 'Afficher les fichiers cachés';

  @override
  String failedToOpenFolder(String error) {
    return 'Échec de l\'ouverture du dossier : $error';
  }

  @override
  String failedToCreateFile(String error) {
    return 'Échec de la création du fichier : $error';
  }

  @override
  String failedToDeleteItem(String error) {
    return 'Échec de la suppression : $error';
  }

  @override
  String failedToRenameItem(String error) {
    return 'Échec du renommage : $error';
  }

  @override
  String renameSuccess(String name) {
    return 'Renommé en $name';
  }

  @override
  String deleteSuccess(String itemType) {
    return '$itemType supprimé avec succès';
  }

  @override
  String get searchFilesHint => 'Rechercher des fichiers...';

  @override
  String get newFolderPlaceholder => 'nouveau-dossier';

  @override
  String get openInNewTabLabel => 'Ouvrir dans un nouvel onglet';

  @override
  String get closeLabel => 'Fermer';

  @override
  String get closeOthersLabel => 'Fermer les autres';

  @override
  String get closeAllLabel => 'Fermer tout';

  @override
  String get commentBlockTitle => 'Bloc de commentaire';

  @override
  String get systemDefault => 'Par défaut (système)';

  @override
  String get systemDefaultSubtitle => 'S\'adapte au thème système';

  @override
  String get defaultLight => 'Clair par défaut';

  @override
  String get defaultLightSubtitle => 'Thème clair';

  @override
  String get defaultDark => 'Sombre par défaut';

  @override
  String get defaultDarkSubtitle => 'Thème sombre';

  @override
  String get minimizeTooltip => 'Minimiser';

  @override
  String get maximizeTooltip => 'Maximiser';

  @override
  String get closeTooltip => 'Fermer';

  @override
  String get zoomTooltip => 'Contrôler le zoom';

  @override
  String get toggleLineNumbersTooltip => 'Basculer les numéros de ligne';

  @override
  String get toggleMinimapTooltip => 'Basculer le minimap';

  @override
  String syntaxWarningsTooltip(int count) {
    return '$count avertissements de syntaxe';
  }

  @override
  String get undoTooltip => 'Annuler (Ctrl+Z)';

  @override
  String get redoTooltip => 'Rétablir (Ctrl+Y)';

  @override
  String get cutTooltip => 'Couper (Ctrl+X)';

  @override
  String get copyTooltip => 'Copier (Ctrl+C)';

  @override
  String get pasteTooltip => 'Coller (Ctrl+V)';

  @override
  String get foldAllTooltip => 'Réduire tout (Ctrl+Maj+[)';

  @override
  String get unfoldAllTooltip => 'Développer tout (Ctrl+Maj+])';

  @override
  String get exportTooltip => 'Exporter (Ctrl+E)';

  @override
  String get moreActionsTooltip => 'Plus d\'actions';

  @override
  String get newFileTooltip => 'Nouveau fichier';

  @override
  String get newFolderTooltip => 'Nouveau dossier';

  @override
  String get refreshTooltip => 'Actualiser';

  @override
  String get fileSystemTooltip => 'Système de fichiers';

  @override
  String get collectionsTooltip => 'Gérer les collections';

  @override
  String get removeFromCollectionTooltip => 'Retirer de la collection';

  @override
  String failedToCloneRepository(String error) {
    return 'Échec du clonage du dépôt : $error';
  }

  @override
  String get openInNewTabAction => 'Ouvrir dans un nouvel onglet';

  @override
  String get nothingToUndo => 'Rien à annuler';

  @override
  String get nothingToRedo => 'Rien à rétablir';

  @override
  String get contentCutToClipboard => 'Contenu coupé dans le presse-papiers';

  @override
  String get noContentToCut => 'Aucun contenu à couper';

  @override
  String get contentCopiedToClipboard => 'Contenu copié dans le presse-papiers';

  @override
  String get noContentToCopy => 'Aucun contenu à copier';

  @override
  String get contentPastedFromClipboard => 'Contenu collé depuis le presse-papiers';

  @override
  String get noTextInClipboard => 'Aucun texte dans le presse-papiers';

  @override
  String get selectSidebarItemFirst => 'Veuillez d\'abord sélectionner un élément dans la barre latérale';

  @override
  String get loomDocumentation => 'Documentation Loom';

  @override
  String get welcomeToLoom => 'Bienvenue sur Loom !';

  @override
  String get loomDescriptionFull => 'Loom est une application de base de connaissances pour organiser, rechercher et éditer vos documents efficacement.';

  @override
  String get keyFeatures => 'Fonctionnalités clés :';

  @override
  String get fileExplorerFeature => '• Explorateur de fichiers : parcourir et gérer vos fichiers';

  @override
  String get richTextEditorFeature => '• Éditeur riche : éditer des documents avec coloration syntaxique';

  @override
  String get searchFeature => 'Recherche';

  @override
  String get settingsFeature => '• Paramètres : personnaliser votre expérience';

  @override
  String get keyboardShortcuts => 'Raccourcis clavier :';

  @override
  String get saveShortcut => '• Ctrl+S : Sauvegarder le fichier';

  @override
  String get globalSearchShortcut => '• Ctrl+Maj+F : Recherche globale';

  @override
  String get undoShortcut => '• Ctrl+Z : Annuler';

  @override
  String get redoShortcut => '• Ctrl+Y : Rétablir';

  @override
  String get fileName => 'Nom de fichier';

  @override
  String get enterFileName => 'Entrez le nom du fichier';

  @override
  String get create => 'Créer';

  @override
  String get invalidFileName => 'Nom de fichier invalide';

  @override
  String get invalidCharactersInFileName => 'Caractères invalides dans le nom de fichier';

  @override
  String fileCreated(String filename) {
    return 'Fichier \"$filename\" créé';
  }

  @override
  String get exportFile => 'Exporter le fichier';

  @override
  String get enterExportLocation => 'Saisir l\'emplacement d\'exportation';

  @override
  String get formatHint => 'ex : txt, md, html';

  @override
  String fileExportedAs(String filename) {
    return 'Fichier exporté sous \"$filename\"';
  }

  @override
  String failedToExportFile(String error) {
    return 'Échec de l\'exportation : $error';
  }

  @override
  String get enterSaveLocation => 'Saisir l\'emplacement d\'enregistrement';

  @override
  String fileSavedAs(String filename) {
    return 'Fichier enregistré sous \"$filename\"';
  }

  @override
  String failedToSaveFile(String error) {
    return 'Échec de l\'enregistrement : $error';
  }

  @override
  String get installed => 'Installé';

  @override
  String get active => 'Actif';

  @override
  String get inactive => 'Inactif';

  @override
  String versionState(String version, String state) {
    return 'Version : $version • État : $state';
  }

  @override
  String commandsCount(int count) {
    return '$count commandes';
  }

  @override
  String failedToEnablePlugin(String error) {
    return 'Échec de l\'activation du plugin : $error';
  }

  @override
  String failedToDisablePlugin(String error) {
    return 'Échec de la désactivation du plugin : $error';
  }

  @override
  String get disablePlugin => 'Désactiver le plugin';

  @override
  String get enablePlugin => 'Activer le plugin';

  @override
  String get noPluginsCurrentlyLoaded => 'Aucun plugin chargé';

  @override
  String get settings => 'Paramètres';

  @override
  String get allSettings => 'Tous les paramètres';

  @override
  String get appearance => 'Apparence';

  @override
  String get appearanceDescription => 'Apparence et paramètres visuels';

  @override
  String get appearanceSubtitle => 'Thème, couleurs, mise en page';

  @override
  String get interface => 'Interface utilisateur';

  @override
  String get interfaceSubtitle => 'Contrôles de fenêtre, mise en page';

  @override
  String get generalSubtitle => 'Préférences, comportement';

  @override
  String get aboutSubtitle => 'Version, licences';

  @override
  String get openLink => 'Ouvrir le lien';

  @override
  String openLinkConfirmation(String url) {
    return 'Voulez-vous ouvrir ce lien ? $url';
  }

  @override
  String urlCopiedToClipboard(String url) {
    return 'URL copiée dans le presse-papiers $url';
  }

  @override
  String get copyUrl => 'Copier l\'URL';

  @override
  String footnote(String id) {
    return 'Note de bas de page $id';
  }

  @override
  String imageAlt(String src) {
    return 'Image (source : $src)';
  }

  @override
  String get find => 'Rechercher';

  @override
  String get findAndReplace => 'Rechercher et remplacer';

  @override
  String get hideReplace => 'Masquer Remplacer';

  @override
  String get showReplace => 'Afficher Remplacer';

  @override
  String get findLabel => 'Rechercher';

  @override
  String get replaceWith => 'Remplacer par';

  @override
  String get matchCase => 'Respecter la casse';

  @override
  String get useRegex => 'Utiliser une expression régulière';

  @override
  String get replace => 'Remplacer';

  @override
  String get replaceAll => 'Remplacer tout';

  @override
  String get findNext => 'Rechercher suivant';

  @override
  String get goToLine => 'Aller à la ligne';

  @override
  String get pleaseEnterLineNumber => 'Veuillez saisir un numéro de ligne';

  @override
  String get invalidLineNumber => 'Numéro de ligne invalide';

  @override
  String get lineNumberMustBeGreaterThanZero => 'Le numéro de ligne doit être supérieur à 0';

  @override
  String lineNumberExceedsMaximum(int maxLines) {
    return 'Le numéro de ligne dépasse la limite ($maxLines)';
  }

  @override
  String lineNumberLabel(int maxLines) {
    return 'Numéro de ligne $maxLines';
  }

  @override
  String get enterLineNumber => 'Entrez le numéro de ligne';

  @override
  String totalLines(int count) {
    return 'Total des lignes : $count';
  }

  @override
  String get share => 'Partager';

  @override
  String get newDocument => 'Nouveau document';

  @override
  String get newFolder => 'Nouveau dossier';

  @override
  String get scanDocument => 'Analyser le document';

  @override
  String get total => 'Total :';

  @override
  String get noActivePlugins => 'Aucun plugin actif';

  @override
  String get searchYourKnowledgeBase => 'Recherchez dans votre base de connaissances';

  @override
  String get searchResultsWillAppearHere => 'Les résultats de recherche apparaîtront ici';

  @override
  String get collectionsViewForMobile => 'Vue collections pour mobile';

  @override
  String get searchEverything => 'Tout rechercher';

  @override
  String get mobileSearchInterface => 'Interface de recherche mobile';

  @override
  String get exportDocument => 'Exporter le document';

  @override
  String fileLabel(String fileName) {
    return 'Fichier: $fileName';
  }

  @override
  String get exportFormat => 'Format d\'export';

  @override
  String get options => 'Paramètres';

  @override
  String get includeLineNumbers => 'Inclure les numéros de ligne';

  @override
  String get includeSyntaxHighlighting => 'Inclure la coloration syntaxique';

  @override
  String get includeHeader => 'Inclure l\'en-tête';

  @override
  String get headerText => 'En-tête';

  @override
  String get documentTitle => 'Titre du document';

  @override
  String get saveLocation => 'Emplacement d\'enregistrement';

  @override
  String get choose => 'Choisir';

  @override
  String get exporting => 'Export en cours...';

  @override
  String get saveExport => 'Enregistrer l\'export';

  @override
  String get createCollection => 'Créer une collection';

  @override
  String get collectionName => 'Nom de la collection';

  @override
  String get myCollection => 'Ma collection';

  @override
  String get chooseTemplateOptional => 'Choisir un modèle (optionnel)';

  @override
  String get empty => 'Vide';

  @override
  String get noCollections => 'Aucune collection';

  @override
  String get createCollectionsToOrganize => 'Créez des collections pour organiser vos fichiers';

  @override
  String deleteCollection(String collectionName) {
    return 'Supprimer la collection $collectionName';
  }

  @override
  String get deleteCollectionConfirmation => 'Supprimer cette collection ? Cela n\'effacera pas les fichiers.';

  @override
  String get smartSuggestion => 'Suggestion intelligente';

  @override
  String get keepHere => 'Garder ici';

  @override
  String get invalidFolderName => 'Nom de dossier invalide';

  @override
  String get invalidCharactersInFolderName => 'Caractères invalides dans le nom du dossier';

  @override
  String folderCreated(String folderName) {
    return 'Dossier créé $folderName';
  }

  @override
  String get useFileOpenToOpenFolder => 'Utilisez Fichier > Ouvrir pour ouvrir un dossier';

  @override
  String get useWelcomeScreenToCreateFile => 'Utilisez l\'écran de bienvenue pour créer un fichier';

  @override
  String get settingsPanelComingSoon => 'Panneau Paramètres bientôt disponible';

  @override
  String openedFile(String fileName) {
    return 'Fichier ouvert $fileName';
  }

  @override
  String get includeHiddenFiles => 'Inclure les fichiers cachés';

  @override
  String get fileSavedSuccessfully => 'Fichier enregistré avec succès';

  @override
  String errorSavingFile(String error) {
    return 'Erreur lors de l\'enregistrement : $error';
  }

  @override
  String get noContentToPreview => 'Aucun contenu à prévisualiser';

  @override
  String get syntaxWarnings => 'Avertissements de syntaxe';

  @override
  String noMatchesFound(String searchText) {
    return 'Aucun résultat trouvé $searchText';
  }

  @override
  String replacedOccurrences(int count) {
    return 'Remplacements effectués : $count';
  }

  @override
  String get createNewFolder => 'Créer un nouveau dossier';

  @override
  String createdFolder(String folderName) {
    return 'Dossier créé : $folderName';
  }

  @override
  String get pleaseOpenWorkspaceFirst => 'Veuillez ouvrir un espace de travail d\'abord';

  @override
  String get createNewFile => 'Créer un nouveau fichier';

  @override
  String createdAndOpenedFile(String fileName) {
    return 'Créé et ouvert : $fileName';
  }

  @override
  String get searchPanelPlaceholder => 'Rechercher...';

  @override
  String get sourceControlPanelPlaceholder => 'Panel de contrôle de source (à implémenter)';

  @override
  String get debugPanelPlaceholder => 'Panel de débogage (à implémenter)';

  @override
  String get extensionsPanelPlaceholder => 'Panel des extensions (à implémenter)';

  @override
  String get settingsPanelPlaceholder => 'Panneau Paramètres (à implémenter)';

  @override
  String get selectPanelFromSidebar => 'Sélectionnez un panneau depuis la barre latérale';

  @override
  String get settingsTooltip => 'Paramètres';

  @override
  String get explorerTooltip => 'Explorateur';

  @override
  String get searchTooltip => 'Recherche';

  @override
  String get flutterLicense => 'Flutter - Licence BSD';

  @override
  String get riverpodLicense => 'Riverpod - Licence';

  @override
  String get adaptiveThemeLicense => 'AdaptiveTheme - Licence';

  @override
  String get filePickerLicense => 'FilePicker - Licence';

  @override
  String get sharedPreferencesLicense => 'SharedPreferences - Licence';

  @override
  String get pdf => 'PDF (format)';

  @override
  String get html => 'HTML (format)';

  @override
  String get markdown => 'Markdown (format)';

  @override
  String get plainText => 'Texte brut';

  @override
  String get loomAppTitle => 'Loom — Base de connaissances';

  @override
  String get loomKnowledgeBase => 'Base de connaissances Loom';

  @override
  String get yourWorkspace => 'Votre espace de travail';

  @override
  String get recentFiles => 'Fichiers récents';

  @override
  String get favorites => 'Favoris';

  @override
  String get history => 'Historique';

  @override
  String get helpAndSupport => 'Aide et support';

  @override
  String get darkMode => 'Mode sombre';

  @override
  String get documents => 'Documents (vos fichiers)';

  @override
  String get search => 'Recherche';

  @override
  String get editor => 'Éditeur';

  @override
  String get collections => 'Collections (groupes)';

  @override
  String get welcomeToYourKnowledgeBase => 'Bienvenue dans votre base de connaissances';

  @override
  String get developmentDocumentation => 'Documentation de développement';

  @override
  String get welcomeToLoomTitle => 'Bienvenue sur Loom';

  @override
  String get yourNextGenerationKnowledgeBase => 'Votre prochaine génération de base de connaissances';

  @override
  String get openFolderTitle => 'Ouvrir un dossier';

  @override
  String get openAnExistingWorkspace => 'Ouvrir un espace de travail existant';

  @override
  String get newFileTitle => 'Nouveau fichier';

  @override
  String get createANewDocument => 'Créer un nouveau document';

  @override
  String get cloneRepositoryTitle => 'Cloner le dépôt';

  @override
  String get cloneFromGit => 'Cloner depuis Git';

  @override
  String openedWorkspace(String workspaceName) {
    return 'Espace de travail ouvert $workspaceName';
  }

  @override
  String get cloningRepository => 'Clonage du dépôt...';

  @override
  String successfullyClonedRepository(String path) {
    return 'Dépôt cloné avec succès $path';
  }

  @override
  String get repositoryUrl => 'URL du dépôt';

  @override
  String get enterGitRepositoryUrl => 'Entrez l\'URL du dépôt Git';

  @override
  String get targetDirectoryOptional => 'Répertoire cible (optionnel)';

  @override
  String get leaveEmptyToUseRepositoryName => 'Laisser vide pour utiliser le nom du dépôt';

  @override
  String editingFile(String filePath) {
    return 'Édition du fichier $filePath';
  }

  @override
  String get editorContentPlaceholder => 'Contenu de l\'éditeur...';

  @override
  String get replacing => 'Remplacement...';

  @override
  String get replacingAll => 'Remplacement de tous';

  @override
  String searchError(Object error) {
    return 'Erreur de recherche : $error';
  }

  @override
  String get recentSearches => 'Recherches récentes';

  @override
  String get selectFolder => 'Sélectionner un dossier';

  @override
  String get goUp => 'Remonter';

  @override
  String get quickAccess => 'Accès rapide';

  @override
  String get home => 'Accueil';

  @override
  String get workspaces => 'Espaces de travail';

  @override
  String get folders => 'Dossiers';

  @override
  String get noFoldersFound => 'Aucun dossier trouvé';

  @override
  String searchResultsSummary(int matches, int files, int time) {
    return '$matches correspondances dans $files fichiers $time';
  }

  @override
  String matchesInFile(int count) {
    return '$count correspondances dans ce fichier';
  }

  @override
  String linePrefix(int number) {
    return 'Ligne $number';
  }

  @override
  String get typeToSearchFilesAndCommands => 'Tapez pour rechercher fichiers et commandes';

  @override
  String get noResultsFound => 'Aucun résultat trouvé';

  @override
  String get navigateUpDown => 'Naviguer haut/bas';

  @override
  String get selectEnter => 'Sélectionner (Entrée)';

  @override
  String get closeEscape => 'Fermer (Échap)';

  @override
  String get findFile => 'Trouver un fichier';

  @override
  String get typeToSearchFiles => 'Tapez pour rechercher des fichiers';

  @override
  String get noFilesFoundInWorkspace => 'Aucun fichier trouvé dans l\'espace de travail';

  @override
  String get noFilesMatchSearch => 'Aucun fichier ne correspond à la recherche';

  @override
  String get navigateOpenClose => 'Ouvrir/Fermer';

  @override
  String get switchTheme => 'Changer le thème';

  @override
  String get layoutAndVisual => 'Disposition et visuel';

  @override
  String get compactMode => 'Mode compact';

  @override
  String get compactModeDescription => 'Réduit les paddings pour une interface compacte';

  @override
  String get showIconsInMenu => 'Afficher les icônes dans le menu';

  @override
  String get showIconsInMenuDescription => 'Afficher des icônes à côté des éléments de menu';

  @override
  String get animationSpeed => 'Vitesse de l\'animation';

  @override
  String get animationSpeedDescription => 'Contrôle la vitesse des animations UI';

  @override
  String get slow => 'Lent';

  @override
  String get normal => 'Normal (défaut)';

  @override
  String get fast => 'Rapide';

  @override
  String get disabled => 'Désactivé';

  @override
  String get sidebarTransparency => 'Transparence de la barre latérale';

  @override
  String get sidebarTransparencyDescription => 'Règle la transparence de la barre latérale';

  @override
  String get interfaceDescription => 'Configurer les contrôles de fenêtre et les options de mise en page';

  @override
  String get currentVersion => '1.0.0 (version actuelle)';

  @override
  String get currentBuild => '20241201 (build actuelle)';

  @override
  String get theme => 'Thème';

  @override
  String get currentTheme => 'Thème actuel';

  @override
  String get currentThemeDescription => 'Le thème actuellement sélectionné';

  @override
  String get colorScheme => 'Schéma de couleurs';

  @override
  String get primary => 'Primaire';

  @override
  String get secondary => 'Secondaire';

  @override
  String get surface => 'Surface (couleur)';

  @override
  String get themePresets => 'Préréglages de thème';

  @override
  String get themePresetsDescription => 'Choisissez un préréglage de couleur';

  @override
  String get systemThemes => 'Thèmes système';

  @override
  String get lightThemes => 'Thèmes clairs';

  @override
  String get darkThemes => 'Thèmes sombres';

  @override
  String get customizeColors => 'Personnaliser les couleurs';

  @override
  String get customizeColorsDescription => 'Choisissez vos couleurs personnalisées';

  @override
  String get primaryColor => 'Couleur primaire';

  @override
  String get secondaryColor => 'Couleur secondaire';

  @override
  String get surfaceColor => 'Couleur de surface';

  @override
  String get typography => 'Typographie';

  @override
  String get typographyDescription => 'Choisissez la famille et la taille de police';

  @override
  String get windowControls => 'Contrôles de la fenêtre';

  @override
  String get showWindowControls => 'Afficher les contrôles de la fenêtre';

  @override
  String get showWindowControlsDescription => 'Afficher les boutons de contrôle de la fenêtre';

  @override
  String get controlsPlacement => 'Placement des contrôles';

  @override
  String get controlsPlacementDescription => 'Position des boutons de contrôle';

  @override
  String get controlsOrder => 'Ordre des contrôles';

  @override
  String get controlsOrderDescription => 'Ordre des boutons de contrôle';

  @override
  String get auto => 'Automatique';

  @override
  String get left => 'Gauche';

  @override
  String get right => 'Droite';

  @override
  String get minimizeMaximizeClose => 'Minimiser, Maximiser, Fermer';

  @override
  String get closeMinimizeMaximize => 'Fermer, Minimiser, Maximiser';

  @override
  String get closeMaximizeMinimize => 'Fermer, Maximiser, Minimiser';

  @override
  String get closeButtonPositions => 'Positions du bouton Fermer';

  @override
  String get closeButtonPositionsDescription => 'Choisissez la position du bouton fermer';

  @override
  String get quickSettings => 'Paramètres rapides';

  @override
  String get quickSettingsDescription => 'Accès rapide aux paramètres courants';

  @override
  String get autoDescription => 'Détecte automatiquement la meilleure option';

  @override
  String get allLeft => 'Tous à gauche';

  @override
  String get allLeftDescription => 'Tous les contrôles alignés à gauche';

  @override
  String get allRight => 'Tous à droite';

  @override
  String get allRightDescription => 'Tous les contrôles alignés à droite';

  @override
  String get individualSettings => 'Paramètres individuels';

  @override
  String get individualSettingsDescription => 'Réglez chaque contrôle séparément';

  @override
  String get tabCloseButtons => 'Boutons de fermeture d\'onglet';

  @override
  String get tabCloseButtonsDescription => 'Afficher les boutons de fermeture sur les onglets';

  @override
  String get panelCloseButtons => 'Boutons de fermeture du panneau';

  @override
  String get panelCloseButtonsDescription => 'Afficher les boutons de fermeture sur les panneaux';

  @override
  String get currently => 'Actuellement';

  @override
  String get sidebarSearchPlaceholder => 'Rechercher dans la barre latérale...';

  @override
  String get sidebarSearchOptions => 'Options de recherche';

  @override
  String get settingsAppearanceDetail => 'Détails d\'apparence';

  @override
  String get settingsInterfaceDetail => 'Détails de l\'interface';

  @override
  String get topbarSearchDialogPlaceholder => 'Rechercher dans la barre supérieure...';

  @override
  String get showAppTitle => 'Afficher le titre de l\'application';

  @override
  String get showAppTitleSubtitle => 'Afficher le titre de l\'application dans la barre supérieure';

  @override
  String get applicationTitleLabel => 'Titre de l\'application';

  @override
  String get applicationTitleHint => 'Titre affiché dans la barre d\'application';

  @override
  String get showSearchBarTitle => 'Afficher la barre de recherche';

  @override
  String get showSearchBarSubtitle => 'Afficher la barre de recherche dans la barre supérieure';

  @override
  String get animationSpeedTestTitle => 'Test de vitesse d\'animation';

  @override
  String get hoverMeFastAnimation => 'Survolez pour voir l\'animation rapide';

  @override
  String get fadeInNormalSpeed => 'Fondu (vitesse normale)';

  @override
  String get gettingStartedTitle => 'Prise en main';

  @override
  String get projectNotesTitle => 'Notes du projet';

  @override
  String get searchOptionFilesTitle => 'Rechercher fichiers';

  @override
  String get searchOptionFilesSubtitle => 'Inclure le contenu des fichiers dans la recherche';

  @override
  String get searchOptionContentTitle => 'Rechercher contenu';

  @override
  String get searchOptionContentSubtitle => 'Rechercher le texte à l\'intérieur des fichiers';

  @override
  String get searchOptionSymbolsTitle => 'Rechercher symboles';

  @override
  String get searchOptionSymbolsSubtitle => 'Inclure les symboles dans la recherche';

  @override
  String moreMatches(int count) {
    return 'Plus de correspondances $count';
  }

  @override
  String get noCommandsAvailable => 'Aucune commande disponible';

  @override
  String get commandPaletteSearchFilesTitle => 'Recherche de fichiers dans la palette de commandes';

  @override
  String get commandPaletteSearchFilesSubtitle => 'Rechercher des fichiers depuis la palette de commandes';

  @override
  String get commandPaletteSearchInFilesTitle => 'Recherche dans les fichiers';

  @override
  String get commandPaletteSearchInFilesSubtitle => 'Rechercher dans le contenu des fichiers depuis la palette';

  @override
  String footerFilesCount(int count) {
    return '$count fichiers';
  }
}
