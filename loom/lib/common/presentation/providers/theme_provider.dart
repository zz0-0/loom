import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/common/index.dart';

// UI State providers
class UIState {
  const UIState({
    this.isSidebarCollapsed = false,
    this.isSidePanelVisible = false,
    this.selectedSidebarItem,
    this.openedFile,
    this.sidePanelWidth = 320.0,
  });
  final bool isSidebarCollapsed;
  final bool isSidePanelVisible;
  final String? selectedSidebarItem;
  final String? openedFile;
  final double sidePanelWidth;

  UIState copyWith({
    bool? isSidebarCollapsed,
    bool? isSidePanelVisible,
    String? selectedSidebarItem,
    String? openedFile,
    double? sidePanelWidth,
    bool clearOpenedFile = false,
  }) {
    return UIState(
      isSidebarCollapsed: isSidebarCollapsed ?? this.isSidebarCollapsed,
      isSidePanelVisible: isSidePanelVisible ?? this.isSidePanelVisible,
      selectedSidebarItem: selectedSidebarItem ?? this.selectedSidebarItem,
      openedFile: clearOpenedFile ? null : (openedFile ?? this.openedFile),
      sidePanelWidth: sidePanelWidth ?? this.sidePanelWidth,
    );
  }
}

class UIStateNotifier extends StateNotifier<UIState> {
  UIStateNotifier() : super(const UIState());

  void toggleSidebar() {
    state = state.copyWith(isSidebarCollapsed: !state.isSidebarCollapsed);
  }

  void collapseSidebar() {
    state = state.copyWith(isSidebarCollapsed: true);
  }

  void expandSidebar() {
    state = state.copyWith(isSidebarCollapsed: false);
  }

  void toggleSidePanel() {
    state = state.copyWith(isSidePanelVisible: !state.isSidePanelVisible);
  }

  void showSidePanel() {
    state = state.copyWith(isSidePanelVisible: true);
  }

  void hideSidePanel() {
    state = state.copyWith(isSidePanelVisible: false);
  }

  void selectSidebarItem(String item) {
    // If clicking the same item, toggle the panel
    if (state.selectedSidebarItem == item) {
      toggleSidePanel();
    } else {
      state = state.copyWith(
        selectedSidebarItem: item,
        isSidePanelVisible: true,
      );
    }
  }

  void openFile(String filePath) {
    state = state.copyWith(openedFile: filePath);
  }

  void closeFile() {
    state = state.copyWith(clearOpenedFile: true);
  }

  void updateSidePanelWidth(double width) {
    state = state.copyWith(sidePanelWidth: width);
  }

  void loadFileContent(String filePath, String content) {
    // This method will be called to update both UI and editor state
    state = state.copyWith(openedFile: filePath);
  }
}

final uiStateProvider = StateNotifierProvider<UIStateNotifier, UIState>(
  (ref) => UIStateNotifier(),
);

// File opening service that coordinates between UI state and editor state
class FileOpeningService {
  const FileOpeningService(this._ref);
  final Ref _ref;

  Future<void> openFile(String filePath) async {
    try {
      // Update UI state first
      _ref.read(uiStateProvider.notifier).openFile(filePath);

      // Update editor state with file path immediately
      _ref.read(editorStateProvider.notifier).updateFilePath(filePath);

      // Load file content asynchronously
      final fileRepository = _ref.read(fileRepositoryProvider);
      final content = await fileRepository.readFile(filePath);

      // Update editor state with content
      _ref.read(editorStateProvider.notifier).updateContent(content);

      // If it's a Blox file, try to parse it
      if (filePath.toLowerCase().endsWith('.blox')) {
        // TODO(user): Parse Blox document when parser is available
        // final parsedDocument = await _ref.read(bloxParserProvider).parse(content);
        // _ref.read(editorStateProvider.notifier).updateParsedDocument(parsedDocument);
      }
    } catch (e) {
      // Handle error - could show snackbar or update error state
      debugPrint('Failed to open file: $e');
    }
  }

  void closeFile() {
    _ref.read(uiStateProvider.notifier).closeFile();
    _ref.read(editorStateProvider.notifier).clear();
  }
}

// Provider for file opening service
final fileOpeningServiceProvider = Provider<FileOpeningService>((ref) {
  return FileOpeningService(ref);
});
