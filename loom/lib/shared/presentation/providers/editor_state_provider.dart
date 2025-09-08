import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/src/rust/api/blox_api.dart';
import 'package:meta/meta.dart';

/// State for the current editor/file
class EditorState {
  const EditorState({
    this.filePath,
    this.content = '',
    this.isBloxFile = false,
    this.parsedDocument,
    this.syntaxWarnings = const [],
    this.cursorPosition = const CursorPosition(line: 1, column: 1),
    this.showLineNumbers = true,
    this.showMinimap = false,
    this.showPreview = false,
  });

  final String? filePath;
  final String content;
  final bool isBloxFile;
  final BloxDocument? parsedDocument;
  final List<String> syntaxWarnings;
  final CursorPosition cursorPosition;
  final bool showLineNumbers;
  final bool showMinimap;
  final bool showPreview;

  EditorState copyWith({
    String? filePath,
    String? content,
    bool? isBloxFile,
    BloxDocument? parsedDocument,
    List<String>? syntaxWarnings,
    CursorPosition? cursorPosition,
    bool? showLineNumbers,
    bool? showMinimap,
    bool? showPreview,
    bool clearFilePath = false,
    bool clearParsedDocument = false,
  }) {
    return EditorState(
      filePath: clearFilePath ? null : (filePath ?? this.filePath),
      content: content ?? this.content,
      isBloxFile: isBloxFile ?? this.isBloxFile,
      parsedDocument:
          clearParsedDocument ? null : (parsedDocument ?? this.parsedDocument),
      syntaxWarnings: syntaxWarnings ?? this.syntaxWarnings,
      cursorPosition: cursorPosition ?? this.cursorPosition,
      showLineNumbers: showLineNumbers ?? this.showLineNumbers,
      showMinimap: showMinimap ?? this.showMinimap,
      showPreview: showPreview ?? this.showPreview,
    );
  }
}

/// Cursor position in the editor
@immutable
class CursorPosition {
  const CursorPosition({
    required this.line,
    required this.column,
  });

  final int line;
  final int column;

  @override
  String toString() => 'Ln $line, Col $column';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CursorPosition &&
          runtimeType == other.runtimeType &&
          line == other.line &&
          column == other.column;

  @override
  int get hashCode => line.hashCode ^ column.hashCode;
}

/// Notifier for editor state
class EditorStateNotifier extends StateNotifier<EditorState> {
  EditorStateNotifier() : super(const EditorState());

  void updateFilePath(String? filePath) {
    final isBloxFile = filePath?.toLowerCase().endsWith('.blox') ?? false;
    state = state.copyWith(
      filePath: filePath,
      isBloxFile: isBloxFile,
      clearFilePath: filePath == null,
      clearParsedDocument: !isBloxFile,
    );
  }

  void updateContent(String content) {
    state = state.copyWith(content: content);
  }

  void updateParsedDocument(BloxDocument? document) {
    state = state.copyWith(
      parsedDocument: document,
      clearParsedDocument: document == null,
    );
  }

  void updateSyntaxWarnings(List<String> warnings) {
    state = state.copyWith(syntaxWarnings: warnings);
  }

  void updateCursorPosition(int line, int column) {
    state = state.copyWith(
      cursorPosition: CursorPosition(line: line, column: column),
    );
  }

  void toggleLineNumbers() {
    state = state.copyWith(showLineNumbers: !state.showLineNumbers);
  }

  void toggleMinimap() {
    state = state.copyWith(showMinimap: !state.showMinimap);
  }

  void togglePreview() {
    state = state.copyWith(showPreview: !state.showPreview);
  }

  void clear() {
    state = const EditorState();
  }
}

/// Provider for editor state
final editorStateProvider =
    StateNotifierProvider<EditorStateNotifier, EditorState>(
  (ref) => EditorStateNotifier(),
);
