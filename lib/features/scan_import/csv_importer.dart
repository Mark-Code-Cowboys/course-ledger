import 'package:cc_core/cc_core.dart';

import '../../data/database/app_database.dart';
import '../../data/repositories/bucket_list_repository.dart';
import '../../data/repositories/course_repository.dart';
import '../../data/repositories/round_repository.dart';
import '../monetization/free_limit.dart';

/// Which CSV column feeds which ledger field. Null means "not in this
/// file". Course name and date are the only fields a row can't do
/// without.
class CsvFieldMapping {
  const CsvFieldMapping({
    this.courseName,
    this.date,
    this.score,
    this.city,
    this.state,
    this.partners,
    this.notes,
  });

  final int? courseName;
  final int? date;
  final int? score;
  final int? city;
  final int? state;
  final int? partners;
  final int? notes;

  /// Guesses a mapping from header wording — the user adjusts on the
  /// mapping screen.
  factory CsvFieldMapping.guess(List<String> header) {
    int? find(List<String> words) {
      for (var i = 0; i < header.length; i++) {
        final h = header[i].toLowerCase();
        if (words.any(h.contains)) return i;
      }
      return null;
    }

    final course = find(['course', 'club']) ?? find(['name']);
    return CsvFieldMapping(
      courseName: course,
      date: find(['date', 'played', 'when']),
      score: find(['score', 'total', 'gross', 'strokes']),
      city: find(['city', 'town']),
      state: find(['state', 'province']),
      partners: find(['partner', 'with', 'player', 'group']),
      notes: find(['note', 'comment', 'story', 'memo']),
    );
  }
}

/// What an import run did, for the wrap-up line.
class CsvImportReport {
  const CsvImportReport({
    required this.roundsAdded,
    required this.coursesCreated,
    required this.rowsSkipped,
    required this.coursesSkippedAtCap,
  });

  final int roundsAdded;
  final int coursesCreated;

  /// Rows without a usable course name or date.
  final int rowsSkipped;

  /// Rows for new courses a free-tier user had no slots left for.
  final int coursesSkippedAtCap;

  String get summary {
    final parts = [
      'Imported $roundsAdded ${roundsAdded == 1 ? 'round' : 'rounds'}',
      if (coursesCreated > 0)
        '$coursesCreated new ${coursesCreated == 1 ? 'course' : 'courses'}',
      if (rowsSkipped > 0) '$rowsSkipped unusable rows skipped',
      if (coursesSkippedAtCap > 0)
        '$coursesSkippedAtCap rows past the free course limit',
    ];
    return parts.join(' · ');
  }
}

/// Imports spreadsheet rows as rounds. Existing courses are matched by
/// name (case-insensitive); new ones are created — but never past the
/// free-tier cap for a free user: those rows are counted and skipped,
/// existing-course rows still import (existing data is never gated).
Future<CsvImportReport> importCsvRounds({
  required CourseRepository courses,
  required RoundRepository rounds,
  required BucketListRepository bucketList,
  required CsvDocument doc,
  required CsvFieldMapping mapping,
  required bool entitled,
}) async {
  final existing = await courses.getCourses();
  final byName = {
    for (final c in existing) c.name.trim().toLowerCase(): c.id,
  };

  var added = 0, created = 0, skipped = 0, atCap = 0;
  for (final row in doc.rows) {
    String? cell(int? column) =>
        column == null ? null : doc.rowCell(row, column);

    final name = cell(mapping.courseName);
    final date = switch (cell(mapping.date)) {
      null => null,
      final text => parseLooseDate(text),
    };
    if (name == null || date == null) {
      skipped++;
      continue;
    }

    var courseId = byName[name.toLowerCase()];
    if (courseId == null) {
      if (!entitled &&
          courseFreeLimit.isReached(await courses.lifetimeCreated())) {
        atCap++;
        continue;
      }
      courseId = await courses.createCourse(CourseDraft(
        name: name,
        city: cell(mapping.city),
        state: cell(mapping.state),
        holes: CourseHoles.h18,
        kind: CourseKind.public,
      ));
      byName[name.toLowerCase()] = courseId;
      created++;
    }

    final roundId = await rounds.createRound(
      courseId,
      RoundDraft(
        date: date,
        totalScore: switch (cell(mapping.score)) {
          null => null,
          final s => int.tryParse(s),
        },
        holesPlayed: HolesPlayed.eighteen,
        partners: cell(mapping.partners) ?? '',
        notes: cell(mapping.notes),
      ),
    );
    await bucketList.completeItemsForCourse(courseId, roundId);
    added++;
  }
  return CsvImportReport(
    roundsAdded: added,
    coursesCreated: created,
    rowsSkipped: skipped,
    coursesSkippedAtCap: atCap,
  );
}
