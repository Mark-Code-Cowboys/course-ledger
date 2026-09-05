import 'package:cc_core/cc_core.dart';
import 'package:drift/drift.dart';

import '../../data/database/app_database.dart';

/// The whole ledger as a JSON-encodable map (format 2: journal tables).
/// Pure data — photo files are referenced by store name; the backup
/// archive carries their bytes separately.
Future<Map<String, Object?>> buildExportData(
  AppDatabase db, {
  required int lifetimeCourses,
  DateTime? now,
}) async {
  final courses = await (db.select(db.courses)
        ..orderBy([(t) => OrderingTerm.asc(t.id)]))
      .get();
  final rounds = await (db.select(db.rounds)
        ..orderBy([(t) => OrderingTerm.asc(t.id)]))
      .get();
  final entries = await (db.select(db.appJournalEntries)
        ..orderBy([(t) => OrderingTerm.asc(t.id)]))
      .get();
  final photos = await (db.select(db.appJournalPhotos)
        ..orderBy([(t) => OrderingTerm.asc(t.id)]))
      .get();
  final tags = await (db.select(db.appJournalTags)
        ..orderBy([(t) => OrderingTerm.asc(t.id)]))
      .get();
  final bucket = await (db.select(db.bucketList)
        ..orderBy([(t) => OrderingTerm.asc(t.id)]))
      .get();

  return {
    'app': 'CourseLedger',
    'format': 2,
    'exportedAt': (now ?? DateTime.now()).toIso8601String(),
    // Carried so a restore never resets the free tier (raiseTo).
    'lifetimeCourses': lifetimeCourses,
    'courses': [
      for (final c in courses)
        {
          'id': c.id,
          'name': c.name,
          'city': c.city,
          'state': c.state,
          'country': c.country,
          'holes': c.holes.name,
          'par': c.par,
          'kind': c.kind.name,
          'rating': c.rating,
          'notes': c.notes,
          'lat': c.lat,
          'lng': c.lng,
          'createdAt': c.createdAt.toIso8601String(),
        },
    ],
    'rounds': [
      for (final r in rounds)
        {
          'id': r.id,
          'courseId': r.courseId,
          'date': r.date.toIso8601String(),
          'totalScore': r.totalScore,
          'holesPlayed': r.holesPlayed.name,
          'tees': r.tees,
          'walkedOrCart': r.walkedOrCart?.name,
          'partners': r.partners,
          'weather': r.weather,
          'journalEntryId': r.journalEntryId,
        },
    ],
    'journalEntries': [
      for (final e in entries)
        {
          'id': e.id,
          'notes': e.notes,
          'rating': e.rating,
          'createdAt': e.createdAt.toIso8601String(),
        },
    ],
    'journalPhotos': [
      for (final p in photos)
        {
          'id': p.id,
          'entryId': p.entryId,
          'path': p.path,
          'caption': p.caption,
        },
    ],
    'journalTags': [
      for (final t in tags)
        {'id': t.id, 'entryId': t.entryId, 'tag': t.tag},
    ],
    'bucketList': [
      for (final b in bucket)
        {
          'id': b.id,
          'courseId': b.courseId,
          'freeText': b.freeText,
          'done': b.done,
          'doneRoundId': b.doneRoundId,
        },
    ],
  };
}

/// Replaces the entire ledger with the contents of an export. Accepts
/// format 2 and format 1 (pre-journal backups: rounds carried
/// notes/rating and a roundPhotos array — they become journal rows).
/// Runs in one transaction; ids are preserved.
///
/// Returns the backup's lifetime-courses figure so the caller can
/// `raiseTo` the tally (never lowered).
Future<int> restoreFromExportData(
    AppDatabase db, Map<String, Object?> data) async {
  if (data['app'] != 'CourseLedger' ||
      (data['format'] != 1 && data['format'] != 2)) {
    throw const InvalidBackupException('Unrecognized export format');
  }
  final upgraded =
      data['format'] == 1 ? _upgradeFormat1(data) : data;

  final courses = upgraded['courses'];
  final rounds = upgraded['rounds'];
  final entries = upgraded['journalEntries'];
  final photos = upgraded['journalPhotos'];
  final tags = upgraded['journalTags'];
  final bucket = upgraded['bucketList'];
  if (courses is! List ||
      rounds is! List ||
      entries is! List ||
      photos is! List ||
      tags is! List ||
      bucket is! List) {
    throw const InvalidBackupException('Malformed export tables');
  }

  await db.transaction(() async {
    await db.delete(db.bucketList).go();
    await db.delete(db.courses).go();
    await db.delete(db.appJournalEntries).go();

    for (final row in entries.cast<Map<String, dynamic>>()) {
      await db.into(db.appJournalEntries).insert(RawValuesInsertable({
            'id': Variable(row['id'] as int),
            'notes': Variable(row['notes'] as String?),
            'rating': Variable(row['rating'] as int?),
            if (row['createdAt'] != null)
              'created_at':
                  Variable(DateTime.parse(row['createdAt'] as String)),
          }));
    }
    for (final row in photos.cast<Map<String, dynamic>>()) {
      await db.into(db.appJournalPhotos).insert(RawValuesInsertable({
            'id': Variable(row['id'] as int),
            'entry_id': Variable(row['entryId'] as int),
            'path': Variable(row['path'] as String),
            'caption': Variable(row['caption'] as String?),
          }));
    }
    for (final row in tags.cast<Map<String, dynamic>>()) {
      await db.into(db.appJournalTags).insert(RawValuesInsertable({
            'id': Variable(row['id'] as int),
            'entry_id': Variable(row['entryId'] as int),
            'tag': Variable(row['tag'] as String),
          }));
    }
    for (final row in courses.cast<Map<String, dynamic>>()) {
      await db.into(db.courses).insert(CoursesCompanion(
            id: Value(row['id'] as int),
            name: Value(row['name'] as String),
            city: Value(row['city'] as String?),
            state: Value(row['state'] as String?),
            country: Value(row['country'] as String),
            holes: Value(CourseHoles.values.byName(row['holes'] as String)),
            par: Value(row['par'] as int?),
            kind: Value(CourseKind.values.byName(row['kind'] as String)),
            rating: Value(row['rating'] as int?),
            notes: Value(row['notes'] as String?),
            lat: Value((row['lat'] as num?)?.toDouble()),
            lng: Value((row['lng'] as num?)?.toDouble()),
            createdAt: Value(DateTime.parse(row['createdAt'] as String)),
          ));
    }
    for (final row in rounds.cast<Map<String, dynamic>>()) {
      await db.into(db.rounds).insert(RoundsCompanion(
            id: Value(row['id'] as int),
            courseId: Value(row['courseId'] as int),
            date: Value(DateTime.parse(row['date'] as String)),
            totalScore: Value(row['totalScore'] as int?),
            holesPlayed: Value(
                HolesPlayed.values.byName(row['holesPlayed'] as String)),
            tees: Value(row['tees'] as String?),
            walkedOrCart: Value(switch (row['walkedOrCart'] as String?) {
              null => null,
              final name => WalkedOrCart.values.byName(name),
            }),
            partners: Value(row['partners'] as String),
            weather: Value(row['weather'] as String?),
            journalEntryId: Value(row['journalEntryId'] as int?),
          ));
    }
    for (final row in bucket.cast<Map<String, dynamic>>()) {
      await db.into(db.bucketList).insert(BucketListCompanion(
            id: Value(row['id'] as int),
            courseId: Value(row['courseId'] as int?),
            freeText: Value(row['freeText'] as String?),
            done: Value(row['done'] as bool),
            doneRoundId: Value(row['doneRoundId'] as int?),
          ));
    }
  });
  return (upgraded['lifetimeCourses'] as num?)?.toInt() ?? courses.length;
}

/// Maps a pre-journal (format 1) export into the format-2 shape:
/// rounds' notes/rating become entries; roundPhotos become
/// journalPhotos on those entries.
Map<String, Object?> _upgradeFormat1(Map<String, Object?> data) {
  final rounds =
      (data['rounds'] as List? ?? const []).cast<Map<String, dynamic>>();
  final oldPhotos =
      (data['roundPhotos'] as List? ?? const []).cast<Map<String, dynamic>>();

  final entries = <Map<String, Object?>>[];
  final photos = <Map<String, Object?>>[];
  final newRounds = <Map<String, Object?>>[];
  var nextEntry = 1;
  var nextPhoto = 1;
  for (final r in rounds) {
    final roundPhotos =
        oldPhotos.where((p) => p['roundId'] == r['id']).toList();
    int? entryId;
    if (r['notes'] != null || r['rating'] != null || roundPhotos.isNotEmpty) {
      entryId = nextEntry++;
      entries.add({
        'id': entryId,
        'notes': r['notes'],
        'rating': r['rating'],
        'createdAt': null,
      });
      for (final p in roundPhotos) {
        photos.add({
          'id': nextPhoto++,
          'entryId': entryId,
          // Format 1 stored arbitrary paths; keep the base name so the
          // photo store can resolve restored media.
          'path': (p['path'] as String).split('/').last,
          'caption': p['caption'],
        });
      }
    }
    newRounds.add({...r, 'journalEntryId': entryId}
      ..remove('notes')
      ..remove('rating'));
  }
  return {
    ...data,
    'format': 2,
    'rounds': newRounds,
    'journalEntries': entries,
    'journalPhotos': photos,
    'journalTags': const <Object?>[],
  };
}
