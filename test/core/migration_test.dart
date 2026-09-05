import 'dart:io';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart' as raw;

import 'package:course_ledger/data/database/app_database.dart';

/// Builds a real schema-v1 database file the way shipped 1.0 installs
/// have it, then opens AppDatabase over it and asserts the v2 migration
/// moved every story into the journal without losing a row.
void main() {
  test('v1 -> v2 migration moves notes/rating/photos into the journal',
      () async {
    final dir = await Directory.systemTemp.createTemp('cl-migration');
    addTearDown(() => dir.delete(recursive: true));
    final path = '${dir.path}/courseledger.sqlite';

    final v1 = raw.sqlite3.open(path);
    v1.execute('''
      CREATE TABLE courses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL, city TEXT, state TEXT,
        country TEXT NOT NULL DEFAULT 'US',
        holes TEXT NOT NULL, par INTEGER, kind TEXT NOT NULL,
        rating INTEGER, notes TEXT, lat REAL, lng REAL,
        created_at INTEGER NOT NULL DEFAULT (strftime('%s','now')));
      CREATE TABLE rounds (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        course_id INTEGER NOT NULL REFERENCES courses (id)
          ON DELETE CASCADE,
        date INTEGER NOT NULL, total_score INTEGER,
        holes_played TEXT NOT NULL, tees TEXT, walked_or_cart TEXT,
        partners TEXT NOT NULL DEFAULT '', weather TEXT,
        rating INTEGER, notes TEXT);
      CREATE TABLE round_photos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        round_id INTEGER NOT NULL REFERENCES rounds (id)
          ON DELETE CASCADE,
        path TEXT NOT NULL, caption TEXT);
      CREATE TABLE bucket_list (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        course_id INTEGER REFERENCES courses (id) ON DELETE CASCADE,
        free_text TEXT,
        done INTEGER NOT NULL DEFAULT 0,
        done_round_id INTEGER REFERENCES rounds (id) ON DELETE SET NULL,
        CHECK ((course_id IS NULL) != (free_text IS NULL)));

      INSERT INTO courses (name, state, holes, kind, rating)
        VALUES ('Pine Hollow', 'MI', 'h18', 'public', 5);
      INSERT INTO rounds
        (course_id, date, total_score, holes_played, partners, rating, notes)
        VALUES (1, 1755000000, 92, 'eighteen', 'Dale', 5,
                'Birdie on 17 into the wind.');
      INSERT INTO rounds (course_id, date, total_score, holes_played)
        VALUES (1, 1756000000, 90, 'eighteen');
      INSERT INTO round_photos (round_id, path, caption)
        VALUES (1, 'card.jpg', 'the card');
      INSERT INTO bucket_list (course_id, done, done_round_id)
        VALUES (1, 1, 1);
      PRAGMA user_version = 1;
    ''');
    v1.close();

    final db = AppDatabase(NativeDatabase(File(path)));
    addTearDown(db.close);

    final rounds = await (db.select(db.rounds)
          ..orderBy([(r) => OrderingTerm.asc(r.id)]))
        .get();
    expect(rounds, hasLength(2));
    expect(rounds.first.totalScore, 92);
    expect(rounds.first.partners, 'Dale');
    expect(rounds.first.journalEntryId, isNotNull);
    expect(rounds.last.journalEntryId, isNull); // story-less round

    final entries = await db.select(db.appJournalEntries).get();
    expect(entries, hasLength(1));
    expect(entries.single.notes, 'Birdie on 17 into the wind.');
    expect(entries.single.rating, 5);

    final photos = await db.select(db.appJournalPhotos).get();
    expect(photos.single.path, 'card.jpg');
    expect(photos.single.caption, 'the card');
    expect(photos.single.entryId, rounds.first.journalEntryId);

    // The old table is gone; the bucket link survived.
    expect(
      () => db.customSelect('SELECT * FROM round_photos').get(),
      throwsA(anything),
    );
    final bucket = await db.select(db.bucketList).get();
    expect(bucket.single.done, isTrue);
    expect(bucket.single.doneRoundId, 1);
  });
}
