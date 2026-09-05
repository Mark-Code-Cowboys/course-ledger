import 'package:drift/native.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:course_ledger/data/database/app_database.dart';
import 'package:course_ledger/data/repositories/course_repository.dart';
import 'package:course_ledger/data/repositories/round_repository.dart';

AppDatabase makeTestDb() => AppDatabase(NativeDatabase.memory());

/// Call at the end of every widget test that renders the app.
///
/// Disposing the ProviderScope cancels drift stream queries, which
/// schedule zero-duration cleanup timers; unmounting here and pumping
/// once lets them fire inside the test's fake-async zone instead of
/// tripping the pending-timer guard during final teardown.
Future<void> disposeApp(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump(const Duration(seconds: 1));
}

CourseDraft courseDraft({
  String name = 'Pine Hollow',
  String? city = 'Lansing',
  String? state = 'MI',
  CourseHoles holes = CourseHoles.h18,
  CourseKind kind = CourseKind.public,
  int? rating,
}) =>
    CourseDraft(
      name: name,
      city: city,
      state: state,
      holes: holes,
      kind: kind,
      rating: rating,
    );

RoundDraft roundDraft({
  DateTime? date,
  int? totalScore,
  HolesPlayed holesPlayed = HolesPlayed.eighteen,
  String partners = '',
  String? notes,
  List<RoundPhotoDraft> photos = const [],
}) =>
    RoundDraft(
      date: date ?? DateTime(2026, 6, 15),
      totalScore: totalScore,
      holesPlayed: holesPlayed,
      partners: partners,
      notes: notes,
      photos: photos,
    );
