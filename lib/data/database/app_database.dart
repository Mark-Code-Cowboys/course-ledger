// Drift's `check(column...)` idiom trips this lint on rating columns.
// ignore_for_file: recursive_getters
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

/// Hole count a course offers (not what was played in a round).
enum CourseHoles { h9, h18, h27, h36 }

enum CourseKind { public, muni, resort, private, executive }

/// How much of the course a round covered.
enum HolesPlayed { nine, eighteen, partial }

enum WalkedOrCart { walked, cart }

class Courses extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 120)();
  TextColumn get city => text().nullable()();
  TextColumn get state => text().nullable()();
  TextColumn get country => text().withDefault(const Constant('US'))();
  TextColumn get holes => textEnum<CourseHoles>()();
  IntColumn get par => integer().nullable()();
  TextColumn get kind => textEnum<CourseKind>()();
  IntColumn get rating =>
      integer().nullable().check(rating.isBetweenValues(1, 5))();
  TextColumn get notes => text().nullable()();
  // Opt-in only; never captured without an explicit user action.
  RealColumn get lat => real().nullable()();
  RealColumn get lng => real().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  // firstPlayed is computed from rounds (see CourseRepository), not stored.
}

class Rounds extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get courseId =>
      integer().references(Courses, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get date => dateTime()();
  IntColumn get totalScore => integer().nullable()();
  TextColumn get holesPlayed => textEnum<HolesPlayed>()();
  TextColumn get tees => text().nullable()();
  TextColumn get walkedOrCart => textEnum<WalkedOrCart>().nullable()();
  TextColumn get partners => text().withDefault(const Constant(''))();
  TextColumn get weather => text().nullable()();
  IntColumn get rating =>
      integer().nullable().check(rating.isBetweenValues(1, 5))();
  // The story. App-local until cc_core journal/ lands (docs/cc-core-gaps.md).
  TextColumn get notes => text().nullable()();
}

/// Photos attached to a round's story: the card, the view from 18.
/// App-local stand-in for cc_core journal photo attachments.
@DataClassName('RoundPhoto')
class RoundPhotos extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get roundId =>
      integer().references(Rounds, #id, onDelete: KeyAction.cascade)();
  TextColumn get path => text()();
  TextColumn get caption => text().nullable()();
}

/// Courses to play someday: either a real course row or free text
/// ("that links course in Bandon"), never both.
@DataClassName('BucketItem')
class BucketList extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get courseId =>
      integer().nullable().references(Courses, #id, onDelete: KeyAction.cascade)();
  TextColumn get freeText => text().nullable()();
  BoolColumn get done => boolean().withDefault(const Constant(false))();
  IntColumn get doneRoundId =>
      integer().nullable().references(Rounds, #id, onDelete: KeyAction.setNull)();

  @override
  List<String> get customConstraints =>
      ['CHECK ((course_id IS NULL) != (free_text IS NULL))'];
}

@DriftDatabase(tables: [Courses, Rounds, RoundPhotos, BucketList])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  /// Opens the on-device database. All data stays local; nothing leaves
  /// the phone.
  factory AppDatabase.open() =>
      AppDatabase(driftDatabase(name: 'courseledger'));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );
}
