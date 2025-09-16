import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/features/core/settings/index.dart';

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

/// Skeleton loading animation for content placeholders
class SkeletonLoader extends StatefulWidget {
  const SkeletonLoader({
    super.key,
    this.width,
    this.height = 16,
    this.borderRadius = 4,
    this.duration = const Duration(milliseconds: 1500),
    this.baseColor,
    this.highlightColor,
  });

  final double? width;
  final double height;
  final double borderRadius;
  final Duration duration;
  final Color? baseColor;
  final Color? highlightColor;

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: -1, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseColor =
        widget.baseColor ?? theme.colorScheme.surfaceContainerHighest;
    final highlightColor = widget.highlightColor ?? theme.colorScheme.surface;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: baseColor,
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
          child: ShaderMask(
            shaderCallback: (bounds) {
              return LinearGradient(
                colors: [
                  baseColor,
                  highlightColor,
                  baseColor,
                ],
                stops: const [
                  0.0,
                  0.5,
                  1.0,
                ],
                transform: GradientRotation(_animation.value * 3.14159),
              ).createShader(bounds);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(widget.borderRadius),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Shimmer effect for loading states
class ShimmerEffect extends StatefulWidget {
  const ShimmerEffect({
    required this.child,
    super.key,
    this.duration = const Duration(milliseconds: 1500),
    this.baseColor,
    this.highlightColor,
    this.enabled = true,
  });

  final Widget child;
  final Duration duration;
  final Color? baseColor;
  final Color? highlightColor;
  final bool enabled;

  @override
  State<ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<ShimmerEffect>
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

    _animation = Tween<double>(begin: -1, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    if (widget.enabled) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(ShimmerEffect oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled != oldWidget.enabled) {
      if (widget.enabled) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;

    final theme = Theme.of(context);
    final baseColor =
        widget.baseColor ?? theme.colorScheme.surfaceContainerHighest;
    final highlightColor = widget.highlightColor ?? theme.colorScheme.surface;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [
                baseColor,
                highlightColor,
                baseColor,
              ],
              stops: const [
                0.0,
                0.5,
                1.0,
              ],
              transform: GradientRotation(_animation.value * 3.14159),
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}

/// Enhanced loading indicator with smooth transitions
class SmoothLoadingIndicator extends StatefulWidget {
  const SmoothLoadingIndicator({
    super.key,
    this.size = 24,
    this.strokeWidth = 2,
    this.color,
    this.duration = const Duration(milliseconds: 1200),
  });

  final double size;
  final double strokeWidth;
  final Color? color;
  final Duration duration;

  @override
  State<SmoothLoadingIndicator> createState() => _SmoothLoadingIndicatorState();
}

class _SmoothLoadingIndicatorState extends State<SmoothLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _rotationAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat();

    _rotationAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1, end: 1.2), weight: 25),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 0.8), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 0.8, end: 1), weight: 25),
    ]).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = widget.color ?? theme.colorScheme.primary;

    return AnimatedBuilder(
      animation: Listenable.merge([_rotationAnimation, _scaleAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Transform.rotate(
            angle: _rotationAnimation.value * 2 * 3.14159,
            child: SizedBox(
              width: widget.size,
              height: widget.size,
              child: CircularProgressIndicator(
                strokeWidth: widget.strokeWidth,
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Pulse animation for attention-grabbing elements
class PulseAnimation extends StatefulWidget {
  const PulseAnimation({
    required this.child,
    super.key,
    this.duration = const Duration(milliseconds: 1500),
    this.minOpacity = 0.5,
    this.maxOpacity = 1.0,
    this.curve = Curves.easeInOut,
  });

  final Widget child;
  final Duration duration;
  final double minOpacity;
  final double maxOpacity;
  final Curve curve;

  @override
  State<PulseAnimation> createState() => _PulseAnimationState();
}

class _PulseAnimationState extends State<PulseAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: widget.minOpacity,
      end: widget.maxOpacity,
    ).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );
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
        return Opacity(
          opacity: _animation.value,
          child: widget.child,
        );
      },
    );
  }
}

/// Success animation with bounce effect
class SuccessAnimation extends StatefulWidget {
  const SuccessAnimation({
    required this.child,
    super.key,
    this.duration = const Duration(milliseconds: 600),
    this.delay = Duration.zero,
  });

  final Widget child;
  final Duration duration;
  final Duration delay;

  @override
  State<SuccessAnimation> createState() => _SuccessAnimationState();
}

class _SuccessAnimationState extends State<SuccessAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.8, end: 1.2), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 1), weight: 60),
    ]).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_scaleAnimation, _opacityAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: widget.child,
          ),
        );
      },
    );
  }
}

/// Pre-built animation widgets for common interactions
class AnimatedHover extends ConsumerWidget {
  const AnimatedHover({
    required this.child,
    super.key,
    this.duration,
    this.curve = AppAnimations.scaleCurve,
    this.scale = AppAnimations.scaleHover,
    this.opacity = AppAnimations.opacityHover,
    this.onTap,
  });

  final Widget child;
  final Duration? duration;
  final Curve curve;
  final double scale;
  final double opacity;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final animationDurations = ref.watch(animationDurationsProvider);
    final effectiveDuration = duration ?? animationDurations.fast;

    return _AnimatedHoverStateful(
      child: child,
      duration: effectiveDuration,
      curve: curve,
      scale: scale,
      opacity: opacity,
      onTap: onTap,
    );
  }
}

class _AnimatedHoverStateful extends StatefulWidget {
  const _AnimatedHoverStateful({
    required this.child,
    required this.duration,
    required this.curve,
    required this.scale,
    required this.opacity,
    this.onTap,
  });

  final Widget child;
  final Duration duration;
  final Curve curve;
  final double scale;
  final double opacity;
  final VoidCallback? onTap;

  @override
  State<_AnimatedHoverStateful> createState() => __AnimatedHoverStatefulState();
}

class __AnimatedHoverStatefulState extends State<_AnimatedHoverStateful> {
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

class AnimatedPress extends ConsumerWidget {
  const AnimatedPress({
    required this.child,
    super.key,
    this.duration,
    this.curve = AppAnimations.scaleCurve,
    this.scale = AppAnimations.scalePressed,
    this.onPressed,
  });

  final Widget child;
  final Duration? duration;
  final Curve curve;
  final double scale;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final animationDurations = ref.watch(animationDurationsProvider);
    final effectiveDuration = duration ?? animationDurations.fast;

    return _AnimatedPressStateful(
      child: child,
      duration: effectiveDuration,
      curve: curve,
      scale: scale,
      onPressed: onPressed,
    );
  }
}

class _AnimatedPressStateful extends StatefulWidget {
  const _AnimatedPressStateful({
    required this.child,
    required this.duration,
    required this.curve,
    required this.scale,
    this.onPressed,
  });

  final Widget child;
  final Duration duration;
  final Curve curve;
  final double scale;
  final VoidCallback? onPressed;

  @override
  State<_AnimatedPressStateful> createState() => __AnimatedPressStatefulState();
}

class __AnimatedPressStatefulState extends State<_AnimatedPressStateful> {
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

class AnimatedFocus extends ConsumerWidget {
  const AnimatedFocus({
    required this.child,
    super.key,
    this.duration,
    this.curve = AppAnimations.scaleCurve,
    this.scale = AppAnimations.scaleFocus,
    this.opacity = AppAnimations.opacityFocus,
    this.focusNode,
  });

  final Widget child;
  final Duration? duration;
  final Curve curve;
  final double scale;
  final double opacity;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final animationDurations = ref.watch(animationDurationsProvider);
    final effectiveDuration = duration ?? animationDurations.fast;

    return _AnimatedFocusStateful(
      child: child,
      duration: effectiveDuration,
      curve: curve,
      scale: scale,
      opacity: opacity,
      focusNode: focusNode,
    );
  }
}

class _AnimatedFocusStateful extends StatefulWidget {
  const _AnimatedFocusStateful({
    required this.child,
    required this.duration,
    required this.curve,
    required this.scale,
    required this.opacity,
    this.focusNode,
  });

  final Widget child;
  final Duration duration;
  final Curve curve;
  final double scale;
  final double opacity;
  final FocusNode? focusNode;

  @override
  State<_AnimatedFocusStateful> createState() => __AnimatedFocusStatefulState();
}

class __AnimatedFocusStatefulState extends State<_AnimatedFocusStateful> {
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

class AnimatedFadeIn extends ConsumerWidget {
  const AnimatedFadeIn({
    required this.child,
    super.key,
    this.duration,
    this.curve = AppAnimations.fadeCurve,
    this.delay = Duration.zero,
  });

  final Widget child;
  final Duration? duration;
  final Curve curve;
  final Duration delay;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final animationDurations = ref.watch(animationDurationsProvider);
    final effectiveDuration = duration ?? animationDurations.normal;

    return FutureBuilder<void>(
      future: Future.delayed(delay),
      builder: (context, snapshot) {
        return AnimatedOpacity(
          opacity: snapshot.connectionState == ConnectionState.done ? 1.0 : 0.0,
          duration: effectiveDuration,
          curve: curve,
          child: AnimatedScale(
            scale:
                snapshot.connectionState == ConnectionState.done ? 1.0 : 0.95,
            duration: effectiveDuration,
            curve: curve,
            child: child,
          ),
        );
      },
    );
  }
}

class AnimatedSlideIn extends ConsumerWidget {
  const AnimatedSlideIn({
    required this.child,
    super.key,
    this.duration,
    this.curve = AppAnimations.slideCurve,
    this.direction = AxisDirection.up,
    this.distance = 20.0,
    this.delay = Duration.zero,
  });

  final Widget child;
  final Duration? duration;
  final Curve curve;
  final AxisDirection direction;
  final double distance;
  final Duration delay;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final animationDurations = ref.watch(animationDurationsProvider);
    final effectiveDuration = duration ?? animationDurations.normal;

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
          duration: effectiveDuration,
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
    Duration? duration,
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
    Duration? duration,
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
    Duration? duration,
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
    Duration? duration,
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
    Duration? duration,
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

  /// Adds shimmer effect
  Widget withShimmer({
    Duration duration = const Duration(milliseconds: 1500),
    Color? baseColor,
    Color? highlightColor,
    bool enabled = true,
  }) {
    return ShimmerEffect(
      duration: duration,
      baseColor: baseColor,
      highlightColor: highlightColor,
      enabled: enabled,
      child: this,
    );
  }

  /// Adds pulse animation
  Widget withPulse({
    Duration duration = const Duration(milliseconds: 1500),
    double minOpacity = 0.5,
    double maxOpacity = 1.0,
    Curve curve = Curves.easeInOut,
  }) {
    return PulseAnimation(
      duration: duration,
      minOpacity: minOpacity,
      maxOpacity: maxOpacity,
      curve: curve,
      child: this,
    );
  }

  /// Adds success animation
  Widget withSuccessAnimation({
    Duration duration = const Duration(milliseconds: 600),
    Duration delay = Duration.zero,
  }) {
    return SuccessAnimation(
      duration: duration,
      delay: delay,
      child: this,
    );
  }

  /// Adds smooth loading indicator
  Widget withSmoothLoading({
    double size = 24,
    double strokeWidth = 2,
    Color? color,
    Duration duration = const Duration(milliseconds: 1200),
  }) {
    return SmoothLoadingIndicator(
      size: size,
      strokeWidth: strokeWidth,
      color: color,
      duration: duration,
    );
  }
}
