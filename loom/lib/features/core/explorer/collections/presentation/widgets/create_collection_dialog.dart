import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/features/core/explorer/index.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Template selection chip widget
class _TemplateChip extends StatelessWidget {
  const _TemplateChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onSelected,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14),
          const SizedBox(width: 4),
          Text(label),
        ],
      ),
      selected: isSelected,
      onSelected: (_) => onSelected(),
      backgroundColor: theme.colorScheme.surface,
      selectedColor: theme.colorScheme.primaryContainer,
      checkmarkColor: theme.colorScheme.primary,
    );
  }
}

/// Dialog for creating a new collection with template selection
class CreateCollectionDialog extends StatefulWidget {
  const CreateCollectionDialog({super.key});

  @override
  State<CreateCollectionDialog> createState() => _CreateCollectionDialogState();
}

class _CreateCollectionDialogState extends State<CreateCollectionDialog> {
  final TextEditingController _controller = TextEditingController();
  String? _selectedTemplateId;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: const Text('Create Collection'),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Collection name',
                hintText: 'My Collection',
                hintStyle: TextStyle(
                  color: theme.colorScheme.onSurface.withOpacity(0.4),
                ),
              ),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            const Text(
              'Choose a template (optional)',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Consumer(
              builder: (context, ref, child) {
                final templates = ref.watch(collectionTemplatesProvider);
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    // Empty template option
                    _TemplateChip(
                      label: 'Empty',
                      icon: LucideIcons.file,
                      isSelected: _selectedTemplateId == null,
                      onSelected: () {
                        setState(() => _selectedTemplateId = null);
                      },
                    ),
                    // Template options
                    ...templates.map(
                      (template) => _TemplateChip(
                        label: template.name,
                        icon: getIconDataFromString(template.icon),
                        isSelected: _selectedTemplateId == template.id,
                        onSelected: () {
                          setState(() => _selectedTemplateId = template.id);
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (_controller.text.isNotEmpty) {
              Navigator.of(context).pop({
                'name': _controller.text,
                'templateId': _selectedTemplateId,
              });
            }
          },
          child: const Text('Create'),
        ),
      ],
    );
  }
}
