import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:course_ledger/data/database/app_database.dart';

import '../helpers.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = makeTestDb());
  tearDown(() => db.close());

  Future<void> openBucketTab(WidgetTester tester) async {
    await tester.pumpWidget(testApp(db: db));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Bucket list'));
    await tester.pumpAndSettle();
  }

  testWidgets('empty bucket list explains the check-off linkage',
      (tester) async {
    await openBucketTab(tester);

    expect(find.text('The courses you haven’t played yet.'), findsOneWidget);
    expect(find.textContaining('checks itself off'), findsOneWidget);
    await disposeApp(tester);
  });

  testWidgets('a wish can be added as free text and checked off by hand',
      (tester) async {
    await openBucketTab(tester);

    await tester.tap(find.text('Add a wish'));
    await tester.pumpAndSettle();
    await tester.enterText(
        find.widgetWithText(TextField, 'Course you want to play'),
        'Bandon Dunes');
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    expect(find.text('Bandon Dunes'), findsOneWidget);

    await tester.tap(find.byType(CheckboxListTile));
    await tester.pumpAndSettle();
    final title = tester.widget<Text>(find.text('Bandon Dunes'));
    expect(title.style?.decoration, TextDecoration.lineThrough);
    await disposeApp(tester);
  });

  testWidgets('add course flow from the shell lands in the ledger',
      (tester) async {
    await tester.pumpWidget(testApp(db: db));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add course'));
    await tester.pumpAndSettle();
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Course name'), 'Cedar Bend');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Cedar Bend'), findsOneWidget);
    expect(find.text('1 course'), findsOneWidget);
    await disposeApp(tester);
  });
}
