import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/common/data/providers.dart';
import 'package:loom/common/domain/repositories/file_repository.dart';
import 'package:loom/features/core/explorer/data/models/project_template.dart';
import 'package:loom/features/core/explorer/domain/entities/workspace_entities.dart';
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
  ProjectCreationNotifier(this._fileRepository)
      : super(const ProjectCreationState());

  final FileRepository _fileRepository;

  /// Create a new project from a template
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

      // Check if directory already exists
      if (await _fileRepository.directoryExists(projectPath)) {
        throw Exception('A folder with this name already exists');
      }

      await _fileRepository.createDirectory(projectPath);

      // Create folders
      for (final folderPath in template.folders) {
        final fullPath = path.join(projectPath, folderPath);
        await _fileRepository.createDirectory(fullPath);
      }

      // Create files
      for (final projectFile in template.files) {
        final filePath = path.join(projectPath, projectFile.path);
        await _fileRepository.writeFile(filePath, projectFile.content);
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
  final fileRepository = ref.watch(fileRepositoryProvider);
  return ProjectCreationNotifier(fileRepository);
});
