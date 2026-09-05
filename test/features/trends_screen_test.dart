import 'dart:io';
import 'dart:ui';

import 'package:cc_core/cc_core.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:course_ledger/core/export/export_service.dart';
import 'package:course_ledger/data/database/app_database.dart';
import 'package:course_ledger/data/repositories/course_repository.dart';
import 'package:course_ledger/data/repositories/round_repository.dart';
import 'package:course_ledger/features/trends/trends_screen.dart';

import '../helpers.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = makeTestDb());
  tearDown(() => db.close());

  Future<void> seed() async {
    final courses = CourseRepository(db);
    final rounds = RoundRepository(db);
    final mi = await courses.createCourse(
        courseDraft(name: 'Pine Hollow', state: 'MI'));
    final oh = await courses.createCourse(
        courseDraft(name: 'Eagle Crest', state: 'OH'));
    await rounds.createRound(
        mi, roundDraft(date: DateTime(2024, 5, 1), totalScore: 95));
    await rounds.createRound(
        mi, roundDraft(date: DateTime(2026, 6, 1), totalScore: 88));
    await rounds.createRound(oh, roundDraft(date: DateTime(2026, 7, 1)));
  }

  testWidgets('free users see the teaser with restore, not the charts',
      (tester) async {
    await tester.pumpWidget(testApp(db: db, home: const TrendsScreen()));
    await tester.pumpAndSettle();

    expect(find.text('The long arc of your golf.'), findsOneWidget);
    expect(find.text('See Course Ledger Pro'), findsOneWidget);
    expect(find.text('Restore a backup'), findsOneWidget);
    expect(find.text('The played map'), findsNothing);
    await disposeApp(tester);
  });

  testWidgets('Pro trends: counters, played map, yearly bars, gated trend',
      (tester) async {
    tester.view.physicalSize = const Size(800, 2600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await seed();
    await tester.pumpWidget(testApp(
      db: db,
      entitlements: FakeEntitlementService(unlimited: true),
      home: const TrendsScreen(),
    ));
    await tester.pumpAndSettle();

    expect(find.text('2 courses'), findsOneWidget);
    expect(find.text('3 rounds'), findsOneWidget);
    expect(find.text('2 states'), findsOneWidget);
    expect(find.text('1 country'), findsOneWidget);
    expect(find.text('The played map'), findsOneWidget);
    expect(find.text('MI'), findsOneWidget); // a filled tile exists
    expect(find.text('New courses by year'), findsOneWidget);
    expect(find.text('Rounds by year'), findsOneWidget);

    // Only two scored rounds: the trend line stays gated.
    expect(find.textContaining('Log five scored rounds'), findsOneWidget);
    await disposeApp(tester);
  });

  testWidgets('five scored rounds unlock the score trend line',
      (tester) async {
    tester.view.physicalSize = const Size(800, 2600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final courses = CourseRepository(db);
    final rounds = RoundRepository(db);
    final id = await courses.createCourse(courseDraft());
    for (var i = 0; i < 5; i++) {
      await rounds.createRound(id,
          roundDraft(date: DateTime(2026, 1 + i, 1), totalScore: 95 - i));
    }

    await tester.pumpWidget(testApp(
      db: db,
      entitlements: FakeEntitlementService(unlimited: true),
      home: const TrendsScreen(),
    ));
    await tester.pumpAndSettle();

    expect(find.textContaining('Log five scored rounds'), findsNothing);
    expect(find.text('95'), findsOneWidget); // range max label
    expect(find.text('91'), findsOneWidget); // range min label
    await disposeApp(tester);
  });

  test('CSV export includes the joined course and story columns', () async {
    final courses = CourseRepository(db);
    final rounds = RoundRepository(db);
    final id = await courses.createCourse(
        courseDraft(name: 'Pine Hollow', state: 'MI'));
    await rounds.createRound(
      id,
      roundDraft(
        date: DateTime(2026, 6, 15),
        totalScore: 92,
        partners: 'Sam, Dale',
        notes: 'Birdie on 17.',
      ),
    );

    final share = FakeShareLauncher();
    final dir = await Directory.systemTemp.createTemp('cl-export-test');
    addTearDown(() => dir.delete(recursive: true));
    final file = await ExportService(db, share, () async => dir)
        .shareRoundsCsv(now: DateTime(2026, 9, 5));

    expect(share.sharedFiles, [file.path]);
    final doc = parseCsv(await file.readAsString());
    expect(doc.header.first, 'course');
    final row = doc.rows.single;
    expect(row[0], 'Pine Hollow');
    expect(row[4], '2026-06-15');
    expect(row[5], '92');
    expect(doc.rowCell(row, 9), 'Sam, Dale');
    expect(doc.rowCell(row, 12), 'Birdie on 17.');
  });
}
