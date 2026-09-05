import 'package:drift/drift.dart';

import 'app_database.dart';

/// Demo ledger for screenshots and store listing shots:
/// `flutter run --dart-define=DEMO_SEED=true`
///
/// Exactly 15 courses across 3 states (MI, OH, NC) and 40 rounds, with
/// the kind of stories the app exists for. No-op unless the ledger is
/// empty, so a real ledger is never polluted.
Future<void> seedDemoData(AppDatabase db) async {
  final existing = await db.select(db.courses).get();
  if (existing.isNotEmpty) return;

  Future<int> course(
    String name,
    String city,
    String state, {
    CourseHoles holes = CourseHoles.h18,
    CourseKind kind = CourseKind.public,
    int? par = 72,
    int? rating,
  }) =>
      db.into(db.courses).insert(CoursesCompanion.insert(
            name: name,
            city: Value(city),
            state: Value(state),
            holes: holes,
            par: Value(par),
            kind: kind,
            rating: Value(rating),
          ));

  Future<int> round(
    int courseId,
    DateTime date, {
    int? score,
    String partners = '',
    String? weather,
    int? rating,
    String? story,
    HolesPlayed holes = HolesPlayed.eighteen,
  }) =>
      db.into(db.rounds).insert(RoundsCompanion.insert(
            courseId: courseId,
            date: date,
            totalScore: Value(score),
            holesPlayed: holes,
            partners: Value(partners),
            weather: Value(weather),
            rating: Value(rating),
            notes: Value(story),
          ));

  // --- Michigan (home turf) ---
  final pine = await course('Pine Hollow Golf Club', 'Lansing', 'MI',
      rating: 5);
  final birch = await course('Birch Run Muni', 'Birch Run', 'MI',
      kind: CourseKind.muni, par: 71, rating: 3);
  final cedar = await course('Cedar Bend', 'Traverse City', 'MI',
      kind: CourseKind.resort, rating: 4);
  final lakeview = await course('Lakeview Nine', 'Petoskey', 'MI',
      holes: CourseHoles.h9, par: 36, rating: 4);
  final ironwood = await course('Ironwood National', 'Marquette', 'MI',
      rating: 4);
  final stjoe = await course("St. Joe's Executive", 'St. Joseph', 'MI',
      kind: CourseKind.executive, par: 62, rating: 3);
  final thumb = await course('Thumb Coast Links', 'Port Austin', 'MI',
      rating: 5);

  // --- Ohio (the annual buddies trip) ---
  final eagle = await course('Eagle Crest', 'Columbus', 'OH', rating: 4);
  final buckeye =
      await course('Buckeye Valley', 'Dayton', 'OH', par: 70, rating: 3);
  final glacier = await course('Glacier Ridge', 'Dublin', 'OH', rating: 4);
  final hocking = await course('Hocking Hills Golf Club', 'Logan', 'OH',
      rating: 5);
  final maumee = await course('Maumee Bay', 'Oregon', 'OH',
      kind: CourseKind.resort, rating: 4);

  // --- North Carolina (the pilgrimage) ---
  final sandhills = await course('Sandhills No. 3', 'Pinehurst', 'NC',
      kind: CourseKind.resort, rating: 5);
  final blueridge = await course('Blue Ridge Highlands', 'Asheville', 'NC',
      kind: CourseKind.private, rating: 5);
  final outerbanks = await course('Outer Banks Dunes', 'Corolla', 'NC',
      rating: 4);

  // --- 40 rounds, 2022 → 2026 ---
  // Pine Hollow: the home course, played every year (10 rounds).
  await round(pine, DateTime(2022, 4, 30), score: 97, partners: 'Dale',
      weather: 'Cold, spitting rain', rating: 3,
      story: 'Season opener. Frozen grips, three lost balls, zero regrets.');
  await round(pine, DateTime(2022, 6, 11), score: 94, partners: 'Dale, Sam');
  await round(pine, DateTime(2022, 9, 3), score: 92, partners: 'Sam',
      story: 'First time under 93. Sam still talks about the flop on 16.');
  await round(pine, DateTime(2023, 5, 20), score: 93, partners: 'Dale');
  await round(pine, DateTime(2023, 8, 12), score: 90, partners: 'Dale, Sam',
      weather: 'Perfect', rating: 5,
      story: 'The birdie on 17 into the wind. The one I retell.');
  await round(pine, DateTime(2024, 5, 4), score: 91, partners: 'Sam');
  await round(pine, DateTime(2024, 10, 5), score: 89, partners: 'Dale',
      rating: 4, story: 'Broke 90 with dad watching from the cart path.');
  await round(pine, DateTime(2025, 6, 21), score: 88, partners: 'Dale, Sam');
  await round(pine, DateTime(2026, 5, 16), score: 90, partners: 'Sam');
  await round(pine, DateTime(2026, 8, 29), score: 86, partners: 'Dale, Sam',
      weather: 'Still morning', rating: 5,
      story: 'Career round. Par save from the bunker on 18 to seal it.');

  // Around Michigan (9 rounds).
  await round(birch, DateTime(2022, 7, 9), score: 95, partners: 'Alex');
  await round(birch, DateTime(2024, 7, 13), score: 92, partners: 'Alex',
      story: 'Muni golf at its finest: \$31, hard pans, no excuses.');
  await round(cedar, DateTime(2023, 7, 1), score: 96, partners: 'Jamie',
      weather: 'Lake breeze', rating: 4,
      story: 'Honeymoon round. Jamie drove the cart like a getaway car.');
  await round(cedar, DateTime(2025, 7, 5), score: 91, partners: 'Jamie');
  await round(lakeview, DateTime(2023, 7, 2), score: 41,
      holes: HolesPlayed.nine, partners: 'Jamie',
      story: 'Nine at sunset over Little Traverse Bay. Kept the card.');
  await round(lakeview, DateTime(2025, 7, 6), score: 39,
      holes: HolesPlayed.nine, partners: 'Jamie', rating: 5);
  await round(ironwood, DateTime(2024, 8, 17), score: 99, partners: 'Sam',
      weather: 'U.P. fog', story: 'Could not see the fairway on 12. Aimed '
          'at a pine and prayed.');
  await round(stjoe, DateTime(2026, 4, 18), score: 68,
      partners: 'Dale', story: 'Executive track to shake off the winter.');
  await round(cedar, DateTime(2024, 7, 6), score: 93, partners: 'Jamie');
  await round(lakeview, DateTime(2026, 7, 4), score: 40,
      holes: HolesPlayed.nine, partners: 'Jamie',
      story: 'Fourth of July nine. Fireworks over the bay on the drive home.');
  await round(thumb, DateTime(2026, 6, 27), score: 89, partners: 'Dale, Sam',
      weather: 'Wind off the lake', rating: 5,
      story: 'Found our new favorite. Fescue like Ireland, pop like Michigan.');
  await round(thumb, DateTime(2026, 8, 15), score: 91, partners: 'Dale');

  // The Ohio buddies trip, every June (12 rounds).
  await round(eagle, DateTime(2022, 6, 17), score: 96,
      partners: 'Dale, Sam, Marcus');
  await round(buckeye, DateTime(2022, 6, 18), score: 93,
      partners: 'Dale, Sam, Marcus',
      story: 'Marcus holed out from 130 and bought zero drinks.');
  await round(eagle, DateTime(2023, 6, 16), score: 94,
      partners: 'Dale, Sam, Marcus');
  await round(glacier, DateTime(2023, 6, 17), score: 95,
      partners: 'Dale, Sam, Marcus', weather: '95 and humid');
  await round(hocking, DateTime(2023, 6, 18), score: 91,
      partners: 'Dale, Sam, Marcus', rating: 5,
      story: 'The one in the hills. We still argue about the 14th green.');
  await round(eagle, DateTime(2024, 6, 21), score: 92,
      partners: 'Dale, Sam, Marcus');
  await round(maumee, DateTime(2024, 6, 22), score: 94,
      partners: 'Dale, Sam, Marcus', weather: 'Gale off Lake Erie',
      story: 'Links wind. Sam putted from 40 yards out and we let him.');
  await round(hocking, DateTime(2024, 6, 23), score: 90,
      partners: 'Dale, Sam, Marcus');
  await round(glacier, DateTime(2025, 6, 20), score: 92,
      partners: 'Dale, Sam, Marcus');
  await round(buckeye, DateTime(2025, 6, 21), score: 94,
      partners: 'Dale, Sam, Marcus');
  await round(hocking, DateTime(2025, 6, 22), score: 89,
      partners: 'Dale, Sam, Marcus', rating: 5,
      story: 'Trip record. Four scores in the 80s, one sunburn each.');
  await round(eagle, DateTime(2026, 6, 19), score: 91,
      partners: 'Dale, Sam, Marcus');
  await round(maumee, DateTime(2026, 6, 21), score: 93,
      partners: 'Dale, Sam, Marcus');

  // The North Carolina pilgrimage (5 rounds).
  await round(sandhills, DateTime(2025, 10, 10), score: 98,
      partners: 'Dale', weather: 'Carolina blue', rating: 5,
      story: 'The pilgrimage. Doesn\'t matter what I shot. (98. It was 98.)');
  await round(sandhills, DateTime(2025, 10, 11), score: 95, partners: 'Dale');
  await round(blueridge, DateTime(2025, 10, 12), score: 97, partners: 'Dale',
      story: 'Guest of Dale\'s cousin. Mountain golf: aim uphill, always.');
  await round(outerbanks, DateTime(2026, 3, 14), score: 96, partners: 'Jamie',
      weather: 'March wind', story: 'Off-season rates, all-season wind.');
  await round(outerbanks, DateTime(2026, 3, 15), score: 94, partners: 'Jamie',
      holes: HolesPlayed.partial,
      story: 'Fourteen holes before the storm chased us in. Counts.');

  // A bucket list with one item checked off by a real round.
  await db.into(db.bucketList).insert(BucketListCompanion.insert(
        freeText: const Value('Bandon Dunes, before I turn 50'),
      ));
  await db.into(db.bucketList).insert(BucketListCompanion.insert(
        freeText: const Value('A links round in Scotland with dad'),
      ));
  final wish = await db.into(db.bucketList).insert(
      BucketListCompanion.insert(courseId: Value(thumb)));
  final thumbRound = await (db.select(db.rounds)
        ..where((r) => r.courseId.equals(thumb))
        ..orderBy([(r) => OrderingTerm.asc(r.date)])
        ..limit(1))
      .getSingle();
  await (db.update(db.bucketList)..where((b) => b.id.equals(wish))).write(
      BucketListCompanion(
          done: const Value(true), doneRoundId: Value(thumbRound.id)));
}
