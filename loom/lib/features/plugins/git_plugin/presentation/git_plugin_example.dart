import 'package:flutter/material.dart';
import 'package:loom/features/plugins/git_plugin/domain/git_plugin_registration.dart';

/// Example demonstrating how to use the Git plugin
class GitPluginExample extends StatelessWidget {
  const GitPluginExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Git Plugin Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Git Plugin Demo',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'The Git plugin has been registered and provides:',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            _buildFeatureList(),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => _registerGitPlugin(context),
              child: const Text('Register Git Plugin'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureList() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FeatureItem('Git status sidebar panel'),
        _FeatureItem('Bottom bar status indicator'),
        _FeatureItem('Git commands (commit, push, pull)'),
        _FeatureItem('Keyboard shortcuts'),
        _FeatureItem('Settings integration'),
        _FeatureItem('File change tracking'),
      ],
    );
  }

  Future<void> _registerGitPlugin(BuildContext context) async {
    try {
      await GitPluginRegistration.register(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Git plugin registered successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to register Git plugin: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

class _FeatureItem extends StatelessWidget {
  const _FeatureItem(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 16),
          const SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }
}
