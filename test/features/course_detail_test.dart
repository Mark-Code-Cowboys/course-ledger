import 'package:flutter_test/flutter_test.dart';

import 'package:course_ledger/data/database/app_database.dart';
import 'package:course_ledger/data/repositories/course_repository.dart';
import 'package:course_ledger/data/repositories/round_repository.dart';
import 'package:course_ledger/features/courses/course_detail_screen.dart';

import '../helpers.dart';

void main() {
  late AppDatabase db;
  late int courseId;

  setUp(() async {
    db = makeTestDb();
    courseId = await CourseRepository(db)
        .createCourse(courseDraft(name: 'Pine Hollow', rating: 4));
  });

  tearDown(() => db.close());

  testWidgets('unplayed course invites the first round', (tester) async {
    await tester.pumpWidget(
        testApp(db: db, home: CourseDetailScreen(courseId: courseId)));
    await tester.pumpAndSettle();

    expect(find.text('Pine Hollow'), findsOneWidget);
    expect(find.text('18 holes'), findsOneWidget);
    expect(find.text('Public'), findsOneWidget);
    expect(find.textContaining('No rounds here yet'), findsOneWidget);
    expect(find.text('First played'), findsNothing);
    await disposeApp(tester);
  });

  testWidgets('played course shows first/last/best and the story preview',
      (tester) async {
    final rounds = RoundRepository(db);
    await rounds.createRound(
      courseId,
      roundDraft(
        date: DateTime(2024, 5, 1),
        totalScore: 92,
        notes: 'Shanked one into the pond on 3, saved par anyway.',
      ),
    );
    await rounds.createRound(
        courseId, roundDraft(date: DateTime(2026, 8, 9), totalScore: 88));

    await tester.pumpWidget(
        testApp(db: db, home: CourseDetailScreen(courseId: courseId)));
    await tester.pumpAndSettle();

    // Each date shows twice: in the stats row and as its round's title.
    expect(find.text('First played'), findsOneWidget);
    expect(find.text('May 1, 2024'), findsNWidgets(2));
    expect(find.text('Last played'), findsOneWidget);
    expect(find.text('Aug 9, 2026'), findsNWidgets(2));
    expect(find.text('Best score'), findsOneWidget);
    expect(find.text('88'), findsNWidgets(2)); // stat + round avatar
    expect(find.textContaining('saved par anyway'), findsOneWidget);
    await disposeApp(tester);
  });
}
