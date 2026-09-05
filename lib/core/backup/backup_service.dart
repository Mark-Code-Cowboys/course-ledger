import 'dart:io';

import 'package:cc_core/cc_core.dart';
import 'package:drift/drift.dart';

import '../../data/database/app_database.dart';

/// The whole ledger as a JSON-encodable map (format 1). Pure data —
/// round photos are referenced by path but not embedded; the backup
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
  final photos = await (db.select(db.roundPhotos)
        ..orderBy([(t) => OrderingTerm.asc(t.id)]))
      .get();
  final bucket = await (db.select(db.bucketList)
        ..orderBy([(t) => OrderingTerm.asc(t.id)]))
      .get();

  return {
    'app': 'CourseLedger',
    'format': 1,
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
          'rating': r.rating,
          'notes': r.notes,
        },
    ],
    'roundPhotos': [
      for (final p in photos)
        {
          'id': p.id,
          'roundId': p.roundId,
          'path': p.path,
          'caption': p.caption,
        },
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

/// Photo files referenced by rounds, keyed by base name, for the backup
/// archive's media folder. Missing files are skipped — the JSON keeps
/// the reference either way.
Future<Map<String, List<int>>> collectRoundPhotoMedia(AppDatabase db) async {
  final photos = await db.select(db.roundPhotos).get();
  final media = <String, List<int>>{};
  for (final p in photos) {
    final file = File(p.path);
    if (await file.exists()) {
      media[file.uri.pathSegments.last] = await file.readAsBytes();
    }
  }
  return media;
}

/// Replaces the entire ledger with the contents of an export (format 1,
/// as produced by [buildExportData]). Runs in one transaction: either
/// the whole backup lands or nothing changes. Ids are preserved so
/// photo and bucket references stay stable.
///
/// Returns the backup's lifetime-courses figure so the caller can
/// `raiseTo` the tally (never lowered).
Future<int> restoreFromExportData(
    AppDatabase db, Map<String, Object?> data) async {
  if (data['app'] != 'CourseLedger' || data['format'] != 1) {
    throw const InvalidBackupException('Unrecognized export format');
  }
  final courses = data['courses'];
  final rounds = data['rounds'];
  final photos = data['roundPhotos'];
  final bucket = data['bucketList'];
  if (courses is! List ||
      rounds is! List ||
      photos is! List ||
      bucket is! List) {
    throw const InvalidBackupException('Malformed export tables');
  }

  await db.transaction(() async {
    // Rounds, photos and bucket rows cascade away with their courses;
    // free-text bucket rows are deleted explicitly.
    await db.delete(db.bucketList).go();
    await db.delete(db.courses).go();

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
            rating: Value(row['rating'] as int?),
            notes: Value(row['notes'] as String?),
          ));
    }
    for (final row in photos.cast<Map<String, dynamic>>()) {
      await db.into(db.roundPhotos).insert(RoundPhotosCompanion(
            id: Value(row['id'] as int),
            roundId: Value(row['roundId'] as int),
            path: Value(row['path'] as String),
            caption: Value(row['caption'] as String?),
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
  return (data['lifetimeCourses'] as num?)?.toInt() ?? courses.length;
}
