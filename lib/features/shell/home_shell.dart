import 'package:cc_core/cc_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';
import '../bucket_list/bucket_list_screen.dart';
import '../courses/course_composer_screen.dart';
import '../home/home_screen.dart';
import '../monetization/free_limit.dart';
import '../monetization/monetization_providers.dart';
import '../monetization/paywall_sheet.dart';
import '../trends/trends_screen.dart';

class HomeShell extends ConsumerStatefulWidget {
  const HomeShell({super.key});

  @override
  ConsumerState<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends ConsumerState<HomeShell> {
  var _index = 0;

  static const _screens = [HomeScreen(), BucketListScreen(), TrendsScreen()];

  /// The one gated action in the app: adding a course past the free
  /// five (lifetime creations, so deletes don't refund slots) opens
  /// the paywall instead; unlocking mid-flow continues to the composer.
  Future<void> _addCourse() async {
    final entitled =
        await ref.read(entitlementServiceProvider).isUnlimited();
    final used = await ref.read(courseRepositoryProvider).lifetimeCreated();
    try {
      courseFreeLimit.guard(used: used, entitled: entitled);
    } on FreeLimitReachedException {
      if (!mounted) return;
      final unlocked = await showPaywallSheet(context);
      if (!unlocked) return;
    }
    if (!mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const CourseComposerScreen(),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_index],
      floatingActionButton: switch (_index) {
        0 => FloatingActionButton.extended(
            onPressed: _addCourse,
            icon: const Icon(Icons.add),
            label: const Text('Add course'),
          ),
        1 => FloatingActionButton.extended(
            onPressed: () => showAddBucketItemDialog(context, ref),
            icon: const Icon(Icons.add),
            label: const Text('Add a wish'),
          ),
        _ => null,
      },
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.menu_book_outlined), label: 'Courses'),
          NavigationDestination(
              icon: Icon(Icons.flag_outlined), label: 'Bucket list'),
          NavigationDestination(
              icon: Icon(Icons.insights_outlined), label: 'Trends'),
        ],
      ),
    );
  }
}
