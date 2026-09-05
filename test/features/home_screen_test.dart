import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:course_ledger/data/database/app_database.dart';
import 'package:course_ledger/data/repositories/course_repository.dart';
import 'package:course_ledger/data/repositories/round_repository.dart';
import 'package:course_ledger/features/home/home_screen.dart';

import '../helpers.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = makeTestDb());
  tearDown(() => db.close());

  testWidgets('empty ledger shows the positioning line and Add course',
      (tester) async {
    await tester.pumpWidget(testApp(db: db));
    await tester.pumpAndSettle();

    expect(find.text('The book of everywhere you’ve played.'), findsOneWidget);
    expect(find.text('Add the first course to start your ledger.'),
        findsOneWidget);
    expect(find.text('Add course'), findsOneWidget);
    await disposeApp(tester);
  });

  testWidgets('seeded ledger shows the count headline and free-tier chip',
      (tester) async {
    final courses = CourseRepository(db);
    await courses.createCourse(courseDraft(name: 'Pine Hollow', state: 'MI'));
    await courses.createCourse(courseDraft(name: 'Eagle Crest', state: 'OH'));

    await tester.pumpWidget(testApp(db: db));
    await tester.pumpAndSettle();

    expect(find.text('2 courses · 2 states'), findsOneWidget);
    expect(find.text('2 of 5 free courses used'), findsOneWidget);
    expect(find.textContaining('Not played yet'), findsNWidgets(2));
    await disposeApp(tester);
  });

  testWidgets('Recent sort puts the last-played course first',
      (tester) async {
    final courses = CourseRepository(db);
    final rounds = RoundRepository(db);
    await courses.createCourse(courseDraft(name: 'Alpha', state: 'MI'));
    final recent =
        await courses.createCourse(courseDraft(name: 'Zulu', state: 'MI'));
    await rounds.createRound(
        recent, roundDraft(date: DateTime(2026, 8, 1), totalScore: 90));

    await tester.pumpWidget(testApp(db: db));
    await tester.pumpAndSettle();

    ListTile firstTile() => tester.widgetList<ListTile>(
          find.byType(ListTile),
        ).first;
    expect(((firstTile().title) as Text).data, 'Alpha'); // A-Z default

    await tester.tap(find.text('Recent'));
    await tester.pumpAndSettle();
    expect(((firstTile().title) as Text).data, 'Zulu');
    expect(find.text('Zulu'), findsOneWidget);
    expect(find.textContaining('Last played Aug 1, 2026'), findsOneWidget);
    await disposeApp(tester);
  });

  test('sortSummaries: by-state groups alphabetically, stateless last', () {
    CourseSummary s(String name, String? state) => CourseSummary(
          Course(
            id: name.hashCode,
            name: name,
            state: state,
            country: 'US',
            holes: CourseHoles.h18,
            kind: CourseKind.public,
            createdAt: DateTime(2026),
          ),
          roundCount: 0,
        );
    final sorted = sortSummaries(
      [s('Nomad', null), s('Beta', 'OH'), s('Alpha', 'OH'), s('Cedar', 'MI')],
      CourseSort.byState,
    );
    expect(sorted.map((x) => x.course.name).toList(),
        ['Cedar', 'Alpha', 'Beta', 'Nomad']);
  });

  test('countHeadline handles singulars and missing states', () {
    CourseSummary s(String name, String? state) => CourseSummary(
          Course(
            id: name.hashCode,
            name: name,
            state: state,
            country: 'US',
            holes: CourseHoles.h18,
            kind: CourseKind.public,
            createdAt: DateTime(2026),
          ),
          roundCount: 0,
        );
    expect(countHeadline([s('One', 'MI')]), '1 course · 1 state');
    expect(countHeadline([s('One', null)]), '1 course');
    expect(countHeadline([s('One', 'MI'), s('Two', 'MI'), s('Three', 'OH')]),
        '3 courses · 2 states');
  });
}
