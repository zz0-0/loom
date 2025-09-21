import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/common/index.dart';
import 'package:loom/flutter_gen/gen_l10n/app_localizations.dart';
import 'package:loom/plugins/api/plugin_manifest.dart';
import 'package:loom/plugins/core/plugin_manager.dart';

/// Individual plugin sidebar item for a specific plugin
class IndividualPluginSidebarItem implements SidebarItem {
  const IndividualPluginSidebarItem(this.plugin);

  final PluginManifest plugin;

  @override
  String get id => 'plugin-${plugin.id}';

  @override
  IconData get icon => _getPluginIcon();

  @override
  String? get tooltip => plugin.name;

  @override
  VoidCallback? get onPressed => null; // Use default panel behavior

  @override
  Widget? buildPanel(BuildContext context) {
    return PluginPanel(plugin: plugin);
  }

  IconData _getPluginIcon() {
    if (plugin.icon != null) {
      // Try to parse the icon string
      return _parseIconString(plugin.icon!);
    }

    // Fallback to default icons based on plugin type
    if (plugin.id.contains('git')) {
      return Icons.account_tree_outlined;
    } else if (plugin.capabilities.commands
        .any((cmd) => cmd.contains('hello') || cmd.contains('greet'))) {
      return Icons.waving_hand_outlined;
    } else {
      return Icons.extension_outlined;
    }
  }

  IconData _parseIconString(String iconString) {
    // For now, we'll use a simple mapping. In a real implementation,
    // you might want to support custom icon assets or more complex icon systems
    switch (iconString.toLowerCase()) {
      case 'git':
      case 'account_tree':
        return Icons.account_tree_outlined;
      case 'code':
        return Icons.code_outlined;
      case 'waving_hand':
      case 'hello':
        // Note: waving_hand_outlined may not exist, so we use the filled version
        // The sidebar will handle the filled/outlined logic automatically
        return Icons.waving_hand;
      case 'extension':
      default:
        return Icons.extension_outlined;
    }
  }
}

/// Plugin panel that appears in the side panel for a specific plugin
class PluginPanel extends ConsumerStatefulWidget {
  const PluginPanel({required this.plugin, super.key});

  final PluginManifest plugin;

  @override
  ConsumerState<PluginPanel> createState() => _PluginPanelState();
}

class _PluginPanelState extends ConsumerState<PluginPanel> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context);

    return Container(
      padding: AppSpacing.paddingMd,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                _getPluginIcon(),
                size: 14,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  widget.plugin.name,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          const Divider(height: AppSpacing.xs),

          // Plugin description
          if (widget.plugin.description.isNotEmpty) ...[
            Text(
              widget.plugin.description,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],

          // Commands
          if (widget.plugin.capabilities.commands.isNotEmpty) ...[
            Text(
              localizations
                  .commandsCount(widget.plugin.capabilities.commands.length),
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Expanded(
              child: ListView.builder(
                itemCount: widget.plugin.capabilities.commands.length,
                itemBuilder: (context, index) {
                  final command = widget.plugin.capabilities.commands[index];
                  return _buildCommandItem(command, theme);
                },
              ),
            ),
          ] else ...[
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 32,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'No commands available',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCommandItem(String command, ThemeData theme) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: InkWell(
        onTap: () => _executeCommand(context, command),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: AppSpacing.paddingSm,
          child: Row(
            children: [
              Icon(
                Icons.play_arrow,
                size: 16,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _formatCommandName(command),
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getPluginIcon() {
    if (widget.plugin.icon != null) {
      return _parseIconString(widget.plugin.icon!);
    }

    if (widget.plugin.id.contains('git')) {
      return Icons.account_tree_outlined;
    } else if (widget.plugin.capabilities.commands
        .any((cmd) => cmd.contains('hello') || cmd.contains('greet'))) {
      return Icons.waving_hand_outlined;
    } else {
      return Icons.extension_outlined;
    }
  }

  IconData _parseIconString(String iconString) {
    switch (iconString.toLowerCase()) {
      case 'git':
      case 'account_tree':
        return Icons.account_tree_outlined;
      case 'code':
        return Icons.code_outlined;
      case 'waving_hand':
      case 'hello':
        // Note: waving_hand_outlined may not exist, so we use the filled version
        // The sidebar will handle the filled/outlined logic automatically
        return Icons.waving_hand;
      case 'extension':
      default:
        return Icons.extension_outlined;
    }
  }

  String _formatCommandName(String command) {
    // Convert command names like 'git.status' to 'Status'
    final parts = command.split('.');
    if (parts.length > 1) {
      return parts.last.replaceAll('_', ' ').toUpperCase();
    }
    return command.replaceAll('_', ' ').toUpperCase();
  }

  Future<void> _executeCommand(BuildContext context, String commandId) async {
    final localizations = AppLocalizations.of(context);

    try {
      final result = await PluginManager.instance.executeCommand(
        widget.plugin.id,
        commandId,
        <String, dynamic>{},
      );

      if (context.mounted) {
        if (result.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(localizations.commandExecutedSuccessfully),
              duration: const Duration(seconds: 2),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                localizations.commandFailed(result.error ?? 'Unknown error'),
              ),
              backgroundColor: Theme.of(context).colorScheme.error,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localizations.failedToExecuteCommand(e.toString())),
            backgroundColor: Theme.of(context).colorScheme.error,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }
}

/// Registration function for plugin sidebar features
class PluginSidebarRegistration {
  static void register() {
    final pluginManager = PluginManager.instance;
    final activePlugins = pluginManager.getActivePlugins();

    // Register individual sidebar items for each active plugin
    final registry = UIRegistry();
    for (final plugin in activePlugins) {
      registry.registerSidebarItem(IndividualPluginSidebarItem(plugin));
    }
  }

  static void unregisterPlugin(String pluginId) {
    final registry = UIRegistry();
    registry.getSidebarItem('plugin-$pluginId');
    // Note: UIRegistry doesn't have an unregister method yet
    // This would need to be added to properly clean up
  }
}
