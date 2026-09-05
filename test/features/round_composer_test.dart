import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:course_ledger/data/database/app_database.dart';
import 'package:course_ledger/data/repositories/bucket_list_repository.dart';
import 'package:course_ledger/data/repositories/course_repository.dart';
import 'package:course_ledger/features/courses/course_detail_screen.dart';

import '../helpers.dart';

void main() {
  late AppDatabase db;
  late int courseId;

  setUp(() async {
    db = makeTestDb();
    courseId = await CourseRepository(db)
        .createCourse(courseDraft(name: 'Pine Hollow'));
  });

  tearDown(() => db.close());

  testWidgets(
      'logging a round saves the memory and checks off the bucket list',
      (tester) async {
    final bucket = BucketListRepository(db);
    await bucket.addCourseItem(courseId);

    await tester.pumpWidget(
        testApp(db: db, home: CourseDetailScreen(courseId: courseId)));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Log a round'));
    await tester.pumpAndSettle();

    await tester.enterText(
        find.widgetWithText(TextField, 'Score'), '91');
    await tester.enterText(
        find.widgetWithText(TextField, 'Played with'), 'Sam, Dale');
    await tester.enterText(find.widgetWithText(TextField, 'The story'),
        'Birdie on 17 into the wind.');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    // Back on the detail screen with the round listed and the snackbar up.
    expect(find.text('Checked off your bucket list.'), findsOneWidget);
    expect(find.textContaining('Birdie on 17'), findsOneWidget);
    expect(find.text('91'), findsAtLeastNWidgets(1));
    expect(find.textContaining('with Sam, Dale'), findsOneWidget);

    // Direct db reads inside a widget test need the real event loop.
    final items = (await tester.runAsync(() => bucket.watchItems().first))!;
    expect(items.single.done, isTrue);
    expect(items.single.doneRoundId, isNotNull);

    // Let the snackbar's auto-dismiss timer fire inside the test zone.
    await tester.pump(const Duration(seconds: 5));
    await disposeApp(tester);
  });
}
