import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Auto-save status
class AutoSaveStatus {
  const AutoSaveStatus({
    this.isActive = false,
    this.lastSaveTime,
    this.filesWithChanges = const {},
  });

  final bool isActive;
  final DateTime? lastSaveTime;
  final Set<String> filesWithChanges;

  AutoSaveStatus copyWith({
    bool? isActive,
    DateTime? lastSaveTime,
    Set<String>? filesWithChanges,
  }) {
    return AutoSaveStatus(
      isActive: isActive ?? this.isActive,
      lastSaveTime: lastSaveTime ?? this.lastSaveTime,
      filesWithChanges: filesWithChanges ?? this.filesWithChanges,
    );
  }
}

/// Auto-save status notifier
class AutoSaveStatusNotifier extends StateNotifier<AutoSaveStatus> {
  AutoSaveStatusNotifier() : super(const AutoSaveStatus());

  void setActive(bool active) {
    state = state.copyWith(isActive: active);
  }

  void setLastSaveTime(DateTime time) {
    state = state.copyWith(lastSaveTime: time);
  }

  void addFileWithChanges(String filePath) {
    final newSet = Set<String>.from(state.filesWithChanges)..add(filePath);
    state = state.copyWith(filesWithChanges: newSet);
  }

  void removeFileWithChanges(String filePath) {
    final newSet = Set<String>.from(state.filesWithChanges)..remove(filePath);
    state = state.copyWith(filesWithChanges: newSet);
  }

  void clearFilesWithChanges() {
    state = state.copyWith(filesWithChanges: const {});
  }
}

/// Provider for auto-save status
final autoSaveStatusProvider =
    StateNotifierProvider<AutoSaveStatusNotifier, AutoSaveStatus>((ref) {
  return AutoSaveStatusNotifier();
});
