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

final courseRepositoryProvider = Provider<CourseRepository>(
  (ref) => CourseRepository(ref.watch(databaseProvider)),
);

final roundRepositoryProvider = Provider<RoundRepository>(
  (ref) => RoundRepository(ref.watch(databaseProvider)),
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
    StreamProvider.family<List<RoundWithPhotos>, int>(
  (ref, courseId) =>
      ref.watch(roundRepositoryProvider).watchRoundsForCourse(courseId),
);

final bucketItemsProvider = StreamProvider<List<BucketItem>>(
  (ref) => ref.watch(bucketListRepositoryProvider).watchItems(),
);
