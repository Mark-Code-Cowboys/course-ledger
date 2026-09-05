import '../../data/database/app_database.dart';
import '../../data/repositories/bucket_list_repository.dart';
import '../../data/repositories/course_repository.dart';
import '../../data/repositories/round_repository.dart';
import 'scorecard_parser.dart';

/// What one bulk insert did, for the wrap-up snackbar.
class ShoeboxReport {
  const ShoeboxReport({
    required this.roundsAdded,
    required this.coursesCreated,
    required this.skippedNoName,
  });

  final int roundsAdded;
  final int coursesCreated;

  /// Cards kept in review without a course name — nothing to file
  /// them under, so they are skipped rather than guessed at.
  final int skippedNoName;

  String get summary {
    final rounds = '$roundsAdded ${roundsAdded == 1 ? 'round' : 'rounds'}';
    final created = coursesCreated == 0
        ? ''
        : ' · $coursesCreated new ${coursesCreated == 1 ? 'course' : 'courses'}';
    final skipped =
        skippedNoName == 0 ? '' : ' · $skippedNoName without a name skipped';
    return 'Added $rounds$created$skipped';
  }
}

/// Files confirmed scorecards into the ledger: each card becomes a
/// round at its course, matched to an existing course by name
/// (case-insensitive) or newly created with sensible defaults the user
/// can edit later. Logged rounds check off bucket-list items as usual.
Future<ShoeboxReport> insertScannedRounds({
  required CourseRepository courses,
  required RoundRepository rounds,
  required BucketListRepository bucketList,
  required List<ScorecardDraft> drafts,
}) async {
  final existing = await courses.getCourses();
  final byName = {
    for (final c in existing) c.name.trim().toLowerCase(): c.id,
  };

  var added = 0, created = 0, skipped = 0;
  for (final draft in drafts) {
    final name = draft.courseName?.trim();
    if (name == null || name.isEmpty) {
      skipped++;
      continue;
    }
    var courseId = byName[name.toLowerCase()];
    if (courseId == null) {
      courseId = await courses.createCourse(CourseDraft(
        name: name,
        holes: CourseHoles.h18,
        kind: CourseKind.public,
      ));
      byName[name.toLowerCase()] = courseId;
      created++;
    }
    final roundId = await rounds.createRound(
      courseId,
      RoundDraft(
        date: draft.date ?? DateTime.now(),
        totalScore: draft.totalScore,
        holesPlayed: HolesPlayed.eighteen,
      ),
    );
    await bucketList.completeItemsForCourse(courseId, roundId);
    added++;
  }
  return ShoeboxReport(
      roundsAdded: added, coursesCreated: created, skippedNoName: skipped);
}
