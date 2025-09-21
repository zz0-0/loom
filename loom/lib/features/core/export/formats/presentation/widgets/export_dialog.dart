import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/common/index.dart';
import 'package:loom/features/core/export/index.dart';
import 'package:loom/flutter_gen/gen_l10n/app_localizations.dart';

/// Export dialog for configuring and executing exports
class ExportDialog extends ConsumerStatefulWidget {
  const ExportDialog({
    required this.content,
    required this.fileName,
    super.key,
  });

  final String content;
  final String fileName;

  @override
  ConsumerState<ExportDialog> createState() => _ExportDialogState();
}

class _ExportDialogState extends ConsumerState<ExportDialog> {
  late ExportOptions _options;
  String? _selectedFilePath;

  @override
  void initState() {
    super.initState();
    _options = const ExportOptions();
  }

  @override
  Widget build(BuildContext context) {
    final exportState = ref.watch(exportProvider);
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context);

    return Dialog(
      child: Container(
        width: 500,
        constraints: const BoxConstraints(maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: AppSpacing.paddingMd,
              child: Row(
                children: [
                  Icon(Icons.file_download, color: theme.colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    localizations.exportDocument,
                    style: theme.textTheme.headlineSmall,
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            const Divider(),

            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: AppSpacing.paddingMd,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // File info
                    Text(
                      localizations.fileLabel(widget.fileName),
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Format selection
                    _buildFormatSection(theme),

                    const SizedBox(height: 16),

                    // Options
                    _buildOptionsSection(theme),

                    const SizedBox(height: 16),

                    // File path
                    _buildFilePathSection(theme),

                    // Error message
                    if (exportState.errorMessage != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: AppSpacing.paddingSm,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.errorContainer,
                          borderRadius: AppRadius.radiusMd,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: theme.colorScheme.error,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                exportState.errorMessage!,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.error,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    // Success message
                    if (exportState.lastResult?.success ?? false) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: AppSpacing.paddingSm,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: AppRadius.radiusMd,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: theme.colorScheme.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Exported successfully to:\n${exportState.lastResult!.filePath}',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const Divider(),

            // Actions
            Padding(
              padding: AppSpacing.paddingMd,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(localizations.cancel),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: exportState.isExporting ? null : _export,
                    icon: exportState.isExporting
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.file_download),
                    label: Text(
                      exportState.isExporting
                          ? localizations.exporting
                          : localizations.export,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormatSection(ThemeData theme) {
    final formats = ref.read(exportProvider.notifier).getSupportedFormats();
    final localizations = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.exportFormat,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: formats.map((format) {
            return ChoiceChip(
              label: Text(format.displayName(localizations)),
              selected: _options.format == format,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _options = _options.copyWith(format: format);
                  });
                }
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildOptionsSection(ThemeData theme) {
    final localizations = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.options,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        SwitchListTile(
          title: Text(localizations.includeLineNumbers),
          value: _options.includeLineNumbers,
          onChanged: (value) {
            setState(() {
              _options = _options.copyWith(includeLineNumbers: value);
            });
          },
        ),
        SwitchListTile(
          title: Text(localizations.includeSyntaxHighlighting),
          value: _options.includeSyntaxHighlighting,
          onChanged: (value) {
            setState(() {
              _options = _options.copyWith(includeSyntaxHighlighting: value);
            });
          },
        ),
        if (_options.format == ExportFormat.html ||
            _options.format == ExportFormat.pdf) ...[
          SwitchListTile(
            title: Text(localizations.includeHeader),
            value: _options.includeHeader,
            onChanged: (value) {
              setState(() {
                _options = _options.copyWith(includeHeader: value);
              });
            },
          ),
          if (_options.includeHeader) ...[
            Padding(
              padding: const EdgeInsets.only(
                left: AppSpacing.md,
                right: AppSpacing.md,
                bottom: AppSpacing.sm,
              ),
              child: TextField(
                decoration: InputDecoration(
                  labelText: localizations.headerText,
                  hintText: localizations.documentTitle,
                  hintStyle: TextStyle(
                    color: theme.colorScheme.onSurface.withOpacity(0.4),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _options = _options.copyWith(headerText: value);
                  });
                },
              ),
            ),
          ],
        ],
      ],
    );
  }

  Widget _buildFilePathSection(ThemeData theme) {
    final localizations = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.saveLocation,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Text(
                _selectedFilePath ?? _getDefaultFilePath(),
                style: theme.textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: _selectFilePath,
              icon: const Icon(Icons.folder_open),
              label: Text(localizations.choose),
            ),
          ],
        ),
      ],
    );
  }

  String _getDefaultFilePath() {
    final baseName = widget.fileName.split('.').first;
    final extension =
        ref.read(exportProvider.notifier).getFileExtension(_options.format);
    return '$baseName$extension';
  }

  Future<void> _selectFilePath() async {
    final localizations = AppLocalizations.of(context);
    final extension =
        ref.read(exportProvider.notifier).getFileExtension(_options.format);
    final fileName = '${widget.fileName.split('.').first}$extension';

    final result = await FilePicker.platform.saveFile(
      dialogTitle: localizations.saveExport,
      fileName: fileName,
      type: FileType.custom,
      allowedExtensions: [extension.substring(1)], // Remove the dot
    );

    if (result != null) {
      setState(() {
        _selectedFilePath = result;
      });
    }
  }

  void _export() {
    final request = ExportRequest(
      content: widget.content,
      fileName: widget.fileName,
      options: _options,
      filePath: _selectedFilePath,
    );

    ref.read(exportProvider.notifier).exportContent(request);
  }
}
