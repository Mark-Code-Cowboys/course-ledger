import 'dart:io';

import 'package:cc_core/cc_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import 'app.dart';
import 'core/export/share_plus_launcher.dart';
import 'data/database/app_database.dart';
import 'data/database/seed.dart';
import 'data/providers.dart';
import 'features/monetization/monetization_providers.dart';
import 'features/scan_import/scan_import_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = AppDatabase.open();
  final documents = await getApplicationDocumentsDirectory();
  final photosDir =
      await Directory('${documents.path}/round_photos').create(recursive: true);

  // Screenshot data: `flutter run --dart-define=DEMO_SEED=true`.
  // Demo builds also fake Pro so the counter stays out of shots and the
  // Pro-gated Trends screens are capturable; never ship this flag
  // (release-checklist.md).
  const demo = bool.fromEnvironment('DEMO_SEED');
  if (demo) {
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
        photoServiceProvider.overrideWithValue(
            ImagePickerPhotoService(photosDir, filePrefix: 'round')),
        tempDirProvider.overrideWithValue(getTemporaryDirectory),
        if (demo)
          entitlementServiceProvider
              .overrideWithValue(FakeEntitlementService(unlimited: true)),
      ],
      child: const CourseLedgerApp(),
    ),
  );
}
