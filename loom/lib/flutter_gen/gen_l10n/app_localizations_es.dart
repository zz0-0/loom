import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Loom - Base de Conocimiento';

  @override
  String get uiPolishShowcase => 'Demostración de Pulido UI';

  @override
  String get enhancedUiAnimations => 'Animaciones UI Mejoradas';

  @override
  String get loadingIndicators => 'Indicadores de Carga';

  @override
  String get smoothLoading => 'Carga Suave';

  @override
  String get skeletonLoader => 'Cargador Esquelético';

  @override
  String get interactiveElements => 'Elementos Interactivos';

  @override
  String get hoverAnimation => 'Animación al Pasar';

  @override
  String get pressAnimation => 'Animación al Presionar';

  @override
  String get pulseAnimation => 'Animación de Pulso';

  @override
  String get shimmerEffects => 'Efectos de Brillo';

  @override
  String get successAnimations => 'Animaciones de Éxito';

  @override
  String get taskCompleted => '¡Tarea Completada!';

  @override
  String get animationCombinations => 'Combinaciones de Animación';

  @override
  String get interactiveButton => 'Botón Interactivo';

  @override
  String get animatedCard => 'Tarjeta Animada';

  @override
  String get animatedCardDescription => 'Esta tarjeta demuestra animaciones de fade-in y slide-in combinadas.';

  @override
  String get general => 'Ajustes generales';

  @override
  String get generalDescription => 'Preferencias generales y comportamiento de la aplicación';

  @override
  String get autoSave => 'Guardado Automático';

  @override
  String get autoSaveDescription => 'Guardar cambios automáticamente en intervalos regulares';

  @override
  String get confirmOnExit => 'Confirmar al Salir';

  @override
  String get confirmOnExitDescription => 'Pedir confirmación al cerrar con cambios no guardados';

  @override
  String get language => 'Idioma';

  @override
  String get languageDescription => 'Idioma de la aplicación';

  @override
  String get followSystemLanguage => 'Seguir idioma del sistema';

  @override
  String get manualLanguageSelection => 'Selección manual de idioma';

  @override
  String get english => 'Inglés';

  @override
  String get spanish => 'Español';

  @override
  String get french => 'Francés';

  @override
  String get german => 'Alemán';

  @override
  String get chinese => 'Chino';

  @override
  String get japanese => 'Japonés';

  @override
  String get korean => 'Coreano';

  @override
  String get autoSaveInterval => 'Intervalo de Auto-guardado';

  @override
  String lastSaved(Object time) {
    return 'Último guardado: ';
  }

  @override
  String get justNow => 'ahora mismo';

  @override
  String minutesAgo(int count) {
    return 'hace $count minutos';
  }

  @override
  String hoursAgo(int count) {
    return 'hace $count horas';
  }

  @override
  String daysAgo(int count) {
    return 'hace $count días';
  }

  @override
  String get commandExecutedSuccessfully => 'Comando ejecutado exitosamente';

  @override
  String commandFailed(String error) {
    return 'Comando fallido: $error';
  }

  @override
  String failedToExecuteCommand(String error) {
    return 'Error al ejecutar comando: $error';
  }

  @override
  String get about => 'Acerca de';

  @override
  String get aboutDescription => 'Información sobre Loom';

  @override
  String get version => 'Versión';

  @override
  String get licenses => 'Licencias';

  @override
  String get viewOpenSourceLicenses => 'Ver licencias de código abierto';

  @override
  String get loom => 'Loom (aplicación)';

  @override
  String get build => 'Construir';

  @override
  String get loomDescription => 'Loom es un editor de código moderno construido con Flutter, diseñado para productividad y facilidad de uso.';

  @override
  String get copyright => '© 2024 Equipo de Loom';

  @override
  String get close => 'Cerrar';

  @override
  String get openSourceLicenses => 'Licencias de Código Abierto';

  @override
  String get usesFollowingLibraries => 'Loom utiliza las siguientes bibliotecas de código abierto:';

  @override
  String get fullLicenseTexts => 'Para textos completos de licencias, visite los repositorios de carpetas respectivos en GitHub.';

  @override
  String get enterPath => 'Ingresar Ruta';

  @override
  String get directoryPath => 'Ruta del Directorio';

  @override
  String get pathHint => '/home/usuario/carpeta';

  @override
  String get cancel => 'Cancelar';

  @override
  String get go => 'Ir';

  @override
  String get select => 'Seleccionar';

  @override
  String get apply => 'Aplicar';

  @override
  String get preview => 'Vista previa';

  @override
  String selectColorLabel(String label) {
    return 'Seleccionar color $label';
  }

  @override
  String get fontFamilyLabel => 'Familia de fuentes';

  @override
  String get fontSizeLabel => 'Tamaño de fuente';

  @override
  String get previewSampleText => 'Vista previa: El rápido zorro marrón salta sobre el perro perezoso';

  @override
  String get searchFilesAndCommands => 'Buscar archivos y comandos...';

  @override
  String get commandKeyShortcut => 'Atajo: ⌘K';

  @override
  String get menu => 'Menú';

  @override
  String get file => 'Archivo';

  @override
  String get newFile => 'Nuevo Archivo';

  @override
  String get openFolder => 'Abrir Carpeta';

  @override
  String get save => 'Guardar';

  @override
  String get saveAs => 'Guardar Como';

  @override
  String get export => 'Exportar';

  @override
  String get exit => 'Salir';

  @override
  String get edit => 'Editar';

  @override
  String get undo => 'Deshacer';

  @override
  String get redo => 'Rehacer';

  @override
  String get cut => 'Cortar';

  @override
  String get copy => 'Copiar';

  @override
  String get paste => 'Pegar';

  @override
  String get view => 'Ver';

  @override
  String get toggleSidebar => 'Alternar Barra Lateral';

  @override
  String get togglePanel => 'Alternar Panel';

  @override
  String get fullScreen => 'Pantalla Completa';

  @override
  String get help => 'Ayuda';

  @override
  String get documentation => 'Documentación';

  @override
  String get plugins => 'Extensiones';

  @override
  String get pluginManager => 'Administrador de Plugins';

  @override
  String get noPluginsLoaded => 'No hay plugins cargados';

  @override
  String get openFolderFirst => 'Por favor abra una carpeta primero para crear un nuevo archivo';

  @override
  String get noFileOpenToSave => 'No hay archivo abierto actualmente para guardar';

  @override
  String fileSaved(String filename) {
    return 'Archivo \"$filename\" guardado';
  }

  @override
  String get noContentToExport => 'No hay contenido para exportar';

  @override
  String get exitApplication => 'Salir de la Aplicación';

  @override
  String get confirmExit => '¿Está seguro de que desea salir de Loom?';

  @override
  String get openInNewTab => 'Abrir en nueva pestaña';

  @override
  String get rename => 'Renombrar';

  @override
  String get delete => 'Eliminar';

  @override
  String get deleteItem => 'Eliminar elemento';

  @override
  String get cancelButton => 'Cancelar';

  @override
  String get enterPathPrompt => 'Introduzca la ruta de la carpeta que desea abrir:';

  @override
  String get folderPathLabel => 'Ruta de la carpeta';

  @override
  String get folderPathHint => 'Introduzca la ruta de la carpeta (p. ej., /workspaces/mi-carpeta)';

  @override
  String get enterFolderNameHint => 'Introduzca el nombre de la carpeta';

  @override
  String get browse => 'Examinar';

  @override
  String get selectFolderLocation => 'Seleccionar ubicación de la carpeta';

  @override
  String failedToSelectLocation(String error) {
    return 'Error al seleccionar la ubicación: $error';
  }

  @override
  String folderCreatedSuccess(String folderName) {
    return 'Carpeta \"$folderName\" creada con éxito!';
  }

  @override
  String failedToCreateFolder(String error) {
    return 'Error al crear carpeta: $error';
  }

  @override
  String get enterFileNameHint => 'Enter file name (e.g., document.md)';

  @override
  String get enterInitialFileContentHint => 'Introduzca el contenido inicial del archivo...';

  @override
  String get enterNewNameHint => 'Introduzca el nuevo nombre';

  @override
  String get closeFolder => 'Cerrar carpeta';

  @override
  String get openFolderMenu => 'Abrir carpeta';

  @override
  String get createFolder => 'Crear carpeta';

  @override
  String get filterFileExtensions => 'Filtrar extensiones de archivo';

  @override
  String get showHiddenFiles => 'Mostrar archivos ocultos';

  @override
  String failedToOpenFolder(String error) {
    return 'Error al abrir la carpeta: $error';
  }

  @override
  String failedToCreateFile(String error) {
    return 'Error al crear archivo: $error';
  }

  @override
  String failedToDeleteItem(String error) {
    return 'Error al eliminar el elemento: $error';
  }

  @override
  String failedToRenameItem(String error) {
    return 'Error al renombrar el elemento: $error';
  }

  @override
  String renameSuccess(String name) {
    return 'Renombrado a $name';
  }

  @override
  String deleteSuccess(String itemType) {
    return '$itemType eliminado con éxito';
  }

  @override
  String get searchFilesHint => 'Buscar archivos...';

  @override
  String get newFolderPlaceholder => 'nueva-carpeta';

  @override
  String get openInNewTabLabel => 'Abrir en nueva pestaña';

  @override
  String get closeLabel => 'Cerrar';

  @override
  String get closeOthersLabel => 'Cerrar otros';

  @override
  String get closeAllLabel => 'Cerrar todo';

  @override
  String get commentBlockTitle => 'Bloque de comentario';

  @override
  String get systemDefault => 'Predeterminado del sistema';

  @override
  String get systemDefaultSubtitle => 'Se adapta al tema del sistema';

  @override
  String get defaultLight => 'Predeterminado claro';

  @override
  String get defaultLightSubtitle => 'Tema claro';

  @override
  String get defaultDark => 'Predeterminado oscuro';

  @override
  String get defaultDarkSubtitle => 'Tema oscuro';

  @override
  String get minimizeTooltip => 'Minimizar';

  @override
  String get maximizeTooltip => 'Maximizar';

  @override
  String get closeTooltip => 'Cerrar';

  @override
  String get zoomTooltip => 'Ampliar/Reducir';

  @override
  String get toggleLineNumbersTooltip => 'Alternar números de línea';

  @override
  String get toggleMinimapTooltip => 'Alternar minimapa';

  @override
  String syntaxWarningsTooltip(int count) {
    return '$count advertencias de sintaxis';
  }

  @override
  String get undoTooltip => 'Deshacer (Ctrl+Z)';

  @override
  String get redoTooltip => 'Rehacer (Ctrl+Y)';

  @override
  String get cutTooltip => 'Cortar (Ctrl+X)';

  @override
  String get copyTooltip => 'Copiar (Ctrl+C)';

  @override
  String get pasteTooltip => 'Pegar (Ctrl+V)';

  @override
  String get foldAllTooltip => 'Plegar todo (Ctrl+Shift+[)';

  @override
  String get unfoldAllTooltip => 'Desplegar todo (Ctrl+Shift+])';

  @override
  String get exportTooltip => 'Exportar (Ctrl+E)';

  @override
  String get moreActionsTooltip => 'Más acciones';

  @override
  String get newFileTooltip => 'Nuevo archivo';

  @override
  String get newFolderTooltip => 'Nueva carpeta';

  @override
  String get refreshTooltip => 'Actualizar';

  @override
  String get fileSystemTooltip => 'Sistema de archivos';

  @override
  String get collectionsTooltip => 'Colecciones';

  @override
  String get removeFromCollectionTooltip => 'Quitar de la colección';

  @override
  String failedToCloneRepository(String error) {
    return 'Error al clonar el repositorio: $error';
  }

  @override
  String get openInNewTabAction => 'Abrir en nueva pestaña';

  @override
  String get nothingToUndo => 'Nada para deshacer';

  @override
  String get nothingToRedo => 'Nada para rehacer';

  @override
  String get contentCutToClipboard => 'Contenido cortado al portapapeles';

  @override
  String get noContentToCut => 'No hay contenido para cortar';

  @override
  String get contentCopiedToClipboard => 'Contenido copiado al portapapeles';

  @override
  String get noContentToCopy => 'No hay contenido para copiar';

  @override
  String get contentPastedFromClipboard => 'Contenido pegado desde el portapapeles';

  @override
  String get noTextInClipboard => 'No hay texto en el portapapeles para pegar';

  @override
  String get selectSidebarItemFirst => 'Por favor seleccione un elemento de la barra lateral primero';

  @override
  String get loomDocumentation => 'Documentación de Loom';

  @override
  String get welcomeToLoom => '¡Bienvenido a Loom!';

  @override
  String get loomDescriptionFull => 'Loom es una aplicación de base de conocimiento para organizar y editar documentos.';

  @override
  String get keyFeatures => 'Características Principales:';

  @override
  String get fileExplorerFeature => '• Explorador de Archivos: Navegar y gestionar sus archivos';

  @override
  String get richTextEditorFeature => '• Editor de Texto Enriquecido: Editar documentos con resaltado de sintaxis';

  @override
  String get searchFeature => '• Búsqueda: Encontrar archivos y contenido rápidamente';

  @override
  String get settingsFeature => '• Configuraciones: Personalice su experiencia';

  @override
  String get keyboardShortcuts => 'Atajos de Teclado:';

  @override
  String get saveShortcut => '• Ctrl+S: Guardar archivo';

  @override
  String get globalSearchShortcut => '• Ctrl+Mayús+F: Búsqueda global';

  @override
  String get undoShortcut => '• Ctrl+Z: Deshacer';

  @override
  String get redoShortcut => '• Ctrl+Y: Rehacer';

  @override
  String get fileName => 'Nombre de archivo';

  @override
  String get enterFileName => 'Ingresar nombre de archivo (ej. ejemplo.blox)';

  @override
  String get create => 'Crear';

  @override
  String get invalidFileName => 'Nombre de archivo inválido';

  @override
  String get invalidCharactersInFileName => 'Caracteres inválidos en nombre de archivo';

  @override
  String fileCreated(String filename) {
    return 'Archivo \"$filename\" creado';
  }

  @override
  String get exportFile => 'Exportar Archivo';

  @override
  String get enterExportLocation => 'Ingresar ubicación de exportación';

  @override
  String get formatHint => 'Formato opcional (por ejemplo: markdown, html, pdf)';

  @override
  String fileExportedAs(String filename) {
    return 'Archivo exportado como \"$filename\"';
  }

  @override
  String failedToExportFile(String error) {
    return 'Error al exportar archivo: $error';
  }

  @override
  String get enterSaveLocation => 'Ingresar ubicación de guardado';

  @override
  String fileSavedAs(String filename) {
    return 'Archivo guardado como \"$filename\"';
  }

  @override
  String failedToSaveFile(String error) {
    return 'Error al guardar archivo: $error';
  }

  @override
  String get installed => 'Instalado';

  @override
  String get active => 'Activo';

  @override
  String get inactive => 'Inactivo';

  @override
  String versionState(String version, String state) {
    return 'Versión: $version • Estado: $state';
  }

  @override
  String commandsCount(int count) {
    return '$count comandos';
  }

  @override
  String failedToEnablePlugin(String error) {
    return 'Error al activar plugin: $error';
  }

  @override
  String failedToDisablePlugin(String error) {
    return 'Error al desactivar plugin: $error';
  }

  @override
  String get disablePlugin => 'Desactivar Plugin';

  @override
  String get enablePlugin => 'Activar Plugin';

  @override
  String get noPluginsCurrentlyLoaded => 'No hay plugins cargados actualmente';

  @override
  String get settings => 'Configuraciones';

  @override
  String get allSettings => 'Todas las configuraciones';

  @override
  String get appearance => 'Apariencia';

  @override
  String get appearanceDescription => 'Personaliza la apariencia y la sensación de la aplicación';

  @override
  String get appearanceSubtitle => 'Tema, colores, diseño';

  @override
  String get interface => 'Interfaz';

  @override
  String get interfaceSubtitle => 'Controles de ventana, diseño';

  @override
  String get generalSubtitle => 'Preferencias, comportamiento';

  @override
  String get aboutSubtitle => 'Versión, licencias';

  @override
  String get openLink => 'Abrir Enlace';

  @override
  String openLinkConfirmation(String url) {
    return '¿Abrir este enlace en su navegador?\n\n$url';
  }

  @override
  String urlCopiedToClipboard(String url) {
    return 'URL copiada al portapapeles: $url';
  }

  @override
  String get copyUrl => 'Copiar URL';

  @override
  String footnote(String id) {
    return 'Nota al pie $id';
  }

  @override
  String imageAlt(String src) {
    return 'Imagen: $src';
  }

  @override
  String get find => 'Buscar';

  @override
  String get findAndReplace => 'Buscar y Reemplazar';

  @override
  String get hideReplace => 'Ocultar Reemplazar';

  @override
  String get showReplace => 'Mostrar Reemplazar';

  @override
  String get findLabel => 'Buscar';

  @override
  String get replaceWith => 'Reemplazar con';

  @override
  String get matchCase => 'Coincidir mayúsculas';

  @override
  String get useRegex => 'Usar regex';

  @override
  String get replace => 'Reemplazar';

  @override
  String get replaceAll => 'Reemplazar Todo';

  @override
  String get findNext => 'Buscar Siguiente';

  @override
  String get goToLine => 'Ir a Línea';

  @override
  String get pleaseEnterLineNumber => 'Por favor ingrese un número de línea';

  @override
  String get invalidLineNumber => 'Número de línea inválido';

  @override
  String get lineNumberMustBeGreaterThanZero => 'El número de línea debe ser mayor que 0';

  @override
  String lineNumberExceedsMaximum(int maxLines) {
    return 'El número de línea excede el máximo ($maxLines)';
  }

  @override
  String lineNumberLabel(int maxLines) {
    return 'Número de línea (1 - $maxLines)';
  }

  @override
  String get enterLineNumber => 'Ingresar número de línea';

  @override
  String totalLines(int count) {
    return 'Total de líneas: $count';
  }

  @override
  String get share => 'Compartir';

  @override
  String get newDocument => 'Nuevo Documento';

  @override
  String get newFolder => 'Nueva Carpeta';

  @override
  String get scanDocument => 'Escanear Documento';

  @override
  String get total => 'Total';

  @override
  String get noActivePlugins => 'No hay plugins activos';

  @override
  String get searchYourKnowledgeBase => 'Buscar en su base de conocimiento...';

  @override
  String get searchResultsWillAppearHere => 'Los resultados de búsqueda aparecerán aquí';

  @override
  String get collectionsViewForMobile => 'Vista de colecciones para móvil';

  @override
  String get searchEverything => 'Buscar todo...';

  @override
  String get mobileSearchInterface => 'Interfaz de búsqueda móvil';

  @override
  String get exportDocument => 'Exportar Documento';

  @override
  String fileLabel(String fileName) {
    return 'Archivo: $fileName';
  }

  @override
  String get exportFormat => 'Formato de Exportación';

  @override
  String get options => 'Opciones';

  @override
  String get includeLineNumbers => 'Incluir números de línea';

  @override
  String get includeSyntaxHighlighting => 'Incluir resaltado de sintaxis';

  @override
  String get includeHeader => 'Incluir encabezado';

  @override
  String get headerText => 'Texto de encabezado';

  @override
  String get documentTitle => 'Título del documento';

  @override
  String get saveLocation => 'Ubicación de Guardado';

  @override
  String get choose => 'Elegir...';

  @override
  String get exporting => 'Exportando...';

  @override
  String get saveExport => 'Guardar Exportación';

  @override
  String get createCollection => 'Crear Colección';

  @override
  String get collectionName => 'Nombre de colección';

  @override
  String get myCollection => 'Mi Colección';

  @override
  String get chooseTemplateOptional => 'Elegir una plantilla (opcional)';

  @override
  String get empty => 'Vacío';

  @override
  String get noCollections => 'Sin Colecciones';

  @override
  String get createCollectionsToOrganize => 'Crear colecciones para organizar sus archivos';

  @override
  String deleteCollection(String collectionName) {
    return 'Eliminar \"$collectionName\"';
  }

  @override
  String get deleteCollectionConfirmation => '¿Está seguro de que desea eliminar esta colección? Esto no eliminará los archivos reales.';

  @override
  String get smartSuggestion => 'Sugerencia Inteligente';

  @override
  String get keepHere => 'Mantener Aquí';

  @override
  String get invalidFolderName => 'Nombre de carpeta inválido';

  @override
  String get invalidCharactersInFolderName => 'Caracteres inválidos en nombre de carpeta';

  @override
  String folderCreated(String folderName) {
    return 'Carpeta \"$folderName\" creada';
  }

  @override
  String get useFileOpenToOpenFolder => 'Use Archivo > Abrir para abrir una carpeta';

  @override
  String get useWelcomeScreenToCreateFile => 'Use la pantalla de bienvenida para crear un nuevo archivo';

  @override
  String get settingsPanelComingSoon => 'Panel de configuraciones próximamente';

  @override
  String openedFile(String fileName) {
    return 'Abierto: $fileName';
  }

  @override
  String get includeHiddenFiles => 'Incluir archivos ocultos';

  @override
  String get fileSavedSuccessfully => 'Archivo guardado exitosamente';

  @override
  String errorSavingFile(String error) {
    return 'Error al guardar archivo: $error';
  }

  @override
  String get noContentToPreview => 'No hay contenido para previsualizar';

  @override
  String get syntaxWarnings => 'Advertencias de Sintaxis';

  @override
  String noMatchesFound(String searchText) {
    return 'No se encontraron coincidencias para \"$searchText\"';
  }

  @override
  String replacedOccurrences(int count) {
    return '$count ocurrencias reemplazadas';
  }

  @override
  String get createNewFolder => 'Crear Nueva Carpeta';

  @override
  String createdFolder(String folderName) {
    return 'Carpeta creada: $folderName';
  }

  @override
  String get pleaseOpenWorkspaceFirst => 'Por favor abra un espacio de trabajo primero';

  @override
  String get createNewFile => 'Crear Nuevo Archivo';

  @override
  String createdAndOpenedFile(String fileName) {
    return 'Creado y abierto: $fileName';
  }

  @override
  String get searchPanelPlaceholder => 'Panel de Búsqueda\n(Por implementar)';

  @override
  String get sourceControlPanelPlaceholder => 'Panel de Control de Código Fuente\n(Por implementar)';

  @override
  String get debugPanelPlaceholder => 'Panel de Depuración\n(Por implementar)';

  @override
  String get extensionsPanelPlaceholder => 'Panel de Extensiones\n(Por implementar)';

  @override
  String get settingsPanelPlaceholder => 'Panel de Configuraciones\n(Por implementar)';

  @override
  String get selectPanelFromSidebar => 'Seleccionar un panel desde la barra lateral';

  @override
  String get settingsTooltip => 'Configuración';

  @override
  String get explorerTooltip => 'Explorador';

  @override
  String get searchTooltip => 'Buscar';

  @override
  String get flutterLicense => 'Flutter - Licencia BSD';

  @override
  String get riverpodLicense => 'Riverpod - Licencia MIT';

  @override
  String get adaptiveThemeLicense => 'Adaptive Theme - Licencia MIT';

  @override
  String get filePickerLicense => 'File Picker - Licencia MIT';

  @override
  String get sharedPreferencesLicense => 'Shared Preferences - Licencia BSD';

  @override
  String get pdf => 'Formato PDF';

  @override
  String get html => 'Formato HTML';

  @override
  String get markdown => 'Formato Markdown';

  @override
  String get plainText => 'Texto plano';

  @override
  String get loomAppTitle => 'Loom — Base de conocimiento';

  @override
  String get loomKnowledgeBase => 'Base de conocimiento de Loom';

  @override
  String get yourWorkspace => 'Su espacio de trabajo';

  @override
  String get recentFiles => 'Archivos recientes';

  @override
  String get favorites => 'Favoritos';

  @override
  String get history => 'Historial';

  @override
  String get helpAndSupport => 'Ayuda y soporte';

  @override
  String get darkMode => 'Modo oscuro';

  @override
  String get documents => 'Documentos';

  @override
  String get search => 'Buscar';

  @override
  String get editor => 'Editor de texto';

  @override
  String get collections => 'Colecciones';

  @override
  String get welcomeToYourKnowledgeBase => 'Bienvenido a su base de conocimiento';

  @override
  String get developmentDocumentation => 'Documentación de desarrollo';

  @override
  String get welcomeToLoomTitle => 'Bienvenido a Loom';

  @override
  String get yourNextGenerationKnowledgeBase => 'Su base de conocimiento de nueva generación';

  @override
  String get openFolderTitle => 'Abrir carpeta';

  @override
  String get openAnExistingWorkspace => 'Abrir un espacio de trabajo existente';

  @override
  String get newFileTitle => 'Nuevo archivo';

  @override
  String get createANewDocument => 'Crear un nuevo documento';

  @override
  String get cloneRepositoryTitle => 'Clonar repositorio';

  @override
  String get cloneFromGit => 'Clonar desde Git';

  @override
  String openedWorkspace(String workspaceName) {
    return 'Espacio de trabajo abierto: $workspaceName';
  }

  @override
  String get cloningRepository => 'Clonando repositorio...';

  @override
  String successfullyClonedRepository(String path) {
    return 'Repositorio clonado correctamente en: $path';
  }

  @override
  String get repositoryUrl => 'URL del repositorio';

  @override
  String get enterGitRepositoryUrl => 'Ingrese la URL del repositorio Git (p. ej., https://github.com/usuario/repositorio.git)';

  @override
  String get targetDirectoryOptional => 'Directorio destino (opcional)';

  @override
  String get leaveEmptyToUseRepositoryName => 'Deje en blanco para usar el nombre del repositorio';

  @override
  String editingFile(String filePath) {
    return 'Editando: $filePath';
  }

  @override
  String get editorContentPlaceholder => 'El contenido del editor se implementará aquí.\n\nAquí es donde vivirá tu innovadora experiencia de edición de base de conocimientos!';

  @override
  String get replacing => 'Reemplazando...';

  @override
  String get replacingAll => 'Reemplazando todo...';

  @override
  String searchError(Object error) {
    return 'Error de búsqueda';
  }

  @override
  String get recentSearches => 'Búsquedas recientes';

  @override
  String get selectFolder => 'Seleccionar carpeta';

  @override
  String get goUp => 'Subir';

  @override
  String get quickAccess => 'Acceso rápido';

  @override
  String get home => 'Inicio';

  @override
  String get workspaces => 'Espacios de trabajo';

  @override
  String get folders => 'Carpetas';

  @override
  String get noFoldersFound => 'No se encontraron carpetas';

  @override
  String searchResultsSummary(int matches, int files, int time) {
    return '$matches coincidencias en $files archivos (${time}ms)';
  }

  @override
  String matchesInFile(int count) {
    return '$count coincidencias';
  }

  @override
  String linePrefix(int number) {
    return 'Línea $number';
  }

  @override
  String get typeToSearchFilesAndCommands => 'Escribe para buscar archivos y comandos...';

  @override
  String get noResultsFound => 'No se encontraron resultados';

  @override
  String get navigateUpDown => '↑↓ Navegar';

  @override
  String get selectEnter => '↵ Seleccionar';

  @override
  String get closeEscape => 'Esc Cerrar';

  @override
  String get findFile => 'Buscar archivo';

  @override
  String get typeToSearchFiles => 'Escribe para buscar archivos...';

  @override
  String get noFilesFoundInWorkspace => 'No se encontraron archivos en el espacio de trabajo';

  @override
  String get noFilesMatchSearch => 'Ningún archivo coincide con tu búsqueda';

  @override
  String get navigateOpenClose => '↑↓ Navegar • ↵ Abrir • Esc Cerrar';

  @override
  String get switchTheme => 'Cambiar tema';

  @override
  String get layoutAndVisual => 'Diseño y visual';

  @override
  String get compactMode => 'Modo compacto';

  @override
  String get compactModeDescription => 'Usar elementos de UI más pequeños y un espaciado reducido';

  @override
  String get showIconsInMenu => 'Mostrar iconos en el menú';

  @override
  String get showIconsInMenuDescription => 'Mostrar iconos junto a los elementos del menú';

  @override
  String get animationSpeed => 'Velocidad de animación';

  @override
  String get animationSpeedDescription => 'Velocidad de las animaciones e transiciones de la interfaz';

  @override
  String get slow => 'Lento';

  @override
  String get normal => 'Predeterminado';

  @override
  String get fast => 'Rápido';

  @override
  String get disabled => 'Desactivado';

  @override
  String get sidebarTransparency => 'Transparencia de la barra lateral';

  @override
  String get sidebarTransparencyDescription => 'Hacer el fondo de la barra lateral semi-transparente';

  @override
  String get interfaceDescription => 'Configurar controles de ventana y opciones de diseño';

  @override
  String get currentVersion => 'Versión 1.0.0';

  @override
  String get currentBuild => 'Compilación 20241201';

  @override
  String get theme => 'Tema';

  @override
  String get currentTheme => 'Tema actual';

  @override
  String get currentThemeDescription => 'Tu tema activo actualmente';

  @override
  String get colorScheme => 'Esquema de color:';

  @override
  String get primary => 'Primario';

  @override
  String get secondary => 'Secundario';

  @override
  String get surface => 'Superficie';

  @override
  String get themePresets => 'Preajustes de tema';

  @override
  String get themePresetsDescription => 'Elige entre temas predefinidos. Los temas del sistema se adaptan automáticamente.';

  @override
  String get systemThemes => 'Temas del sistema';

  @override
  String get lightThemes => 'Temas claros';

  @override
  String get darkThemes => 'Temas oscuros';

  @override
  String get customizeColors => 'Personalizar colores';

  @override
  String get customizeColorsDescription => 'Personaliza los colores del tema';

  @override
  String get primaryColor => 'Color primario';

  @override
  String get secondaryColor => 'Color secundario';

  @override
  String get surfaceColor => 'Color de superficie';

  @override
  String get typography => 'Tipografía';

  @override
  String get typographyDescription => 'Personaliza fuentes y apariencia del texto';

  @override
  String get windowControls => 'Controles de ventana';

  @override
  String get showWindowControls => 'Mostrar controles de ventana';

  @override
  String get showWindowControlsDescription => 'Mostrar botones minimizar, maximizar y cerrar';

  @override
  String get controlsPlacement => 'Ubicación de controles';

  @override
  String get controlsPlacementDescription => 'Posición de los botones de control de ventana';

  @override
  String get controlsOrder => 'Orden de controles';

  @override
  String get controlsOrderDescription => 'Orden de los botones de control de ventana';

  @override
  String get auto => 'Automático';

  @override
  String get left => 'Izquierda';

  @override
  String get right => 'Derecha';

  @override
  String get minimizeMaximizeClose => 'Minimizar, Maximizar, Cerrar';

  @override
  String get closeMinimizeMaximize => 'Cerrar, Minimizar, Maximizar';

  @override
  String get closeMaximizeMinimize => 'Cerrar, Maximizar, Minimizar';

  @override
  String get closeButtonPositions => 'Posiciones del botón de cierre';

  @override
  String get closeButtonPositionsDescription => 'Configurar dónde aparecen los botones de cierre en pestañas y paneles';

  @override
  String get quickSettings => 'Ajustes Rápidos';

  @override
  String get quickSettingsDescription => 'Establecer todas las posiciones de botones de cierre a la vez';

  @override
  String get autoDescription => 'Seguir la configuración predeterminada de la plataforma para el botón de cierre';

  @override
  String get allLeft => 'Todo a la izquierda';

  @override
  String get allLeftDescription => 'Botones de cierre y controles de ventana a la izquierda';

  @override
  String get allRight => 'Todo a la derecha';

  @override
  String get allRightDescription => 'Botones de cierre y controles de ventana a la derecha';

  @override
  String get individualSettings => 'Ajustes individuales';

  @override
  String get individualSettingsDescription => 'Ajustar finamente la posición de cada botón de cierre';

  @override
  String get tabCloseButtons => 'Botones de cierre en pestañas';

  @override
  String get tabCloseButtonsDescription => 'Posición de los botones de cierre en las pestañas';

  @override
  String get panelCloseButtons => 'Botones de cierre en paneles';

  @override
  String get panelCloseButtonsDescription => 'Posición de los botones de cierre en paneles';

  @override
  String get currently => 'Actualmente';

  @override
  String get sidebarSearchPlaceholder => 'Buscar...';

  @override
  String get sidebarSearchOptions => 'Opciones';

  @override
  String get settingsAppearanceDetail => 'Configuración de apariencia';

  @override
  String get settingsInterfaceDetail => 'Configuración de interfaz';

  @override
  String get topbarSearchDialogPlaceholder => 'Buscar (Ctrl+K)';

  @override
  String get showAppTitle => 'Mostrar título de la aplicación';

  @override
  String get showAppTitleSubtitle => 'Mostrar el título de la aplicación en la barra superior';

  @override
  String get applicationTitleLabel => 'Título de la aplicación';

  @override
  String get applicationTitleHint => 'Ingrese un título para la aplicación';

  @override
  String get showSearchBarTitle => 'Mostrar barra de búsqueda';

  @override
  String get showSearchBarSubtitle => 'Mostrar la barra de búsqueda en la parte superior';

  @override
  String get animationSpeedTestTitle => 'Prueba de velocidad de animación';

  @override
  String get hoverMeFastAnimation => 'Pasa el cursor: animación rápida';

  @override
  String get fadeInNormalSpeed => 'Aparecer: velocidad normal';

  @override
  String get gettingStartedTitle => 'Introducción';

  @override
  String get projectNotesTitle => 'Notas del proyecto';

  @override
  String get searchOptionFilesTitle => 'Archivos';

  @override
  String get searchOptionFilesSubtitle => 'Buscar en nombres de archivos';

  @override
  String get searchOptionContentTitle => 'Contenido';

  @override
  String get searchOptionContentSubtitle => 'Buscar en el contenido de archivos';

  @override
  String get searchOptionSymbolsTitle => 'Símbolos';

  @override
  String get searchOptionSymbolsSubtitle => 'Buscar funciones, clases';

  @override
  String moreMatches(int count) {
    return '+$count coincidencias más';
  }

  @override
  String get noCommandsAvailable => 'No hay comandos disponibles';

  @override
  String get commandPaletteSearchFilesTitle => 'Buscar archivos';

  @override
  String get commandPaletteSearchFilesSubtitle => 'Buscar archivos por nombre';

  @override
  String get commandPaletteSearchInFilesTitle => 'Buscar en archivos';

  @override
  String get commandPaletteSearchInFilesSubtitle => 'Buscar contenido de texto en archivos';

  @override
  String footerFilesCount(int count) {
    return '$count archivos';
  }
}
