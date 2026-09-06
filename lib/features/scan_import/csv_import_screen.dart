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
  await showCsvMappingScreen(
    context,
    doc: doc,
    fields: clCsvFields,
    title: 'Import spreadsheet',
    footnote: 'Rows without a course name or a readable date are '
        'skipped. Existing courses are matched by name.',
    onImport: (mapping) async {
      final report = await importCsvRounds(
        courses: ref.read(courseRepositoryProvider),
        rounds: ref.read(roundRepositoryProvider),
        bucketList: ref.read(bucketListRepositoryProvider),
        doc: doc,
        mapping: CsvFieldMapping(
          courseName: mapping['courseName'],
          date: mapping['date'],
          score: mapping['score'],
          city: mapping['city'],
          state: mapping['state'],
          partners: mapping['partners'],
          notes: mapping['notes'],
        ),
        entitled: await ref.read(entitlementServiceProvider).isUnlimited(),
      );
      return report.summary;
    },
  );
}


/// The Course Ledger fields for cc_core's [CsvMappingScreen].
const clCsvFields = [
  CsvField('courseName',
      label: 'Course name (required)',
      isRequired: true,
      guessTiers: [
        ['course', 'club'],
        ['name'],
      ]),
  CsvField('date',
      label: 'Date (required)',
      isRequired: true,
      guessTiers: [
        ['date', 'played', 'when'],
      ]),
  CsvField('score', label: 'Score', guessTiers: [
    ['score', 'total', 'gross', 'strokes'],
  ]),
  CsvField('city', label: 'City', guessTiers: [
    ['city', 'town'],
  ]),
  CsvField('state', label: 'State', guessTiers: [
    ['state', 'province'],
  ]),
  CsvField('partners', label: 'Partners', guessTiers: [
    ['partner', 'with', 'player', 'group'],
  ]),
  CsvField('notes', label: 'Notes', guessTiers: [
    ['note', 'comment', 'story', 'memo'],
  ]),
];
