// Drift's `check(column...)` idiom trips this lint on rating columns.
// ignore_for_file: recursive_getters
import 'package:cc_core/cc_core.dart';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

/// This database's concrete journal repository type (cc_core's
/// JournalRepository is generic over the generated table classes).
typedef AppJournalRepository = JournalRepository<$AppJournalEntriesTable,
    $AppJournalPhotosTable, $AppJournalTagsTable>;

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
  // The story, day rating, and photos live in the shared cc_core
  // journal tables (schema v2); a round with none of those has no
  // entry. RoundRepository owns the entry lifecycle. Raw-SQL FK for the
  // same cross-package reason as cc_core's journal tables.
  IntColumn get journalEntryId => integer().nullable()();

  @override
  List<String> get customConstraints => [
        'FOREIGN KEY (journal_entry_id) REFERENCES journal_entries (id) '
            'ON DELETE SET NULL',
      ];
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

// Drift's generator can't analyze table classes across package
// boundaries in the default build mode, so the app registers thin
// local subclasses of cc_core's journal tables (columns and row types
// inherited; table names pinned to the shared schema).
@UseRowClass(JournalEntry)
class AppJournalEntries extends JournalEntries {
  @override
  String get tableName => 'journal_entries';
}

@UseRowClass(JournalPhoto)
class AppJournalPhotos extends JournalPhotos {
  @override
  String get tableName => 'journal_photos';
}

@UseRowClass(JournalTag)
class AppJournalTags extends JournalTags {
  @override
  String get tableName => 'journal_tags';
}

@DriftDatabase(tables: [
  Courses,
  Rounds,
  BucketList,
  AppJournalEntries,
  AppJournalPhotos,
  AppJournalTags,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  /// Opens the on-device database. All data stays local; nothing leaves
  /// the phone.
  factory AppDatabase.open() =>
      AppDatabase(driftDatabase(name: 'courseledger'));

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (m, from, to) async {
          if (from < 2) await _migrateToJournal(m);
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  /// The journal repository over this database's generated tables.
  AppJournalRepository journal({PhotoFileStore? photoStore}) =>
      JournalRepository(this,
          entries: appJournalEntries,
          photos: appJournalPhotos,
          tags: appJournalTags,
          photoStore: photoStore);

  /// v1 -> v2: rounds' notes/rating and the round_photos table move
  /// into the shared journal tables. Runs inside the migration
  /// transaction; raw SQL because the old columns no longer exist in
  /// the Dart schema.
  Future<void> _migrateToJournal(Migrator m) async {
    await m.createTable(appJournalEntries);
    await m.createTable(appJournalPhotos);
    await m.createTable(appJournalTags);
    await m.addColumn(rounds, rounds.journalEntryId);

    final storied = await customSelect(
      'SELECT id, notes, rating FROM rounds '
      'WHERE notes IS NOT NULL OR rating IS NOT NULL '
      'OR id IN (SELECT round_id FROM round_photos)',
    ).get();
    for (final row in storied) {
      final entryId = await customInsert(
        'INSERT INTO journal_entries (notes, rating) VALUES (?, ?)',
        variables: [
          Variable(row.read<String?>('notes')),
          Variable(row.read<int?>('rating')),
        ],
        updates: {appJournalEntries},
      );
      final roundId = row.read<int>('id');
      await customStatement(
          'UPDATE rounds SET journal_entry_id = ? WHERE id = ?',
          [entryId, roundId]);
      await customStatement(
          'INSERT INTO journal_photos (entry_id, path, caption) '
          'SELECT ?, path, caption FROM round_photos WHERE round_id = ?',
          [entryId, roundId]);
    }
    await customStatement('DROP TABLE round_photos');
    // Rebuild rounds to the v2 shape (drops the notes/rating columns).
    await m.alterTable(TableMigration(rounds));
  }
}
