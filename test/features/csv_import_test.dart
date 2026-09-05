import 'package:cc_core/cc_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:course_ledger/data/database/app_database.dart';
import 'package:course_ledger/data/repositories/bucket_list_repository.dart';
import 'package:course_ledger/data/repositories/course_repository.dart';
import 'package:course_ledger/data/repositories/round_repository.dart';
import 'package:course_ledger/features/scan_import/csv_import_screen.dart';
import 'package:course_ledger/features/scan_import/csv_importer.dart';

import '../helpers.dart';

void main() {
  late AppDatabase db;
  late CourseRepository courses;

  setUp(() {
    db = makeTestDb();
    courses = CourseRepository(db);
  });

  tearDown(() => db.close());

  Future<CsvImportReport> import(CsvDocument doc, CsvFieldMapping mapping,
          {bool entitled = true}) =>
      importCsvRounds(
        courses: courses,
        rounds: RoundRepository(db),
        bucketList: BucketListRepository(db),
        doc: doc,
        mapping: mapping,
        entitled: entitled,
      );

  test('mapping guess reads spreadsheet-keeper headers', () {
    final m = CsvFieldMapping.guess(
        ['Course Name', 'Date Played', 'Gross', 'City', 'Who With']);
    expect(m.courseName, 0);
    expect(m.date, 1);
    expect(m.score, 2);
    expect(m.city, 3);
    expect(m.partners, 4);
    expect(m.notes, isNull);
  });

  test('imports rows, matches existing courses, skips unusable rows',
      () async {
    await courses.createCourse(courseDraft(name: 'Pine Hollow'));
    final doc = parseCsv('course,date,score,notes\n'
        'Pine Hollow,6/15/2026,92,windy\n'
        'pine hollow,7/1/2026,88,\n'
        'Eagle Crest,7/4/2026,90,new one\n'
        'No Date Course,,85,\n');
    final report = await import(
        doc, const CsvFieldMapping(courseName: 0, date: 1, score: 2, notes: 3));

    expect(report.roundsAdded, 3);
    expect(report.coursesCreated, 1);
    expect(report.rowsSkipped, 1);
    expect(await courses.count(), 2); // case-insensitive match reused
    final rounds = await db.select(db.rounds).get();
    expect(rounds.map((r) => r.totalScore), containsAll([92, 88, 90]));
    expect(rounds.where((r) => r.notes == 'windy'), hasLength(1));
  });

  test('free users import into existing courses but not past the cap',
      () async {
    for (var i = 0; i < 5; i++) {
      await courses.createCourse(courseDraft(name: 'Course $i'));
    }
    final doc = parseCsv('course,date\n'
        'Course 0,6/15/2026\n'
        'Brand New,6/16/2026\n');
    final report = await import(
        doc, const CsvFieldMapping(courseName: 0, date: 1),
        entitled: false);

    expect(report.roundsAdded, 1);
    expect(report.coursesSkippedAtCap, 1);
    expect(await courses.count(), 5);
  });

  testWidgets('mapping screen imports with adjusted columns',
      (tester) async {
    final doc = parseCsv('when,club,total\n'
        '6/15/2026,Pine Hollow,92\n'
        '7/4/2026,Eagle Crest,88\n');

    // The mapper is pushed over the shell in the app; the snackbar
    // lands on the screen beneath after the pop.
    await tester.pumpWidget(testApp(
      db: db,
      entitlements: FakeEntitlementService(unlimited: true),
      home: Scaffold(
        body: Builder(
          builder: (context) => TextButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                  builder: (_) => CsvImportScreen(doc: doc)),
            ),
            child: const Text('open mapper'),
          ),
        ),
      ),
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.text('open mapper'));
    await tester.pumpAndSettle();

    expect(find.text('2 rows found. Match your columns to the ledger:'),
        findsOneWidget);

    await tester.scrollUntilVisible(find.text('Import'), 100);
    await tester.tap(find.text('Import'));
    await tester.pumpAndSettle();

    expect(find.text('Imported 2 rounds · 2 new courses'), findsOneWidget);
    expect(await tester.runAsync(() => courses.count()), 2);

    await tester.pump(const Duration(seconds: 5)); // snackbar timer
    await disposeApp(tester);
  });
}
