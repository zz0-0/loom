import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Loom - 知识库';

  @override
  String get uiPolishShowcase => 'UI润色展示';

  @override
  String get enhancedUiAnimations => '增强的UI动画';

  @override
  String get loadingIndicators => '加载指示器';

  @override
  String get smoothLoading => '平滑加载';

  @override
  String get skeletonLoader => '骨架加载器';

  @override
  String get interactiveElements => '交互式元素';

  @override
  String get hoverAnimation => '悬停动画';

  @override
  String get pressAnimation => '按压动画';

  @override
  String get pulseAnimation => '脉冲动画';

  @override
  String get shimmerEffects => '闪烁效果';

  @override
  String get successAnimations => '成功动画';

  @override
  String get taskCompleted => '任务完成！';

  @override
  String get animationCombinations => '动画组合';

  @override
  String get interactiveButton => '交互式按钮';

  @override
  String get animatedCard => '动画卡片';

  @override
  String get animatedCardDescription => '此卡片演示了淡入和滑入动画的组合。';

  @override
  String get general => '通用';

  @override
  String get generalDescription => '通用偏好设置和应用程序行为';

  @override
  String get autoSave => '自动保存';

  @override
  String get autoSaveDescription => '定期自动保存更改';

  @override
  String get confirmOnExit => '退出时确认';

  @override
  String get confirmOnExitDescription => '关闭时有未保存的更改时请求确认';

  @override
  String get language => '语言';

  @override
  String get languageDescription => '应用程序语言';

  @override
  String get followSystemLanguage => '跟随系统语言';

  @override
  String get manualLanguageSelection => '手动语言选择';

  @override
  String get english => '英语';

  @override
  String get spanish => '西班牙语';

  @override
  String get french => '法语';

  @override
  String get german => '德语';

  @override
  String get chinese => '中文';

  @override
  String get japanese => '日语';

  @override
  String get korean => '韩语';

  @override
  String get autoSaveInterval => '自动保存间隔';

  @override
  String lastSaved(Object time) {
    return '最后保存：';
  }

  @override
  String get justNow => '刚刚';

  @override
  String minutesAgo(int count) {
    return '$count分钟前';
  }

  @override
  String hoursAgo(int count) {
    return '$count小时前';
  }

  @override
  String daysAgo(int count) {
    return '$count天前';
  }

  @override
  String get commandExecutedSuccessfully => '命令执行成功';

  @override
  String commandFailed(String error) {
    return '命令失败：$error';
  }

  @override
  String failedToExecuteCommand(String error) {
    return '执行命令失败：$error';
  }

  @override
  String get about => '关于';

  @override
  String get aboutDescription => '关于Loom的信息';

  @override
  String get version => '版本';

  @override
  String get licenses => '许可证';

  @override
  String get viewOpenSourceLicenses => '查看开源许可证';

  @override
  String get loom => '织机';

  @override
  String get build => '构建';

  @override
  String get loomDescription => 'Loom是一个使用Flutter构建的现代代码编辑器，旨在提高生产力和易用性。';

  @override
  String get copyright => '© 2024 Loom团队';

  @override
  String get close => '关闭';

  @override
  String get openSourceLicenses => '开源许可证';

  @override
  String get usesFollowingLibraries => 'Loom使用以下开源库：';

  @override
  String get fullLicenseTexts => '有关完整许可证文本，请访问GitHub上的相应文件夹存储库。';

  @override
  String get enterPath => '输入路径';

  @override
  String get directoryPath => '目录路径';

  @override
  String get pathHint => '/home/user/ordner';

  @override
  String get cancel => '取消';

  @override
  String get go => '转到';

  @override
  String get select => '选择';

  @override
  String get apply => '应用';

  @override
  String get preview => '预览';

  @override
  String selectColorLabel(String label) {
    return '选择颜色 $label';
  }

  @override
  String get fontFamilyLabel => '字体系列';

  @override
  String get fontSizeLabel => '字体大小';

  @override
  String get previewSampleText => '示例文本';

  @override
  String get searchFilesAndCommands => '搜索文件和命令...';

  @override
  String get commandKeyShortcut => '命令：⌘K';

  @override
  String get menu => '菜单';

  @override
  String get file => '文件';

  @override
  String get newFile => '新文件';

  @override
  String get openFolder => '打开文件夹';

  @override
  String get save => '保存';

  @override
  String get saveAs => '另存为';

  @override
  String get export => '导出';

  @override
  String get exit => '退出';

  @override
  String get edit => '编辑';

  @override
  String get undo => '撤销';

  @override
  String get redo => '重做';

  @override
  String get cut => '剪切';

  @override
  String get copy => '复制';

  @override
  String get paste => '粘贴';

  @override
  String get view => '查看';

  @override
  String get toggleSidebar => '切换侧边栏';

  @override
  String get togglePanel => '切换面板';

  @override
  String get fullScreen => '全屏';

  @override
  String get help => '帮助';

  @override
  String get documentation => '文档';

  @override
  String get plugins => '插件';

  @override
  String get pluginManager => '插件管理器';

  @override
  String get noPluginsLoaded => '未加载插件';

  @override
  String get openFolderFirst => '请先打开文件夹以创建新文件';

  @override
  String get noFileOpenToSave => '当前没有打开的文件可保存';

  @override
  String fileSaved(String filename) {
    return '文件\"$filename\"已保存';
  }

  @override
  String get noContentToExport => '无内容可导出';

  @override
  String get exitApplication => '退出应用程序';

  @override
  String get confirmExit => '您确定要退出Loom吗？';

  @override
  String get openInNewTab => '在新标签页中打开';

  @override
  String get rename => '重命名';

  @override
  String get delete => '删除';

  @override
  String get deleteItem => '删除项目';

  @override
  String get cancelButton => '取消';

  @override
  String get enterPathPrompt => '请输入要打开的文件夹路径:';

  @override
  String get folderPathLabel => '文件夹路径';

  @override
  String get folderPathHint => '请输入文件夹路径（例如：/workspaces/my-folder）';

  @override
  String get enterFolderNameHint => '请输入文件夹名称';

  @override
  String get browse => '浏览';

  @override
  String get selectFolderLocation => '选择文件夹位置';

  @override
  String failedToSelectLocation(String error) {
    return '选择位置失败：$error';
  }

  @override
  String folderCreatedSuccess(String folderName) {
    return '文件夹 \"$folderName\" 创建成功！';
  }

  @override
  String failedToCreateFolder(String error) {
    return '创建文件夹失败：$error';
  }

  @override
  String get enterFileNameHint => '输入文件名（例如：document.md）';

  @override
  String get enterInitialFileContentHint => '请输入初始文件内容...';

  @override
  String get enterNewNameHint => '请输入新名称';

  @override
  String get closeFolder => '关闭文件夹';

  @override
  String get openFolderMenu => '打开文件夹';

  @override
  String get createFolder => '创建文件夹';

  @override
  String get filterFileExtensions => '过滤文件扩展名';

  @override
  String get showHiddenFiles => '显示隐藏文件';

  @override
  String failedToOpenFolder(String error) {
    return '打开文件夹失败：$error';
  }

  @override
  String failedToCreateFile(String error) {
    return '创建文件失败：$error';
  }

  @override
  String failedToDeleteItem(String error) {
    return '删除项目失败：$error';
  }

  @override
  String failedToRenameItem(String error) {
    return '重命名项目失败：$error';
  }

  @override
  String renameSuccess(String name) {
    return '已重命名为 $name';
  }

  @override
  String deleteSuccess(String itemType) {
    return '$itemType 已成功删除';
  }

  @override
  String get searchFilesHint => '搜索文件...';

  @override
  String get newFolderPlaceholder => '新文件夹';

  @override
  String get openInNewTabLabel => '在新标签页中打开';

  @override
  String get closeLabel => '关闭';

  @override
  String get closeOthersLabel => '关闭其他';

  @override
  String get closeAllLabel => '全部关闭';

  @override
  String get commentBlockTitle => '注释块';

  @override
  String get systemDefault => '系统默认';

  @override
  String get systemDefaultSubtitle => '匹配系统主题';

  @override
  String get defaultLight => '默认浅色';

  @override
  String get defaultLightSubtitle => '浅色主题';

  @override
  String get defaultDark => '默认深色';

  @override
  String get defaultDarkSubtitle => '深色主题';

  @override
  String get minimizeTooltip => '最小化';

  @override
  String get maximizeTooltip => '最大化';

  @override
  String get closeTooltip => '关闭';

  @override
  String get zoomTooltip => '缩放';

  @override
  String get toggleLineNumbersTooltip => '切换行号';

  @override
  String get toggleMinimapTooltip => '切换小地图';

  @override
  String syntaxWarningsTooltip(int count) {
    return '$count 条语法警告';
  }

  @override
  String get undoTooltip => '撤销 (Ctrl+Z)';

  @override
  String get redoTooltip => '重做 (Ctrl+Y)';

  @override
  String get cutTooltip => '剪切 (Ctrl+X)';

  @override
  String get copyTooltip => '复制 (Ctrl+C)';

  @override
  String get pasteTooltip => '粘贴 (Ctrl+V)';

  @override
  String get foldAllTooltip => '全部折叠 (Ctrl+Shift+[)';

  @override
  String get unfoldAllTooltip => '全部展开 (Ctrl+Shift+])';

  @override
  String get exportTooltip => '导出 (Ctrl+E)';

  @override
  String get moreActionsTooltip => '更多操作';

  @override
  String get newFileTooltip => '新建文件';

  @override
  String get newFolderTooltip => '新建文件夹';

  @override
  String get refreshTooltip => '刷新';

  @override
  String get fileSystemTooltip => '文件系统';

  @override
  String get collectionsTooltip => '收藏';

  @override
  String get removeFromCollectionTooltip => '从收藏中移除';

  @override
  String failedToCloneRepository(String error) {
    return '克隆仓库失败：$error';
  }

  @override
  String get openInNewTabAction => '在新标签页中打开';

  @override
  String get nothingToUndo => '无内容可撤销';

  @override
  String get nothingToRedo => '无内容可重做';

  @override
  String get contentCutToClipboard => '内容已剪切到剪贴板';

  @override
  String get noContentToCut => '无内容可剪切';

  @override
  String get contentCopiedToClipboard => '内容已复制到剪贴板';

  @override
  String get noContentToCopy => '无内容可复制';

  @override
  String get contentPastedFromClipboard => '内容已从剪贴板粘贴';

  @override
  String get noTextInClipboard => '剪贴板中没有可粘贴的文本';

  @override
  String get selectSidebarItemFirst => '请先从侧边栏选择项目';

  @override
  String get loomDocumentation => 'Loom文档';

  @override
  String get welcomeToLoom => '欢迎使用Loom！';

  @override
  String get loomDescriptionFull => 'Loom是一个用于组织和编辑文档的知识库应用程序。';

  @override
  String get keyFeatures => '主要功能：';

  @override
  String get fileExplorerFeature => '• 文件资源管理器：浏览和管理您的文件';

  @override
  String get richTextEditorFeature => '• 富文本编辑器：使用语法高亮编辑文档';

  @override
  String get searchFeature => '• 搜索：快速查找文件和内容';

  @override
  String get settingsFeature => '• 设置：自定义您的体验';

  @override
  String get keyboardShortcuts => '键盘快捷键：';

  @override
  String get saveShortcut => '• Ctrl+S：保存文件';

  @override
  String get globalSearchShortcut => '• Ctrl+Shift+F：全局搜索';

  @override
  String get undoShortcut => '• Ctrl+Z：撤销';

  @override
  String get redoShortcut => '• Ctrl+Y：重做';

  @override
  String get fileName => '文件名';

  @override
  String get enterFileName => '输入文件名（例如：example.blox）';

  @override
  String get create => '创建';

  @override
  String get invalidFileName => '无效文件名';

  @override
  String get invalidCharactersInFileName => '文件名中包含无效字符';

  @override
  String fileCreated(String filename) {
    return '文件\"$filename\"已创建';
  }

  @override
  String get exportFile => '导出文件';

  @override
  String get enterExportLocation => '输入导出位置';

  @override
  String get formatHint => 'txt, md, html 等';

  @override
  String fileExportedAs(String filename) {
    return '文件已导出为\"$filename\"';
  }

  @override
  String failedToExportFile(String error) {
    return '导出文件失败：$error';
  }

  @override
  String get enterSaveLocation => '输入保存位置';

  @override
  String fileSavedAs(String filename) {
    return '文件已保存为\"$filename\"';
  }

  @override
  String failedToSaveFile(String error) {
    return '保存文件失败：$error';
  }

  @override
  String get installed => '已安装';

  @override
  String get active => '活跃';

  @override
  String get inactive => '不活跃';

  @override
  String versionState(String version, String state) {
    return '版本：$version • 状态：$state';
  }

  @override
  String commandsCount(int count) {
    return '$count 个命令';
  }

  @override
  String failedToEnablePlugin(String error) {
    return '启用插件失败：$error';
  }

  @override
  String failedToDisablePlugin(String error) {
    return '禁用插件失败：$error';
  }

  @override
  String get disablePlugin => '禁用插件';

  @override
  String get enablePlugin => '启用插件';

  @override
  String get noPluginsCurrentlyLoaded => '当前未加载插件';

  @override
  String get settings => '设置';

  @override
  String get allSettings => '所有设置';

  @override
  String get appearance => '外观';

  @override
  String get appearanceDescription => '自定义应用的外观和感觉';

  @override
  String get appearanceSubtitle => '主题、颜色、布局';

  @override
  String get interface => '界面';

  @override
  String get interfaceSubtitle => '窗口控件、布局';

  @override
  String get generalSubtitle => '偏好设置、行为';

  @override
  String get aboutSubtitle => '版本、许可证';

  @override
  String get openLink => '打开链接';

  @override
  String openLinkConfirmation(String url) {
    return '在浏览器中打开此链接？\n\n$url';
  }

  @override
  String urlCopiedToClipboard(String url) {
    return 'URL已复制到剪贴板：$url';
  }

  @override
  String get copyUrl => '复制URL';

  @override
  String footnote(String id) {
    return '脚注 $id';
  }

  @override
  String imageAlt(String src) {
    return '图片：$src';
  }

  @override
  String get find => '查找';

  @override
  String get findAndReplace => '查找和替换';

  @override
  String get hideReplace => '隐藏替换';

  @override
  String get showReplace => '显示替换';

  @override
  String get findLabel => '查找';

  @override
  String get replaceWith => '替换为';

  @override
  String get matchCase => '匹配大小写';

  @override
  String get useRegex => '使用正则表达式';

  @override
  String get replace => '替换';

  @override
  String get replaceAll => '全部替换';

  @override
  String get findNext => '查找下一个';

  @override
  String get goToLine => '转到行';

  @override
  String get pleaseEnterLineNumber => '请输入行号';

  @override
  String get invalidLineNumber => '无效行号';

  @override
  String get lineNumberMustBeGreaterThanZero => '行号必须大于0';

  @override
  String lineNumberExceedsMaximum(int maxLines) {
    return '行号超过最大值 ($maxLines)';
  }

  @override
  String lineNumberLabel(int maxLines) {
    return '行号 (1 - $maxLines)';
  }

  @override
  String get enterLineNumber => '输入行号';

  @override
  String totalLines(int count) {
    return '总行数：$count';
  }

  @override
  String get share => '分享';

  @override
  String get newDocument => '新文档';

  @override
  String get newFolder => '新文件夹';

  @override
  String get scanDocument => '扫描文档';

  @override
  String get total => '总计';

  @override
  String get noActivePlugins => '无活跃插件';

  @override
  String get searchYourKnowledgeBase => '搜索您的知识库...';

  @override
  String get searchResultsWillAppearHere => '搜索结果将显示在此处';

  @override
  String get collectionsViewForMobile => '移动设备的集合视图';

  @override
  String get searchEverything => '搜索所有内容...';

  @override
  String get mobileSearchInterface => '移动搜索界面';

  @override
  String get exportDocument => '导出文档';

  @override
  String fileLabel(String fileName) {
    return '文件：$fileName';
  }

  @override
  String get exportFormat => '导出格式';

  @override
  String get options => '选项';

  @override
  String get includeLineNumbers => '包含行号';

  @override
  String get includeSyntaxHighlighting => '包含语法高亮';

  @override
  String get includeHeader => '包含标题';

  @override
  String get headerText => '标题文本';

  @override
  String get documentTitle => '文档标题';

  @override
  String get saveLocation => '保存位置';

  @override
  String get choose => '选择...';

  @override
  String get exporting => '正在导出...';

  @override
  String get saveExport => '保存导出';

  @override
  String get createCollection => '创建集合';

  @override
  String get collectionName => '集合名称';

  @override
  String get myCollection => '我的集合';

  @override
  String get chooseTemplateOptional => '选择模板（可选）';

  @override
  String get empty => '空';

  @override
  String get noCollections => '无集合';

  @override
  String get createCollectionsToOrganize => '创建集合来组织您的文件';

  @override
  String deleteCollection(String collectionName) {
    return '删除\"$collectionName\"';
  }

  @override
  String get deleteCollectionConfirmation => '您确定要删除此集合吗？这不会删除实际文件。';

  @override
  String get smartSuggestion => '智能建议';

  @override
  String get keepHere => '保留在此处';

  @override
  String get invalidFolderName => '无效文件夹名';

  @override
  String get invalidCharactersInFolderName => '文件夹名中包含无效字符';

  @override
  String folderCreated(String folderName) {
    return '文件夹\"$folderName\"已创建';
  }

  @override
  String get useFileOpenToOpenFolder => '使用文件 > 打开来打开文件夹';

  @override
  String get useWelcomeScreenToCreateFile => '使用欢迎屏幕创建新文件';

  @override
  String get settingsPanelComingSoon => '设置面板即将推出';

  @override
  String openedFile(String fileName) {
    return '已打开：$fileName';
  }

  @override
  String get includeHiddenFiles => '包含隐藏文件';

  @override
  String get fileSavedSuccessfully => '文件保存成功';

  @override
  String errorSavingFile(String error) {
    return '保存文件错误：$error';
  }

  @override
  String get noContentToPreview => '无内容可预览';

  @override
  String get syntaxWarnings => '语法警告';

  @override
  String noMatchesFound(String searchText) {
    return '未找到\"$searchText\"的匹配项';
  }

  @override
  String replacedOccurrences(int count) {
    return '已替换 $count 个匹配项';
  }

  @override
  String get createNewFolder => '创建新文件夹';

  @override
  String createdFolder(String folderName) {
    return '文件夹已创建：$folderName';
  }

  @override
  String get pleaseOpenWorkspaceFirst => '请先打开工作区';

  @override
  String get createNewFile => '创建新文件';

  @override
  String createdAndOpenedFile(String fileName) {
    return '已创建并打开：$fileName';
  }

  @override
  String get searchPanelPlaceholder => '搜索面板\n（待实现）';

  @override
  String get sourceControlPanelPlaceholder => '源代码控制面板\n（待实现）';

  @override
  String get debugPanelPlaceholder => '调试面板\n（待实现）';

  @override
  String get extensionsPanelPlaceholder => '扩展面板\n（待实现）';

  @override
  String get settingsPanelPlaceholder => '设置面板\n（待实现）';

  @override
  String get selectPanelFromSidebar => '从侧边栏选择面板';

  @override
  String get settingsTooltip => '设置';

  @override
  String get explorerTooltip => '资源管理器';

  @override
  String get searchTooltip => '搜索';

  @override
  String get flutterLicense => 'Flutter - BSD许可证';

  @override
  String get riverpodLicense => 'Riverpod - MIT许可证';

  @override
  String get adaptiveThemeLicense => 'Adaptive Theme - MIT许可证';

  @override
  String get filePickerLicense => 'File Picker - MIT许可证';

  @override
  String get sharedPreferencesLicense => 'Shared Preferences - BSD 许可证';

  @override
  String get pdf => 'PDF 文档';

  @override
  String get html => 'HTML 文档';

  @override
  String get markdown => 'Markdown 文档';

  @override
  String get plainText => '纯文本';

  @override
  String get loomAppTitle => '织机';

  @override
  String get loomKnowledgeBase => 'Loom 知识库';

  @override
  String get yourWorkspace => '您的工作区';

  @override
  String get recentFiles => '最近的文件';

  @override
  String get favorites => '收藏';

  @override
  String get history => '历史';

  @override
  String get helpAndSupport => '帮助与支持';

  @override
  String get darkMode => '深色模式';

  @override
  String get documents => '文档';

  @override
  String get search => '搜索';

  @override
  String get editor => '编辑器';

  @override
  String get collections => '集合';

  @override
  String get welcomeToYourKnowledgeBase => '欢迎来到您的知识库';

  @override
  String get developmentDocumentation => 'Entwicklungsdokumentation';

  @override
  String get welcomeToLoomTitle => '欢迎使用 Loom';

  @override
  String get yourNextGenerationKnowledgeBase => '您的下一代知识库';

  @override
  String get openFolderTitle => '打开文件夹';

  @override
  String get openAnExistingWorkspace => '打开现有工作区';

  @override
  String get newFileTitle => '新建文件';

  @override
  String get createANewDocument => '创建新文档';

  @override
  String get cloneRepositoryTitle => '克隆仓库';

  @override
  String get cloneFromGit => '从 Git 克隆';

  @override
  String openedWorkspace(String workspaceName) {
    return '已打开工作区：$workspaceName';
  }

  @override
  String get cloningRepository => '正在克隆仓库...';

  @override
  String successfullyClonedRepository(String path) {
    return '仓库已成功克隆到：$path';
  }

  @override
  String get repositoryUrl => '仓库 URL';

  @override
  String get enterGitRepositoryUrl => 'Git-Repository-URL eingeben (z.B. https://github.com/user/repo.git)';

  @override
  String get targetDirectoryOptional => 'Zielverzeichnis (optional)';

  @override
  String get leaveEmptyToUseRepositoryName => '留空以使用仓库名称';

  @override
  String editingFile(String filePath) {
    return '正在编辑：$filePath';
  }

  @override
  String get editorContentPlaceholder => '编辑器内容将在此处显示。\n\n这里是您编辑知识库内容的地方！';

  @override
  String get replacing => '替换中...';

  @override
  String get replacingAll => '全部替换中...';

  @override
  String searchError(Object error) {
    return '搜索错误';
  }

  @override
  String get recentSearches => '最近搜索';

  @override
  String get selectFolder => '选择文件夹';

  @override
  String get goUp => '向上';

  @override
  String get quickAccess => '快速访问';

  @override
  String get home => '主页';

  @override
  String get workspaces => '工作区';

  @override
  String get folders => '文件夹';

  @override
  String get noFoldersFound => '未找到文件夹';

  @override
  String searchResultsSummary(int matches, int files, int time) {
    return '在 $files 个文件中找到 $matches 个匹配项 (${time}ms)';
  }

  @override
  String matchesInFile(int count) {
    return '$count 个匹配项';
  }

  @override
  String linePrefix(int number) {
    return '第 $number 行';
  }

  @override
  String get typeToSearchFilesAndCommands => '输入以搜索文件和命令...';

  @override
  String get noResultsFound => '未找到结果';

  @override
  String get navigateUpDown => '↑↓ 导航';

  @override
  String get selectEnter => '↵ 选择';

  @override
  String get closeEscape => 'Esc 关闭';

  @override
  String get findFile => '查找文件';

  @override
  String get typeToSearchFiles => '输入以搜索文件...';

  @override
  String get noFilesFoundInWorkspace => '在工作区中未找到文件';

  @override
  String get noFilesMatchSearch => '没有文件与您的搜索匹配';

  @override
  String get navigateOpenClose => '↑↓ 导航 • ↵ 打开 • Esc 关闭';

  @override
  String get switchTheme => '切换主题';

  @override
  String get layoutAndVisual => '布局与视觉';

  @override
  String get compactMode => '紧凑模式';

  @override
  String get compactModeDescription => '缩小 UI 元素以减少间距';

  @override
  String get showIconsInMenu => '在菜单中显示图标';

  @override
  String get showIconsInMenuDescription => '在菜单项旁边显示图标';

  @override
  String get animationSpeed => '动画速度';

  @override
  String get animationSpeedDescription => 'UI 动画和过渡的速度';

  @override
  String get slow => '慢';

  @override
  String get normal => '正常';

  @override
  String get fast => '快';

  @override
  String get disabled => '禁用';

  @override
  String get sidebarTransparency => '侧栏透明度';

  @override
  String get sidebarTransparencyDescription => '将侧栏背景设置为半透明';

  @override
  String get interfaceDescription => '配置窗口控件和布局';

  @override
  String get currentVersion => '版本 1.0.0';

  @override
  String get currentBuild => '构建 20241201';

  @override
  String get theme => '主题';

  @override
  String get currentTheme => '当前主题';

  @override
  String get currentThemeDescription => '当前启用的主题';

  @override
  String get colorScheme => '配色方案:';

  @override
  String get primary => '主色';

  @override
  String get secondary => '次色';

  @override
  String get surface => '表面';

  @override
  String get themePresets => '主题预设';

  @override
  String get themePresetsDescription => '从预设计的主题中选择。系统主题将自动适应系统设置。';

  @override
  String get systemThemes => '系统主题';

  @override
  String get lightThemes => '浅色主题';

  @override
  String get darkThemes => '深色主题';

  @override
  String get customizeColors => '自定义颜色';

  @override
  String get customizeColorsDescription => '将主题颜色调整为个人偏好';

  @override
  String get primaryColor => '主色';

  @override
  String get secondaryColor => '辅色';

  @override
  String get surfaceColor => '表面色';

  @override
  String get typography => '排版';

  @override
  String get typographyDescription => '自定义字体和文本显示';

  @override
  String get windowControls => '窗口控件';

  @override
  String get showWindowControls => '显示窗口控件';

  @override
  String get showWindowControlsDescription => '显示最小化、最大化、关闭按钮';

  @override
  String get controlsPlacement => '控件放置';

  @override
  String get controlsPlacementDescription => '窗口控件按钮的位置';

  @override
  String get controlsOrder => '控件顺序';

  @override
  String get controlsOrderDescription => '窗口控件按钮的顺序';

  @override
  String get auto => '自动';

  @override
  String get left => '左';

  @override
  String get right => '右';

  @override
  String get minimizeMaximizeClose => '最小化、最大化、关闭';

  @override
  String get closeMinimizeMaximize => '关闭、最小化、最大化';

  @override
  String get closeMaximizeMinimize => '关闭、最大化、最小化';

  @override
  String get closeButtonPositions => '关闭按钮位置';

  @override
  String get closeButtonPositionsDescription => '设置在选项卡和面板中放置关闭按钮的位置';

  @override
  String get quickSettings => '快速设置';

  @override
  String get quickSettingsDescription => '一次设置所有关闭按钮';

  @override
  String get autoDescription => '遵循关闭按钮的默认设置';

  @override
  String get allLeft => '全部靠左';

  @override
  String get allLeftDescription => '将关闭按钮和窗口控件放在左侧';

  @override
  String get allRight => '全部靠右';

  @override
  String get allRightDescription => '将关闭按钮和窗口控件放在右侧';

  @override
  String get individualSettings => '单独设置';

  @override
  String get individualSettingsDescription => '微调每个关闭按钮的位置';

  @override
  String get tabCloseButtons => '选项卡关闭按钮';

  @override
  String get tabCloseButtonsDescription => '选项卡中关闭按钮的位置';

  @override
  String get panelCloseButtons => '面板关闭按钮';

  @override
  String get panelCloseButtonsDescription => '面板内关闭按钮的位置';

  @override
  String get currently => '当前';

  @override
  String get sidebarSearchPlaceholder => '搜索...';

  @override
  String get sidebarSearchOptions => '选项';

  @override
  String get settingsAppearanceDetail => '外观设置';

  @override
  String get settingsInterfaceDetail => '界面设置';

  @override
  String get topbarSearchDialogPlaceholder => '输入以搜索...';

  @override
  String get showAppTitle => '显示应用标题';

  @override
  String get showAppTitleSubtitle => '在顶部栏显示应用名称';

  @override
  String get applicationTitleLabel => '应用标题';

  @override
  String get applicationTitleHint => '输入自定义应用标题';

  @override
  String get showSearchBarTitle => '显示搜索栏';

  @override
  String get showSearchBarSubtitle => '在顶部栏显示搜索功能';

  @override
  String get animationSpeedTestTitle => '动画速度测试';

  @override
  String get hoverMeFastAnimation => '悬停（快速动画）';

  @override
  String get fadeInNormalSpeed => '淡入（正常速度）';

  @override
  String get gettingStartedTitle => '快速上手';

  @override
  String get projectNotesTitle => '项目笔记';

  @override
  String get searchOptionFilesTitle => '文件';

  @override
  String get searchOptionFilesSubtitle => '在文件名中搜索';

  @override
  String get searchOptionContentTitle => '内容';

  @override
  String get searchOptionContentSubtitle => '在文件内容中搜索';

  @override
  String get searchOptionSymbolsTitle => '符号';

  @override
  String get searchOptionSymbolsSubtitle => '搜索函数、类';

  @override
  String moreMatches(int count) {
    return '+$count 个更多匹配';
  }

  @override
  String get noCommandsAvailable => '没有可用的命令';

  @override
  String get commandPaletteSearchFilesTitle => '搜索文件';

  @override
  String get commandPaletteSearchFilesSubtitle => '按名称搜索文件';

  @override
  String get commandPaletteSearchInFilesTitle => '在文件中搜索';

  @override
  String get commandPaletteSearchInFilesSubtitle => '在文件中搜索文本内容';

  @override
  String footerFilesCount(int count) {
    return '$count 个文件';
  }
}
