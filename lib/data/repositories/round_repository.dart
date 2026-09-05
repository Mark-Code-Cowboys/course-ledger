import 'package:drift/drift.dart';
import 'package:stream_transform/stream_transform.dart';

import '../database/app_database.dart';

/// A round plus its story photos.
class RoundWithPhotos {
  const RoundWithPhotos(this.round, this.photos);

  final Round round;
  final List<RoundPhoto> photos;
}

/// A photo being attached in the round composer, before it has a
/// database id.
class RoundPhotoDraft {
  const RoundPhotoDraft({required this.path, this.caption});

  final String path;
  final String? caption;
}

/// A round being composed, before it has a database id.
class RoundDraft {
  const RoundDraft({
    required this.date,
    this.totalScore,
    required this.holesPlayed,
    this.tees,
    this.walkedOrCart,
    this.partners = '',
    this.weather,
    this.rating,
    this.notes,
    this.photos = const [],
  });

  final DateTime date;
  final int? totalScore;
  final HolesPlayed holesPlayed;
  final String? tees;
  final WalkedOrCart? walkedOrCart;
  final String partners;
  final String? weather;
  final int? rating;
  final String? notes;
  final List<RoundPhotoDraft> photos;
}

class RoundRepository {
  RoundRepository(this._db);

  final AppDatabase _db;

  /// Rounds at a course, newest first, each with its photos.
  Stream<List<RoundWithPhotos>> watchRoundsForCourse(int courseId) {
    final query = _db.select(_db.rounds)
      ..where((r) => r.courseId.equals(courseId))
      ..orderBy([
        (r) => OrderingTerm.desc(r.date),
        (r) => OrderingTerm.desc(r.id),
      ]);
    return query.watch().switchMap(_withPhotos);
  }

  Stream<RoundWithPhotos?> watchRound(int roundId) {
    final query = _db.select(_db.rounds)..where((r) => r.id.equals(roundId));
    return query
        .watchSingleOrNull()
        .switchMap((round) => round == null
            ? Stream.value(null)
            : _withPhotos([round]).map((list) => list.single));
  }

  Stream<List<RoundWithPhotos>> _withPhotos(List<Round> rounds) {
    if (rounds.isEmpty) return Stream.value(const []);
    final ids = rounds.map((r) => r.id).toList();
    final photoQuery = _db.select(_db.roundPhotos)
      ..where((p) => p.roundId.isIn(ids))
      ..orderBy([(p) => OrderingTerm.asc(p.id)]);
    return photoQuery.watch().map((photos) => [
          for (final round in rounds)
            RoundWithPhotos(
              round,
              photos.where((p) => p.roundId == round.id).toList(),
            ),
        ]);
  }

  /// Creates the round and its photos atomically; returns the round id.
  /// Bucket-list check-off happens in the composer via
  /// BucketListRepository.completeItemsForCourse (Phase B linkage).
  Future<int> createRound(int courseId, RoundDraft d) {
    return _db.transaction(() async {
      final roundId = await _db.into(_db.rounds).insert(
            RoundsCompanion.insert(
              courseId: courseId,
              date: d.date,
              totalScore: Value(d.totalScore),
              holesPlayed: d.holesPlayed,
              tees: Value(d.tees),
              walkedOrCart: Value(d.walkedOrCart),
              partners: Value(d.partners),
              weather: Value(d.weather),
              rating: Value(d.rating),
              notes: Value(d.notes),
            ),
          );
      for (final p in d.photos) {
        await _db.into(_db.roundPhotos).insert(
              RoundPhotosCompanion.insert(
                roundId: roundId,
                path: p.path,
                caption: Value(p.caption),
              ),
            );
      }
      return roundId;
    });
  }

  /// Rewrites the round's fields; photos are managed separately by the
  /// composer (add/remove one at a time).
  Future<void> updateRound(int roundId, RoundDraft d) {
    return (_db.update(_db.rounds)..where((r) => r.id.equals(roundId))).write(
      RoundsCompanion(
        date: Value(d.date),
        totalScore: Value(d.totalScore),
        holesPlayed: Value(d.holesPlayed),
        tees: Value(d.tees),
        walkedOrCart: Value(d.walkedOrCart),
        partners: Value(d.partners),
        weather: Value(d.weather),
        rating: Value(d.rating),
        notes: Value(d.notes),
      ),
    );
  }

  Future<int> addPhoto(int roundId, RoundPhotoDraft p) {
    return _db.into(_db.roundPhotos).insert(
          RoundPhotosCompanion.insert(
            roundId: roundId,
            path: p.path,
            caption: Value(p.caption),
          ),
        );
  }

  Future<void> deletePhoto(int photoId) {
    return (_db.delete(_db.roundPhotos)..where((p) => p.id.equals(photoId)))
        .go();
  }

  /// Photo rows cascade with the round. Photo *files* are cleaned up by
  /// the composer layer (Phase B), which owns the file store.
  Future<void> deleteRound(int roundId) {
    return (_db.delete(_db.rounds)..where((r) => r.id.equals(roundId))).go();
  }
}
