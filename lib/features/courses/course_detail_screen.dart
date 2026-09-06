import 'package:cc_core/cc_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/dates.dart';
import '../../core/utils/labels.dart';
import '../../data/database/app_database.dart';
import '../../data/providers.dart';
import '../../data/repositories/course_repository.dart';
import '../../data/repositories/round_repository.dart';
import '../rounds/round_composer_screen.dart';
import 'course_composer_screen.dart';

class CourseDetailScreen extends ConsumerWidget {
  const CourseDetailScreen({super.key, required this.courseId});

  final int courseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final course = ref.watch(courseProvider(courseId)).value;
    if (course == null) {
      // Deleted out from under us (or still loading the first frame).
      return const Scaffold(body: SizedBox.shrink());
    }
    final stats = ref.watch(courseStatsProvider(courseId)).value;
    final rounds = ref.watch(roundsForCourseProvider(courseId)).value;
    return Scaffold(
      appBar: AppBar(
        title: Text(course.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit course',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => CourseComposerScreen(existing: course),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Delete course',
            onPressed: () => _confirmDelete(context, ref, course),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => RoundComposerScreen(courseId: courseId),
            fullscreenDialog: true,
          ),
        ),
        icon: const Icon(Icons.sports_golf),
        label: const Text('Log a round'),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 88),
        children: [
          _header(context, course),
          if (stats != null && stats.roundCount > 0)
            _statsRow(context, stats),
          const Divider(height: 32),
          if (rounds != null && rounds.isEmpty) _emptyRounds(context),
          if (rounds != null)
            for (final r in rounds) _RoundTile(entry: r),
        ],
      ),
    );
  }

  Widget _header(BuildContext context, Course course) {
    final theme = Theme.of(context);
    final place = [
      if (course.city != null) course.city,
      if (course.state != null) course.state,
      if (course.country != 'US') course.country,
    ].join(', ');
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (place.isNotEmpty)
            Text(place, style: theme.textTheme.bodyLarge),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Chip(label: Text(course.holes.label)),
              Chip(label: Text(course.kind.label)),
              if (course.par != null) Chip(label: Text('Par ${course.par}')),
              if (course.rating != null) RatingStars(rating: course.rating),
            ],
          ),
          if (course.notes != null) ...[
            const SizedBox(height: 12),
            Text(course.notes!, style: theme.textTheme.bodyMedium),
          ],
        ],
      ),
    );
  }

  Widget _statsRow(BuildContext context, CourseStats stats) {
    Widget stat(String label, String value) => Expanded(
          child: Column(
            children: [
              Text(value,
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center),
              Text(label,
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center),
            ],
          ),
        );
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        children: [
          stat('First played', formatDate(stats.firstPlayed!)),
          stat('Last played', formatDate(stats.lastPlayed!)),
          stat('Best score', stats.bestScore?.toString() ?? '—'),
        ],
      ),
    );
  }

  Widget _emptyRounds(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(Icons.menu_book_outlined,
              size: 48, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(height: 12),
          Text(
            'No rounds here yet. Log the first one — the date, the score, '
            'the story.',
            style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(
      BuildContext context, WidgetRef ref, Course course) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Delete ${course.name}?'),
        content: const Text(
            'Every round logged here goes with it. This cannot be undone.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Delete')),
        ],
      ),
    );
    if (confirmed != true) return;
    await ref.read(courseRepositoryProvider).deleteCourse(course.id);
    if (context.mounted) Navigator.of(context).pop();
  }
}

class _RoundTile extends StatelessWidget {
  const _RoundTile({required this.entry});

  final RoundWithStory entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final round = entry.round;
    final details = [
      '${round.holesPlayed.label} holes',
      if (round.walkedOrCart != null) round.walkedOrCart!.label,
      if (round.tees != null) '${round.tees} tees',
      if (round.partners.isNotEmpty) 'with ${round.partners}',
      if (round.weather != null) round.weather,
    ].join(' · ');
    return ListTile(
      isThreeLine: entry.notes != null,
      leading: CircleAvatar(
        child: Text(round.totalScore?.toString() ?? '—'),
      ),
      title: Text(formatDate(round.date)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(details),
          if (entry.notes != null)
            Text(
              entry.notes!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                fontStyle: FontStyle.italic,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
        ],
      ),
      trailing: entry.rating == null
          ? null
          : RatingStars(rating: entry.rating, size: 14),
    );
  }
}
