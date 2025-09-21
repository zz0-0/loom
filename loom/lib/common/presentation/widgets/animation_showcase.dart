import 'package:flutter/material.dart';
import 'package:loom/common/index.dart';
import 'package:loom/flutter_gen/gen_l10n/app_localizations.dart';

/// Demo widget showcasing the enhanced UI animations and polish
class AnimationShowcase extends StatelessWidget {
  const AnimationShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.uiPolishShowcase),
        backgroundColor: theme.colorScheme.surfaceContainerHighest,
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.paddingMd,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              localizations.enhancedUiAnimations,
              style: theme.textTheme.headlineMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Loading Indicators Section
            _buildSection(
              context,
              localizations.loadingIndicators,
              [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text(localizations.smoothLoading),
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
                    Column(
                      children: [
                        Text(localizations.skeletonLoader),
                        const SizedBox(height: AppSpacing.sm),
                        const SkeletonLoader(
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
              localizations.interactiveElements,
              [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Hover animation demo
                    Column(
                      children: [
                        Text(localizations.hoverAnimation),
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
                        Text(localizations.pressAnimation),
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
                        Text(localizations.pulseAnimation),
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
              localizations.shimmerEffects,
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
              localizations.successAnimations,
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
                            localizations.taskCompleted,
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
              localizations.animationCombinations,
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
                        child: Text(localizations.interactiveButton),
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
                              localizations.animatedCard,
                              style: theme.textTheme.titleMedium,
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              localizations.animatedCardDescription,
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
