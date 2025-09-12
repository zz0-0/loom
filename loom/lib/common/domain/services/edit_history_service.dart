/// Service for managing edit history and undo/redo operations
abstract class EditHistoryService {
  /// Adds a new state to the edit history
  void addState(String content);

  /// Gets the previous state (undo)
  String? undo();

  /// Gets the next state (redo)
  String? redo();

  /// Checks if undo is available
  bool get canUndo;

  /// Checks if redo is available
  bool get canRedo;

  /// Clears the edit history
  void clear();

  /// Gets the current history size
  int get historySize;
}
