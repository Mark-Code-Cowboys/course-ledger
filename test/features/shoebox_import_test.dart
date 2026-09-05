import 'package:cc_core/cc_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:course_ledger/data/database/app_database.dart';
import 'package:course_ledger/data/repositories/bucket_list_repository.dart';
import 'package:course_ledger/data/repositories/course_repository.dart';

import '../helpers.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = makeTestDb());
  tearDown(() => db.close());

  OcrLine line(String text, {double top = 0, double height = 20}) =>
      OcrLine(text, left: 0, top: top, height: height);

  List<OcrLine> card(String name, {String? date, int? total}) => [
        line('$name GOLF CLUB', top: 5, height: 40),
        if (date != null) line('Date $date', top: 100),
        line('TOTAL ${total ?? ''}', top: 400),
      ];

  Future<void> openShoebox(WidgetTester tester) async {
    await tester.tap(find.byTooltip('Import rounds'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Scan scorecards'));
    await tester.pumpAndSettle();
  }

  testWidgets('shoebox: scan, review, uncheck one, bulk insert',
      (tester) async {
    // "Pine Hollow" already exists — its card must match, not duplicate.
    final courses = CourseRepository(db);
    final existing = await courses
        .createCourse(courseDraft(name: 'Pine Hollow Golf Club'));
    await BucketListRepository(db).addCourseItem(existing);

    await tester.pumpWidget(testApp(
      db: db,
      entitlements: FakeEntitlementService(unlimited: true),
      scanner: FakeDocumentScanService(['a.jpg', 'b.jpg', 'c.jpg']),
      recognizer: FakeTextRecognitionService(linesByPath: {
        'a.jpg': card('PINE HOLLOW', date: '6/15/2026', total: 92),
        'b.jpg': card('EAGLE CREST', date: '7/4/2026', total: 88),
        'c.jpg': card('WRONG SPORT'),
      }),
    ));
    await tester.pumpAndSettle();
    await openShoebox(tester);

    // Review screen shows the transcriptions verbatim.
    expect(find.text('Scanned scorecards'), findsOneWidget);
    expect(find.text('Pine Hollow Golf Club'), findsOneWidget);
    expect(find.text('Jun 15, 2026 · Score 92'), findsOneWidget);
    expect(find.text('Eagle Crest Golf Club'), findsOneWidget);
    expect(find.text('No date · No score'), findsOneWidget);

    // Uncheck the card that doesn't belong.
    await tester.tap(find.byType(Checkbox).last);
    await tester.pumpAndSettle();
    expect(find.text('Add 2 rounds'), findsOneWidget);

    await tester.tap(find.text('Add 2 rounds'));
    await tester.pumpAndSettle();

    // Back home: one matched course, one new, none for the unchecked.
    expect(find.text('Added 2 rounds · 1 new course'), findsOneWidget);
    expect(await courses.count(), 2);
    final rounds = await db.select(db.rounds).get();
    expect(rounds, hasLength(2));

    // The existing course's bucket item got checked off by its round.
    final bucket = await tester
        .runAsync(() => BucketListRepository(db).watchItems().first);
    expect(bucket!.single.done, isTrue);

    await tester.pump(const Duration(seconds: 5)); // snackbar timer
    await disposeApp(tester);
  });

  testWidgets('editing a card in review fixes a misread before insert',
      (tester) async {
    await tester.pumpWidget(testApp(
      db: db,
      entitlements: FakeEntitlementService(unlimited: true),
      scanner: FakeDocumentScanService(['a.jpg']),
      recognizer: FakeTextRecognitionService(linesByPath: {
        'a.jpg': card('PINE HOLIOW', total: 92), // OCR misread
      }),
    ));
    await tester.pumpAndSettle();
    await openShoebox(tester);

    await tester.tap(find.byTooltip('Edit card'));
    await tester.pumpAndSettle();
    await tester.enterText(
        find.widgetWithText(TextField, 'Course name'), 'Pine Hollow');
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();
    expect(find.text('Pine Hollow'), findsOneWidget);

    await tester.tap(find.text('Add 1 round'));
    await tester.pumpAndSettle();

    final course = await tester.runAsync(
        () => CourseRepository(db).watchCourses().first);
    expect(course!.single.name, 'Pine Hollow');

    await tester.pump(const Duration(seconds: 5)); // snackbar timer
    await disposeApp(tester);
  });

  testWidgets('the shoebox is a Pro feature — free users get the paywall',
      (tester) async {
    await tester.pumpWidget(testApp(db: db));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Import rounds'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Scan scorecards'));
    await tester.pumpAndSettle();

    expect(find.text('Course Ledger Pro'), findsOneWidget);
    expect(find.text('Scanned scorecards'), findsNothing);
    await disposeApp(tester);
  });
}
