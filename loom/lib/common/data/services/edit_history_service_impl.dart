import 'package:loom/common/index.dart';

/// Implementation of EditHistoryService
class EditHistoryServiceImpl implements EditHistoryService {
  final List<String> _history = [];
  int _currentIndex = -1;
  static const int _maxHistorySize = 100;

  @override
  void addState(String content) {
    // Remove any states after current index (when user types after undo)
    if (_currentIndex < _history.length - 1) {
      _history.removeRange(_currentIndex + 1, _history.length);
    }

    // Add new state
    _history.add(content);
    _currentIndex = _history.length - 1;

    // Limit history size
    if (_history.length > _maxHistorySize) {
      _history.removeAt(0);
      _currentIndex--;
    }
  }

  @override
  String? undo() {
    if (!canUndo) return null;

    _currentIndex--;
    return _history[_currentIndex];
  }

  @override
  String? redo() {
    if (!canRedo) return null;

    _currentIndex++;
    return _history[_currentIndex];
  }

  @override
  bool get canUndo => _currentIndex > 0;

  @override
  bool get canRedo => _currentIndex < _history.length - 1;

  @override
  void clear() {
    _history.clear();
    _currentIndex = -1;
  }

  @override
  int get historySize => _history.length;
}
