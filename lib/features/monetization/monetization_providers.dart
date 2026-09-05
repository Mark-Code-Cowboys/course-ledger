import 'dart:async';

import 'package:cc_core/cc_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';
import 'entitlements.dart';
import 'free_limit.dart';

final entitlementServiceProvider = Provider<EntitlementService>((ref) {
  final service =
      StoreEntitlementService(ref.watch(kvStoreProvider), clStoreProducts);
  // Fire-and-forget lapse check; the cache answers until it lands.
  unawaited(service.refreshEntitlements());
  ref.onDispose(service.dispose);
  return service;
});

/// True when Pro is owned — the lifetime unlock or an active monthly
/// subscription (cc_core's `isUnlimited` covers both). Defaults to
/// false while loading so gating stays conservative.
final isProProvider = StreamProvider<bool>(
  (ref) => ref.watch(entitlementServiceProvider).watchUnlimited(),
);

/// Store failure messages (failed purchases, restore/refresh errors)
/// so an open paywall sheet can show why nothing happened.
final storeErrorsProvider = StreamProvider<String>(
  (ref) => ref.watch(entitlementServiceProvider).storeErrors,
);

/// Courses ever created on this device, live, so the free-tier counter
/// ticks the moment a course is saved. Deleting a course doesn't lower
/// it: the free tier is spent by creating, not by keeping.
final lifetimeCoursesProvider = StreamProvider<int>(
  (ref) => ref.watch(courseRepositoryProvider).watchLifetimeCreated(),
);

/// Null while entitlements or the count are still loading, and null
/// whenever the cap doesn't apply (Pro owned) — so counter UI simply
/// disappears for paying users and never flashes at them on startup.
final freeTierUsageProvider = Provider<FreeLimitUsage?>((ref) {
  final pro = ref.watch(isProProvider).value;
  final count = ref.watch(lifetimeCoursesProvider).value;
  if (pro == null || pro || count == null) return null;
  return courseFreeLimit.usage(count);
});
