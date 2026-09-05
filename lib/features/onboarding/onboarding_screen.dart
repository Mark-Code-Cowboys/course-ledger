import 'package:cc_core/cc_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';
import '../courses/course_composer_screen.dart';
import '../scan_import/shoebox_flow.dart';

/// First run seen? Refreshed after onboarding completes.
final firstRunSeenProvider = FutureProvider<bool>(
  (ref) => FirstRunFlag(ref.watch(kvStoreProvider)).seen(),
);

/// The first thing a new user reads is the positioning — this is a
/// ledger, not a gadget — followed by the fork: shoebox importers start
/// with their stack of cards, everyone else with a course or a look
/// around.
class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  Future<void> _finish(WidgetRef ref) async {
    await FirstRunFlag(ref.read(kvStoreProvider)).markSeen();
    ref.invalidate(firstRunSeenProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OnboardingScaffold(
      icon: Icons.golf_course,
      positioning: 'The book of everywhere you’ve played.',
      subtitle: 'Not a rangefinder. Not a scorecard. Course Ledger is the '
          'notebook golfers keep — courses, when, with whom, one score, '
          'the story.',
      actions: [
        FilledButton.icon(
          icon: const Icon(Icons.document_scanner_outlined),
          label: const Text('Import my shoebox of scorecards'),
          onPressed: () async {
            // Run the flow first so this screen stays alive under it,
            // then swap to the shell.
            await runShoeboxImport(context, ref);
            await _finish(ref);
          },
        ),
        OutlinedButton.icon(
          icon: const Icon(Icons.add),
          label: const Text('Add my first course'),
          onPressed: () async {
            await Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const CourseComposerScreen(),
                fullscreenDialog: true,
              ),
            );
            await _finish(ref);
          },
        ),
        TextButton(
          onPressed: () => _finish(ref),
          child: const Text('Just look around'),
        ),
      ],
    );
  }
}
