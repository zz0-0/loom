import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/common/index.dart';
import 'package:loom/features/core/settings/index.dart';

/// Test widget to verify animation speed changes
class AnimationSpeedTest extends ConsumerWidget {
  const AnimationSpeedTest({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final animationDurations = ref.watch(animationDurationsProvider);
    final appearanceSettings = ref.watch(appearanceSettingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Animation Speed Test'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Current Animation Speed: ${appearanceSettings.animationSpeed}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            Text(
              'Fast Duration: ${animationDurations.fast.inMilliseconds}ms\n'
              'Normal Duration: ${animationDurations.normal.inMilliseconds}ms\n'
              'Slow Duration: ${animationDurations.slow.inMilliseconds}ms\n'
              'Slower Duration: ${animationDurations.slower.inMilliseconds}ms',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 40),
            // Test button with hover animation
            AnimatedHover(
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Hover Me (Fast Animation)'),
              ),
            ),
            const SizedBox(height: 20),
            // Test fade in animation
            AnimatedFadeIn(
              child: Container(
                padding: const EdgeInsets.all(16),
                color: Theme.of(context).colorScheme.primaryContainer,
                child: const Text('Fade In Animation (Normal Speed)'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
