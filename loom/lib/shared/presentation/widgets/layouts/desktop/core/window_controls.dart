import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loom/shared/presentation/providers/window_controls_provider.dart';
import 'package:window_manager/window_manager.dart';

/// Platform-aware window controls that follow system conventions
class WindowControls extends StatelessWidget {
  const WindowControls({
    super.key,
    this.onMinimize,
    this.onMaximize,
    this.onClose,
    this.placement = WindowControlsPlacement.right,
    this.order,
  });

  final VoidCallback? onMinimize;
  final VoidCallback? onMaximize;
  final VoidCallback? onClose;
  final WindowControlsPlacement placement;
  final WindowControlsOrder? order;

  @override
  Widget build(BuildContext context) {
    if (Platform.isWindows) {
      return _buildWindowsControls(context);
    } else if (Platform.isMacOS) {
      return _buildMacOSControls(context);
    } else if (Platform.isLinux) {
      return _buildLinuxControls(context);
    }

    // Fallback for other platforms
    return const SizedBox.shrink();
  }

  Widget _buildWindowsControls(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveOrder = order ?? WindowControlsOrder.standard;

    final buttons = [
      _WindowControlButton(
        icon: Icons.minimize,
        onPressed: onMinimize ?? _minimize,
        tooltip: 'Minimize',
        theme: theme,
      ),
      _WindowControlButton(
        icon: Icons.crop_square,
        onPressed: onMaximize ?? _maximize,
        tooltip: 'Maximize',
        theme: theme,
      ),
      _WindowControlButton(
        icon: Icons.close,
        onPressed: onClose ?? _close,
        tooltip: 'Close',
        theme: theme,
        isClose: true,
      ),
    ];

    List<Widget> orderedButtons;
    switch (effectiveOrder) {
      case WindowControlsOrder.macOS:
        orderedButtons = [
          buttons[2],
          buttons[0],
          buttons[1],
        ]; // Close, Minimize, Maximize
      case WindowControlsOrder.reverse:
        orderedButtons = buttons.reversed.toList(); // Close, Maximize, Minimize
      case WindowControlsOrder.standard:
      default:
        orderedButtons = buttons; // Minimize, Maximize, Close
        break;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: orderedButtons,
    );
  }

  Widget _buildMacOSControls(BuildContext context) {
    final effectiveOrder = order ?? WindowControlsOrder.macOS;

    final buttons = [
      _MacOSControlButton(
        color: Colors.red,
        onPressed: onClose ?? _close,
        tooltip: 'Close',
      ),
      _MacOSControlButton(
        color: Colors.orange,
        onPressed: onMinimize ?? _minimize,
        tooltip: 'Minimize',
      ),
      _MacOSControlButton(
        color: Colors.green,
        onPressed: onMaximize ?? _maximize,
        tooltip: 'Zoom',
      ),
    ];

    final spacers = [
      const SizedBox(width: 8),
      const SizedBox(width: 8),
    ];

    List<Widget> orderedControls;
    switch (effectiveOrder) {
      case WindowControlsOrder.standard:
        // Minimize, Maximize, Close
        orderedControls = [
          buttons[1],
          spacers[0],
          buttons[2],
          spacers[1],
          buttons[0],
        ];
      case WindowControlsOrder.reverse:
        // Close, Maximize, Minimize
        orderedControls = [
          buttons[0],
          spacers[0],
          buttons[2],
          spacers[1],
          buttons[1],
        ];
      case WindowControlsOrder.macOS:
      default:
        // Close, Minimize, Maximize (default macOS order)
        orderedControls = [
          buttons[0],
          spacers[0],
          buttons[1],
          spacers[1],
          buttons[2],
        ];
        break;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: placement == WindowControlsPlacement.left
          ? orderedControls
          : orderedControls.reversed.toList(),
    );
  }

  Widget _buildLinuxControls(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveOrder = order ?? WindowControlsOrder.standard;

    final buttons = [
      _WindowControlButton(
        icon: Icons.minimize,
        onPressed: onMinimize ?? _minimize,
        tooltip: 'Minimize',
        theme: theme,
      ),
      _WindowControlButton(
        icon: Icons.crop_square,
        onPressed: onMaximize ?? _maximize,
        tooltip: 'Maximize',
        theme: theme,
      ),
      _WindowControlButton(
        icon: Icons.close,
        onPressed: onClose ?? _close,
        tooltip: 'Close',
        theme: theme,
        isClose: true,
      ),
    ];

    List<Widget> orderedButtons;
    switch (effectiveOrder) {
      case WindowControlsOrder.macOS:
        orderedButtons = [
          buttons[2],
          buttons[0],
          buttons[1],
        ]; // Close, Minimize, Maximize
      case WindowControlsOrder.reverse:
        orderedButtons = buttons.reversed.toList(); // Close, Maximize, Minimize
      case WindowControlsOrder.standard:
      default:
        orderedButtons = buttons; // Minimize, Maximize, Close
        break;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: placement == WindowControlsPlacement.left
          ? orderedButtons.reversed.toList()
          : orderedButtons,
    );
  }

  Future<void> _minimize() async {
    try {
      await windowManager.minimize();
    } catch (e) {
      debugPrint('Failed to minimize window: $e');
    }
  }

  Future<void> _maximize() async {
    try {
      if (await windowManager.isMaximized()) {
        await windowManager.unmaximize();
      } else {
        await windowManager.maximize();
      }
    } catch (e) {
      debugPrint('Failed to maximize window: $e');
    }
  }

  Future<void> _close() async {
    try {
      await windowManager.close();
    } catch (e) {
      debugPrint('Failed to close window: $e');
      await SystemNavigator.pop();
    }
  }
}

class _WindowControlButton extends StatefulWidget {
  const _WindowControlButton({
    required this.icon,
    required this.onPressed,
    required this.tooltip,
    required this.theme,
    this.isClose = false,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final String tooltip;
  final ThemeData theme;
  final bool isClose;

  @override
  State<_WindowControlButton> createState() => _WindowControlButtonState();
}

class _WindowControlButtonState extends State<_WindowControlButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: widget.onPressed,
          child: Container(
            width: 46,
            height: 32,
            decoration: BoxDecoration(
              color: _isHovered
                  ? widget.isClose
                      ? Colors.red
                      : widget.theme.colorScheme.surfaceContainerHighest
                  : Colors.transparent,
            ),
            child: Icon(
              widget.icon,
              size: 16,
              color: _isHovered && widget.isClose
                  ? Colors.white
                  : widget.theme.colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}

class _MacOSControlButton extends StatefulWidget {
  const _MacOSControlButton({
    required this.color,
    required this.onPressed,
    required this.tooltip,
  });

  final Color color;
  final VoidCallback onPressed;
  final String tooltip;

  @override
  State<_MacOSControlButton> createState() => _MacOSControlButtonState();
}

class _MacOSControlButtonState extends State<_MacOSControlButton> {
  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: GestureDetector(
        onTap: widget.onPressed,
        child: Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.color,
            border: Border.all(
              color: widget.color.withOpacity(0.3),
              width: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}

enum WindowControlsPlacement {
  left,
  right,
  auto,
}
