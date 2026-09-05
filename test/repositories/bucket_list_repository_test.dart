import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';

import 'package:course_ledger/data/repositories/bucket_list_repository.dart';
import 'package:course_ledger/data/repositories/course_repository.dart';
import 'package:course_ledger/data/repositories/round_repository.dart';
import 'package:course_ledger/data/database/app_database.dart';

import '../helpers.dart';

void main() {
  late AppDatabase db;
  late BucketListRepository repo;

  setUp(() {
    db = makeTestDb();
    repo = BucketListRepository(db);
  });

  tearDown(() => db.close());

  test('an item is a course reference XOR free text — never both, never '
      'neither', () async {
    expect(
      () => db.into(db.bucketList).insert(const BucketListCompanion()),
      throwsA(anything),
    );

    final courseId = await CourseRepository(db).createCourse(courseDraft());
    expect(
      () => db.into(db.bucketList).insert(
            BucketListCompanion.insert(
              courseId: Value(courseId),
              freeText: const Value('Bandon Dunes'),
            ),
          ),
      throwsA(anything),
    );
  });

  test('check-off-on-round-add marks open course items done and links '
      'the round', () async {
    final courses = CourseRepository(db);
    final target = await courses.createCourse(courseDraft(name: 'Target'));
    final other = await courses.createCourse(courseDraft(name: 'Other'));

    final targetItem = await repo.addCourseItem(target);
    final otherItem = await repo.addCourseItem(other);
    final freeItem = await repo.addFreeTextItem('Bandon Dunes someday');

    final roundId =
        await RoundRepository(db, journal: db.journal()).createRound(target, roundDraft());
    final checked = await repo.completeItemsForCourse(target, roundId);

    expect(checked, 1);
    final items = await repo.watchItems().first;
    final byId = {for (final i in items) i.id: i};
    expect(byId[targetItem]!.done, isTrue);
    expect(byId[targetItem]!.doneRoundId, roundId);
    expect(byId[otherItem]!.done, isFalse);
    expect(byId[freeItem]!.done, isFalse);
  });

  test('completeItemsForCourse leaves already-done items linked to their '
      'original round', () async {
    final courseId = await CourseRepository(db).createCourse(courseDraft());
    final item = await repo.addCourseItem(courseId);
    final rounds = RoundRepository(db, journal: db.journal());

    final firstRound = await rounds.createRound(courseId, roundDraft());
    await repo.completeItemsForCourse(courseId, firstRound);
    final secondRound = await rounds.createRound(courseId, roundDraft());
    final checked = await repo.completeItemsForCourse(courseId, secondRound);

    expect(checked, 0);
    final items = await repo.watchItems().first;
    expect(items.single.id, item);
    expect(items.single.doneRoundId, firstRound);
  });

  test('markOpen clears the done round link', () async {
    final courseId = await CourseRepository(db).createCourse(courseDraft());
    final item = await repo.addCourseItem(courseId);
    final roundId =
        await RoundRepository(db, journal: db.journal()).createRound(courseId, roundDraft());
    await repo.markDone(item, roundId: roundId);

    await repo.markOpen(item);

    final stored = (await repo.watchItems().first).single;
    expect(stored.done, isFalse);
    expect(stored.doneRoundId, isNull);
  });

  test('watchItems lists open items before done ones', () async {
    await repo.addFreeTextItem('open one');
    final doneItem = await repo.addFreeTextItem('done one');
    await repo.markDone(doneItem);
    await repo.addFreeTextItem('open two');

    final items = await repo.watchItems().first;
    expect(items.map((i) => i.freeText),
        ['open one', 'open two', 'done one']);
  });

  test('deleting the course removes its bucket item; deleting the done '
      'round keeps the item but clears the link', () async {
    final courses = CourseRepository(db);
    final courseId = await courses.createCourse(courseDraft());
    final item = await repo.addCourseItem(courseId);
    final rounds = RoundRepository(db, journal: db.journal());
    final roundId = await rounds.createRound(courseId, roundDraft());
    await repo.markDone(item, roundId: roundId);

    await rounds.deleteRound(roundId);
    var stored = (await repo.watchItems().first).single;
    expect(stored.done, isTrue);
    expect(stored.doneRoundId, isNull);

    await courses.deleteCourse(courseId);
    expect(await repo.watchItems().first, isEmpty);
  });
}
