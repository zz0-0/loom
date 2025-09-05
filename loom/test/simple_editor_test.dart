import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loom/shared/presentation/widgets/editor/find_replace_dialog.dart';

void main() {
  group('FindReplaceDialog Tests', () {
    testWidgets('should display basic find dialog',
        (WidgetTester tester) async {
      var findCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FindReplaceDialog(
              onFind: (String text, bool caseSensitive, bool useRegex) {
                findCalled = true;
              },
              onReplace: (
                String find,
                String replace,
                bool caseSensitive,
                bool useRegex,
              ) {},
              onReplaceAll: (
                String find,
                String replace,
                bool caseSensitive,
                bool useRegex,
              ) {},
            ),
          ),
        ),
      );

      // Check if basic components exist
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Find'), findsWidgets);
      expect(find.text('Find Next'), findsOneWidget);

      // Test find functionality
      await tester.enterText(find.byType(TextField), 'hello');
      await tester.tap(find.text('Find Next'));
      await tester.pump();

      expect(findCalled, isTrue);
    });

    testWidgets('should show replace fields when toggled',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FindReplaceDialog(
              onFind: (String text, bool caseSensitive, bool useRegex) {},
              onReplace: (
                String find,
                String replace,
                bool caseSensitive,
                bool useRegex,
              ) {},
              onReplaceAll: (
                String find,
                String replace,
                bool caseSensitive,
                bool useRegex,
              ) {},
            ),
          ),
        ),
      );

      // Initially only one text field (find)
      expect(find.byType(TextField), findsOneWidget);

      // Toggle to show replace
      await tester.tap(find.byIcon(Icons.find_replace));
      await tester.pump();

      // Now should have two text fields
      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.text('Replace'), findsWidgets);
    });
  });
}
