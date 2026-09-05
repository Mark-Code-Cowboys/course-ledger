import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cc_core/cc_core.dart';
import 'package:course_ledger/core/theme/app_theme.dart';
import 'package:course_ledger/data/database/app_database.dart';
import 'package:course_ledger/data/providers.dart';
import 'package:course_ledger/data/repositories/course_repository.dart';
import 'package:course_ledger/data/repositories/round_repository.dart';
import 'package:course_ledger/features/monetization/monetization_providers.dart';
import 'package:course_ledger/features/scan_import/scan_import_providers.dart';
import 'package:course_ledger/features/shell/home_shell.dart';

AppDatabase makeTestDb() => AppDatabase(NativeDatabase.memory());

/// The app wired to an in-memory database and fake services; [home]
/// defaults to the shell and [entitlements] to a free-tier user.
Widget testApp({
  required AppDatabase db,
  EntitlementService? entitlements,
  DocumentScanService? scanner,
  TextRecognitionService? recognizer,
  Widget? home,
}) =>
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),
        kvStoreProvider.overrideWithValue(InMemoryKeyValueStore()),
        entitlementServiceProvider
            .overrideWithValue(entitlements ?? FakeEntitlementService()),
        documentScanServiceProvider.overrideWithValue(
            scanner ?? const UnsupportedDocumentScanService()),
        textRecognitionServiceProvider
            .overrideWithValue(recognizer ?? FakeTextRecognitionService()),
      ],
      child: MaterialApp(
        theme: AppTheme.light(),
        home: home ?? const HomeShell(),
      ),
    );

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
