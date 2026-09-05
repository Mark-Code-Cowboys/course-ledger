import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../bucket_list/bucket_list_screen.dart';
import '../courses/course_composer_screen.dart';
import '../home/home_screen.dart';

class HomeShell extends ConsumerStatefulWidget {
  const HomeShell({super.key});

  @override
  ConsumerState<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends ConsumerState<HomeShell> {
  var _index = 0;

  static const _screens = [HomeScreen(), BucketListScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_index],
      floatingActionButton: _index == 0
          ? FloatingActionButton.extended(
              // Phase C wraps this in the FreeLimit gate.
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const CourseComposerScreen(),
                  fullscreenDialog: true,
                ),
              ),
              icon: const Icon(Icons.add),
              label: const Text('Add course'),
            )
          : FloatingActionButton.extended(
              onPressed: () => showAddBucketItemDialog(context, ref),
              icon: const Icon(Icons.add),
              label: const Text('Add a wish'),
            ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.menu_book_outlined), label: 'Courses'),
          NavigationDestination(
              icon: Icon(Icons.flag_outlined), label: 'Bucket list'),
        ],
      ),
    );
  }
}
