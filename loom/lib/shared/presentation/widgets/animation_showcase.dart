import 'package:flutter/material.dart';
import 'package:loom/shared/presentation/theme/app_animations.dart';
import 'package:loom/shared/presentation/theme/app_theme.dart';

/// Demo widget showcasing the enhanced UI animations and polish
class AnimationShowcase extends StatelessWidget {
  const AnimationShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('UI Polish Showcase'),
        backgroundColor: theme.colorScheme.surfaceContainerHighest,
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.paddingMd,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Enhanced UI Animations',
              style: theme.textTheme.headlineMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Loading Indicators Section
            _buildSection(
              context,
              'Loading Indicators',
              [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        const Text('Smooth Loading'),
                        const SizedBox(height: AppSpacing.sm),
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHighest,
                            borderRadius: AppRadius.radiusMd,
                          ),
                          child: const SmoothLoadingIndicator(),
                        ),
                      ],
                    ),
                    const Column(
                      children: [
                        Text('Skeleton Loader'),
                        SizedBox(height: AppSpacing.sm),
                        SkeletonLoader(
                          width: 120,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.lg),

            // Interactive Elements Section
            _buildSection(
              context,
              'Interactive Elements',
              [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Hover animation demo
                    Column(
                      children: [
                        const Text('Hover Animation'),
                        const SizedBox(height: AppSpacing.sm),
                        Container(
                          padding: AppSpacing.paddingMd,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHighest,
                            borderRadius: AppRadius.radiusMd,
                          ),
                          child: const Icon(Icons.star_border)
                              .withHoverAnimation(),
                        ),
                      ],
                    ),

                    // Press animation demo
                    Column(
                      children: [
                        const Text('Press Animation'),
                        const SizedBox(height: AppSpacing.sm),
                        Container(
                          padding: AppSpacing.paddingMd,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer,
                            borderRadius: AppRadius.radiusMd,
                          ),
                          child:
                              const Icon(Icons.touch_app).withPressAnimation(),
                        ),
                      ],
                    ),

                    // Pulse animation demo
                    Column(
                      children: [
                        const Text('Pulse Animation'),
                        const SizedBox(height: AppSpacing.sm),
                        Container(
                          padding: AppSpacing.paddingMd,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.secondaryContainer,
                            borderRadius: AppRadius.radiusMd,
                          ),
                          child: const Icon(Icons.notifications_active)
                              .withPulse(minOpacity: 0.3),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.lg),

            // Shimmer Effects Section
            _buildSection(
              context,
              'Shimmer Effects',
              [
                Container(
                  padding: AppSpacing.paddingMd,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: AppRadius.radiusMd,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: AppRadius.radiusSm,
                        ),
                        child: const Icon(Icons.image),
                      ).withShimmer(),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              height: 16,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surface,
                                borderRadius: AppRadius.radiusXs,
                              ),
                            ).withShimmer(),
                            const SizedBox(height: AppSpacing.xs),
                            Container(
                              width: 200,
                              height: 12,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surface,
                                borderRadius: AppRadius.radiusXs,
                              ),
                            ).withShimmer(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.lg),

            // Success Animations Section
            _buildSection(
              context,
              'Success Animations',
              [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: AppSpacing.paddingMd,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: AppRadius.radiusMd,
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle, color: Colors.green)
                              .withSuccessAnimation(),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            'Task Completed!',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.lg),

            // Animation Combinations Section
            _buildSection(
              context,
              'Animation Combinations',
              [
                Container(
                  padding: AppSpacing.paddingMd,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: AppRadius.radiusMd,
                  ),
                  child: Column(
                    children: [
                      // Button with multiple animations
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: theme.colorScheme.onPrimary,
                          padding: AppSpacing.paddingHorizontalMd,
                          shape: const RoundedRectangleBorder(
                            borderRadius: AppRadius.radiusMd,
                          ),
                        ),
                        child: const Text('Interactive Button'),
                      )
                          .withHoverAnimation(scale: 1.05)
                          .withPressAnimation(scale: 0.95),

                      const SizedBox(height: AppSpacing.md),

                      // Card with fade-in and slide-in
                      Container(
                        padding: AppSpacing.paddingMd,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: AppRadius.radiusMd,
                          border: Border.all(
                            color: theme.colorScheme.outline.withOpacity(0.2),
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Animated Card',
                              style: theme.textTheme.titleMedium,
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              'This card demonstrates fade-in and slide-in animations combined.',
                              style: theme.textTheme.bodySmall,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                          .withFadeInAnimation(
                            delay: const Duration(milliseconds: 200),
                          )
                          .withSlideInAnimation(
                            distance: 30,
                            delay: const Duration(milliseconds: 100),
                          ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        ...children,
      ],
    );
  }
}
