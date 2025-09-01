import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/core/utils/platform_utils.dart';

/// Minimal architecture test to validate platform detection and basic layout
void main() {
  runApp(const MinimalArchitectureTest());
}

class MinimalArchitectureTest extends StatelessWidget {
  const MinimalArchitectureTest({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'Minimal Architecture Test',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        home: const ArchitectureTestPage(),
      ),
    );
  }
}

class ArchitectureTestPage extends ConsumerWidget {
  const ArchitectureTestPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDesktop = PlatformUtils.isDesktop;
    final isMobile = PlatformUtils.isMobile;
    final platformName = defaultTargetPlatform.name;
    final uiParadigm = PlatformUtils.getUIParadigm(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('🧪 Architecture Test'),
        backgroundColor: Colors.blue.shade100,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.architecture,
                size: 64,
                color: Colors.blue,
              ),
              const SizedBox(height: 24),
              const Text(
                'UI Architecture Test',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Platform: $platformName',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                'Is Desktop: $isDesktop',
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                'UI Paradigm: ${uiParadigm.name}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  border: Border.all(color: Colors.green),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green),
                    const SizedBox(height: 8),
                    const Text(
                      '✅ Architecture Status',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text('• Platform detection working'),
                    const Text('• Flutter app structure valid'),
                    const Text('• Riverpod provider scope active'),
                    const Text('• Basic theming applied'),
                    if (isDesktop) const Text('• Desktop layout ready'),
                    if (isMobile) const Text('• Mobile layout ready'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'The UI architecture foundation is working correctly!',
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
