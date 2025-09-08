import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/features/core/settings/presentation/providers/close_button_settings_provider.dart';
import 'package:loom/shared/presentation/widgets/layouts/desktop/core/ui_registry.dart';

/// Extensible side panel that displays content for the selected sidebar item
class ExtensibleSidePanel extends ConsumerWidget {
  const ExtensibleSidePanel({
    required this.selectedItemId,
    required this.onClose,
    super.key,
  });

  final String? selectedItemId;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final registry = UIRegistry();

    if (selectedItemId == null) {
      return const SizedBox.shrink();
    }

    final selectedItem = registry.getSidebarItem(selectedItemId!);
    final panelContent = selectedItem?.buildPanel(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          right: BorderSide(
            color: theme.dividerColor,
          ),
        ),
      ),
      child: Column(
        children: [
          // Panel header
          _PanelHeader(
            title: selectedItem?.tooltip ?? selectedItemId!,
            onClose: onClose,
          ),

          // Panel content
          Expanded(
            child: panelContent ?? _buildEmptyPanel(context),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyPanel(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.extension,
            size: 48,
            color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No panel registered for this item',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Register a panel using UIRegistry.registerSidebarItem()',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _PanelHeader extends ConsumerWidget {
  const _PanelHeader({
    required this.title,
    required this.onClose,
  });

  final String title;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final closeButtonSettings = ref.watch(closeButtonSettingsProvider);

    return Container(
      height: 35,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.dividerColor,
          ),
        ),
      ),
      child: Row(
        children: _buildHeaderChildren(theme, closeButtonSettings),
      ),
    );
  }

  List<Widget> _buildHeaderChildren(
    ThemeData theme,
    CloseButtonSettings settings,
  ) {
    final titleWidget = Expanded(
      child: Text(
        title.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );

    final closeButton = IconButton(
      icon: const Icon(Icons.close, size: 16),
      onPressed: onClose,
      splashRadius: 16,
      padding: const EdgeInsets.all(4),
      constraints: const BoxConstraints(
        minWidth: 24,
        minHeight: 24,
      ),
    );

    if (settings.effectivePanelPosition == CloseButtonPosition.left) {
      return [closeButton, titleWidget];
    } else {
      return [titleWidget, closeButton];
    }
  }
}
