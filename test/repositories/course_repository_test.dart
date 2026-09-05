import 'package:flutter_test/flutter_test.dart';

import 'package:course_ledger/data/database/app_database.dart';
import 'package:course_ledger/data/repositories/course_repository.dart';
import 'package:course_ledger/data/repositories/round_repository.dart';

import '../helpers.dart';

void main() {
  late AppDatabase db;
  late CourseRepository repo;

  setUp(() {
    db = makeTestDb();
    repo = CourseRepository(db);
  });

  tearDown(() => db.close());

  test('createCourse stores fields and count feeds the free limit', () async {
    await repo.createCourse(courseDraft(name: 'Pine Hollow', rating: 4));
    await repo.createCourse(courseDraft(name: 'Eagle Crest', state: 'OH'));

    expect(await repo.count(), 2);
    final courses = await repo.watchCourses().first;
    final pine = courses.singleWhere((c) => c.name == 'Pine Hollow');
    expect(pine.country, 'US');
    expect(pine.holes, CourseHoles.h18);
    expect(pine.kind, CourseKind.public);
    expect(pine.rating, 4);
    expect(pine.lat, isNull);
  });

  test('watchCourses orders A-Z, case-insensitively', () async {
    await repo.createCourse(courseDraft(name: 'birch run'));
    await repo.createCourse(courseDraft(name: 'Augusta Municipal'));
    await repo.createCourse(courseDraft(name: 'Cedar Bend'));

    final names =
        (await repo.watchCourses().first).map((c) => c.name).toList();
    expect(names, ['Augusta Municipal', 'birch run', 'Cedar Bend']);
  });

  test('rating outside 1-5 is rejected by the schema', () async {
    expect(
      () => repo.createCourse(courseDraft(rating: 6)),
      throwsA(anything),
    );
  });

  test('watchStats is empty for an unplayed course', () async {
    final id = await repo.createCourse(courseDraft());

    final stats = await repo.watchStats(id).first;
    expect(stats.roundCount, 0);
    expect(stats.firstPlayed, isNull);
    expect(stats.lastPlayed, isNull);
    expect(stats.bestScore, isNull);
  });

  test('watchStats computes first/last played and best score', () async {
    final id = await repo.createCourse(courseDraft());
    final rounds = RoundRepository(db);
    await rounds.createRound(
        id, roundDraft(date: DateTime(2024, 5, 1), totalScore: 92));
    await rounds.createRound(
        id, roundDraft(date: DateTime(2026, 8, 9), totalScore: 88));
    await rounds.createRound(id, roundDraft(date: DateTime(2025, 7, 4)));

    final stats = await repo.watchStats(id).first;
    expect(stats.roundCount, 3);
    expect(stats.firstPlayed, DateTime(2024, 5, 1));
    expect(stats.lastPlayed, DateTime(2026, 8, 9));
    expect(stats.bestScore, 88);
  });

  test('deleteCourse cascades its rounds', () async {
    final id = await repo.createCourse(courseDraft());
    await RoundRepository(db).createRound(id, roundDraft());

    await repo.deleteCourse(id);

    expect(await repo.count(), 0);
    expect(await db.select(db.rounds).get(), isEmpty);
  });
}
