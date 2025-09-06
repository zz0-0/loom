import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loom/shared/presentation/widgets/editor/find_replace_dialog.dart';
import 'package:loom/shared/presentation/widgets/layouts/desktop/core/file_content_provider.dart';

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

  group('TextEditHistory Tests', () {
    test('should track text changes for undo/redo', () {
      final history = TextEditHistory();

      // Initial state
      expect(history.canUndo, isFalse);
      expect(history.canRedo, isFalse);

      // Add first state
      history.addState('Hello');
      expect(history.canUndo, isFalse); // Can't undo first state
      expect(history.canRedo, isFalse);

      // Add second state
      history.addState('Hello World');
      expect(history.canUndo, isTrue);
      expect(history.canRedo, isFalse);

      // Add third state
      history.addState('Hello World!');
      expect(history.canUndo, isTrue);
      expect(history.canRedo, isFalse);

      // Test undo
      final undone = history.undo();
      expect(undone, equals('Hello World'));
      expect(history.canUndo, isTrue);
      expect(history.canRedo, isTrue);

      // Test redo
      final redone = history.redo();
      expect(redone, equals('Hello World!'));
      expect(history.canUndo, isTrue);
      expect(history.canRedo, isFalse);

      // Test undo to beginning
      history
        ..undo() // Back to 'Hello World'
        ..undo(); // Back to 'Hello'
      expect(history.canUndo, isFalse);
      expect(history.canRedo, isTrue);
    });

    test('should limit history size', () {
      final history = TextEditHistory();

      // Add states up to limit
      for (var i = 0; i < 105; i++) {
        history.addState('State $i');
      }

      // Should be able to undo up to the limit
      for (var i = 0; i < 99; i++) {
        expect(history.canUndo, isTrue);
        history.undo();
      }

      // Should not be able to undo beyond the limit
      expect(history.canUndo, isFalse);
    });

    test('should clear redo states when new change is made', () {
      final history = TextEditHistory();

      history
        ..addState('State 1')
        ..addState('State 2')
        ..addState('State 3')

        // Undo twice
        ..undo() // At State 2
        ..undo(); // At State 1

      expect(history.canRedo, isTrue);

      // Add new state - should clear redo history
      history.addState('State 1 Modified');

      expect(history.canRedo, isFalse);
      expect(history.canUndo, isTrue);
    });
  });

  group('Text Selection Tests', () {
    test('should handle text selection for copy/cut operations', () {
      const testText = 'Hello World';
      const selection =
          TextSelection(baseOffset: 6, extentOffset: 11); // "World"

      final selectedText = testText.substring(selection.start, selection.end);
      expect(selectedText, equals('World'));
      expect(selection.isCollapsed, isFalse);
    });

    test('should handle collapsed selection (cursor only)', () {
      const testText = 'Hello World';
      const selection = TextSelection.collapsed(offset: 5);

      expect(selection.isCollapsed, isTrue);
      expect(selection.baseOffset, equals(5));
      expect(testText.length, equals(11)); // Use the testText variable
    });

    test('should handle text replacement with selection', () {
      const originalText = 'Hello World';
      const replacementText = 'Universe';
      const selection =
          TextSelection(baseOffset: 6, extentOffset: 11); // "World"

      final result = originalText.replaceRange(
        selection.start,
        selection.end,
        replacementText,
      );
      expect(result, equals('Hello Universe'));
    });

    test('should handle text insertion at cursor', () {
      const originalText = 'Hello World';
      const insertText = ' Beautiful';
      const cursorPosition = 5;

      final result =
          originalText.replaceRange(cursorPosition, cursorPosition, insertText);
      expect(result, equals('Hello Beautiful World'));
    });
  });

  group('CodeFoldingManager Tests', () {
    test('should parse code blocks for folding', () {
      const testText = '''
# Header 1

Some content here.

```dart
void main() {
  print('Hello');
  print('World');
}
```

More content.

## Header 2

More content here.
''';

      final manager = CodeFoldingManager(testText);

      expect(manager.regions.length, equals(3)); // 1 code block + 2 headers
      expect(manager.regions[0].type, equals(FoldableRegionType.section));
      expect(manager.regions[0].title, equals('Header 1'));
      expect(manager.regions[1].type, equals(FoldableRegionType.codeBlock));
      expect(manager.regions[1].title, equals('dart'));
      expect(manager.regions[2].type, equals(FoldableRegionType.section));
      expect(manager.regions[2].title, equals('Header 2'));
    });

    test('should toggle fold state', () {
      const testText = '''
# Header

Content
''';

      final manager = CodeFoldingManager(testText);
      expect(manager.isRegionFolded(0), isFalse);

      manager.toggleFold(0);
      expect(manager.isRegionFolded(0), isTrue);

      manager.toggleFold(0);
      expect(manager.isRegionFolded(0), isFalse);
    });

    test('should generate folded text', () {
      const testText = '''
# Header

Line 1
Line 2
Line 3

## Subheader

More content
''';

      final manager = CodeFoldingManager(testText);
      manager.toggleFold(0); // Fold the main header

      final foldedText = manager.getFoldedText();
      expect(foldedText.contains('... ('), isTrue);
      expect(foldedText.contains('lines folded)'), isTrue);
    });

    test('should handle empty text', () {
      const testText = '';
      final manager = CodeFoldingManager(testText);

      expect(manager.regions.length, equals(0));
      expect(manager.getFoldedText(), equals(''));
    });

    test('should handle text without foldable regions', () {
      const testText =
          'Just some plain text\nwith multiple lines\nbut no headers or code blocks';
      final manager = CodeFoldingManager(testText);

      expect(manager.regions.length, equals(0));
      expect(manager.getFoldedText(), equals(testText));
    });
  });

  group('Text Indentation Tests', () {
    test('should indent single line without selection', () {
      const originalText = 'Hello World';
      const cursorPosition = 6; // After "Hello "

      // Simulate inserting tab at cursor
      final result =
          originalText.replaceRange(cursorPosition, cursorPosition, '\t');
      expect(result, equals('Hello \tWorld'));
    });

    test('should indent multiple selected lines', () {
      const originalText = 'Line 1\nLine 2\nLine 3';

      // Split and indent each line
      final lines = originalText.split('\n');
      final indentedLines = lines.map((line) => '\t$line').toList();
      final result = indentedLines.join('\n');

      expect(result, equals('\tLine 1\n\tLine 2\n\tLine 3'));
    });

    test('should dedent single line without selection - tab', () {
      const originalText = '\tHello World';

      final result = originalText.substring(1);
      expect(result, equals('Hello World'));
    });

    test('should dedent single line without selection - spaces', () {
      const originalText = '    Hello World';

      final result = originalText.substring(4);
      expect(result, equals('Hello World'));
    });

    test('should dedent multiple selected lines', () {
      const originalText = '\tLine 1\n\tLine 2\n\tLine 3';

      // Split and dedent each line
      final lines = originalText.split('\n');
      final dedentedLines = lines.map((line) => line.substring(1)).toList();
      final result = dedentedLines.join('\n');

      expect(result, equals('Line 1\nLine 2\nLine 3'));
    });

    test('should handle mixed indentation in dedent', () {
      const originalText = '\tLine 1\n  Line 2\n    Line 3\nLine 4';

      // Split and dedent each line
      final lines = originalText.split('\n');
      final dedentedLines = lines.map((line) {
        if (line.startsWith('\t')) {
          return line.substring(1);
        } else if (line.startsWith('    ')) {
          return line.substring(4);
        } else if (line.startsWith('  ')) {
          return line.substring(2);
        } else if (line.startsWith(' ')) {
          return line.substring(1);
        }
        return line;
      }).toList();

      final result = dedentedLines.join('\n');
      expect(result, equals('Line 1\nLine 2\nLine 3\nLine 4'));
    });
  });
}
