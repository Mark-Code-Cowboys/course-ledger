import 'package:flutter_test/flutter_test.dart';

import 'package:course_ledger/data/database/app_database.dart';
import 'package:course_ledger/data/repositories/course_repository.dart';
import 'package:course_ledger/data/repositories/round_repository.dart';

import '../helpers.dart';

void main() {
  late AppDatabase db;
  late RoundRepository repo;
  late int courseId;

  setUp(() async {
    db = makeTestDb();
    repo = RoundRepository(db);
    courseId = await CourseRepository(db).createCourse(courseDraft());
  });

  tearDown(() => db.close());

  test('createRound stores the round and its photos atomically', () async {
    final roundId = await repo.createRound(
      courseId,
      roundDraft(
        totalScore: 91,
        partners: 'Sam, Dale',
        notes: 'Birdie on 17 into the wind.',
        photos: const [
          RoundPhotoDraft(path: 'cards/0001.jpg', caption: 'the card'),
          RoundPhotoDraft(path: 'views/0001.jpg', caption: 'view from 18'),
        ],
      ),
    );

    final stored = await repo.watchRound(roundId).first;
    expect(stored?.round.totalScore, 91);
    expect(stored?.round.partners, 'Sam, Dale');
    expect(stored?.round.holesPlayed, HolesPlayed.eighteen);
    expect(stored?.round.notes, 'Birdie on 17 into the wind.');
    expect(stored?.photos.map((p) => p.caption),
        ['the card', 'view from 18']);
  });

  test('watchRoundsForCourse lists newest first with photos', () async {
    await repo.createRound(courseId, roundDraft(date: DateTime(2025, 4, 1)));
    final newest = await repo.createRound(
      courseId,
      roundDraft(
        date: DateTime(2026, 9, 1),
        photos: const [RoundPhotoDraft(path: 'p.jpg')],
      ),
    );

    final rounds = await repo.watchRoundsForCourse(courseId).first;
    expect(rounds, hasLength(2));
    expect(rounds.first.round.id, newest);
    expect(rounds.first.photos, hasLength(1));
    expect(rounds.last.photos, isEmpty);
  });

  test('updateRound rewrites fields', () async {
    final roundId = await repo.createRound(courseId, roundDraft());

    await repo.updateRound(
      roundId,
      roundDraft(
        date: DateTime(2026, 6, 16),
        totalScore: 84,
        holesPlayed: HolesPlayed.nine,
        partners: 'Alex',
      ),
    );

    final stored = await repo.watchRound(roundId).first;
    expect(stored?.round.totalScore, 84);
    expect(stored?.round.holesPlayed, HolesPlayed.nine);
    expect(stored?.round.partners, 'Alex');
    expect(stored?.round.date, DateTime(2026, 6, 16));
  });

  test('deleteRound cascades its photo rows', () async {
    final roundId = await repo.createRound(
      courseId,
      roundDraft(photos: const [RoundPhotoDraft(path: 'p.jpg')]),
    );

    await repo.deleteRound(roundId);

    expect(await repo.watchRound(roundId).first, isNull);
    expect(await db.select(db.roundPhotos).get(), isEmpty);
  });

  test('addPhoto and deletePhoto manage attachments one at a time',
      () async {
    final roundId = await repo.createRound(courseId, roundDraft());

    final photoId =
        await repo.addPhoto(roundId, const RoundPhotoDraft(path: 'p.jpg'));
    expect((await repo.watchRound(roundId).first)?.photos, hasLength(1));

    await repo.deletePhoto(photoId);
    expect((await repo.watchRound(roundId).first)?.photos, isEmpty);
  });
}
