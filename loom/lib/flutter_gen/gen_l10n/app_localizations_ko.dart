import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'Loom - 지식 기반';

  @override
  String get uiPolishShowcase => 'UI 폴리시 쇼케이스';

  @override
  String get enhancedUiAnimations => '향상된 UI 애니메이션';

  @override
  String get loadingIndicators => '로딩 표시기';

  @override
  String get smoothLoading => '부드러운 로딩';

  @override
  String get skeletonLoader => '스켈레톤 로더';

  @override
  String get interactiveElements => '대화형 요소';

  @override
  String get hoverAnimation => '호버 애니메이션';

  @override
  String get pressAnimation => '누르기 애니메이션';

  @override
  String get pulseAnimation => '펄스 애니메이션';

  @override
  String get shimmerEffects => '쉬머 효과';

  @override
  String get successAnimations => '성공 애니메이션';

  @override
  String get taskCompleted => '작업 완료!';

  @override
  String get animationCombinations => '애니메이션 조합';

  @override
  String get interactiveButton => '대화형 버튼';

  @override
  String get animatedCard => '애니메이션 카드';

  @override
  String get animatedCardDescription => '이 카드는 페이드인과 슬라이드인 애니메이션이 결합된 것을 보여줍니다.';

  @override
  String get general => '일반';

  @override
  String get generalDescription => '일반 설정 및 응용 프로그램 동작';

  @override
  String get autoSave => '자동 저장';

  @override
  String get autoSaveDescription => '정기적으로 변경사항을 자동으로 저장';

  @override
  String get confirmOnExit => '종료 시 확인';

  @override
  String get confirmOnExitDescription => '저장되지 않은 변경사항이 있을 때 닫기 전에 확인 요청';

  @override
  String get language => '언어';

  @override
  String get languageDescription => '응용 프로그램 언어';

  @override
  String get followSystemLanguage => '시스템 언어 따르기';

  @override
  String get manualLanguageSelection => '수동 언어 선택';

  @override
  String get english => '영어';

  @override
  String get spanish => '스페인어';

  @override
  String get french => '프랑스어';

  @override
  String get german => '독일어';

  @override
  String get chinese => '중국어';

  @override
  String get japanese => '일본어';

  @override
  String get korean => '한국어';

  @override
  String get autoSaveInterval => '자동 저장 간격';

  @override
  String lastSaved(Object time) {
    return '마지막 저장: ';
  }

  @override
  String get justNow => '방금';

  @override
  String minutesAgo(int count) {
    return '$count분 전';
  }

  @override
  String hoursAgo(int count) {
    return '$count시간 전';
  }

  @override
  String daysAgo(int count) {
    return '$count일 전';
  }

  @override
  String get commandExecutedSuccessfully => '명령이 성공적으로 실행되었습니다';

  @override
  String commandFailed(String error) {
    return '명령 실패: $error';
  }

  @override
  String failedToExecuteCommand(String error) {
    return '명령 실행 실패: $error';
  }

  @override
  String get about => '정보';

  @override
  String get aboutDescription => 'Loom에 대한 정보';

  @override
  String get version => '버전';

  @override
  String get licenses => '라이선스';

  @override
  String get viewOpenSourceLicenses => '오픈 소스 라이선스 보기';

  @override
  String get loom => '룸';

  @override
  String get build => '빌드';

  @override
  String get loomDescription => 'Loom은 생산성과 사용 편의성을 위해 설계된 Flutter로 구축된 현대적인 코드 편집기입니다.';

  @override
  String get copyright => '© 2024 Loom 팀';

  @override
  String get close => '닫기';

  @override
  String get openSourceLicenses => '오픈 소스 라이선스';

  @override
  String get usesFollowingLibraries => 'Loom은 다음 오픈 소스 라이브러리를 사용합니다:';

  @override
  String get fullLicenseTexts => '전체 라이선스 텍스트는 GitHub의 각 폴더 저장소를 방문하세요.';

  @override
  String get enterPath => '경로 입력';

  @override
  String get directoryPath => '디렉토리 경로';

  @override
  String get pathHint => '/home/user/폴더';

  @override
  String get cancel => '취소';

  @override
  String get go => '이동';

  @override
  String get select => '선택';

  @override
  String get apply => '적용';

  @override
  String get preview => '미리보기';

  @override
  String selectColorLabel(String label) {
    return '색상 선택 $label';
  }

  @override
  String get fontFamilyLabel => '글꼴 패밀리';

  @override
  String get fontSizeLabel => '글꼴 크기';

  @override
  String get previewSampleText => '샘플 텍스트';

  @override
  String get searchFilesAndCommands => '파일과 명령 검색...';

  @override
  String get commandKeyShortcut => '명령: ⌘K';

  @override
  String get menu => '메뉴';

  @override
  String get file => '파일';

  @override
  String get newFile => '새 파일';

  @override
  String get openFolder => '폴더 열기';

  @override
  String get save => '저장';

  @override
  String get saveAs => '다른 이름으로 저장';

  @override
  String get export => '내보내기';

  @override
  String get exit => '종료';

  @override
  String get edit => '편집';

  @override
  String get undo => '실행 취소';

  @override
  String get redo => '다시 실행';

  @override
  String get cut => '잘라내기';

  @override
  String get copy => '복사';

  @override
  String get paste => '붙여넣기';

  @override
  String get view => '보기';

  @override
  String get toggleSidebar => '사이드바 토글';

  @override
  String get togglePanel => '패널 토글';

  @override
  String get fullScreen => '전체 화면';

  @override
  String get help => '도움말';

  @override
  String get documentation => '문서';

  @override
  String get plugins => '플러그인';

  @override
  String get pluginManager => '플러그인 관리자';

  @override
  String get noPluginsLoaded => '로드된 플러그인 없음';

  @override
  String get openFolderFirst => '새 파일을 생성하려면 먼저 폴더를 여세요';

  @override
  String get noFileOpenToSave => '현재 저장할 파일이 열려 있지 않습니다';

  @override
  String fileSaved(String filename) {
    return '파일 \"$filename\" 저장됨';
  }

  @override
  String get noContentToExport => '내보낼 콘텐츠 없음';

  @override
  String get exitApplication => '응용 프로그램 종료';

  @override
  String get confirmExit => 'Loom을 종료하시겠습니까?';

  @override
  String get openInNewTab => '新しいタブで開く';

  @override
  String get rename => '名前を変更';

  @override
  String get delete => '삭제';

  @override
  String get deleteItem => '項目を削除';

  @override
  String get cancelButton => 'キャンセル';

  @override
  String get enterPathPrompt => '開きたいフォルダのパスを入力してください:';

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
    return '위치 선택에 실패했습니다: $error';
  }

  @override
  String folderCreatedSuccess(String folderName) {
    return '폴더 \"$folderName\" 생성에 성공했습니다!';
  }

  @override
  String failedToCreateFolder(String error) {
    return '폴더 생성 실패: $error';
  }

  @override
  String get enterFileNameHint => '파일 이름을 입력하세요 (예: document.md)';

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
    return '폴더를 여는 중 오류가 발생했습니다: $error';
  }

  @override
  String failedToCreateFile(String error) {
    return '파일 생성 실패: $error';
  }

  @override
  String failedToDeleteItem(String error) {
    return '항목 삭제에 실패했습니다: $error';
  }

  @override
  String failedToRenameItem(String error) {
    return '이름 변경에 실패했습니다: $error';
  }

  @override
  String renameSuccess(String name) {
    return '$name(으)로 이름 변경됨';
  }

  @override
  String deleteSuccess(String itemType) {
    return '$itemType이(가) 성공적으로 삭제되었습니다';
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
    return '구문 경고 $count개';
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
    return '저장소 복제 실패: $error';
  }

  @override
  String get openInNewTabAction => '新しいタブで開く';

  @override
  String get nothingToUndo => '실행 취소할 항목 없음';

  @override
  String get nothingToRedo => '다시 실행할 항목 없음';

  @override
  String get contentCutToClipboard => '콘텐츠가 잘려서 클립보드에 복사되었습니다';

  @override
  String get noContentToCut => '잘라낼 콘텐츠 없음';

  @override
  String get contentCopiedToClipboard => '콘텐츠가 클립보드에 복사되었습니다';

  @override
  String get noContentToCopy => '복사할 콘텐츠 없음';

  @override
  String get contentPastedFromClipboard => '클립보드에서 콘텐츠가 붙여넣기되었습니다';

  @override
  String get noTextInClipboard => '클립보드에 붙여넣을 텍스트가 없습니다';

  @override
  String get selectSidebarItemFirst => '먼저 사이드바에서 항목을 선택하세요';

  @override
  String get loomDocumentation => 'Loom 문서';

  @override
  String get welcomeToLoom => 'Loom에 오신 것을 환영합니다!';

  @override
  String get loomDescriptionFull => 'Loom은 문서 정리 및 편집을 위한 지식 기반 응용 프로그램입니다.';

  @override
  String get keyFeatures => '주요 기능:';

  @override
  String get fileExplorerFeature => '• 파일 탐색기: 파일을 찾아보고 관리';

  @override
  String get richTextEditorFeature => '• 리치 텍스트 편집기: 구문 강조로 문서 편집';

  @override
  String get searchFeature => '• 검색: 파일과 콘텐츠를 빠르게 찾기';

  @override
  String get settingsFeature => '• 설정: 경험을 사용자 정의';

  @override
  String get keyboardShortcuts => '키보드 단축키:';

  @override
  String get saveShortcut => '• Ctrl+S: 파일 저장';

  @override
  String get globalSearchShortcut => '• Ctrl+Shift+F: 전역 검색';

  @override
  String get undoShortcut => '• Ctrl+Z: 실행 취소';

  @override
  String get redoShortcut => '• Ctrl+Y: 다시 실행';

  @override
  String get fileName => '파일 이름';

  @override
  String get enterFileName => '파일 이름 입력 (예: example.blox)';

  @override
  String get create => '생성';

  @override
  String get invalidFileName => '잘못된 파일 이름';

  @override
  String get invalidCharactersInFileName => '파일 이름에 잘못된 문자가 있습니다';

  @override
  String fileCreated(String filename) {
    return '파일 \"$filename\" 생성됨';
  }

  @override
  String get exportFile => '파일 내보내기';

  @override
  String get enterExportLocation => '내보내기 위치 입력';

  @override
  String get formatHint => 'txt, md, html, 등';

  @override
  String fileExportedAs(String filename) {
    return '파일이 \"$filename\"으로 내보내짐';
  }

  @override
  String failedToExportFile(String error) {
    return '파일 내보내기 실패: $error';
  }

  @override
  String get enterSaveLocation => '저장 위치 입력';

  @override
  String fileSavedAs(String filename) {
    return '파일이 \"$filename\"으로 저장됨';
  }

  @override
  String failedToSaveFile(String error) {
    return '파일 저장 실패: $error';
  }

  @override
  String get installed => '설치됨';

  @override
  String get active => '활성';

  @override
  String get inactive => '비활성';

  @override
  String versionState(String version, String state) {
    return '버전: $version • 상태: $state';
  }

  @override
  String commandsCount(int count) {
    return '$count개 명령';
  }

  @override
  String failedToEnablePlugin(String error) {
    return '플러그인 활성화 실패: $error';
  }

  @override
  String failedToDisablePlugin(String error) {
    return '플러그인 비활성화 실패: $error';
  }

  @override
  String get disablePlugin => '플러그인 비활성화';

  @override
  String get enablePlugin => '플러그인 활성화';

  @override
  String get noPluginsCurrentlyLoaded => '현재 로드된 플러그인이 없습니다';

  @override
  String get settings => '설정';

  @override
  String get allSettings => '모든 설정';

  @override
  String get appearance => '외관';

  @override
  String get appearanceDescription => '응용 프로그램의 모양과 느낌을 사용자 지정합니다';

  @override
  String get appearanceSubtitle => '테마, 색상, 레이아웃';

  @override
  String get interface => '인터페이스';

  @override
  String get interfaceSubtitle => '창 컨트롤, 레이아웃';

  @override
  String get generalSubtitle => '설정, 동작';

  @override
  String get aboutSubtitle => '버전, 라이선스';

  @override
  String get openLink => '링크 열기';

  @override
  String openLinkConfirmation(String url) {
    return '브라우저에서 이 링크를 여시겠습니까?\n\n$url';
  }

  @override
  String urlCopiedToClipboard(String url) {
    return 'URL이 클립보드에 복사됨: $url';
  }

  @override
  String get copyUrl => 'URL 복사';

  @override
  String footnote(String id) {
    return '각주 $id';
  }

  @override
  String imageAlt(String src) {
    return '이미지: $src';
  }

  @override
  String get find => '찾기';

  @override
  String get findAndReplace => '찾기 및 바꾸기';

  @override
  String get hideReplace => '바꾸기 숨기기';

  @override
  String get showReplace => '바꾸기 표시';

  @override
  String get findLabel => '찾기';

  @override
  String get replaceWith => '다음으로 바꾸기';

  @override
  String get matchCase => '대소문자 구분';

  @override
  String get useRegex => '정규식 사용';

  @override
  String get replace => '바꾸기';

  @override
  String get replaceAll => '모두 바꾸기';

  @override
  String get findNext => '다음 찾기';

  @override
  String get goToLine => '줄로 이동';

  @override
  String get pleaseEnterLineNumber => '줄 번호를 입력하세요';

  @override
  String get invalidLineNumber => '잘못된 줄 번호';

  @override
  String get lineNumberMustBeGreaterThanZero => '줄 번호는 0보다 커야 합니다';

  @override
  String lineNumberExceedsMaximum(int maxLines) {
    return '줄 번호가 최대값 ($maxLines)을 초과합니다';
  }

  @override
  String lineNumberLabel(int maxLines) {
    return '줄 번호 (1 - $maxLines)';
  }

  @override
  String get enterLineNumber => '줄 번호 입력';

  @override
  String totalLines(int count) {
    return '총 줄 수: $count';
  }

  @override
  String get share => '공유';

  @override
  String get newDocument => '새 문서';

  @override
  String get newFolder => '새 폴더';

  @override
  String get scanDocument => '문서 스캔';

  @override
  String get total => '총계';

  @override
  String get noActivePlugins => '활성 플러그인 없음';

  @override
  String get searchYourKnowledgeBase => '지식 기반 검색...';

  @override
  String get searchResultsWillAppearHere => '검색 결과가 여기에 표시됩니다';

  @override
  String get collectionsViewForMobile => '모바일용 컬렉션 보기';

  @override
  String get searchEverything => '모두 검색...';

  @override
  String get mobileSearchInterface => '모바일 검색 인터페이스';

  @override
  String get exportDocument => '문서 내보내기';

  @override
  String fileLabel(String fileName) {
    return '파일: $fileName';
  }

  @override
  String get exportFormat => '내보내기 형식';

  @override
  String get options => '옵션';

  @override
  String get includeLineNumbers => '줄 번호 포함';

  @override
  String get includeSyntaxHighlighting => '구문 강조 포함';

  @override
  String get includeHeader => '헤더 포함';

  @override
  String get headerText => '헤더 텍스트';

  @override
  String get documentTitle => '문서 제목';

  @override
  String get saveLocation => '저장 위치';

  @override
  String get choose => '선택...';

  @override
  String get exporting => '내보내는 중...';

  @override
  String get saveExport => '내보내기 저장';

  @override
  String get createCollection => '컬렉션 생성';

  @override
  String get collectionName => '컬렉션 이름';

  @override
  String get myCollection => '내 컬렉션';

  @override
  String get chooseTemplateOptional => '템플릿 선택 (선택사항)';

  @override
  String get empty => '비어있음';

  @override
  String get noCollections => '컬렉션 없음';

  @override
  String get createCollectionsToOrganize => '파일을 정리하기 위해 컬렉션을 생성하세요';

  @override
  String deleteCollection(String collectionName) {
    return '\"$collectionName\" 삭제';
  }

  @override
  String get deleteCollectionConfirmation => '이 컬렉션을 삭제하시겠습니까? 실제 파일은 삭제되지 않습니다.';

  @override
  String get smartSuggestion => '스마트 제안';

  @override
  String get keepHere => '여기에 유지';

  @override
  String get invalidFolderName => '잘못된 폴더 이름';

  @override
  String get invalidCharactersInFolderName => '폴더 이름에 잘못된 문자가 있습니다';

  @override
  String folderCreated(String folderName) {
    return '폴더 \"$folderName\" 생성됨';
  }

  @override
  String get useFileOpenToOpenFolder => '폴더를 열려면 파일 > 열기를 사용하세요';

  @override
  String get useWelcomeScreenToCreateFile => '새 파일을 생성하려면 환영 화면을 사용하세요';

  @override
  String get settingsPanelComingSoon => '설정 패널 곧 제공 예정';

  @override
  String openedFile(String fileName) {
    return '열림: $fileName';
  }

  @override
  String get includeHiddenFiles => '숨겨진 파일 포함';

  @override
  String get fileSavedSuccessfully => '파일이 성공적으로 저장되었습니다';

  @override
  String errorSavingFile(String error) {
    return '파일 저장 오류: $error';
  }

  @override
  String get noContentToPreview => '미리 볼 콘텐츠 없음';

  @override
  String get syntaxWarnings => '구문 경고';

  @override
  String noMatchesFound(String searchText) {
    return '\"$searchText\"에 대한 일치 항목을 찾을 수 없습니다';
  }

  @override
  String replacedOccurrences(int count) {
    return '$count개 항목 교체함';
  }

  @override
  String get createNewFolder => '새 폴더 생성';

  @override
  String createdFolder(String folderName) {
    return '폴더 생성됨: $folderName';
  }

  @override
  String get pleaseOpenWorkspaceFirst => '먼저 작업 공간을 여세요';

  @override
  String get createNewFile => '새 파일 생성';

  @override
  String createdAndOpenedFile(String fileName) {
    return '생성 및 열림: $fileName';
  }

  @override
  String get searchPanelPlaceholder => '검색 패널\n(구현 예정)';

  @override
  String get sourceControlPanelPlaceholder => '소스 컨트롤 패널\n(구현 예정)';

  @override
  String get debugPanelPlaceholder => '디버그 패널\n(구현 예정)';

  @override
  String get extensionsPanelPlaceholder => '확장 패널\n(구현 예정)';

  @override
  String get settingsPanelPlaceholder => '설정 패널\n(구현 예정)';

  @override
  String get selectPanelFromSidebar => '사이드바에서 패널 선택';

  @override
  String get settingsTooltip => '설정';

  @override
  String get explorerTooltip => '탐색기';

  @override
  String get searchTooltip => '검색';

  @override
  String get flutterLicense => 'Flutter - BSD 라이선스';

  @override
  String get riverpodLicense => 'Riverpod - MIT 라이선스';

  @override
  String get adaptiveThemeLicense => 'Adaptive Theme - MIT 라이선스';

  @override
  String get filePickerLicense => 'File Picker - MIT 라이선스';

  @override
  String get sharedPreferencesLicense => 'Shared Preferences - BSD 라이선스';

  @override
  String get pdf => 'PDF 문서';

  @override
  String get html => 'HTML 문서';

  @override
  String get markdown => '마크다운';

  @override
  String get plainText => '일반 텍스트';

  @override
  String get loomAppTitle => '룸';

  @override
  String get loomKnowledgeBase => 'Loom 지식 베이스';

  @override
  String get yourWorkspace => '작업 공간';

  @override
  String get recentFiles => '최근 파일';

  @override
  String get favorites => '즐겨찾기';

  @override
  String get history => '기록';

  @override
  String get helpAndSupport => '도움말 및 지원';

  @override
  String get darkMode => 'Dunkler Modus';

  @override
  String get documents => 'Dokumente';

  @override
  String get search => 'Suche';

  @override
  String get editor => '편집기';

  @override
  String get collections => 'Sammlungen';

  @override
  String get welcomeToYourKnowledgeBase => '지식 베이스에 오신 것을 환영합니다';

  @override
  String get developmentDocumentation => 'Entwicklungsdokumentation';

  @override
  String get welcomeToLoomTitle => 'Loom에 오신 것을 환영합니다';

  @override
  String get yourNextGenerationKnowledgeBase => '차세대 지식 베이스';

  @override
  String get openFolderTitle => '폴더 열기';

  @override
  String get openAnExistingWorkspace => '기존 작업 공간 열기';

  @override
  String get newFileTitle => '새 파일';

  @override
  String get createANewDocument => '새 문서 만들기';

  @override
  String get cloneRepositoryTitle => '저장소 복제';

  @override
  String get cloneFromGit => 'Git에서 복제';

  @override
  String openedWorkspace(String workspaceName) {
    return '작업 공간을 열었습니다: $workspaceName';
  }

  @override
  String get cloningRepository => '저장소를 복제하는 중...';

  @override
  String successfullyClonedRepository(String path) {
    return '저장소가 다음 위치에 성공적으로 복제되었습니다: $path';
  }

  @override
  String get repositoryUrl => '저장소 URL';

  @override
  String get enterGitRepositoryUrl => 'Git-Repository-URL eingeben (z.B. https://github.com/user/repo.git)';

  @override
  String get targetDirectoryOptional => 'Zielverzeichnis (optional)';

  @override
  String get leaveEmptyToUseRepositoryName => '비워두면 저장소 이름을 사용합니다';

  @override
  String editingFile(String filePath) {
    return 'Bearbeiten: $filePath';
  }

  @override
  String get editorContentPlaceholder => '편집기 콘텐츠가 여기에 구현됩니다.\n\n여기가 혁신적인 지식 기반 편집 경험의 장소입니다!';

  @override
  String get replacing => '바꾸는 중...';

  @override
  String get replacingAll => '모두 바꾸는 중...';

  @override
  String searchError(Object error) {
    return '검색 오류';
  }

  @override
  String get recentSearches => '최근 검색';

  @override
  String get selectFolder => '폴더 선택';

  @override
  String get goUp => '위로';

  @override
  String get quickAccess => '빠른 액세스';

  @override
  String get home => '홈';

  @override
  String get workspaces => '작업 공간';

  @override
  String get folders => '폴더';

  @override
  String get noFoldersFound => '폴더를 찾을 수 없습니다';

  @override
  String searchResultsSummary(int matches, int files, int time) {
    return '$files개 파일에서 $matches개 일치 (${time}ms)';
  }

  @override
  String matchesInFile(int count) {
    return '$count개 일치';
  }

  @override
  String linePrefix(int number) {
    return '$number번째 줄';
  }

  @override
  String get typeToSearchFilesAndCommands => '파일과 명령을 검색하려면 입력하세요...';

  @override
  String get noResultsFound => '결과를 찾을 수 없습니다';

  @override
  String get navigateUpDown => '↑↓ 탐색';

  @override
  String get selectEnter => '↵ 선택';

  @override
  String get closeEscape => 'Esc 닫기';

  @override
  String get findFile => '파일 찾기';

  @override
  String get typeToSearchFiles => '파일을 검색하려면 입력하세요...';

  @override
  String get noFilesFoundInWorkspace => '작업 영역에서 파일을 찾을 수 없습니다';

  @override
  String get noFilesMatchSearch => '검색과 일치하는 파일이 없습니다';

  @override
  String get navigateOpenClose => '↑↓ 탐색 • ↵ 열기 • Esc 닫기';

  @override
  String get switchTheme => '테마 전환';

  @override
  String get layoutAndVisual => '레이아웃 및 시각';

  @override
  String get compactMode => '컴팩트 모드';

  @override
  String get compactModeDescription => 'UI 요소를 작게 하여 간격을 줄입니다';

  @override
  String get showIconsInMenu => '메뉴에 아이콘 표시';

  @override
  String get showIconsInMenuDescription => '메뉴 항목 옆에 아이콘을 표시합니다';

  @override
  String get animationSpeed => '애니메이션 속도';

  @override
  String get animationSpeedDescription => 'UI 애니메이션 및 전환 속도';

  @override
  String get slow => '느림';

  @override
  String get normal => '보통';

  @override
  String get fast => '빠름';

  @override
  String get disabled => '비활성';

  @override
  String get sidebarTransparency => '사이드바 투명도';

  @override
  String get sidebarTransparencyDescription => '사이드바 배경을 반투명하게 합니다';

  @override
  String get interfaceDescription => '창 컨트롤 및 레이아웃을 구성합니다';

  @override
  String get currentVersion => '버전 1.0.0';

  @override
  String get currentBuild => '빌드 20241201';

  @override
  String get theme => '테마';

  @override
  String get currentTheme => '현재 테마';

  @override
  String get currentThemeDescription => '현재 활성화된 테마';

  @override
  String get colorScheme => '색 구성표:';

  @override
  String get primary => '기본';

  @override
  String get secondary => '보조';

  @override
  String get surface => '표면';

  @override
  String get themePresets => '테마 프리셋';

  @override
  String get themePresetsDescription => '미리 디자인된 테마에서 선택하십시오. 시스템 테마는 자동으로 시스템 설정에 적응합니다.';

  @override
  String get systemThemes => '시스템 테마';

  @override
  String get lightThemes => '라이트 테마';

  @override
  String get darkThemes => '다크 테마';

  @override
  String get customizeColors => '색상 사용자 지정';

  @override
  String get customizeColorsDescription => '테마 색상을 개인 취향에 맞게 조정합니다';

  @override
  String get primaryColor => '기본 색상';

  @override
  String get secondaryColor => '보조 색상';

  @override
  String get surfaceColor => '표면 색상';

  @override
  String get typography => '타이포그래피';

  @override
  String get typographyDescription => '글꼴 및 텍스트 표시를 사용자 지정합니다';

  @override
  String get windowControls => '창 컨트롤';

  @override
  String get showWindowControls => '창 컨트롤 표시';

  @override
  String get showWindowControlsDescription => '최소화, 최대화, 닫기 버튼을 표시합니다';

  @override
  String get controlsPlacement => '컨트롤 배치';

  @override
  String get controlsPlacementDescription => '창 컨트롤 버튼의 위치';

  @override
  String get controlsOrder => '컨트롤 순서';

  @override
  String get controlsOrderDescription => '창 컨트롤 버튼의 순서';

  @override
  String get auto => '자동';

  @override
  String get left => '왼쪽';

  @override
  String get right => '오른쪽';

  @override
  String get minimizeMaximizeClose => '최소화, 최대화, 닫기';

  @override
  String get closeMinimizeMaximize => '닫기, 최소화, 최대화';

  @override
  String get closeMaximizeMinimize => '닫기, 최대화, 최소화';

  @override
  String get closeButtonPositions => '닫기 버튼 위치';

  @override
  String get closeButtonPositionsDescription => '탭 및 패널에 닫기 버튼을 배치할 위치를 설정합니다';

  @override
  String get quickSettings => '빠른 설정';

  @override
  String get quickSettingsDescription => '모든 닫기 버튼을 한 번에 설정합니다';

  @override
  String get autoDescription => '닫기 버튼의 기본 설정을 따릅니다';

  @override
  String get allLeft => '모두 왼쪽';

  @override
  String get allLeftDescription => '닫기 버튼 및 창 컨트롤을 왼쪽으로 배치';

  @override
  String get allRight => '모두 오른쪽';

  @override
  String get allRightDescription => '닫기 버튼 및 창 컨트롤을 오른쪽으로 배치';

  @override
  String get individualSettings => '개별 설정';

  @override
  String get individualSettingsDescription => '각 닫기 버튼의 위치를 미세 조정합니다';

  @override
  String get tabCloseButtons => '탭 닫기 버튼';

  @override
  String get tabCloseButtonsDescription => '탭 안의 닫기 버튼 위치';

  @override
  String get panelCloseButtons => '패널 닫기 버튼';

  @override
  String get panelCloseButtonsDescription => '패널 내 닫기 버튼 위치';

  @override
  String get currently => '현재';

  @override
  String get sidebarSearchPlaceholder => '검색...';

  @override
  String get sidebarSearchOptions => '옵션';

  @override
  String get settingsAppearanceDetail => '모양 설정';

  @override
  String get settingsInterfaceDetail => '인터페이스 설정';

  @override
  String get topbarSearchDialogPlaceholder => '검색어를 입력하세요...';

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
  String get searchOptionFilesTitle => '파일';

  @override
  String get searchOptionFilesSubtitle => '파일 이름에서 검색';

  @override
  String get searchOptionContentTitle => '내용';

  @override
  String get searchOptionContentSubtitle => '파일 내용에서 검색';

  @override
  String get searchOptionSymbolsTitle => '심볼';

  @override
  String get searchOptionSymbolsSubtitle => '함수, 클래스 검색';

  @override
  String moreMatches(int count) {
    return '+$count개 더';
  }

  @override
  String get noCommandsAvailable => '사용 가능한 명령이 없습니다';

  @override
  String get commandPaletteSearchFilesTitle => '파일 검색';

  @override
  String get commandPaletteSearchFilesSubtitle => '이름으로 파일 검색';

  @override
  String get commandPaletteSearchInFilesTitle => '파일에서 검색';

  @override
  String get commandPaletteSearchInFilesSubtitle => '파일의 텍스트 내용을 검색';

  @override
  String footerFilesCount(int count) {
    return '$count 파일';
  }
}
