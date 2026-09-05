import 'package:cc_core/cc_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'data/database/app_database.dart';
import 'data/providers.dart';
import 'features/scan_import/scan_import_providers.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final db = AppDatabase.open();

  runApp(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),
        documentScanServiceProvider
            .overrideWithValue(MlKitDocumentScanService()),
        textRecognitionServiceProvider
            .overrideWithValue(MlKitTextRecognitionService()),
      ],
      child: const CourseLedgerApp(),
    ),
  );
}
