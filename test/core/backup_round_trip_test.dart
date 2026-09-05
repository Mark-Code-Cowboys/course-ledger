import 'dart:io';

import 'package:cc_core/cc_core.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:course_ledger/core/backup/backup_service.dart';
import 'package:course_ledger/data/repositories/bucket_list_repository.dart';
import 'package:course_ledger/data/repositories/course_repository.dart';
import 'package:course_ledger/data/repositories/round_repository.dart';

import '../helpers.dart';

void main() {
  test('backup archive round-trips the whole ledger and the tally',
      () async {
    final source = makeTestDb();
    addTearDown(source.close);
    final courses = CourseRepository(source);
    final rounds = RoundRepository(source, journal: source.journal());
    final bucket = BucketListRepository(source);

    final pineId = await courses.createCourse(courseDraft(
        name: 'Pine Hollow', state: 'MI', rating: 4));
    await courses.createCourse(courseDraft(name: 'Eagle Crest', state: 'OH'));
    final roundId = await rounds.createRound(
      pineId,
      roundDraft(
        date: DateTime(2026, 6, 15),
        totalScore: 92,
        partners: 'Sam',
        notes: 'Birdie on 17.',
        photos: const [JournalPhotoDraft(path: 'cards/1.jpg', caption: 'card')],
      ),
    );
    final item = await bucket.addCourseItem(pineId);
    await bucket.markDone(item, roundId: roundId);
    await bucket.addFreeTextItem('Bandon Dunes');

    // Lifetime figure larger than the row count (a deleted course).
    final bytes = buildBackupArchive(
      exportData: await buildExportData(source,
          lifetimeCourses: 7, now: DateTime(2026, 9, 5)),
      media: {
        '1.jpg': [1, 2, 3],
      },
    );

    // Restore into a fresh database, as after a reinstall.
    final target = makeTestDb();
    addTearDown(target.close);
    final tally = LifetimeTally(InMemoryKeyValueStore(),
        key: 'courses_created_lifetime');
    addTearDown(tally.dispose);

    final contents = readBackupArchive(bytes);
    expect(contents.media['1.jpg'], [1, 2, 3]);
    final lifetime = await restoreFromExportData(target, contents.exportData);
    await tally.raiseTo(lifetime);

    expect(await tally.value(), 7);
    final restored = await buildExportData(target,
        lifetimeCourses: 7, now: DateTime(2026, 9, 5));
    expect(restored, contents.exportData);

    // Spot checks through the repositories.
    final restoredCourses = CourseRepository(target);
    expect(await restoredCourses.count(), 2);
    final stats = await restoredCourses.watchStats(pineId).first;
    expect(stats.bestScore, 92);
    final items = await BucketListRepository(target).watchItems().first;
    expect(items, hasLength(2));
    expect(items.map((i) => i.done), containsAll([true, false]));
  });

  test('restore rejects foreign or malformed exports', () async {
    final db = makeTestDb();
    addTearDown(db.close);
    expect(
      () => restoreFromExportData(db, {'app': 'TableEncore', 'format': 1}),
      throwsA(isA<InvalidBackupException>()),
    );
    expect(
      () => restoreFromExportData(
          db, {'app': 'CourseLedger', 'format': 1, 'courses': 'nope'}),
      throwsA(isA<InvalidBackupException>()),
    );
  });

  test('collectMedia skips photo rows whose file is gone', () async {
    final db = makeTestDb();
    addTearDown(db.close);
    final courses = CourseRepository(db);
    final rounds = RoundRepository(db, journal: db.journal());
    final courseId = await courses.createCourse(courseDraft());

    final dir = await Directory.systemTemp.createTemp('cl-backup-test');
    addTearDown(() => dir.delete(recursive: true));
    final store = ImagePickerPhotoService(dir, filePrefix: 'round');
    await store.importBytes('real.jpg', [9, 9, 9]);

    await rounds.createRound(
      courseId,
      roundDraft(photos: const [
        JournalPhotoDraft(path: 'real.jpg'),
        JournalPhotoDraft(path: 'gone.jpg'),
      ]),
    );

    final media = await db.journal().collectMedia(store);
    expect(media.keys, ['real.jpg']);
    expect(media['real.jpg'], [9, 9, 9]);
  });
}
