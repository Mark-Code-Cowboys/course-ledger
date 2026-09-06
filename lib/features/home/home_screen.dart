import 'package:cc_core/cc_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/dates.dart';
import '../../data/providers.dart';
import '../../data/repositories/course_repository.dart';
import '../courses/course_detail_screen.dart';
import '../monetization/monetization_providers.dart';
import '../monetization/paywall_sheet.dart';
import '../scan_import/import_sheet.dart';

enum CourseSort { az, byState, byRecent }

/// [summaries] sorted for the given mode. A-Z is case-insensitive;
/// by-state groups alphabetically with stateless courses last; by-recent
/// puts the most recently played first and never-played courses last.
List<CourseSummary> sortSummaries(
    List<CourseSummary> summaries, CourseSort sort) {
  final sorted = [...summaries];
  int byName(CourseSummary a, CourseSummary b) =>
      a.course.name.toLowerCase().compareTo(b.course.name.toLowerCase());
  switch (sort) {
    case CourseSort.az:
      sorted.sort(byName);
    case CourseSort.byState:
      sorted.sort((a, b) {
        final sa = a.course.state, sb = b.course.state;
        if (sa == null && sb == null) return byName(a, b);
        if (sa == null) return 1;
        if (sb == null) return -1;
        final cmp = sa.compareTo(sb);
        return cmp != 0 ? cmp : byName(a, b);
      });
    case CourseSort.byRecent:
      sorted.sort((a, b) {
        final da = a.lastPlayed, db = b.lastPlayed;
        if (da == null && db == null) return byName(a, b);
        if (da == null) return 1;
        if (db == null) return -1;
        return db.compareTo(da);
      });
  }
  return sorted;
}

/// "47 courses · 12 states" — the ledger's proudest line, via cc_core's
/// countHeadline (zero states drop off; the course count always shows).
String ledgerHeadline(List<CourseSummary> summaries) {
  final states = summaries
      .map((s) => s.course.state)
      .whereType<String>()
      .toSet()
      .length;
  return countHeadline([
    CountedSubject(summaries.length, 'course'),
    CountedSubject(states, 'state'),
  ]);
}

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  var _sort = CourseSort.az;

  @override
  Widget build(BuildContext context) {
    final summaries = ref.watch(courseSummariesProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Ledger'),
        actions: [
          IconButton(
            icon: const Icon(Icons.move_to_inbox_outlined),
            tooltip: 'Import rounds',
            onPressed: () => showImportSheet(context, ref),
          ),
        ],
      ),
      body: summaries.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (list) => list.isEmpty ? _empty(context) : _list(context, list),
      ),
    );
  }

  Widget _empty(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.golf_course,
                size: 64, color: theme.colorScheme.primary),
            const SizedBox(height: 16),
            Text('The book of everywhere you’ve played.',
                style: theme.textTheme.titleMedium,
                textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(
              'Add the first course to start your ledger.',
              style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _list(BuildContext context, List<CourseSummary> list) {
    final theme = Theme.of(context);
    final sorted = sortSummaries(list, _sort);
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
          child: Text(ledgerHeadline(list),
              style: theme.textTheme.headlineSmall),
        ),
        // Invisible for Pro owners; taps open the paywall.
        // Invisible for Pro owners; taps open the paywall.
        if (ref.watch(freeTierUsageProvider) case final usage?)
          FreeTierCounter(
            usage: usage,
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            onGoPro: () => showPaywallSheet(context),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: SegmentedButton<CourseSort>(
            segments: const [
              ButtonSegment(value: CourseSort.az, label: Text('A-Z')),
              ButtonSegment(value: CourseSort.byState, label: Text('State')),
              ButtonSegment(value: CourseSort.byRecent, label: Text('Recent')),
            ],
            selected: {_sort},
            onSelectionChanged: (s) => setState(() => _sort = s.single),
          ),
        ),
        for (final summary in sorted) _CourseTile(summary: summary),
        const SizedBox(height: 88), // keep the FAB off the last tile
      ],
    );
  }
}

class _CourseTile extends StatelessWidget {
  const _CourseTile({required this.summary});

  final CourseSummary summary;

  @override
  Widget build(BuildContext context) {
    final course = summary.course;
    final place = [
      if (course.city != null) course.city,
      if (course.state != null) course.state,
    ].join(', ');
    final played = summary.lastPlayed == null
        ? 'Not played yet'
        : 'Last played ${formatDate(summary.lastPlayed!)}';
    return ListTile(
      title: Text(course.name),
      subtitle: Text(place.isEmpty ? played : '$place · $played'),
      trailing: summary.roundCount == 0
          ? null
          : Text('${summary.roundCount} '
              '${summary.roundCount == 1 ? 'round' : 'rounds'}'),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => CourseDetailScreen(courseId: course.id),
        ),
      ),
    );
  }
}
