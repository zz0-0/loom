import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loom/features/export/presentation/widgets/export_dialog.dart';

void main() {
  Widget createTestWidget({
    required String content,
    required String fileName,
  }) {
    return ProviderScope(
      child: MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () {
                showDialog<void>(
                  context: context,
                  builder: (context) => ExportDialog(
                    content: content,
                    fileName: fileName,
                  ),
                );
              },
              child: const Text('Show Dialog'),
            ),
          ),
        ),
      ),
    );
  }

  group('ExportDialog', () {
    const testContent = 'Test content';
    const testFileName = 'test.txt';

    testWidgets('displays dialog with correct title', (tester) async {
      await tester.pumpWidget(createTestWidget(
        content: testContent,
        fileName: testFileName,
      ),);

      // Open the dialog
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Check dialog title
      expect(find.text('Export Document'), findsOneWidget);
    });

    testWidgets('displays file name', (tester) async {
      await tester.pumpWidget(createTestWidget(
        content: testContent,
        fileName: testFileName,
      ),);

      // Open the dialog
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Check file name display
      expect(find.text('File: test.txt'), findsOneWidget);
    });

    testWidgets('displays format selection section', (tester) async {
      await tester.pumpWidget(createTestWidget(
        content: testContent,
        fileName: testFileName,
      ),);

      // Open the dialog
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Check format section
      expect(find.text('Export Format'), findsOneWidget);
      expect(find.text('Plain Text'), findsOneWidget);
      expect(find.text('HTML'), findsOneWidget);
      expect(find.text('PDF'), findsOneWidget);
    });

    testWidgets('displays options section', (tester) async {
      await tester.pumpWidget(createTestWidget(
        content: testContent,
        fileName: testFileName,
      ),);

      // Open the dialog
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Check options section
      expect(find.text('Options'), findsOneWidget);
      expect(find.text('Include line numbers'), findsOneWidget);
      expect(find.text('Include syntax highlighting'), findsOneWidget);
    });

    testWidgets('displays save location section', (tester) async {
      await tester.pumpWidget(createTestWidget(
        content: testContent,
        fileName: testFileName,
      ),);

      // Open the dialog
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Check save location section
      expect(find.text('Save Location'), findsOneWidget);
      expect(find.text('Choose...'), findsOneWidget);
    });

    testWidgets('displays action buttons', (tester) async {
      await tester.pumpWidget(createTestWidget(
        content: testContent,
        fileName: testFileName,
      ),);

      // Open the dialog
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Check action buttons
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Export'), findsOneWidget);
    });

    testWidgets('can close dialog with cancel button', (tester) async {
      await tester.pumpWidget(createTestWidget(
        content: testContent,
        fileName: testFileName,
      ),);

      // Open the dialog
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Tap cancel button
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      // Dialog should be closed
      expect(find.text('Export Document'), findsNothing);
    });

    testWidgets('can close dialog with close icon', (tester) async {
      await tester.pumpWidget(createTestWidget(
        content: testContent,
        fileName: testFileName,
      ),);

      // Open the dialog
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Tap close icon
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      // Dialog should be closed
      expect(find.text('Export Document'), findsNothing);
    });
  });
}
