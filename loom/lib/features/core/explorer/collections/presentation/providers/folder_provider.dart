import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/common/index.dart';
import 'package:loom/common/presentation/widgets/dialogs/folder_browser_dialog.dart';
import 'package:loom/features/core/explorer/collections/domain/entities/folder.dart';
import 'package:loom/features/core/explorer/collections/domain/repositories/folder_repository.dart';
import 'package:loom/features/core/explorer/collections/domain/usecases/folder_use_cases.dart';
import 'package:loom/features/core/explorer/collections/presentation/providers/workspace_provider.dart';

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
    String? selectedDirectory;

    try {
      selectedDirectory = await FilePicker.platform.getDirectoryPath();
    } catch (filePickerError) {
      // FilePicker failed (common in containerized environments)
      selectedDirectory = null;
    }

    if (selectedDirectory != null && selectedDirectory.isNotEmpty) {
      try {
        // Use workspace provider to open the folder so the explorer updates
        final container = ProviderScope.containerOf(context, listen: false);
        await container
            .read(currentWorkspaceProvider.notifier)
            .openWorkspace(selectedDirectory);
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
    } else {
      // Fallback: Show the shared directory browser like the old implementation
      final path = await showDialog<String>(
        context: context,
        builder: (context) => FolderBrowserDialog(
          initialPath: '/workspaces',
        ),
      );
      if (path != null && path.isNotEmpty) {
        try {
          // Use workspace provider to open the folder so the explorer updates
          final container = ProviderScope.containerOf(context, listen: false);
          await container
              .read(currentWorkspaceProvider.notifier)
              .openWorkspace(path);
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
  }

  Future<void> createFolder(BuildContext context) async {
    // Get the current workspace to create folders in
    final container = ProviderScope.containerOf(context, listen: false);
    final workspace = container.read(currentWorkspaceProvider);

    if (workspace == null) {
      // No workspace is open, show error
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please open a workspace first to create folders'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    final path = await showDialog<String>(
      context: context,
      builder: (context) => const CreateFolderDialog(),
    );

    if (path != null && path.isNotEmpty) {
      try {
        // Use workspace's createDirectory method
        await container
            .read(currentWorkspaceProvider.notifier)
            .createDirectory(path);
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to create folder: $e'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
    }
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
          await createFileUseCase.call(state!.rootPath, name, content: content);
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

class CreateFolderDialog extends StatefulWidget {
  const CreateFolderDialog({super.key});

  @override
  State<CreateFolderDialog> createState() => _CreateFolderDialogState();
}

class _CreateFolderDialogState extends State<CreateFolderDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final bool _isCreating = false;

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
        height: 250,
        padding: const EdgeInsets.all(24),
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
                    Text(
                      'Folder Name',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _nameController,
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

  void _createFolder() {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();
    if (name.isNotEmpty) {
      Navigator.of(context).pop(name);
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
        padding: const EdgeInsets.all(24),
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
                          contentPadding: const EdgeInsets.all(12),
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
        padding: const EdgeInsets.all(24),
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
  // You may need to provide a real fileRepository here
  return FolderRepositoryImpl(null);
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
