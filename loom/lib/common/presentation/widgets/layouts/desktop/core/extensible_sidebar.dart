import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/common/index.dart';
import 'package:loom/features/core/settings/index.dart';
import 'package:loom/flutter_gen/gen_l10n/app_localizations.dart';

// Top-level helpers so utility buttons can reuse the same outlined->filled mapping
IconData _getFilledIcon(IconData originalIcon) {
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
    // Language & theme icons
    Icons.language: Icons.language,
    Icons.translate: Icons.translate,
    Icons.flag: Icons.flag,
    Icons.outlined_flag: Icons.flag,
    Icons.g_translate: Icons.g_translate,
    Icons.dark_mode: Icons.dark_mode,
    Icons.light_mode: Icons.light_mode,
    Icons.brightness_auto: Icons.brightness_auto,
  };

  return iconMap[originalIcon] ?? originalIcon;
}

IconData _getOutlinedIcon(IconData originalIcon) {
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
    // Language & theme icons outlined variants
    Icons.language: Icons.language_outlined,
    Icons.translate: Icons.translate,
    Icons.flag: Icons.flag_sharp,
    Icons.g_translate: Icons.g_translate,
    Icons.dark_mode: Icons.dark_mode_outlined,
    Icons.light_mode: Icons.light_mode_outlined,
    Icons.brightness_auto: Icons.brightness_auto,
  };

  return iconMap[originalIcon] ?? originalIcon;
}

IconData languageCodeToIcon(String languageCode) {
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

    // Watch current language once so icon and badge update together
    final _currentLanguage = ref.watch(generalSettingsProvider).language;

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
            // Show short uppercase language code next to the icon so users
            // can quickly see the current language (e.g. EN, FR)
            _LanguageUtilityButton(
              languageCode: _currentLanguage,
              icon: languageCodeToIcon(_currentLanguage),
              tooltip: AppLocalizations.of(context).language,
              compactMode: compactMode,
              onPressed: () => _showLanguageSelectionDialog(context, ref),
            ),
            _ThemeUtilityButton(
              themeData: ref.watch(customThemeProvider),
              icon: Icons.brightness_6,
              tooltip: AppLocalizations.of(context).switchTheme,
              compactMode: compactMode,
              onPressed: () => _showThemeSelectionDialog(context, ref),
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
      // Note: waving_hand doesn't have an outlined version, so we map it to a close
      // pair (fallback) to get distinct outlined/filled icons for hover.
      Icons.waving_hand: Icons.close_outlined,
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

/// Language utility button that shows the current language short code
class _LanguageUtilityButton extends StatefulWidget {
  const _LanguageUtilityButton({
    required this.languageCode,
    this.icon,
    this.tooltip,
    this.compactMode = false,
    this.onPressed,
  });

  final String languageCode;
  final IconData? icon;
  final String? tooltip;
  final bool compactMode;
  final VoidCallback? onPressed;

  @override
  State<_LanguageUtilityButton> createState() => _LanguageUtilityButtonState();
}

class _LanguageUtilityButtonState extends State<_LanguageUtilityButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonSize = widget.compactMode ? 40.0 : 48.0;

    // compact overlay is built inline below

    return Container(
      margin: widget.compactMode
          ? const EdgeInsets.symmetric(vertical: 2)
          : AppSpacing.marginVerticalXs,
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
              child: widget.compactMode
                  ? Stack(
                      alignment: Alignment.center,
                      children: [
                        // Icon that becomes filled when hovered (or style change fallback)
                        Builder(builder: (context) {
                          final orig = widget.icon ?? Icons.language;
                          final outlined = _getOutlinedIcon(orig);
                          final filled = _getFilledIcon(orig);
                          final hasVariant = outlined != filled;
                          final iconToShow = _isHovered ? filled : outlined;
                          return Icon(
                            iconToShow,
                            size: _isHovered ? 20 : 18,
                            color: hasVariant
                                ? (_isHovered
                                    ? theme.colorScheme.onSurface
                                    : theme.colorScheme.onSurfaceVariant)
                                : (_isHovered
                                    ? theme.colorScheme.onSurface
                                    : theme.colorScheme.onSurfaceVariant),
                          );
                        }),
                        // small badge overlay at top-right (compact only) - slightly larger so two letters fit
                        Positioned(
                          right: 6,
                          top: 6,
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: _isHovered
                                  ? theme.colorScheme.primary
                                  : Colors.transparent,
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: _isHovered
                                      ? theme.colorScheme.primary
                                          .withOpacity(0.9)
                                      : theme.colorScheme.outline
                                          .withOpacity(0.2)),
                            ),
                            alignment: Alignment.center,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                widget.languageCode.toUpperCase(),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  color: _isHovered
                                      ? theme.colorScheme.onPrimary
                                      : theme.colorScheme.onSurface,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Center(
                      // Normal mode: only the icon (outlined -> filled on hover). If no filled variant exists, change appearance instead.
                      child: Builder(builder: (context) {
                        final orig = widget.icon ?? Icons.language;
                        final outlined = _getOutlinedIcon(orig);
                        final filled = _getFilledIcon(orig);
                        final hasVariant = outlined != filled;
                        if (hasVariant) {
                          return Icon(
                            _isHovered ? filled : outlined,
                            size: 20,
                            color: _isHovered
                                ? theme.colorScheme.onSurface
                                : theme.colorScheme.onSurfaceVariant,
                          );
                        }
                        // fallback: change color/size to indicate hover
                        return Icon(
                          orig,
                          size: _isHovered ? 22 : 20,
                          color: _isHovered
                              ? theme.colorScheme.onSurface
                              : theme.colorScheme.onSurfaceVariant,
                        );
                      }),
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

/// Theme utility button that shows the current theme name or a compact swatch
class _ThemeUtilityButton extends StatefulWidget {
  const _ThemeUtilityButton({
    required this.themeData,
    this.icon,
    this.tooltip,
    this.compactMode = false,
    this.onPressed,
  });

  final CustomThemeData themeData;
  final IconData? icon;
  final String? tooltip;
  final bool compactMode;
  final VoidCallback? onPressed;

  @override
  State<_ThemeUtilityButton> createState() => _ThemeUtilityButtonState();
}

class _ThemeUtilityButtonState extends State<_ThemeUtilityButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonSize = widget.compactMode ? 40.0 : 48.0;

    // Note: compact badges are built inline; no separate normal-mode badge/swatch needed

    // Choose an icon that reflects the theme type (system/light/dark)
    IconData themeIcon;
    final nameLower = widget.themeData.name.toLowerCase();
    if (nameLower.contains('dark')) {
      themeIcon = Icons.dark_mode;
    } else if (nameLower.contains('light')) {
      themeIcon = Icons.light_mode;
    } else if (nameLower.contains('system')) {
      themeIcon = Icons.brightness_auto;
    } else {
      themeIcon = widget.icon ?? Icons.brightness_6;
    }

    return Container(
      margin: widget.compactMode
          ? const EdgeInsets.symmetric(vertical: 2)
          : AppSpacing.marginVerticalXs,
      child: Material(
        color: _isHovered
            ? theme.colorScheme.onSurface.withOpacity(0.08)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: Tooltip(
          message: widget.tooltip ?? widget.themeData.name,
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
              child: widget.compactMode
                  ? Stack(
                      alignment: Alignment.center,
                      children: [
                        Builder(builder: (context) {
                          final outlined = _getOutlinedIcon(themeIcon);
                          final filled = _getFilledIcon(themeIcon);
                          final hasVariant = outlined != filled;
                          final iconToShow = _isHovered ? filled : outlined;
                          return Icon(
                            iconToShow,
                            size: _isHovered ? 20 : 18,
                            color: hasVariant
                                ? (_isHovered
                                    ? theme.colorScheme.onSurface
                                    : theme.colorScheme.onSurfaceVariant)
                                : (_isHovered
                                    ? theme.colorScheme.onSurface
                                    : theme.colorScheme.onSurfaceVariant),
                          );
                        }),
                        Positioned(
                          right: 6,
                          top: 6,
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: _isHovered
                                  ? theme.colorScheme.primary
                                  : Colors.transparent,
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: _isHovered
                                      ? theme.colorScheme.primary
                                          .withOpacity(0.9)
                                      : theme.colorScheme.outline
                                          .withOpacity(0.3)),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: Builder(builder: (context) {
                        final outlined = _getOutlinedIcon(themeIcon);
                        final filled = _getFilledIcon(themeIcon);
                        final hasVariant = outlined != filled;
                        if (hasVariant) {
                          return Icon(
                            _isHovered ? filled : outlined,
                            size: 20,
                            color: _isHovered
                                ? theme.colorScheme.onSurface
                                : theme.colorScheme.onSurfaceVariant,
                          );
                        }
                        return Icon(
                          themeIcon,
                          size: _isHovered ? 22 : 20,
                          color: _isHovered
                              ? theme.colorScheme.onSurface
                              : theme.colorScheme.onSurfaceVariant,
                        );
                      }),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

void _showThemeSelectionDialog(BuildContext context, WidgetRef ref) {
  final localizations = AppLocalizations.of(context);
  final currentTheme = ref.read(customThemeProvider);

  showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(localizations.theme),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // System themes
            _ThemeDialogGroup(
              title: localizations.systemThemes,
              themes: BuiltInThemes.systemThemes,
              currentTheme: currentTheme,
              onThemeSelected: (theme) {
                ref.read(customThemeProvider.notifier).setTheme(theme);
                Navigator.of(context).pop();
              },
            ),
            const SizedBox(height: 12),
            _ThemeDialogGroup(
              title: localizations.lightThemes,
              themes: BuiltInThemes.lightThemes,
              currentTheme: currentTheme,
              onThemeSelected: (theme) {
                ref.read(customThemeProvider.notifier).setTheme(theme);
                Navigator.of(context).pop();
              },
            ),
            const SizedBox(height: 12),
            _ThemeDialogGroup(
              title: localizations.darkThemes,
              themes: BuiltInThemes.darkThemes,
              currentTheme: currentTheme,
              onThemeSelected: (theme) {
                ref.read(customThemeProvider.notifier).setTheme(theme);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
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

class _ThemeDialogGroup extends StatelessWidget {
  const _ThemeDialogGroup({
    required this.title,
    required this.themes,
    required this.currentTheme,
    required this.onThemeSelected,
  });

  final String title;
  final List<CustomThemeData> themes;
  final CustomThemeData currentTheme;
  final void Function(CustomThemeData) onThemeSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: themes.map((presetTheme) {
            final isSelected = currentTheme.name == presetTheme.name;
            return GestureDetector(
              onTap: () => onThemeSelected(presetTheme),
              child: SizedBox(
                width: 160, // fixed width for uniform appearance
                child: Container(
                  padding: AppSpacing.paddingSm,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: isSelected
                        ? theme.colorScheme.primary.withOpacity(0.1)
                        : theme.colorScheme.surfaceContainerHighest
                            .withOpacity(0.3),
                    border: Border.all(
                      color: isSelected
                          ? theme.colorScheme.primary.withOpacity(0.3)
                          : theme.colorScheme.outline.withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 28,
                        height: 18,
                        decoration: BoxDecoration(
                          color: presetTheme.primaryColor,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                              color:
                                  theme.colorScheme.outline.withOpacity(0.4)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          presetTheme.name,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isSelected
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurface,
                            fontWeight: isSelected ? FontWeight.w600 : null,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
