import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:path/path.dart' as path;

/// Reusable folder browser dialog used by multiple UI flows
class FolderBrowserDialog extends StatefulWidget {
  const FolderBrowserDialog({required this.initialPath, super.key});
  final String initialPath;

  @override
  State<FolderBrowserDialog> createState() => _FolderBrowserDialogState();
}

class _FolderBrowserDialogState extends State<FolderBrowserDialog> {
  late String currentPath;
  List<Directory> directories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    currentPath = widget.initialPath;
    _loadDirectories();
  }

  Future<void> _loadDirectories() async {
    setState(() => isLoading = true);
    try {
      final dir = Directory(currentPath);
      if (dir.existsSync()) {
        final entities = await dir.list().toList();
        directories = entities
            .whereType<Directory>()
            .where((d) => !path.basename(d.path).startsWith('.'))
            .toList();
        directories.sort(
          (a, b) => path
              .basename(a.path)
              .toLowerCase()
              .compareTo(path.basename(b.path).toLowerCase()),
        );
      }
    } catch (e) {
      directories = [];
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _navigateUp() {
    final parent = Directory(currentPath).parent;
    if (parent.path != currentPath) {
      currentPath = parent.path;
      _loadDirectories();
    }
  }

  void _navigateToDirectory(Directory dir) {
    currentPath = dir.path;
    _loadDirectories();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      child: Container(
        width: 600,
        height: 500,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  LucideIcons.folder,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  'Select Folder',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(LucideIcons.x),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      currentPath,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _navigateUp,
                    icon: const Icon(LucideIcons.arrowUp),
                    tooltip: 'Go up',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Quick Access',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _QuickAccessButton(
                  icon: LucideIcons.home,
                  label: 'Home',
                  path: Platform.environment['HOME'] ?? '/home',
                  onTap: (path) {
                    currentPath = path;
                    _loadDirectories();
                  },
                ),
                const SizedBox(width: 8),
                _QuickAccessButton(
                  icon: LucideIcons.code,
                  label: 'Workspaces',
                  path: '/workspaces',
                  onTap: (path) {
                    currentPath = path;
                    _loadDirectories();
                  },
                ),
                const SizedBox(width: 8),
                _QuickAccessButton(
                  icon: LucideIcons.folder,
                  label: 'Documents',
                  path: path.join(
                    Platform.environment['HOME'] ?? '/home',
                    'Documents',
                  ),
                  onTap: (path) {
                    currentPath = path;
                    _loadDirectories();
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Folders',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : directories.isEmpty
                      ? Center(
                          child: Text(
                            'No folders found',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: directories.length,
                          itemBuilder: (context, index) {
                            final dir = directories[index];
                            final name = path.basename(dir.path);
                            return ListTile(
                              leading: const Icon(LucideIcons.folder),
                              title: Text(name),
                              onTap: () => _navigateToDirectory(dir),
                              dense: true,
                            );
                          },
                        ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: () async {
                    final controller = TextEditingController(text: currentPath);
                    final customPath = await showDialog<String>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Enter Path'),
                        content: TextField(
                          controller: controller,
                          decoration: const InputDecoration(
                            labelText: 'Directory Path',
                            hintText: '/home/user/projects',
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () =>
                                Navigator.of(context).pop(controller.text),
                            child: const Text('Go'),
                          ),
                        ],
                      ),
                    );
                    if (customPath != null && customPath.isNotEmpty) {
                      currentPath = customPath;
                      await _loadDirectories();
                    }
                  },
                  icon: const Icon(LucideIcons.edit),
                  label: const Text('Enter Path'),
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed: () => Navigator.of(context).pop(currentPath),
                      child: const Text('Select'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickAccessButton extends StatelessWidget {
  const _QuickAccessButton({
    required this.icon,
    required this.label,
    required this.path,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final String path;
  final void Function(String) onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () => onTap(path),
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }
}
