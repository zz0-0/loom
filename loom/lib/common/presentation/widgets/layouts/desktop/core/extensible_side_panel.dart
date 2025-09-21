import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/common/index.dart';
import 'package:loom/features/core/settings/index.dart';
import 'package:loom/flutter_gen/gen_l10n/app_localizations.dart';

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

    return AnimatedBuilder(
      animation: registry,
      builder: (context, child) {
        final selectedItem = registry.getSidebarItem(selectedItemId!);
        final panelContent = selectedItem?.buildPanel(context);

        // Compute localized title for the panel header
        final loc = AppLocalizations.of(context);
        String title;
        switch (selectedItemId) {
          case 'explorer':
            title = loc.explorerTooltip;
          case 'search':
            title = loc.searchTooltip;
          case 'settings':
            title = loc.settings;
          default:
            title = selectedItem?.tooltip ?? selectedItemId!;
        }

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
                title: title,
                onClose: onClose,
              ),

              // Panel content
              Expanded(
                child: panelContent ?? _buildEmptyPanel(context),
              ),
            ],
          ),
        );
      },
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
      padding: AppSpacing.paddingHorizontalSm,
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
      padding: AppSpacing.paddingSm,
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
