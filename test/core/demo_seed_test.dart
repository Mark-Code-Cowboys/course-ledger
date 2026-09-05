import 'package:flutter_test/flutter_test.dart';

import 'package:course_ledger/data/database/seed.dart';

import '../helpers.dart';

void main() {
  test('DEMO_SEED plants exactly 15 courses, 40 rounds, 3 states',
      () async {
    final db = makeTestDb();
    addTearDown(db.close);

    await seedDemoData(db);

    final courses = await db.select(db.courses).get();
    final rounds = await db.select(db.rounds).get();
    expect(courses, hasLength(15));
    expect(rounds, hasLength(40));
    expect(courses.map((c) => c.state).toSet(), {'MI', 'OH', 'NC'});

    // Stories are the point — a healthy share of rounds carry one,
    // now as journal entries linked from the round.
    final entries = await db.select(db.appJournalEntries).get();
    expect(entries.where((e) => e.notes != null).length,
        greaterThanOrEqualTo(15));
    expect(rounds.where((r) => r.journalEntryId != null).length,
        greaterThanOrEqualTo(15));

    // The bucket list demos the check-off linkage.
    final bucket = await db.select(db.bucketList).get();
    expect(bucket, hasLength(3));
    expect(bucket.where((b) => b.done && b.doneRoundId != null),
        hasLength(1));
  });

  test('seeding is a no-op on a ledger with data', () async {
    final db = makeTestDb();
    addTearDown(db.close);

    await seedDemoData(db);
    await seedDemoData(db); // second run must not duplicate

    expect(await db.select(db.courses).get(), hasLength(15));
  });
}
