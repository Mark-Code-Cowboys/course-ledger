import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'csv_import_screen.dart';
import 'shoebox_flow.dart';

/// The two ways history gets into the ledger besides typing it.
Future<void> showImportSheet(BuildContext context, WidgetRef ref) async {
  final choice = await showModalBottomSheet<_Import>(
    context: context,
    builder: (context) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.document_scanner_outlined),
            title: const Text('Scan scorecards'),
            subtitle: const Text(
                'The shoebox import — shoot a stack of cards, review, '
                'add them all.'),
            onTap: () => Navigator.of(context).pop(_Import.shoebox),
          ),
          ListTile(
            leading: const Icon(Icons.table_chart_outlined),
            title: const Text('Import a spreadsheet'),
            subtitle: const Text('CSV in, rounds out — map your columns.'),
            onTap: () => Navigator.of(context).pop(_Import.csv),
          ),
        ],
      ),
    ),
  );
  if (choice == null || !context.mounted) return;
  switch (choice) {
    case _Import.shoebox:
      await runShoeboxImport(context, ref);
    case _Import.csv:
      await runCsvImport(context, ref);
  }
}

enum _Import { shoebox, csv }
