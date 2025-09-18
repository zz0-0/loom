import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/common/index.dart';
import 'package:loom/features/core/explorer/collections/domain/entities/folder.dart';
import 'package:loom/features/core/explorer/collections/domain/repositories/folder_repository.dart';
import 'package:loom/features/core/explorer/collections/domain/usecases/folder_use_cases.dart';
import 'package:path/path.dart' as path;

class FolderNotifier extends StateNotifier<Folder?> {
  FolderNotifier(
    this.repository,
    this.refreshFolderTreeUseCase,
    this.createFileUseCase,
    this.createDirectoryUseCase,
    this.deleteItemUseCase,
    this.renameItemUseCase,
  ) : super(null);
  final FolderRepository repository;
  final RefreshFolderTreeUseCase refreshFolderTreeUseCase;
  final FolderCreateFileUseCase createFileUseCase;
  final FolderCreateDirectoryUseCase createDirectoryUseCase;
  final FolderDeleteItemUseCase deleteItemUseCase;
  final FolderRenameItemUseCase renameItemUseCase;

  Future<void> openFolder(BuildContext context) async {
    final path = await showDialog<String>(
      context: context,
      builder: (context) => const FolderBrowserDialog(
        initialPath: '/workspaces',
      ),
    );
    if (path != null && path.isNotEmpty && context.mounted) {
      try {
        final folder = await repository.openFolder(path);
        state = folder;
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to open folder: $e'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
    }
  }

  Future<void> createFolder(BuildContext context) async {
    // Show the enhanced create folder dialog
    await showDialog<void>(
      context: context,
      builder: (context) => const CreateFolderDialog(),
    );
  }

  Future<void> createFile(BuildContext context) async {
    if (state == null) return;
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => const EnhancedCreateFileDialog(),
    );
    if (result != null) {
      final name = result['name'];
      final content = result['content'] ?? '';
      if (name != null && name.isNotEmpty) {
        try {
          final filePath = path.join(state!.rootPath, name);
          await createFileUseCase.call(
            state!.rootPath,
            filePath,
            content: content,
          );
          await refreshFolderTree();
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to create file: $e'),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        }
      }
    }
  }

  Future<void> deleteItem(BuildContext context, String itemPath) async {
    if (state == null) return;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item'),
        content: Text('Are you sure you want to delete "$itemPath"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirm ?? false) {
      try {
        await deleteItemUseCase.call(state!.rootPath, itemPath);
        await refreshFolderTree();
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to delete item: $e'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
    }
  }

  Future<void> renameItem(BuildContext context, String oldPath) async {
    if (state == null) return;
    final newName = await showDialog<String>(
      context: context,
      builder: (context) => EnhancedRenameDialog(initialName: oldPath),
    );
    if (newName != null && newName.isNotEmpty && newName != oldPath) {
      try {
        await renameItemUseCase.call(state!.rootPath, oldPath, newName);
        await refreshFolderTree();
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to rename item: $e'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
    }
  }

  Future<void> refreshFolderTree() async {
    if (state == null) return;
    try {
      final fileTree = await refreshFolderTreeUseCase.call(state!);
      state = state!.copyWith(fileTree: fileTree);
    } catch (e) {
      // Optionally show error
    }
  }

  void closeFolder() {
    state = null;
  }
}

/// Fallback dialog for manual folder path entry (copied from workspace_toolbar.dart)
class _FallbackFolderDialog extends StatefulWidget {
  @override
  State<_FallbackFolderDialog> createState() => _FallbackFolderDialogState();
}

class _FallbackFolderDialogState extends State<_FallbackFolderDialog> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = '/workspaces';
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: const Text('Open Folder'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Enter the path to the folder you want to open:'),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: 'Folder Path',
              hintText: 'Enter folder path (e.g., /workspaces/my-folder)',
              hintStyle: TextStyle(
                color: theme.colorScheme.onSurface.withOpacity(0.4),
              ),
            ),
            autofocus: true,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final path = _controller.text.trim();
            if (path.isNotEmpty) {
              Navigator.of(context).pop(path);
            }
          },
          child: const Text('Open'),
        ),
      ],
    );
  }
}

class CreateFolderDialog extends ConsumerStatefulWidget {
  const CreateFolderDialog({super.key});

  @override
  ConsumerState<CreateFolderDialog> createState() => _CreateFolderDialogState();
}

class _CreateFolderDialogState extends ConsumerState<CreateFolderDialog> {
  final _formKey = GlobalKey<FormState>();
  final _folderNameController = TextEditingController();
  final _locationController = TextEditingController();

  bool _isCreating = false;

  @override
  void initState() {
    super.initState();
    // Default location to a projects folder
    _locationController.text = Platform.environment['HOME'] ?? '/workspaces';
  }

  @override
  void dispose() {
    _folderNameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      child: Container(
        width: 600,
        height: 480,
        padding: AppSpacing.paddingMd,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.create_new_folder,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  'Create New Folder',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed:
                      _isCreating ? null : () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
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
                    // Folder Name
                    Text(
                      'Folder Name',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _folderNameController,
                      decoration: InputDecoration(
                        hintText: 'Enter folder name',
                        hintStyle: TextStyle(
                          color: theme.colorScheme.onSurface.withOpacity(0.4),
                        ),
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a folder name';
                        }
                        if (!RegExp(r'^[a-zA-Z0-9_-]+$')
                            .hasMatch(value.trim())) {
                          return 'Folder name can only contain letters, numbers, hyphens, and underscores';
                        }
                        return null;
                      },
                      enabled: !_isCreating,
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
                            enabled: !_isCreating,
                          ),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton.icon(
                          onPressed: _isCreating ? null : _selectLocation,
                          icon: const Icon(Icons.folder_open, size: 16),
                          label: const Text('Browse'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Folder Template (grid-like layout for single item)
                    Text(
                      'Folder Template',
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
                            padding: AppSpacing.paddingMd,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: theme.colorScheme.primary,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              color: theme.colorScheme.primary.withOpacity(0.1),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.folder,
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
                                        'Empty Folder',
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
                      _isCreating ? null : () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  onPressed: _isCreating ? null : _createFolder,
                  icon: _isCreating
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.create_new_folder, size: 16),
                  label: Text(_isCreating ? 'Creating...' : 'Create Folder'),
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
          dialogTitle: 'Select Folder Location',
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

  Future<void> _createFolder() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isCreating = true);

    final folderName = _folderNameController.text.trim();
    final location = _locationController.text.trim();
    final fullPath = path.join(location, folderName);

    try {
      // Use folder repository to create the folder
      await ref
          .read(currentFolderProvider.notifier)
          .repository
          .createFolder(fullPath);

      if (mounted) {
        Navigator.of(context).pop();

        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Folder "$folderName" created successfully!'),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create folder: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isCreating = false);
      }
    }
  }
}

/// Enhanced Create File Dialog
class EnhancedCreateFileDialog extends StatefulWidget {
  const EnhancedCreateFileDialog({super.key});

  @override
  State<EnhancedCreateFileDialog> createState() =>
      _EnhancedCreateFileDialogState();
}

class _EnhancedCreateFileDialogState extends State<EnhancedCreateFileDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      child: Container(
        width: 500,
        height: 400,
        padding: AppSpacing.paddingMd,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.note_add,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  'Create New File',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
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
                    Text(
                      'File Name',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: 'Enter file name (e.g., main.dart)',
                        hintStyle: TextStyle(
                          color: theme.colorScheme.onSurface.withOpacity(0.4),
                        ),
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a file name';
                        }
                        return null;
                      },
                      autofocus: true,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Initial Content (Optional)',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: TextFormField(
                        controller: _contentController,
                        maxLines: null,
                        expands: true,
                        textAlignVertical: TextAlignVertical.top,
                        decoration: InputDecoration(
                          hintText: 'Enter initial file content...',
                          hintStyle: TextStyle(
                            color: theme.colorScheme.onSurface.withOpacity(0.4),
                          ),
                          border: const OutlineInputBorder(),
                          contentPadding: AppSpacing.paddingMd,
                        ),
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
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  onPressed: _createFile,
                  icon: const Icon(Icons.note_add, size: 16),
                  label: const Text('Create File'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _createFile() {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();
    final content = _contentController.text.trim();

    if (name.isNotEmpty) {
      Navigator.of(context).pop({
        'name': name,
        'content': content,
      });
    }
  }
}

/// Enhanced Rename Dialog
class EnhancedRenameDialog extends StatefulWidget {
  const EnhancedRenameDialog({required this.initialName, super.key});

  final String initialName;

  @override
  State<EnhancedRenameDialog> createState() => _EnhancedRenameDialogState();
}

class _EnhancedRenameDialogState extends State<EnhancedRenameDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      child: Container(
        width: 400,
        height: 200,
        padding: AppSpacing.paddingMd,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.edit,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  'Rename Item',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
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
                    Text(
                      'New Name',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: 'Enter new name',
                        hintStyle: TextStyle(
                          color: theme.colorScheme.onSurface.withOpacity(0.4),
                        ),
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a name';
                        }
                        if (value.trim() == widget.initialName) {
                          return 'New name must be different';
                        }
                        return null;
                      },
                      autofocus: true,
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
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  onPressed: _renameItem,
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text('Rename'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _renameItem() {
    if (!_formKey.currentState!.validate()) return;

    final newName = _nameController.text.trim();
    if (newName.isNotEmpty && newName != widget.initialName) {
      Navigator.of(context).pop(newName);
    }
  }
}

final folderRepositoryProvider = Provider<FolderRepository>((ref) {
  final fileRepository = ref.watch(fileRepositoryProvider);
  return FolderRepositoryImpl(fileRepository);
});

final folderCreateDirectoryUseCaseProvider =
    Provider<FolderCreateDirectoryUseCase>((ref) {
  final repository = ref.watch(folderRepositoryProvider);
  return FolderCreateDirectoryUseCase(repository);
});

final folderCreateFileUseCaseProvider =
    Provider<FolderCreateFileUseCase>((ref) {
  final repository = ref.watch(folderRepositoryProvider);
  return FolderCreateFileUseCase(repository);
});

final folderDeleteItemUseCaseProvider =
    Provider<FolderDeleteItemUseCase>((ref) {
  final repository = ref.watch(folderRepositoryProvider);
  return FolderDeleteItemUseCase(repository);
});

final folderRenameItemUseCaseProvider =
    Provider<FolderRenameItemUseCase>((ref) {
  final repository = ref.watch(folderRepositoryProvider);
  return FolderRenameItemUseCase(repository);
});

final refreshFolderTreeUseCaseProvider =
    Provider<RefreshFolderTreeUseCase>((ref) {
  final repository = ref.watch(folderRepositoryProvider);
  return RefreshFolderTreeUseCase(repository);
});

final currentFolderProvider =
    StateNotifierProvider<FolderNotifier, Folder?>((ref) {
  final repository = ref.watch(folderRepositoryProvider);
  final refreshFolderTreeUseCase = ref.watch(refreshFolderTreeUseCaseProvider);
  final createFileUseCase = ref.watch(folderCreateFileUseCaseProvider);
  final createDirectoryUseCase =
      ref.watch(folderCreateDirectoryUseCaseProvider);
  final deleteItemUseCase = ref.watch(folderDeleteItemUseCaseProvider);
  final renameItemUseCase = ref.watch(folderRenameItemUseCaseProvider);
  return FolderNotifier(
    repository,
    refreshFolderTreeUseCase,
    createFileUseCase,
    createDirectoryUseCase,
    deleteItemUseCase,
    renameItemUseCase,
  );
});
