import 'package:flutter/material.dart';

/// Centralized micro-interactions and animations for the entire app
/// Similar to AppSpacing and AppRadius, this provides consistent animations across the project
class AppAnimations {
  // Duration constants
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 350);
  static const Duration slower = Duration(milliseconds: 500);

  // Curve constants
  static const Curve easeInOut = Curves.easeInOut;
  static const Curve easeOut = Curves.easeOut;
  static const Curve easeIn = Curves.easeIn;
  static const Curve bounceOut = Curves.bounceOut;
  static const Curve elasticOut = Curves.elasticOut;

  // Common animation curves
  static const Curve scaleCurve = Curves.easeInOut;
  static const Curve fadeCurve = Curves.easeInOut;
  static const Curve slideCurve = Curves.easeOut;
  static const Curve bounceCurve = Curves.bounceOut;

  // Scale animations
  static const double scaleHover = 1.02;
  static const double scalePressed = 0.98;
  static const double scaleFocus = 1.01;

  // Opacity animations
  static const double opacityHover = 0.8;
  static const double opacityDisabled = 0.5;
  static const double opacityFocus = 0.9;

  // Border radius animations
  static const double borderRadiusHover = 1.05;
  static const double borderRadiusPressed = 0.95;
}

/// Pre-built animation widgets for common interactions
class AnimatedHover extends StatefulWidget {
  const AnimatedHover({
    required this.child,
    super.key,
    this.duration = AppAnimations.fast,
    this.curve = AppAnimations.scaleCurve,
    this.scale = AppAnimations.scaleHover,
    this.opacity = AppAnimations.opacityHover,
    this.onTap,
  });

  final Widget child;
  final Duration duration;
  final Curve curve;
  final double scale;
  final double opacity;
  final VoidCallback? onTap;

  @override
  State<AnimatedHover> createState() => _AnimatedHoverState();
}

class _AnimatedHoverState extends State<AnimatedHover> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _isHovered ? widget.scale : 1.0,
          duration: widget.duration,
          curve: widget.curve,
          child: AnimatedOpacity(
            opacity: _isHovered ? widget.opacity : 1.0,
            duration: widget.duration,
            curve: widget.curve,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

class AnimatedPress extends StatefulWidget {
  const AnimatedPress({
    required this.child,
    super.key,
    this.duration = AppAnimations.fast,
    this.curve = AppAnimations.scaleCurve,
    this.scale = AppAnimations.scalePressed,
    this.onPressed,
  });

  final Widget child;
  final Duration duration;
  final Curve curve;
  final double scale;
  final VoidCallback? onPressed;

  @override
  State<AnimatedPress> createState() => _AnimatedPressState();
}

class _AnimatedPressState extends State<AnimatedPress> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onPressed,
      child: AnimatedScale(
        scale: _isPressed ? widget.scale : 1.0,
        duration: widget.duration,
        curve: widget.curve,
        child: widget.child,
      ),
    );
  }
}

class AnimatedFocus extends StatefulWidget {
  const AnimatedFocus({
    required this.child,
    super.key,
    this.duration = AppAnimations.fast,
    this.curve = AppAnimations.scaleCurve,
    this.scale = AppAnimations.scaleFocus,
    this.opacity = AppAnimations.opacityFocus,
    this.focusNode,
  });

  final Widget child;
  final Duration duration;
  final Curve curve;
  final double scale;
  final double opacity;
  final FocusNode? focusNode;

  @override
  State<AnimatedFocus> createState() => _AnimatedFocusState();
}

class _AnimatedFocusState extends State<AnimatedFocus> {
  late final FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    } else {
      _focusNode.removeListener(_handleFocusChange);
    }
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() => _isFocused = _focusNode.hasFocus);
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      child: AnimatedScale(
        scale: _isFocused ? widget.scale : 1.0,
        duration: widget.duration,
        curve: widget.curve,
        child: AnimatedOpacity(
          opacity: _isFocused ? widget.opacity : 1.0,
          duration: widget.duration,
          curve: widget.curve,
          child: widget.child,
        ),
      ),
    );
  }
}

class AnimatedFadeIn extends StatelessWidget {
  const AnimatedFadeIn({
    required this.child,
    super.key,
    this.duration = AppAnimations.normal,
    this.curve = AppAnimations.fadeCurve,
    this.delay = Duration.zero,
  });

  final Widget child;
  final Duration duration;
  final Curve curve;
  final Duration delay;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: Future.delayed(delay),
      builder: (context, snapshot) {
        return AnimatedOpacity(
          opacity: snapshot.connectionState == ConnectionState.done ? 1.0 : 0.0,
          duration: duration,
          curve: curve,
          child: AnimatedScale(
            scale:
                snapshot.connectionState == ConnectionState.done ? 1.0 : 0.95,
            duration: duration,
            curve: curve,
            child: child,
          ),
        );
      },
    );
  }
}

class AnimatedSlideIn extends StatelessWidget {
  const AnimatedSlideIn({
    required this.child,
    super.key,
    this.duration = AppAnimations.normal,
    this.curve = AppAnimations.slideCurve,
    this.direction = AxisDirection.up,
    this.distance = 20.0,
    this.delay = Duration.zero,
  });

  final Widget child;
  final Duration duration;
  final Curve curve;
  final AxisDirection direction;
  final double distance;
  final Duration delay;

  @override
  Widget build(BuildContext context) {
    final offset = switch (direction) {
      AxisDirection.up => Offset(0, distance),
      AxisDirection.down => Offset(0, -distance),
      AxisDirection.left => Offset(distance, 0),
      AxisDirection.right => Offset(-distance, 0),
    };

    return FutureBuilder<void>(
      future: Future.delayed(delay),
      builder: (context, snapshot) {
        return AnimatedSlide(
          offset: snapshot.connectionState == ConnectionState.done
              ? Offset.zero
              : offset,
          duration: duration,
          curve: curve,
          child: child,
        );
      },
    );
  }
}

class AnimatedBounce extends StatefulWidget {
  const AnimatedBounce({
    required this.child,
    super.key,
    this.duration = AppAnimations.slow,
    this.curve = AppAnimations.bounceCurve,
    this.scale = 1.1,
  });

  final Widget child;
  final Duration duration;
  final Curve curve;
  final double scale;

  @override
  State<AnimatedBounce> createState() => _AnimatedBounceState();
}

class _AnimatedBounceState extends State<AnimatedBounce>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 1,
      end: widget.scale,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: widget.curve,
      ),
    );

    // Auto-play the animation
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: widget.child,
        );
      },
    );
  }
}

/// Extension methods for common animation patterns
extension AnimationExtensions on Widget {
  /// Adds hover animation
  Widget withHoverAnimation({
    Duration duration = AppAnimations.fast,
    Curve curve = AppAnimations.scaleCurve,
    double scale = AppAnimations.scaleHover,
    double opacity = AppAnimations.opacityHover,
    VoidCallback? onTap,
  }) {
    return AnimatedHover(
      duration: duration,
      curve: curve,
      scale: scale,
      opacity: opacity,
      onTap: onTap,
      child: this,
    );
  }

  /// Adds press animation
  Widget withPressAnimation({
    Duration duration = AppAnimations.fast,
    Curve curve = AppAnimations.scaleCurve,
    double scale = AppAnimations.scalePressed,
    VoidCallback? onPressed,
  }) {
    return AnimatedPress(
      duration: duration,
      curve: curve,
      scale: scale,
      onPressed: onPressed,
      child: this,
    );
  }

  /// Adds focus animation
  Widget withFocusAnimation({
    Duration duration = AppAnimations.fast,
    Curve curve = AppAnimations.scaleCurve,
    double scale = AppAnimations.scaleFocus,
    double opacity = AppAnimations.opacityFocus,
    FocusNode? focusNode,
  }) {
    return AnimatedFocus(
      duration: duration,
      curve: curve,
      scale: scale,
      opacity: opacity,
      focusNode: focusNode,
      child: this,
    );
  }

  /// Adds fade-in animation
  Widget withFadeInAnimation({
    Duration duration = AppAnimations.normal,
    Curve curve = AppAnimations.fadeCurve,
    Duration delay = Duration.zero,
  }) {
    return AnimatedFadeIn(
      duration: duration,
      curve: curve,
      delay: delay,
      child: this,
    );
  }

  /// Adds slide-in animation
  Widget withSlideInAnimation({
    Duration duration = AppAnimations.normal,
    Curve curve = AppAnimations.slideCurve,
    AxisDirection direction = AxisDirection.up,
    double distance = 20.0,
    Duration delay = Duration.zero,
  }) {
    return AnimatedSlideIn(
      duration: duration,
      curve: curve,
      direction: direction,
      distance: distance,
      delay: delay,
      child: this,
    );
  }

  /// Adds bounce animation
  Widget withBounceAnimation({
    Duration duration = AppAnimations.slow,
    Curve curve = AppAnimations.bounceCurve,
    double scale = 1.1,
  }) {
    return AnimatedBounce(
      duration: duration,
      curve: curve,
      scale: scale,
      child: this,
    );
  }
}
