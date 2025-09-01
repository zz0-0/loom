import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Left side status items
          Expanded(
            child: Row(
              children: [
                _StatusItem(
                  icon: LucideIcons.gitBranch,
                  text: 'main',
                  onTap: () {
                    // TODO: Git branch info
                  },
                ),
                _StatusItem(
                  icon: LucideIcons.alertCircle,
                  text: '0',
                  color: theme.colorScheme.error,
                  onTap: () {
                    // TODO: Show errors
                  },
                ),
                _StatusItem(
                  icon: LucideIcons.alertTriangle,
                  text: '0',
                  color: Colors.orange,
                  onTap: () {
                    // TODO: Show warnings
                  },
                ),
              ],
            ),
          ),

          // Right side status items
          Row(
            children: [
              _StatusItem(
                text: 'UTF-8',
                onTap: () {
                  // TODO: Encoding settings
                },
              ),
              _StatusItem(
                text: 'Dart',
                onTap: () {
                  // TODO: Language mode
                },
              ),
              _StatusItem(
                icon: LucideIcons.check,
                text: 'Ready',
                color: theme.colorScheme.primary,
                onTap: () {
                  // TODO: Status info
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusItem extends StatelessWidget {
  final IconData? icon;
  final String text;
  final Color? color;
  final VoidCallback? onTap;

  const _StatusItem({
    this.icon,
    required this.text,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final itemColor = color ?? theme.colorScheme.onSurfaceVariant;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 12,
                  color: itemColor,
                ),
                const SizedBox(width: 4),
              ],
              Text(
                text,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: itemColor,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
