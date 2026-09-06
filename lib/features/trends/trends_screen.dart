
import 'package:cc_core/cc_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/backup/backup_service.dart';
import '../../core/export/export_service.dart';
import '../../data/providers.dart';
import '../monetization/monetization_providers.dart';
import '../monetization/paywall_sheet.dart';

class TrendsScreen extends ConsumerWidget {
  const TrendsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pro = ref.watch(isProProvider).value ?? false;
    return Scaffold(
      appBar: AppBar(title: const Text('Trends')),
      body: pro
          ? const _TrendsContent()
          : ProTeaser(
              icon: Icons.map_outlined,
              headline: 'The long arc of your golf.',
              body: 'The played map, courses and rounds by year, your '
                  'score trend, and export — all part of Course Ledger '
                  'Pro.',
              ctaLabel: 'See Course Ledger Pro',
              onSeePro: () => showPaywallSheet(context),
              ungatedLabel: 'Restore a backup',
              onUngated: () => restoreBackupFlow(context, ref),
            ),
    );
  }
}

class _TrendsContent extends ConsumerWidget {
  const _TrendsContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final summaries = ref.watch(courseSummariesProvider).value;
    final rounds = ref.watch(allRoundsProvider).value;
    if (summaries == null || rounds == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final playedStates = summaries
        .map((s) => s.course.state?.trim().toUpperCase())
        .whereType<String>()
        .toSet();
    final countries =
        summaries.map((s) => s.course.country.trim().toUpperCase()).toSet();
    final scored = [
      for (final r in rounds)
        if (r.totalScore != null) (r.date, r.totalScore! as num),
    ];

    // First-played year per course; unplayed courses have no year yet.
    final firstPlayed = <int, DateTime>{};
    for (final r in rounds) {
      final seen = firstPlayed[r.courseId];
      if (seen == null || r.date.isBefore(seen)) {
        firstPlayed[r.courseId] = r.date;
      }
    }
    final coursesPerYear = <int, int>{};
    for (final d in firstPlayed.values) {
      coursesPerYear[d.year] = (coursesPerYear[d.year] ?? 0) + 1;
    }
    final roundsPerYear = <int, int>{};
    for (final r in rounds) {
      roundsPerYear[r.date.year] = (roundsPerYear[r.date.year] ?? 0) + 1;
    }

    Widget section(String title, Widget child) => Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: theme.textTheme.titleSmall),
              const SizedBox(height: 8),
              child,
            ],
          ),
        );

    return ListView(
      padding: const EdgeInsets.only(bottom: 32),
      children: [
        section(
          'The ledger so far',
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _StatChip(count: summaries.length, one: 'course'),
              _StatChip(count: rounds.length, one: 'round'),
              _StatChip(count: playedStates.length, one: 'state'),
              _StatChip(
                  count: countries.length,
                  one: 'country',
                  many: 'countries'),
            ],
          ),
        ),
        section(
          'The played map',
          RegionTileGrid(tiles: usStateTiles, filled: playedStates),
        ),
        if (coursesPerYear.isNotEmpty)
          section('New courses by year',
              YearlyBars(countsByYear: coursesPerYear)),
        if (roundsPerYear.isNotEmpty)
          section(
              'Rounds by year', YearlyBars(countsByYear: roundsPerYear)),
        section(
          'Score trend',
          TrendGate(
            points: scored.length,
            minPoints: 5,
            nudge: 'Log five scored rounds and the trend line appears — '
                'this is a ledger, not a stats app.',
            builder: (_) => SimpleLineChart(points: scored),
          ),
        ),
        section(
          'Your book, portable',
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              OutlinedButton.icon(
                icon: const Icon(Icons.table_chart_outlined),
                label: const Text('Share rounds as CSV'),
                onPressed: () => _shareCsv(context, ref),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                icon: const Icon(Icons.archive_outlined),
                label: const Text('Back up the whole ledger'),
                onPressed: () => _shareBackup(context, ref),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                icon: const Icon(Icons.settings_backup_restore),
                label: const Text('Restore a backup'),
                onPressed: () => restoreBackupFlow(context, ref),
              ),
            ],
          ),
        ),
      ],
    );
  }

  ExportService _exporter(WidgetRef ref) => ExportService(
        ref.read(databaseProvider),
        ref.read(shareLauncherProvider),
        ref.read(tempDirProvider),
        photos: ref.read(photoServiceProvider),
      );

  Future<void> _shareCsv(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await _exporter(ref).shareRoundsCsv();
    } on Exception catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Export failed: $e')));
    }
  }

  Future<void> _shareBackup(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await _exporter(ref).shareBackup(
          lifetimeCourses:
              await ref.read(courseRepositoryProvider).lifetimeCreated());
    } on Exception catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Backup failed: $e')));
    }
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.count, required this.one, String? many})
      : many = many ?? '${one}s';

  final int count;
  final String one;
  final String many;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Chip(
      label: Text('$count ${count == 1 ? one : many}'),
      labelStyle: theme.textTheme.bodyMedium,
    );
  }
}

/// The shared cc_core restore flow with Course Ledger's words and
/// tally raise. Available to free users — restoring your own ledger is
/// never gated.
Future<void> restoreBackupFlow(BuildContext context, WidgetRef ref) async {
  await runRestoreFlow(
    context,
    confirmBody: 'The ledger on this phone is replaced with the backup — '
        'courses, rounds, and bucket list. This cannot be undone.',
    photoStore: ref.read(photoServiceProvider),
    restore: (contents) async {
      final lifetime = await restoreFromExportData(
          ref.read(databaseProvider), contents.exportData);
      await ref.read(courseTallyProvider).raiseTo(lifetime);
    },
  );
}
