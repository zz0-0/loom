import 'package:flutter/material.dart';

/// Mock feature widget that demonstrates how features should be implemented
/// Features should provide adaptive widgets, not decide UI implementation
class MockAdaptiveFeature extends StatelessWidget {
  final String featureName;
  final String content;
  final VoidCallback? onAction;

  const MockAdaptiveFeature({
    super.key,
    required this.featureName,
    required this.content,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    // Feature returns a simple adaptive widget
    // The main UI (desktop/mobile layout) will decide how to render this
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            featureName,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                content,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
          if (onAction != null) ...[
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onAction,
              child: const Text('Feature Action'),
            ),
          ],
        ],
      ),
    );
  }
}

/// Mock document editor feature (minimal implementation)
class MockDocumentEditor extends StatefulWidget {
  final String initialContent;
  final ValueChanged<String>? onContentChanged;

  const MockDocumentEditor({
    super.key,
    required this.initialContent,
    this.onContentChanged,
  });

  @override
  State<MockDocumentEditor> createState() => _MockDocumentEditorState();
}

class _MockDocumentEditorState extends State<MockDocumentEditor> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialContent);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Simple adaptive editor - the layout decides how to present this
    return TextField(
      controller: _controller,
      maxLines: null,
      expands: true,
      decoration: const InputDecoration(
        hintText: 'Start typing...',
        border: InputBorder.none,
      ),
      onChanged: widget.onContentChanged,
    );
  }
}

/// Mock file explorer feature
class MockFileExplorer extends StatelessWidget {
  final List<String> files;
  final ValueChanged<String>? onFileSelected;

  const MockFileExplorer({
    super.key,
    required this.files,
    this.onFileSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: files.length,
      itemBuilder: (context, index) {
        final file = files[index];
        return ListTile(
          leading: const Icon(Icons.description),
          title: Text(file),
          onTap: () => onFileSelected?.call(file),
        );
      },
    );
  }
}

/// Mock search feature
class MockSearchFeature extends StatefulWidget {
  final ValueChanged<String>? onSearch;

  const MockSearchFeature({
    super.key,
    this.onSearch,
  });

  @override
  State<MockSearchFeature> createState() => _MockSearchFeatureState();
}

class _MockSearchFeatureState extends State<MockSearchFeature> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search...',
            prefixIcon: Icon(Icons.search),
          ),
          onSubmitted: widget.onSearch,
        ),
        const SizedBox(height: 16),
        const Expanded(
          child: Center(
            child: Text('Search results will appear here'),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
