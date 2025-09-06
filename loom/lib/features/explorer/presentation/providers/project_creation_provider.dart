import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/features/explorer/data/models/project_template.dart';
import 'package:loom/features/explorer/domain/entities/workspace_entities.dart';
import 'package:path/path.dart' as path;

/// State for project creation process
class ProjectCreationState {
  const ProjectCreationState({
    this.isLoading = false,
    this.error,
  });

  final bool isLoading;
  final String? error;

  ProjectCreationState copyWith({
    bool? isLoading,
    String? error,
  }) {
    return ProjectCreationState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Provider for available project templates
final projectTemplatesProvider = Provider<List<ProjectTemplate>>((ref) {
  return ProjectTemplates.getDomainTemplates();
});

/// Notifier for project creation state
class ProjectCreationNotifier extends StateNotifier<ProjectCreationState> {
  ProjectCreationNotifier() : super(const ProjectCreationState());

  /// Create a new project from a template
  // ignore: avoid_slow_async_io
  Future<void> createProject({
    required String name,
    required String location,
    required String templateId,
  }) async {
    state = state.copyWith(isLoading: true);

    try {
      // Get available templates
      final templates = ProjectTemplates.getDomainTemplates();
      final template = templates.firstWhere(
        (ProjectTemplate t) => t.id == templateId,
        orElse: () => throw Exception('Template not found: $templateId'),
      );

      // Create project directory
      final projectPath = path.join(location, name);
      final projectDir = Directory(projectPath);

      // ignore: avoid_slow_async_io
      if (await projectDir.exists()) {
        throw Exception('A folder with this name already exists');
      }

      // ignore: avoid_slow_async_io
      await projectDir.create(recursive: true);

      // Create folders
      for (final folderPath in template.folders) {
        final folder = Directory(path.join(projectPath, folderPath));
        await folder.create(recursive: true); // ignore: avoid_slow_async_io
      }

      // Create files
      for (final projectFile in template.files) {
        final file = File(path.join(projectPath, projectFile.path));

        // Ensure the parent directory exists
        await file.parent
            .create(recursive: true); // ignore: avoid_slow_async_io

        // Write the file content
        await file
            .writeAsString(projectFile.content); // ignore: avoid_slow_async_io
      }

      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  /// Clear any errors
  void clearError() {
    state = state.copyWith();
  }
}

/// Provider for project creation state
final projectCreationStateProvider =
    StateNotifierProvider<ProjectCreationNotifier, ProjectCreationState>((ref) {
  return ProjectCreationNotifier();
});
