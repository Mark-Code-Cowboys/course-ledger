import 'dart:io';

import 'package:cc_core/cc_core.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';
import '../monetization/monetization_providers.dart';
import 'csv_importer.dart';

/// Picks a CSV file and opens the column-mapping screen.
Future<void> runCsvImport(BuildContext context, WidgetRef ref) async {
  const typeGroup = XTypeGroup(
    label: 'Spreadsheet',
    extensions: ['csv', 'txt'],
  );
  final file = await openFile(acceptedTypeGroups: const [typeGroup]);
  if (file == null || !context.mounted) return;
  final messenger = ScaffoldMessenger.of(context);

  final CsvDocument doc;
  try {
    doc = parseCsv(await File(file.path).readAsString());
  } on Exception {
    messenger.showSnackBar(const SnackBar(
        content: Text("Couldn't read that file as CSV.")));
    return;
  }
  if (!context.mounted) return;
  if (doc.header.isEmpty || doc.rows.isEmpty) {
    messenger.showSnackBar(const SnackBar(
        content: Text('That file has no data rows.')));
    return;
  }
  await Navigator.of(context).push(
    MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (_) => CsvImportScreen(doc: doc),
    ),
  );
}

/// The column mapper: pick which spreadsheet column feeds which ledger
/// field, then import. Course name and date are required per row;
/// everything else is optional.
class CsvImportScreen extends ConsumerStatefulWidget {
  const CsvImportScreen({super.key, required this.doc});

  final CsvDocument doc;

  @override
  ConsumerState<CsvImportScreen> createState() => _CsvImportScreenState();
}

class _CsvImportScreenState extends ConsumerState<CsvImportScreen> {
  late final _guess = CsvFieldMapping.guess(widget.doc.header);
  late int? _courseName = _guess.courseName;
  late int? _date = _guess.date;
  late int? _score = _guess.score;
  late int? _city = _guess.city;
  late int? _state = _guess.state;
  late int? _partners = _guess.partners;
  late int? _notes = _guess.notes;
  var _importing = false;

  Future<void> _import() async {
    if (_importing) return;
    setState(() => _importing = true);
    final messenger = ScaffoldMessenger.of(context);
    final report = await importCsvRounds(
      courses: ref.read(courseRepositoryProvider),
      rounds: ref.read(roundRepositoryProvider),
      bucketList: ref.read(bucketListRepositoryProvider),
      doc: widget.doc,
      mapping: CsvFieldMapping(
        courseName: _courseName,
        date: _date,
        score: _score,
        city: _city,
        state: _state,
        partners: _partners,
        notes: _notes,
      ),
      entitled: await ref.read(entitlementServiceProvider).isUnlimited(),
    );
    messenger.showSnackBar(SnackBar(content: Text(report.summary)));
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rowWord = widget.doc.rows.length == 1 ? 'row' : 'rows';
    return Scaffold(
      appBar: AppBar(title: const Text('Import spreadsheet')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('${widget.doc.rows.length} $rowWord found. Match your '
              'columns to the ledger:'),
          const SizedBox(height: 16),
          _picker('Course name (required)', _courseName,
              (i) => _courseName = i),
          _picker('Date (required)', _date, (i) => _date = i),
          _picker('Score', _score, (i) => _score = i),
          _picker('City', _city, (i) => _city = i),
          _picker('State', _state, (i) => _state = i),
          _picker('Partners', _partners, (i) => _partners = i),
          _picker('Notes', _notes, (i) => _notes = i),
          const SizedBox(height: 8),
          Text(
            'Rows without a course name or a readable date are skipped. '
            'Existing courses are matched by name.',
            style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _courseName == null || _date == null || _importing
                ? null
                : _import,
            icon: const Icon(Icons.download_done),
            label: Text(_importing ? 'Importing…' : 'Import'),
          ),
        ],
      ),
    );
  }

  Widget _picker(String label, int? value, void Function(int?) apply) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<int?>(
        initialValue: value,
        decoration: InputDecoration(labelText: label),
        items: [
          const DropdownMenuItem(value: null, child: Text('—')),
          for (var i = 0; i < widget.doc.header.length; i++)
            DropdownMenuItem(value: i, child: Text(widget.doc.header[i])),
        ],
        onChanged: (i) => setState(() => apply(i)),
      ),
    );
  }
}
