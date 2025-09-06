import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loom/shared/presentation/widgets/editor/find_replace_dialog.dart';

void main() {
  group('FindReplaceDialog Tests', () {
    testWidgets('should show find dialog', (WidgetTester tester) async {
      var findCalled = false;
      var searchText = '';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FindReplaceDialog(
              onFind: (String text, bool caseSensitive, bool useRegex) {
                findCalled = true;
                searchText = text;
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
              initialSearchText: 'test',
            ),
          ),
        ),
      );

      // Check if the dialog is displayed by finding the close button
      expect(find.byIcon(Icons.close), findsOneWidget);

      // Check if the initial text is set
      expect(find.text('test'), findsOneWidget);

      // Test find functionality
      await tester.enterText(find.byType(TextField).first, 'hello');
      await tester.tap(find.text('Find Next'));
      await tester.pump();

      expect(findCalled, isTrue);
      expect(searchText, equals('hello'));
    });

    testWidgets('should toggle case sensitivity', (WidgetTester tester) async {
      var caseSensitive = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FindReplaceDialog(
              onFind: (String text, bool cs, bool useRegex) {
                caseSensitive = cs;
              },
              onReplace:
                  (String find, String replace, bool cs, bool useRegex) {},
              onReplaceAll:
                  (String find, String replace, bool cs, bool useRegex) {},
            ),
          ),
        ),
      );

      // Toggle case sensitivity
      await tester.tap(find.byType(Checkbox).first);
      await tester.pump();

      // Trigger find to check the state
      await tester.enterText(find.byType(TextField).first, 'test');
      await tester.tap(find.text('Find Next'));
      await tester.pump();

      expect(caseSensitive, isTrue);
    });

    testWidgets('should perform replace operation',
        (WidgetTester tester) async {
      var replaceCalled = false;
      var findText = '';
      var replaceText = '';

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
              ) {
                replaceCalled = true;
                findText = find;
                replaceText = replace;
              },
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

      // Switch to replace mode first
      await tester.tap(find.byIcon(Icons.find_replace));
      await tester.pump();

      // Enter find and replace text
      final textFields = find.byType(TextField);
      await tester.enterText(textFields.first, 'old');
      await tester.enterText(textFields.at(1), 'new');

      // Tap replace button
      await tester.tap(find.text('Replace'));
      await tester.pump();

      expect(replaceCalled, isTrue);
      expect(findText, equals('old'));
      expect(replaceText, equals('new'));
    });
  });
}
