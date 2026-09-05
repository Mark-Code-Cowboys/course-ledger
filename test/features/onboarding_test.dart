import 'package:cc_core/cc_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:course_ledger/core/theme/app_theme.dart';
import 'package:course_ledger/data/database/app_database.dart';
import 'package:course_ledger/data/providers.dart';
import 'package:course_ledger/features/monetization/monetization_providers.dart';
import 'package:course_ledger/features/onboarding/onboarding_screen.dart';
import 'package:course_ledger/features/scan_import/scan_import_providers.dart';
import 'package:course_ledger/features/shell/home_shell.dart';

import '../helpers.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = makeTestDb());
  tearDown(() => db.close());

  Widget rootApp(KeyValueStore store) => ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          kvStoreProvider.overrideWithValue(store),
          entitlementServiceProvider
              .overrideWithValue(FakeEntitlementService()),
          documentScanServiceProvider
              .overrideWithValue(const UnsupportedDocumentScanService()),
          textRecognitionServiceProvider
              .overrideWithValue(FakeTextRecognitionService()),
        ],
        child: MaterialApp(theme: AppTheme.light(), home: const _Root()),
      );

  testWidgets(
      'first run leads with the positioning line, the promise, and the fork',
      (tester) async {
    final store = InMemoryKeyValueStore();
    await tester.pumpWidget(rootApp(store));
    await tester.pumpAndSettle();

    expect(find.text('The book of everywhere you’ve played.'), findsOneWidget);
    expect(find.textContaining('Not a rangefinder. Not a scorecard.'),
        findsOneWidget);
    expect(find.text(kPrivacyBoilerplate), findsOneWidget);
    expect(find.text('Import my shoebox of scorecards'), findsOneWidget);
    expect(find.text('Add my first course'), findsOneWidget);

    await tester.tap(find.text('Just look around'));
    await tester.pumpAndSettle();

    // Swapped to the shell, and the flag persisted.
    expect(find.text('Course Ledger'), findsOneWidget);
    expect(await FirstRunFlag(store).seen(), isTrue);
    await disposeApp(tester);
  });

  testWidgets('returning users go straight to the shell', (tester) async {
    final store = InMemoryKeyValueStore();
    await FirstRunFlag(store).markSeen();

    await tester.pumpWidget(rootApp(store));
    await tester.pumpAndSettle();

    // The shell (which reuses the positioning line in its empty state),
    // not the onboarding fork.
    expect(find.text('Just look around'), findsNothing);
    expect(find.text('Course Ledger'), findsOneWidget);
    await disposeApp(tester);
  });

  testWidgets('the add-first-course fork opens the composer, then the shell',
      (tester) async {
    await tester.pumpWidget(rootApp(InMemoryKeyValueStore()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add my first course'));
    await tester.pumpAndSettle();
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Course name'), 'Pine Hollow');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Pine Hollow'), findsOneWidget); // in the ledger
    expect(find.text('1 course · 1 state'), findsNothing); // no state given
    expect(find.text('1 course'), findsOneWidget);
    await disposeApp(tester);
  });
}

/// Mirrors app.dart's root switch without exporting the private widget.
class _Root extends ConsumerWidget {
  const _Root();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final seen = ref.watch(firstRunSeenProvider).value;
    return switch (seen) {
      null => const Scaffold(body: SizedBox.shrink()),
      false => const OnboardingScreen(),
      true => const HomeShell(),
    };
  }
}
