import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Menu button (hamburger)
          IconButton(
            icon: const Icon(LucideIcons.menu, size: 16),
            onPressed: () {
              // TODO: Implement menu
            },
            splashRadius: 16,
          ),

          // App title/breadcrumb
          Expanded(
            child: Text(
              'Loom',
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // Search bar (centered)
          Expanded(
            flex: 2,
            child: Container(
              height: 24,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: theme.colorScheme.outline.withOpacity(0.2),
                ),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  Icon(
                    LucideIcons.search,
                    size: 14,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        hintStyle: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Window controls area
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Theme toggle
                IconButton(
                  icon: const Icon(LucideIcons.sun, size: 16),
                  onPressed: () {
                    // TODO: Implement theme toggle
                  },
                  splashRadius: 16,
                ),

                // Settings
                IconButton(
                  icon: const Icon(LucideIcons.settings, size: 16),
                  onPressed: () {
                    // TODO: Implement settings
                  },
                  splashRadius: 16,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
