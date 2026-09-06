import 'package:cc_core/cc_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/dates.dart';
import '../../data/providers.dart';
import '../monetization/monetization_providers.dart';
import '../monetization/paywall_sheet.dart';
import 'scan_import_providers.dart';
import 'scorecard_parser.dart';
import 'shoebox_importer.dart';

/// THE feature: the shoebox import. Shoot a stack of scorecards (up to
/// 20 in one scanner session), review what each card transcribed to,
/// fix anything the camera misread, and file them all at once.
///
/// Transcription only: the review screen shows exactly what was read —
/// missing fields stay blank for the user, never guessed.
Future<void> runShoeboxImport(BuildContext context, WidgetRef ref) async {
  // The converter is a Pro feature, like scanning in every CC app.
  final pro = await ref.read(entitlementServiceProvider).isUnlimited();
  if (!context.mounted) return;
  if (!pro) {
    final unlocked = await showPaywallSheet(context);
    if (!unlocked || !context.mounted) return;
  }

  final messenger = ScaffoldMessenger.of(context);

  final paths = await captureDocumentPages(
      ref.read(documentScanServiceProvider),
      pageLimit: 20);
  if (paths.isEmpty || !context.mounted) return;

  final transcription = await batchTranscribe<ScorecardDraft>(
    imagePaths: paths,
    recognizer: ref.read(textRecognitionServiceProvider),
    parse: parseScorecard,
  );
  if (!context.mounted) return;
  if (transcription.items.isEmpty) {
    messenger.showSnackBar(const SnackBar(
        content: Text("Couldn't read those cards — try closer, "
            'straighter shots.')));
    return;
  }
  if (transcription.failedCount > 0) {
    messenger.showSnackBar(SnackBar(
        content: Text('${transcription.failedCount} '
            '${transcription.failedCount == 1 ? 'card was' : 'cards were'} '
            'unreadable and skipped.')));
  }

  final kept = await showBatchReviewScreen<ScorecardDraft>(
    context,
    items: transcription.items,
    title: 'Scanned scorecards',
    subtitle: 'Exactly what each card says — fix anything the camera '
        'misread, uncheck cards that don\'t belong. Cards without a date '
        'are filed under today.',
    confirmLabel: (n) => n == 1 ? 'Add 1 round' : 'Add $n rounds',
    itemBuilder: (context, item, onChanged) =>
        _ScorecardRow(item: item, onChanged: onChanged),
  );
  if (kept == null || kept.isEmpty || !context.mounted) return;

  final report = await insertScannedRounds(
    courses: ref.read(courseRepositoryProvider),
    rounds: ref.read(roundRepositoryProvider),
    bucketList: ref.read(bucketListRepositoryProvider),
    drafts: [for (final item in kept) item.value],
  );
  messenger.showSnackBar(SnackBar(content: Text(report.summary)));
}

class _ScorecardRow extends StatelessWidget {
  const _ScorecardRow({required this.item, required this.onChanged});

  final BatchScanItem<ScorecardDraft> item;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final draft = item.value;
    final details = [
      draft.date == null ? 'No date' : formatDate(draft.date!),
      draft.totalScore == null ? 'No score' : 'Score ${draft.totalScore}',
    ].join(' · ');
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(draft.courseName ?? 'No course name',
          style: draft.courseName == null
              ? theme.textTheme.bodyLarge?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: theme.colorScheme.onSurfaceVariant)
              : null),
      subtitle: Text(details),
      trailing: IconButton(
        icon: const Icon(Icons.edit_outlined),
        tooltip: 'Edit card',
        onPressed: () async {
          await showDialog<void>(
            context: context,
            builder: (_) => _EditScorecardDialog(draft: draft),
          );
          onChanged();
        },
      ),
    );
  }
}

/// Edits one transcribed card in place. Fields start as what the camera
/// saw; the dialog never suggests values.
class _EditScorecardDialog extends StatefulWidget {
  const _EditScorecardDialog({required this.draft});

  final ScorecardDraft draft;

  @override
  State<_EditScorecardDialog> createState() => _EditScorecardDialogState();
}

class _EditScorecardDialogState extends State<_EditScorecardDialog> {
  late final _name = TextEditingController(text: widget.draft.courseName);
  late final _score =
      TextEditingController(text: widget.draft.totalScore?.toString());
  late DateTime? _date = widget.draft.date;

  @override
  void dispose() {
    _name.dispose();
    _score.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit card'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _name,
            decoration: const InputDecoration(labelText: 'Course name'),
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _score,
            decoration: const InputDecoration(labelText: 'Total score'),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.event),
              label: Text(_date == null ? 'Set date' : formatDate(_date!)),
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _date ?? DateTime.now(),
                  firstDate: DateTime(1950),
                  lastDate: DateTime.now(),
                );
                if (picked != null) setState(() => _date = picked);
              },
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel')),
        FilledButton(
          onPressed: () {
            final name = _name.text.trim();
            widget.draft
              ..courseName = name.isEmpty ? null : name
              ..totalScore = int.tryParse(_score.text.trim())
              ..date = _date;
            Navigator.of(context).pop();
          },
          child: const Text('Done'),
        ),
      ],
    );
  }
}
