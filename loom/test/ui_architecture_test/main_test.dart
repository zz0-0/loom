import 'package:flutter/material.dart';
import 'test_app.dart';

/// Main entry point for UI architecture testing
/// Run this to test the adaptive layout without affecting real features
void main() {
  runApp(const UIArchitectureTestApp());
}

/// Alternative test runner for specific scenarios
class UITestRunner {
  /// Test desktop layout specifically
  static void testDesktopLayout() {
    runApp(const MaterialApp(
      home: DesktopLayoutTestPage(),
      debugShowCheckedModeBanner: false,
    ));
  }

  /// Test mobile layout specifically
  static void testMobileLayout() {
    runApp(const MaterialApp(
      home: MobileLayoutTestPage(),
      debugShowCheckedModeBanner: false,
    ));
  }

  /// Test feature integration
  static void testFeatureIntegration() {
    runApp(const MaterialApp(
      home: FeatureIntegrationTestPage(),
      debugShowCheckedModeBanner: false,
    ));
  }
}

/// Desktop-specific test page
class DesktopLayoutTestPage extends StatelessWidget {
  const DesktopLayoutTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Desktop Layout Test'),
        backgroundColor: Colors.blue,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.desktop_windows, size: 64),
            SizedBox(height: 16),
            Text(
              'Desktop Layout Test',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Testing VSCode-like desktop interface'),
            SizedBox(height: 32),
            Text('Features to test:'),
            Text('• Sidebar with icons'),
            Text('• Collapsible side panels'),
            Text('• Top menu bar'),
            Text('• Status bar'),
            Text('• Keyboard shortcuts'),
            Text('• Right-click context menus'),
          ],
        ),
      ),
    );
  }
}

/// Mobile-specific test page
class MobileLayoutTestPage extends StatelessWidget {
  const MobileLayoutTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mobile Layout Test'),
        backgroundColor: Colors.green,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.phone_android, size: 64),
            SizedBox(height: 16),
            Text(
              'Mobile Layout Test',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Testing mobile-friendly interface'),
            SizedBox(height: 32),
            Text('Features to test:'),
            Text('• Bottom navigation'),
            Text('• Drawer navigation'),
            Text('• Touch-friendly buttons'),
            Text('• Modal bottom sheets'),
            Text('• Swipe gestures'),
            Text('• Full-screen editing'),
          ],
        ),
      ),
      drawer: const Drawer(
        child: Center(
          child: Text('Mobile Navigation Drawer'),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit),
            label: 'Edit',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
