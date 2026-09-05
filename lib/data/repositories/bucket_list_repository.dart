import 'package:drift/drift.dart';

import '../database/app_database.dart';

class BucketListRepository {
  BucketListRepository(this._db);

  final AppDatabase _db;

  /// Open items first, then done; oldest first within each group.
  Stream<List<BucketItem>> watchItems() {
    final query = _db.select(_db.bucketList)
      ..orderBy([
        (b) => OrderingTerm.asc(b.done),
        (b) => OrderingTerm.asc(b.id),
      ]);
    return query.watch();
  }

  /// A wish tied to a real course in the ledger.
  Future<int> addCourseItem(int courseId) {
    return _db.into(_db.bucketList).insert(
          BucketListCompanion.insert(courseId: Value(courseId)),
        );
  }

  /// A wish for a course not (yet) in the ledger — free text only.
  Future<int> addFreeTextItem(String freeText) {
    return _db.into(_db.bucketList).insert(
          BucketListCompanion.insert(freeText: Value(freeText)),
        );
  }

  Future<void> markDone(int itemId, {int? roundId}) {
    return (_db.update(_db.bucketList)..where((b) => b.id.equals(itemId)))
        .write(BucketListCompanion(
      done: const Value(true),
      doneRoundId: Value(roundId),
    ));
  }

  Future<void> markOpen(int itemId) {
    return (_db.update(_db.bucketList)..where((b) => b.id.equals(itemId)))
        .write(const BucketListCompanion(
      done: Value(false),
      doneRoundId: Value(null),
    ));
  }

  Future<void> deleteItem(int itemId) {
    return (_db.delete(_db.bucketList)..where((b) => b.id.equals(itemId)))
        .go();
  }

  /// Check-off-on-round-add linkage: when a round is logged at a course,
  /// any open bucket item for that course is marked done and linked to
  /// the round. Returns how many items were checked off.
  Future<int> completeItemsForCourse(int courseId, int roundId) {
    return (_db.update(_db.bucketList)
          ..where((b) => b.courseId.equals(courseId) & b.done.equals(false)))
        .write(BucketListCompanion(
      done: const Value(true),
      doneRoundId: Value(roundId),
    ));
  }
}
