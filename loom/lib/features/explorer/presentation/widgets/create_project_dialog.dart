import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/features/explorer/presentation/providers/project_creation_provider.dart';
import 'package:loom/features/explorer/presentation/providers/workspace_provider.dart';
import 'package:loom/shared/presentation/theme/app_theme.dart';
import 'package:loom/shared/presentation/widgets/dialogs/folder_browser_dialog.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:path/path.dart' as path;

/// Dialog for creating new projects
class CreateProjectDialog extends ConsumerStatefulWidget {
  const CreateProjectDialog({super.key});

  @override
  ConsumerState<CreateProjectDialog> createState() =>
      _CreateProjectDialogState();
}

class _CreateProjectDialogState extends ConsumerState<CreateProjectDialog> {
  final _formKey = GlobalKey<FormState>();
  final _projectNameController = TextEditingController();
  final _locationController = TextEditingController();

  final String _selectedTemplate = 'empty';

  @override
  void initState() {
    super.initState();
    // Default location to a projects folder
    _locationController.text = Platform.environment['HOME'] ?? '/workspaces';
  }

  @override
  void dispose() {
    _projectNameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCreating = ref.watch(projectCreationStateProvider).isLoading;

    return Dialog(
      child: Container(
        width: 600,
        height: 480,
        padding: AppSpacing.paddingXl,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  LucideIcons.folderPlus,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  'Create New Project',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed:
                      isCreating ? null : () => Navigator.of(context).pop(),
                  icon: const Icon(LucideIcons.x),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Form
            Expanded(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Project Name
                    Text(
                      'Project Name',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _projectNameController,
                      decoration: InputDecoration(
                        hintText: 'my-awesome-project',
                        hintStyle: TextStyle(
                          color: theme.colorScheme.onSurface.withOpacity(0.4),
                        ),
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a project name';
                        }
                        if (!RegExp(r'^[a-zA-Z0-9_-]+$')
                            .hasMatch(value.trim())) {
                          return 'Project name can only contain letters, numbers, hyphens, and underscores';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    // Location
                    Text(
                      'Location',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _locationController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please select a location';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton.icon(
                          onPressed: isCreating ? null : _selectLocation,
                          icon: const Icon(LucideIcons.folderOpen, size: 16),
                          label: const Text('Browse'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Project Template (grid-like layout for single item)
                    Text(
                      'Project Template',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 80, // Fixed height to prevent overflow
                      child: GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 3,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: theme.colorScheme.primary,
                                width: 2,
                              ),
                              borderRadius: AppRadius.radiusLg,
                              color: theme.colorScheme.primary.withOpacity(0.1),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  LucideIcons.file,
                                  size: 20,
                                  color: theme.colorScheme.primary,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Empty Project',
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: theme.colorScheme.primary,
                                        ),
                                      ),
                                      Text(
                                        'Start with a blank slate',
                                        style:
                                            theme.textTheme.bodySmall?.copyWith(
                                          color: theme
                                              .colorScheme.onSurfaceVariant,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Actions
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed:
                      isCreating ? null : () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  onPressed: isCreating ? null : _createProject,
                  icon: isCreating
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(LucideIcons.folderPlus, size: 16),
                  label: Text(isCreating ? 'Creating...' : 'Create Project'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectLocation() async {
    try {
      String? result;

      // Try to use the system file picker first
      try {
        result = await FilePicker.platform.getDirectoryPath(
          dialogTitle: 'Select Project Location',
          initialDirectory: _locationController.text.isNotEmpty
              ? _locationController.text
              : Platform.environment['HOME'] ?? '/workspaces',
        );
      } catch (filePickerError) {
        result = null;
      }

      // Enhanced fallback: Show the shared directory browser
      if (result == null && mounted) {
        result = await showDialog<String>(
          context: context,
          builder: (context) => FolderBrowserDialog(
            initialPath: _locationController.text.isNotEmpty
                ? _locationController.text
                : '/workspaces',
          ),
        );
      }

      if (result != null && result.isNotEmpty) {
        _locationController.text = result;
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to select location: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _createProject() async {
    if (!_formKey.currentState!.validate()) return;

    final projectName = _projectNameController.text.trim();
    final location = _locationController.text.trim();
    final fullPath = path.join(location, projectName);

    try {
      await ref.read(projectCreationStateProvider.notifier).createProject(
            name: projectName,
            location: location,
            templateId: _selectedTemplate,
          );

      if (mounted) {
        // Open the newly created project
        await ref
            .read(currentWorkspaceProvider.notifier)
            .openWorkspace(fullPath);
        if (mounted) {
          Navigator.of(context).pop();

          // Show success message
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Project "$projectName" created successfully!'),
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create project: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }
}
