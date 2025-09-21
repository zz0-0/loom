import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/common/index.dart';
import 'package:loom/flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:path/path.dart' as path;

/// Reusable folder browser dialog used by multiple UI flows
class FolderBrowserDialog extends ConsumerStatefulWidget {
  const FolderBrowserDialog({required this.initialPath, super.key});
  final String initialPath;

  @override
  ConsumerState<FolderBrowserDialog> createState() =>
      _FolderBrowserDialogState();
}

class _FolderBrowserDialogState extends ConsumerState<FolderBrowserDialog> {
  @override
  void initState() {
    super.initState();
    // Initialize the provider with the initial path
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(folderBrowserProvider.notifier).initialize(widget.initialPath);
    });
  }

  void _navigateUp() {
    ref.read(folderBrowserProvider.notifier).navigateUp();
  }

  void _navigateToDirectory(String dirPath) {
    ref.read(folderBrowserProvider.notifier).navigateTo(dirPath);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(folderBrowserProvider);
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context);

    return Dialog(
      child: Container(
        width: 600,
        height: 500,
        padding: AppSpacing.paddingLg,
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
                  localizations.selectFolder,
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
              padding: AppSpacing.paddingMd,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      state.currentPath,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _navigateUp,
                    icon: const Icon(LucideIcons.arrowUp),
                    tooltip: localizations.goUp,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              localizations.quickAccess,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _QuickAccessButton(
                  icon: LucideIcons.home,
                  label: localizations.home,
                  path: '/home',
                  onTap: _navigateToDirectory,
                ),
                const SizedBox(width: 8),
                _QuickAccessButton(
                  icon: LucideIcons.code,
                  label: localizations.workspaces,
                  path: '/workspaces',
                  onTap: _navigateToDirectory,
                ),
                const SizedBox(width: 8),
                _QuickAccessButton(
                  icon: LucideIcons.folder,
                  label: localizations.documents,
                  path: path.join('/home', 'Documents'),
                  onTap: _navigateToDirectory,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              localizations.folders,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: state.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : state.directories.isEmpty
                      ? Center(
                          child: Text(
                            localizations.noFoldersFound,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: state.directories.length,
                          itemBuilder: (context, index) {
                            final dirPath = state.directories[index];
                            final name = path.basename(dirPath);
                            return ListTile(
                              leading: const Icon(LucideIcons.folder),
                              title: Text(name),
                              onTap: () => _navigateToDirectory(dirPath),
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
                    final controller =
                        TextEditingController(text: state.currentPath);
                    final customPath = await showDialog<String>(
                      context: context,
                      builder: (context) {
                        final localizations = AppLocalizations.of(context);
                        return AlertDialog(
                          title: Text(localizations.enterPath),
                          content: TextField(
                            controller: controller,
                            decoration: InputDecoration(
                              labelText: localizations.directoryPath,
                              hintText: localizations.pathHint,
                              hintStyle: TextStyle(
                                color: theme.colorScheme.onSurface
                                    .withOpacity(0.4),
                              ),
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text(localizations.cancel),
                            ),
                            TextButton(
                              onPressed: () =>
                                  Navigator.of(context).pop(controller.text),
                              child: Text(localizations.go),
                            ),
                          ],
                        );
                      },
                    );
                    if (customPath != null && customPath.isNotEmpty) {
                      _navigateToDirectory(customPath);
                    }
                  },
                  icon: const Icon(LucideIcons.edit),
                  label: Text(
                    AppLocalizations.of(context).enterPath,
                  ),
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        AppLocalizations.of(context).cancel,
                      ),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed: () =>
                          Navigator.of(context).pop(state.currentPath),
                      child: Text(
                        AppLocalizations.of(context).select,
                      ),
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
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.smd,
          vertical: AppSpacing.sm,
        ),
      ),
    );
  }
}
