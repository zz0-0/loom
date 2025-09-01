import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loom/shared/presentation/widgets/layouts/adaptive/adaptive_main_layout.dart';
import 'mock_features.dart';

/// Simplified test app for validating UI architecture
/// This tests the adaptive layout without complex dependencies
class UIArchitectureTestApp extends StatelessWidget {
  const UIArchitectureTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'UI Architecture Test',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.dark,
          ),
        ),
        home: const TestHomePage(),
      ),
    );
  }
}

/// Test home page that uses adaptive layout
class TestHomePage extends ConsumerWidget {
  const TestHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      appBar: null,
      body: AdaptiveMainLayout(),
    );
  }
}

/// Simple feature integration test page
class FeatureIntegrationTestPage extends StatelessWidget {
  const FeatureIntegrationTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Feature Integration Test'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.home), text: 'Adaptive'),
              Tab(icon: Icon(Icons.edit), text: 'Editor'),
              Tab(icon: Icon(Icons.search), text: 'Search'),
              Tab(icon: Icon(Icons.account_tree), text: 'Graph'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            MockAdaptiveFeature(),
            MockDocumentEditor(),
            MockSearchFeature(),
            MockKnowledgeGraph(),
          ],
        ),
      ),
    );
  }
}
