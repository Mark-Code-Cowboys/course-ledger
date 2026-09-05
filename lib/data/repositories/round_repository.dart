import 'package:cc_core/cc_core.dart';
import 'package:drift/drift.dart';
import 'package:stream_transform/stream_transform.dart';

import '../database/app_database.dart';

/// A round joined with its journal entry (the story, the day rating,
/// the photos). Rounds without any of those have no entry.
class RoundWithStory {
  const RoundWithStory(this.round,
      {this.entry, this.photos = const [], this.tags = const []});

  final Round round;
  final JournalEntry? entry;
  final List<JournalPhoto> photos;
  final List<JournalTag> tags;

  String? get notes => entry?.notes;
  int? get rating => entry?.rating;
}

/// A round being composed, before it has a database id. Story fields
/// land in the shared journal tables.
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
  final List<JournalPhotoDraft> photos;

  bool get hasStory =>
      notes != null || rating != null || photos.isNotEmpty;
}

class RoundRepository {
  RoundRepository(this._db, {required AppJournalRepository journal})
      // ignore: prefer_initializing_formals
      : _journal = journal;

  final AppDatabase _db;
  final AppJournalRepository _journal;

  /// Rounds at a course, newest first, each with its story.
  Stream<List<RoundWithStory>> watchRoundsForCourse(int courseId) {
    final query = _db.select(_db.rounds)
      ..where((r) => r.courseId.equals(courseId))
      ..orderBy([
        (r) => OrderingTerm.desc(r.date),
        (r) => OrderingTerm.desc(r.id),
      ]);
    return _withStories(query.watch());
  }

  Stream<RoundWithStory?> watchRound(int roundId) {
    final query = _db.select(_db.rounds)..where((r) => r.id.equals(roundId));
    return _withStories(
            query.watch().map((rows) => rows.take(1).toList()))
        .map((list) => list.isEmpty ? null : list.single);
  }

  /// Every round in the ledger, oldest first — trends aggregates.
  Stream<List<Round>> watchAllRounds() {
    final query = _db.select(_db.rounds)
      ..orderBy([(r) => OrderingTerm.asc(r.date)]);
    return query.watch();
  }

  /// Joins rounds to their entries/photos/tags, staying live as any of
  /// the journal tables change.
  Stream<List<RoundWithStory>> _withStories(Stream<List<Round>> rounds) {
    final entries = _db.select(_db.appJournalEntries).watch();
    final photos = (_db.select(_db.appJournalPhotos)
          ..orderBy([(p) => OrderingTerm.asc(p.id)]))
        .watch();
    final tags = (_db.select(_db.appJournalTags)
          ..orderBy([(t) => OrderingTerm.asc(t.id)]))
        .watch();
    return rounds
        .combineLatest(entries,
            (List<Round> r, List<JournalEntry> e) => (r, e))
        .combineLatest(photos, (pair, List<JournalPhoto> p) => (pair, p))
        .combineLatest(tags, (nested, List<JournalTag> t) {
      final ((roundRows, entryRows), photoRows) = nested;
      final byId = {for (final e in entryRows) e.id: e};
      return [
        for (final round in roundRows)
          RoundWithStory(
            round,
            entry: byId[round.journalEntryId],
            photos: [
              for (final p in photoRows)
                if (p.entryId == round.journalEntryId) p,
            ],
            tags: [
              for (final tag in t)
                if (tag.entryId == round.journalEntryId) tag,
            ],
          ),
      ];
    });
  }

  /// Creates the round (and its journal entry when there's a story)
  /// atomically; returns the round id.
  Future<int> createRound(int courseId, RoundDraft d) {
    return _db.transaction(() async {
      int? entryId;
      if (d.hasStory) {
        entryId = await _journal.createEntry(JournalEntryDraft(
          notes: d.notes,
          rating: d.rating,
          photos: d.photos,
        ));
      }
      return _db.into(_db.rounds).insert(
            RoundsCompanion.insert(
              courseId: courseId,
              date: d.date,
              totalScore: Value(d.totalScore),
              holesPlayed: d.holesPlayed,
              tees: Value(d.tees),
              walkedOrCart: Value(d.walkedOrCart),
              partners: Value(d.partners),
              weather: Value(d.weather),
              journalEntryId: Value(entryId),
            ),
          );
    });
  }

  /// Rewrites the round's fields and its story text/rating. Photos are
  /// managed separately ([addPhoto]/[removePhoto]) — the draft's photo
  /// list is ignored here.
  Future<void> updateRound(int roundId, RoundDraft d) {
    return _db.transaction(() async {
      final round = await (_db.select(_db.rounds)
            ..where((r) => r.id.equals(roundId)))
          .getSingle();
      var entryId = round.journalEntryId;
      final hasText = d.notes != null || d.rating != null;
      if (entryId == null && hasText) {
        entryId = await _journal
            .createEntry(JournalEntryDraft(notes: d.notes, rating: d.rating));
      } else if (entryId != null) {
        await _journal.updateEntry(entryId, notes: d.notes, rating: d.rating);
      }
      await (_db.update(_db.rounds)..where((r) => r.id.equals(roundId)))
          .write(RoundsCompanion(
        date: Value(d.date),
        totalScore: Value(d.totalScore),
        holesPlayed: Value(d.holesPlayed),
        tees: Value(d.tees),
        walkedOrCart: Value(d.walkedOrCart),
        partners: Value(d.partners),
        weather: Value(d.weather),
        journalEntryId: Value(entryId),
      ));
    });
  }

  /// The round's entry id, creating an empty entry if none exists yet
  /// (first photo on a story-less round).
  Future<int> ensureEntry(int roundId) async {
    final round = await (_db.select(_db.rounds)
          ..where((r) => r.id.equals(roundId)))
        .getSingle();
    if (round.journalEntryId != null) return round.journalEntryId!;
    final entryId = await _journal.createEntry(const JournalEntryDraft());
    await (_db.update(_db.rounds)..where((r) => r.id.equals(roundId)))
        .write(RoundsCompanion(journalEntryId: Value(entryId)));
    return entryId;
  }

  Future<int> addPhoto(int roundId, JournalPhotoDraft p) async =>
      _journal.addPhoto(await ensureEntry(roundId), p);

  Future<void> removePhoto(int photoId) => _journal.removePhoto(photoId);

  /// Deletes the round and its journal entry (photo files included).
  Future<void> deleteRound(int roundId) async {
    final round = await (_db.select(_db.rounds)
          ..where((r) => r.id.equals(roundId)))
        .getSingleOrNull();
    await (_db.delete(_db.rounds)..where((r) => r.id.equals(roundId))).go();
    final entryId = round?.journalEntryId;
    if (entryId != null) await _journal.deleteEntries([entryId]);
  }
}
