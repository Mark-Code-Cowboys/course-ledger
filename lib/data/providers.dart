import 'dart:io';

import 'package:cc_core/cc_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'database/app_database.dart';
import 'repositories/bucket_list_repository.dart';
import 'repositories/course_repository.dart';
import 'repositories/round_repository.dart';

/// Overridden in main() with the real on-device database, and in tests
/// with an in-memory one.
final databaseProvider = Provider<AppDatabase>(
  (ref) => throw UnimplementedError('databaseProvider must be overridden'),
);

/// Overridden in tests with [InMemoryKeyValueStore].
final kvStoreProvider = Provider<KeyValueStore>((ref) => SharedPrefsStore());

/// Courses ever created on this device; feeds the free tier so a slot
/// can't be recycled by delete-and-re-add.
final courseTallyProvider = Provider<LifetimeTally>((ref) {
  final tally = LifetimeTally(ref.watch(kvStoreProvider),
      key: 'courses_created_lifetime');
  ref.onDispose(tally.dispose);
  return tally;
});

/// Overridden in main() with ImagePickerPhotoService over the app's
/// round_photos directory, and in tests with a fake.
final photoServiceProvider = Provider<PhotoService>(
  (ref) => throw UnimplementedError('photoServiceProvider must be overridden'),
);

/// cc_core's journal repository over this database's generated tables.
final journalRepositoryProvider = Provider<AppJournalRepository>(
  (ref) => ref
      .watch(databaseProvider)
      .journal(photoStore: ref.watch(photoServiceProvider)),
);

final courseRepositoryProvider = Provider<CourseRepository>(
  (ref) => CourseRepository(ref.watch(databaseProvider),
      tally: ref.watch(courseTallyProvider),
      journal: ref.watch(journalRepositoryProvider)),
);

final roundRepositoryProvider = Provider<RoundRepository>(
  (ref) => RoundRepository(ref.watch(databaseProvider),
      journal: ref.watch(journalRepositoryProvider)),
);

final bucketListRepositoryProvider = Provider<BucketListRepository>(
  (ref) => BucketListRepository(ref.watch(databaseProvider)),
);

final courseSummariesProvider = StreamProvider<List<CourseSummary>>(
  (ref) => ref.watch(courseRepositoryProvider).watchSummaries(),
);

final courseProvider = StreamProvider.family<Course?, int>(
  (ref, id) => ref.watch(courseRepositoryProvider).watchCourse(id),
);

final courseStatsProvider = StreamProvider.family<CourseStats, int>(
  (ref, id) => ref.watch(courseRepositoryProvider).watchStats(id),
);

final roundsForCourseProvider =
    StreamProvider.family<List<RoundWithStory>, int>(
  (ref, courseId) =>
      ref.watch(roundRepositoryProvider).watchRoundsForCourse(courseId),
);

final bucketItemsProvider = StreamProvider<List<BucketItem>>(
  (ref) => ref.watch(bucketListRepositoryProvider).watchItems(),
);

/// Every round in the ledger, for the trends aggregates.
final allRoundsProvider = StreamProvider<List<Round>>(
  (ref) => ref.watch(roundRepositoryProvider).watchAllRounds(),
);

/// Overridden in main() with SharePlusLauncher, and in tests with
/// cc_core's FakeShareLauncher.
final shareLauncherProvider = Provider<ShareLauncher>(
  (ref) => throw UnimplementedError('shareLauncherProvider must be overridden'),
);

/// Overridden in main() with path_provider's temp dir, and in tests
/// with a system temp directory.
final tempDirProvider = Provider<Future<Directory> Function()>(
  (ref) => throw UnimplementedError('tempDirProvider must be overridden'),
);
