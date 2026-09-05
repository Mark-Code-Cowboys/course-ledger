import 'package:cc_core/cc_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:course_ledger/data/database/app_database.dart';
import 'package:course_ledger/data/repositories/course_repository.dart';

import '../helpers.dart';

/// Restore that actually finds a purchase, for the restore-path test.
class _RestoringFake extends FakeEntitlementService {
  @override
  Future<void> restorePurchases() => buyUnlimited();
}

void main() {
  late AppDatabase db;

  setUp(() => db = makeTestDb());
  tearDown(() => db.close());

  Future<void> seedCourses(int n) async {
    final repo = CourseRepository(db);
    for (var i = 0; i < n; i++) {
      await repo.createCourse(courseDraft(name: 'Course $i'));
    }
  }

  testWidgets('at the cap, Add course opens the paywall, not the composer',
      (tester) async {
    await seedCourses(5);

    await tester.pumpWidget(testApp(db: db));
    await tester.pumpAndSettle();
    expect(find.text('5 of 5 free courses used'), findsOneWidget);
    expect(find.text('Free courses all used — go Pro to keep the ledger '
        'growing.'), findsOneWidget);

    await tester.tap(find.text('Add course'));
    await tester.pumpAndSettle();

    expect(find.text('Course Ledger Pro'), findsOneWidget);
    // The paywall restates where the user stands.
    expect(find.text('5 of 5 free courses used'), findsNWidgets(2));
    expect(find.text('Unlimited courses'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Course name'), findsNothing);

    await tester.ensureVisible(find.text('Maybe later'));
    await tester.tap(find.text('Maybe later'));
    await tester.pumpAndSettle();
    expect(find.text('Course Ledger Pro'), findsNothing);
    expect(find.widgetWithText(TextFormField, 'Course name'), findsNothing);
    await disposeApp(tester);
  });

  testWidgets('under the cap, Add course goes straight to the composer',
      (tester) async {
    await seedCourses(4);

    await tester.pumpWidget(testApp(db: db));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add course'));
    await tester.pumpAndSettle();

    expect(find.text('Course Ledger Pro'), findsNothing);
    expect(find.widgetWithText(TextFormField, 'Course name'), findsOneWidget);
    await disposeApp(tester);
  });

  testWidgets('buying monthly Pro mid-gate continues into the composer',
      (tester) async {
    await seedCourses(5);

    await tester.pumpWidget(testApp(db: db));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add course'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text(r'Go Pro · $12.99 / month'));
    await tester.tap(find.text(r'Go Pro · $12.99 / month'));
    await tester.pumpAndSettle();

    expect(find.text('Course Ledger Pro'), findsNothing);
    expect(find.widgetWithText(TextFormField, 'Course name'), findsOneWidget);

    // Leave the composer: the counter is gone for the new Pro owner.
    await tester.tap(find.byType(CloseButton));
    await tester.pumpAndSettle();
    expect(find.textContaining('free courses used'), findsNothing);
    await disposeApp(tester);
  });

  testWidgets('restore purchase unlocks from the sheet', (tester) async {
    await seedCourses(5);

    await tester.pumpWidget(
        testApp(db: db, entitlements: _RestoringFake()));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add course'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Restore purchase'));
    await tester.tap(find.text('Restore purchase'));
    await tester.pumpAndSettle();

    expect(find.text('Course Ledger Pro'), findsNothing);
    expect(find.widgetWithText(TextFormField, 'Course name'), findsOneWidget);
    await disposeApp(tester);
  });

  testWidgets('Pro owners see no counter and no gate', (tester) async {
    await seedCourses(6);

    await tester.pumpWidget(testApp(
        db: db, entitlements: FakeEntitlementService(unlimited: true)));
    await tester.pumpAndSettle();

    expect(find.textContaining('free courses used'), findsNothing);
    expect(find.text('6 courses · 1 state'), findsOneWidget);

    await tester.tap(find.text('Add course'));
    await tester.pumpAndSettle();
    expect(find.text('Course Ledger Pro'), findsNothing);
    expect(find.widgetWithText(TextFormField, 'Course name'), findsOneWidget);
    await disposeApp(tester);
  });

  testWidgets('tapping the counter opens the paywall directly',
      (tester) async {
    await seedCourses(2);

    await tester.pumpWidget(testApp(db: db));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Go Pro'));
    await tester.pumpAndSettle();
    expect(find.text('Course Ledger Pro'), findsOneWidget);
    await disposeApp(tester);
  });
}
