import 'package:cc_core/cc_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import 'app.dart';
import 'core/export/share_plus_launcher.dart';
import 'data/database/app_database.dart';
import 'data/database/seed.dart';
import 'data/providers.dart';
import 'features/scan_import/scan_import_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = AppDatabase.open();

  // Screenshot data: `flutter run --dart-define=DEMO_SEED=true`
  if (const bool.fromEnvironment('DEMO_SEED')) {
    await seedDemoData(db);
  }

  runApp(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),
        documentScanServiceProvider
            .overrideWithValue(MlKitDocumentScanService()),
        textRecognitionServiceProvider
            .overrideWithValue(MlKitTextRecognitionService()),
        shareLauncherProvider.overrideWithValue(SharePlusLauncher()),
        tempDirProvider.overrideWithValue(getTemporaryDirectory),
      ],
      child: const CourseLedgerApp(),
    ),
  );
}
