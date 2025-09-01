import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Mock features for testing UI architecture without polluting feature folders
/// These are ONLY for testing - real features should be in their own folders

/// Mock adaptive feature that demonstrates how features should integrate
class MockAdaptiveFeature extends ConsumerWidget {
  const MockAdaptiveFeature({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mock Adaptive Feature',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'This feature adapts automatically to desktop/mobile layouts.',
          ),
          SizedBox(height: 16),
          Text('Features should:'),
          Text('• Use adaptive widgets only'),
          Text('• Not decide UI paradigm'),
          Text('• Work on any layout'),
          Text('• Follow clean architecture'),
        ],
      ),
    );
  }
}

/// Mock document editor for testing
class MockDocumentEditor extends ConsumerWidget {
  const MockDocumentEditor({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.edit_document, size: 16),
              SizedBox(width: 8),
              Text(
                'Mock Document Editor',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text('This is a mock editor that would adapt to:'),
          SizedBox(height: 8),
          Text('Desktop: Full toolbar, keyboard shortcuts, panels'),
          Text('Mobile: Touch-friendly controls, modal sheets'),
          SizedBox(height: 16),
          Expanded(
            child: TextField(
              maxLines: null,
              expands: true,
              decoration: InputDecoration(
                hintText: 'Start typing your document...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Mock knowledge graph feature
class MockKnowledgeGraph extends ConsumerWidget {
  const MockKnowledgeGraph({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.account_tree, size: 16),
              SizedBox(width: 8),
              Text(
                'Mock Knowledge Graph',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.scatter_plot, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text('Interactive Knowledge Graph'),
                    SizedBox(height: 8),
                    Text(
                      'Would show connected nodes and relationships',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Mock search feature
class MockSearchFeature extends ConsumerWidget {
  const MockSearchFeature({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.search, size: 16),
              SizedBox(width: 8),
              Text(
                'Mock Search Feature',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const TextField(
            decoration: InputDecoration(
              hintText: 'Search knowledge base...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.description),
                  title: Text('Search Result ${index + 1}'),
                  subtitle: Text('Mock search result ${index + 1}'),
                  onTap: () {
                    // Mock action
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
