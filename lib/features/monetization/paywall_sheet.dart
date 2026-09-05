import 'package:cc_core/cc_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'free_limit.dart';
import 'monetization_providers.dart';

/// Shows the Pro pitch. Resolves true if the user owns Pro when the
/// sheet closes (purchase or restore completed while it was open).
Future<bool> showPaywallSheet(BuildContext context) async {
  final result = await showPaywallModal<bool>(
    context,
    builder: (context) => const _PaywallSheet(),
  );
  return result ?? false;
}

class _PaywallSheet extends ConsumerWidget {
  const _PaywallSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final monthlyPrice = ref.watch(_monthlyPriceProvider).value;
    final lifetimePrice = ref.watch(_lifetimePriceProvider).value;
    final usage = ref.watch(freeTierUsageProvider);
    final service = ref.read(entitlementServiceProvider);

    // Close with success the moment the entitlement lands.
    ref.listen(isProProvider, (_, next) {
      if (next.value == true && context.mounted) {
        Navigator.of(context).pop(true);
      }
    });

    // Purchase-stream failures land asynchronously; show them here so
    // "nothing happened" always has a visible reason.
    ref.listen(storeErrorsProvider, (_, next) {
      final message = next.value;
      if (message != null && context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
      }
    });

    return PaywallSheetScaffold(
      icon: Icons.menu_book_rounded,
      title: 'Course Ledger Pro',
      highlight: usage?.label,
      body: 'The free ledger keeps your first $kFreeCourseLimit courses '
          'forever — nothing you\'ve logged is ever locked away. Pro is '
          'the whole book: every course you\'ve ever played, in one '
          'place. No account, and your ledger still never leaves this '
          'device.',
      benefits: const [
        PaywallBenefit(
          icon: Icons.all_inclusive,
          title: 'Unlimited courses',
          detail: 'The ledger grows as far as your golf does.',
        ),
        PaywallBenefit(
          icon: Icons.map_outlined,
          title: 'Trends and the played map',
          detail: 'States filled in, courses per year, the long arc.',
        ),
        PaywallBenefit(
          icon: Icons.ios_share_outlined,
          title: 'Export and backup',
          detail: 'Your book, portable — CSV export and full backup.',
        ),
      ],
      primaryLabel: 'Go Pro · ${monthlyPrice ?? r'$2.99'} / month',
      onPrimary: () => runStoreAction(context, service.buyPremium),
      restoreLabel: 'Restore purchase',
      onRestore: () => runStoreAction(context, service.restorePurchases),
      extraActions: [
        TextButton(
          onPressed: () => runStoreAction(context, service.buyUnlimited),
          child: Text('Or yours forever · ${lifetimePrice ?? r'$24.99'}'),
        ),
      ],
      onLater: () => Navigator.of(context).pop(false),
    );
  }
}

final _monthlyPriceProvider = FutureProvider.autoDispose<String?>(
  (ref) => ref.watch(entitlementServiceProvider).premiumPrice(),
);

final _lifetimePriceProvider = FutureProvider.autoDispose<String?>(
  (ref) => ref.watch(entitlementServiceProvider).unlimitedPrice(),
);
