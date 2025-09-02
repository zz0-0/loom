import 'package:flutter/material.dart';
import 'package:loom/shared/presentation/widgets/layouts/desktop/core/bottom_bar_registry.dart';
import 'package:loom/shared/presentation/theme/app_theme.dart';

/// Extensible bottom bar that displays registered items
class BottomBar extends StatelessWidget {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final registry = BottomBarRegistry();

    return Container(
      height: AppTheme.bottomBarHeight,
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.light
            ? theme.colorScheme.surfaceContainerHighest
            : theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.dividerColor,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            // Left side items
            ...registry.items
                .where((item) => item.priority < 100)
                .map((item) => item.build(context)),

            // Spacer
            const Spacer(),

            // Right side items
            ...registry.items
                .where((item) => item.priority >= 100)
                .map((item) => item.build(context)),
          ],
        ),
      ),
    );
  }
}

/// Default status items for the bottom bar
class StatusBottomBarItem implements BottomBarItem {
  @override
  String get id => 'status';

  @override
  int get priority => 1;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.circle,
            size: 8,
            color: Colors.green,
          ),
          const SizedBox(width: 6),
          Text(
            'Ready',
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class LanguageBottomBarItem implements BottomBarItem {
  @override
  String get id => 'language';

  @override
  int get priority => 100;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Text(
        'Dart',
        style: theme.textTheme.bodySmall,
      ),
    );
  }
}

class EncodingBottomBarItem implements BottomBarItem {
  @override
  String get id => 'encoding';

  @override
  int get priority => 101;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Text(
        'UTF-8',
        style: theme.textTheme.bodySmall,
      ),
    );
  }
}

class LineEndingBottomBarItem implements BottomBarItem {
  @override
  String get id => 'line_ending';

  @override
  int get priority => 102;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Text(
        'LF',
        style: theme.textTheme.bodySmall,
      ),
    );
  }
}
