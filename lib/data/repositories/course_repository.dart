import 'package:drift/drift.dart';

import '../database/app_database.dart';

/// Play history at one course, computed from rounds — never stored.
class CourseStats {
  const CourseStats({
    required this.roundCount,
    this.firstPlayed,
    this.lastPlayed,
    this.bestScore,
  });

  final int roundCount;
  final DateTime? firstPlayed;
  final DateTime? lastPlayed;
  final int? bestScore;
}

/// One row in the Home courses list: the course plus its play history
/// roll-up. Sorting (A-Z / by state / by recent) happens on this list.
class CourseSummary {
  const CourseSummary(this.course, {required this.roundCount, this.lastPlayed});

  final Course course;
  final int roundCount;
  final DateTime? lastPlayed;
}

/// A course being composed in the add/edit flows, before it has a
/// database id.
class CourseDraft {
  const CourseDraft({
    required this.name,
    this.city,
    this.state,
    this.country = 'US',
    required this.holes,
    this.par,
    required this.kind,
    this.rating,
    this.notes,
    this.lat,
    this.lng,
  });

  final String name;
  final String? city;
  final String? state;
  final String country;
  final CourseHoles holes;
  final int? par;
  final CourseKind kind;
  final int? rating;
  final String? notes;
  final double? lat;
  final double? lng;
}

class CourseRepository {
  CourseRepository(this._db);

  final AppDatabase _db;

  /// All courses A-Z; by-state and by-recent orderings come with the
  /// Home screen (Phase B).
  Stream<List<Course>> watchCourses() {
    final query = _db.select(_db.courses)
      ..orderBy([(c) => OrderingTerm.asc(c.name.lower())]);
    return query.watch();
  }

  /// Every course with round count and last-played date, unsorted; the
  /// Home screen applies the user's sort mode.
  Stream<List<CourseSummary>> watchSummaries() {
    final lastPlayed = _db.rounds.date.max();
    final roundCount = _db.rounds.id.count();
    final query = _db.select(_db.courses).join([
      leftOuterJoin(
        _db.rounds,
        _db.rounds.courseId.equalsExp(_db.courses.id),
        useColumns: false,
      ),
    ])
      ..addColumns([lastPlayed, roundCount])
      ..groupBy([_db.courses.id]);
    return query.watch().map((rows) => rows
        .map((row) => CourseSummary(
              row.readTable(_db.courses),
              roundCount: row.read(roundCount)!,
              lastPlayed: row.read(lastPlayed),
            ))
        .toList());
  }

  Stream<Course?> watchCourse(int id) {
    final query = _db.select(_db.courses)..where((c) => c.id.equals(id));
    return query.watchSingleOrNull();
  }

  /// Number of courses in the ledger — feeds `FreeLimit(5, 'courses')`.
  Future<int> count() async {
    final countExp = _db.courses.id.count();
    final query = _db.selectOnly(_db.courses)..addColumns([countExp]);
    final row = await query.getSingle();
    return row.read(countExp)!;
  }

  /// First/last played, best score, round count — kept live as rounds
  /// change.
  Stream<CourseStats> watchStats(int courseId) {
    final first = _db.rounds.date.min();
    final last = _db.rounds.date.max();
    final best = _db.rounds.totalScore.min();
    final total = _db.rounds.id.count();
    final query = _db.selectOnly(_db.rounds)
      ..addColumns([first, last, best, total])
      ..where(_db.rounds.courseId.equals(courseId));
    return query.watchSingle().map((row) => CourseStats(
          roundCount: row.read(total)!,
          firstPlayed: row.read(first),
          lastPlayed: row.read(last),
          bestScore: row.read(best),
        ));
  }

  Future<int> createCourse(CourseDraft d) {
    return _db.into(_db.courses).insert(_companion(d));
  }

  Future<void> updateCourse(int id, CourseDraft d) {
    return (_db.update(_db.courses)..where((c) => c.id.equals(id)))
        .write(_companion(d));
  }

  /// Rounds (and their photo rows) and bucket-list references cascade.
  Future<void> deleteCourse(int id) {
    return (_db.delete(_db.courses)..where((c) => c.id.equals(id))).go();
  }

  CoursesCompanion _companion(CourseDraft d) => CoursesCompanion.insert(
        name: d.name,
        city: Value(d.city),
        state: Value(d.state),
        country: Value(d.country),
        holes: d.holes,
        par: Value(d.par),
        kind: d.kind,
        rating: Value(d.rating),
        notes: Value(d.notes),
        lat: Value(d.lat),
        lng: Value(d.lng),
      );
}
