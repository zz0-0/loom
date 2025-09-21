import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/common/index.dart';
import 'package:loom/features/core/settings/index.dart';
import 'package:loom/flutter_gen/gen_l10n/app_localizations.dart';

/// Extensible sidebar that displays registered sidebar items
class ExtensibleSidebar extends ConsumerWidget {
  const ExtensibleSidebar({super.key});

  String? _getLocalizedTooltip(BuildContext context, SidebarItem item) {
    final localizations = AppLocalizations.of(context);

    // If the item provides its own tooltip, use it
    if (item.tooltip != null) {
      return item.tooltip;
    }

    // Otherwise, provide localized tooltips for known items
    switch (item.id) {
      case 'settings':
        return localizations.settingsTooltip;
      case 'explorer':
        return localizations.explorerTooltip;
      case 'search':
        return localizations.searchTooltip;
      default:
        return null;
    }
  }

  IconData _getLanguageIcon(String languageCode) {
    switch (languageCode) {
      case 'en':
        return Icons.language;
      case 'es':
        return Icons.translate;
      case 'fr':
        return Icons.flag;
      case 'de':
        return Icons.outlined_flag;
      case 'zh':
        return Icons.g_translate;
      case 'ja':
        return Icons.translate;
      case 'ko':
        return Icons.language;
      default:
        return Icons.language;
    }
  }

  void _showLanguageSelectionDialog(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context);
    final currentLanguage = ref.read(generalSettingsProvider).language;

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.language),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _LanguageOption(
              languageCode: 'en',
              languageName: localizations.english,
              isSelected: currentLanguage == 'en',
              onTap: () {
                ref.read(generalSettingsProvider.notifier).setLanguage('en');
                Navigator.of(context).pop();
              },
            ),
            _LanguageOption(
              languageCode: 'es',
              languageName: localizations.spanish,
              isSelected: currentLanguage == 'es',
              onTap: () {
                ref.read(generalSettingsProvider.notifier).setLanguage('es');
                Navigator.of(context).pop();
              },
            ),
            _LanguageOption(
              languageCode: 'fr',
              languageName: localizations.french,
              isSelected: currentLanguage == 'fr',
              onTap: () {
                ref.read(generalSettingsProvider.notifier).setLanguage('fr');
                Navigator.of(context).pop();
              },
            ),
            _LanguageOption(
              languageCode: 'de',
              languageName: localizations.german,
              isSelected: currentLanguage == 'de',
              onTap: () {
                ref.read(generalSettingsProvider.notifier).setLanguage('de');
                Navigator.of(context).pop();
              },
            ),
            _LanguageOption(
              languageCode: 'zh',
              languageName: localizations.chinese,
              isSelected: currentLanguage == 'zh',
              onTap: () {
                ref.read(generalSettingsProvider.notifier).setLanguage('zh');
                Navigator.of(context).pop();
              },
            ),
            _LanguageOption(
              languageCode: 'ja',
              languageName: localizations.japanese,
              isSelected: currentLanguage == 'ja',
              onTap: () {
                ref.read(generalSettingsProvider.notifier).setLanguage('ja');
                Navigator.of(context).pop();
              },
            ),
            _LanguageOption(
              languageCode: 'ko',
              languageName: localizations.korean,
              isSelected: currentLanguage == 'ko',
              onTap: () {
                ref.read(generalSettingsProvider.notifier).setLanguage('ko');
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(localizations.cancel),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final uiState = ref.watch(uiStateProvider);
    final appearanceSettings = ref.watch(appearanceSettingsProvider);
    final compactMode = appearanceSettings.compactMode;
    final sidebarTransparency = appearanceSettings.sidebarTransparency;
    final registry = UIRegistry();

    return AnimatedBuilder(
      animation: registry,
      builder: (context, child) => Container(
        decoration: BoxDecoration(
          color: sidebarTransparency
              ? theme.colorScheme.surfaceContainerHighest.withOpacity(0.1)
              : theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
          border: Border(
            right: BorderSide(
              color: theme.dividerColor,
            ),
          ),
        ),
        child: Column(
          children: [
            // Separate settings from other items
            ...registry.sidebarItems.where((item) => item.id != 'settings').map(
                  (item) => _SidebarButton(
                    icon: item.icon,
                    tooltip: _getLocalizedTooltip(context, item),
                    isSelected: uiState.selectedSidebarItem == item.id,
                    compactMode: compactMode,
                    onPressed: () {
                      if (item.onPressed != null) {
                        item.onPressed!();
                      } else {
                        ref
                            .read(uiStateProvider.notifier)
                            .selectSidebarItem(item.id);
                      }
                    },
                  ),
                ),

            // Spacer to push settings and utility buttons to bottom
            const Spacer(),

            // Language and theme switch buttons above settings
            _UtilityButton(
              icon:
                  _getLanguageIcon(ref.read(generalSettingsProvider).language),
              tooltip: AppLocalizations.of(context).language,
              compactMode: compactMode,
              onPressed: () => _showLanguageSelectionDialog(context, ref),
            ),
            _UtilityButton(
              icon: Icons.brightness_6,
              tooltip: AppLocalizations.of(context).switchTheme,
              compactMode: compactMode,
              onPressed: () {
                // TODO(user): Implement theme switching
                debugPrint('Theme switch not yet implemented');
              },
            ),

            // Settings at the bottom
            ...registry.sidebarItems.where((item) => item.id == 'settings').map(
                  (item) => _SidebarButton(
                    icon: item.icon,
                    tooltip: _getLocalizedTooltip(context, item),
                    isSelected: uiState.selectedSidebarItem == item.id,
                    compactMode: compactMode,
                    onPressed: () {
                      if (item.onPressed != null) {
                        item.onPressed!();
                      } else {
                        ref
                            .read(uiStateProvider.notifier)
                            .selectSidebarItem(item.id);
                      }
                    },
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

class _SidebarButton extends StatefulWidget {
  const _SidebarButton({
    required this.icon,
    this.tooltip,
    this.isSelected = false,
    this.compactMode = false,
    this.onPressed,
  });

  final IconData icon;
  final String? tooltip;
  final bool isSelected;
  final bool compactMode;
  final VoidCallback? onPressed;

  @override
  State<_SidebarButton> createState() => _SidebarButtonState();
}

class _SidebarButtonState extends State<_SidebarButton> {
  bool _isHovered = false;

  /// Get filled version of common icons
  IconData _getFilledIcon(IconData originalIcon) {
    // Map hollow icons to their filled variants
    final iconMap = {
      Icons.settings: Icons.settings,
      Icons.home: Icons.home,
      Icons.folder: Icons.folder,
      Icons.search: Icons.search,
      Icons.star: Icons.star,
      Icons.favorite: Icons.favorite,
      Icons.bookmark: Icons.bookmark,
      Icons.notifications: Icons.notifications,
      Icons.mail: Icons.mail,
      Icons.person: Icons.person,
      Icons.dashboard: Icons.dashboard,
      Icons.file_copy: Icons.file_copy,
      Icons.edit: Icons.edit,
      Icons.delete: Icons.delete,
      Icons.add: Icons.add,
      Icons.remove: Icons.remove,
      Icons.close: Icons.close,
      Icons.check: Icons.check,
      Icons.arrow_back: Icons.arrow_back,
      Icons.arrow_forward: Icons.arrow_forward,
      Icons.expand_more: Icons.expand_more,
      Icons.expand_less: Icons.expand_less,
      Icons.menu: Icons.menu,
      Icons.more_vert: Icons.more_vert,
      Icons.more_horiz: Icons.more_horiz,
      Icons.account_tree: Icons.account_tree,
      Icons.waving_hand: Icons.waving_hand,
      Icons.extension: Icons.extension,
    };

    // Get filled version if available, otherwise return original
    return iconMap[originalIcon] ?? originalIcon;
  }

  /// Get outlined version of common icons
  IconData _getOutlinedIcon(IconData originalIcon) {
    // Map filled icons to their outlined variants
    final iconMap = {
      Icons.settings: Icons.settings_outlined,
      Icons.home: Icons.home_outlined,
      Icons.folder: Icons.folder_outlined,
      Icons.search: Icons.search_outlined,
      Icons.star: Icons.star_outline,
      Icons.favorite: Icons.favorite_border,
      Icons.bookmark: Icons.bookmark_border,
      Icons.notifications: Icons.notifications_outlined,
      Icons.mail: Icons.mail_outlined,
      Icons.person: Icons.person_outline,
      Icons.dashboard: Icons.dashboard_outlined,
      Icons.file_copy: Icons.file_copy_outlined,
      Icons.edit: Icons.edit_outlined,
      Icons.delete: Icons.delete_outlined,
      Icons.add: Icons.add_outlined,
      Icons.remove: Icons.remove_outlined,
      Icons.close: Icons.close_outlined,
      Icons.check: Icons.check_outlined,
      Icons.arrow_back: Icons.arrow_back_outlined,
      Icons.arrow_forward: Icons.arrow_forward_outlined,
      Icons.expand_more: Icons.expand_more_outlined,
      Icons.expand_less: Icons.expand_less_outlined,
      Icons.menu: Icons.menu_outlined,
      Icons.more_vert: Icons.more_vert_outlined,
      Icons.more_horiz: Icons.more_horiz_outlined,
      Icons.account_tree: Icons.account_tree_outlined,
      Icons.extension: Icons.extension_outlined,
      // Note: waving_hand doesn't have an outlined version, so we skip it
    };

    // Get outlined version if available, otherwise return original
    return iconMap[originalIcon] ?? originalIcon;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonSize = widget.compactMode ? 40.0 : 48.0;
    final iconSize = widget.compactMode ? 18.0 : 20.0;
    final margin = widget.compactMode
        ? const EdgeInsets.symmetric(vertical: 2)
        : AppSpacing.marginVerticalXs;

    // Use filled icon when selected or hovered, outlined when not
    final displayIcon = widget.isSelected || _isHovered
        ? _getFilledIcon(widget.icon)
        : _getOutlinedIcon(widget.icon);

    return Container(
      margin: margin,
      child: Material(
        color: widget.isSelected
            ? theme.colorScheme.primary.withOpacity(0.12)
            : _isHovered
                ? theme.colorScheme.onSurface.withOpacity(0.08)
                : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: Tooltip(
          message: widget.tooltip ?? '',
          child: InkWell(
            onTap: widget.onPressed,
            onHover: (hovering) {
              setState(() {
                _isHovered = hovering;
              });
            },
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: double.infinity,
              height: buttonSize,
              child: Icon(
                displayIcon,
                size: iconSize,
                color: widget.isSelected
                    ? theme.colorScheme.primary
                    : _isHovered
                        ? theme.colorScheme.onSurface
                        : theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _UtilityButton extends StatefulWidget {
  const _UtilityButton({
    required this.icon,
    this.tooltip,
    this.compactMode = false,
    this.onPressed,
  });

  final IconData icon;
  final String? tooltip;
  final bool compactMode;
  final VoidCallback? onPressed;

  @override
  State<_UtilityButton> createState() => _UtilityButtonState();
}

class _UtilityButtonState extends State<_UtilityButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonSize = widget.compactMode ? 40.0 : 48.0;
    final iconSize = widget.compactMode ? 18.0 : 20.0;
    final margin = widget.compactMode
        ? const EdgeInsets.symmetric(vertical: 2)
        : AppSpacing.marginVerticalXs;

    return Container(
      margin: margin,
      child: Material(
        color: _isHovered
            ? theme.colorScheme.onSurface.withOpacity(0.08)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: Tooltip(
          message: widget.tooltip ?? '',
          child: InkWell(
            onTap: widget.onPressed,
            onHover: (hovering) {
              setState(() {
                _isHovered = hovering;
              });
            },
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: double.infinity,
              height: buttonSize,
              child: Icon(
                widget.icon,
                size: iconSize,
                color: _isHovered
                    ? theme.colorScheme.onSurface
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({
    required this.languageCode,
    required this.languageName,
    required this.isSelected,
    required this.onTap,
  });

  final String languageCode;
  final String languageName;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              size: 20,
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 12),
            Text(
              languageName,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '($languageCode)',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
