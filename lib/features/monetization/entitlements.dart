import 'package:cc_core/cc_core.dart';

// The billing wrapper, entitlement cache, and store types live in
// cc_core; this file keeps Course Ledger's product catalog and
// re-exports the shared types for app import sites.
export 'package:cc_core/cc_core.dart'
    show
        EntitlementService,
        FakeEntitlementService,
        StoreEntitlementService,
        StoreProducts,
        StoreUnavailableException;

/// Store product ids. Must match the products configured in Play
/// Console (and later App Store Connect) exactly.
abstract final class ProductIds {
  static const proMonthly = 'courseledger_pro_monthly';
  static const proLifetime = 'courseledger_pro_lifetime';
  static const all = [proMonthly, proLifetime];
}

/// Course Ledger's catalog: one Pro entitlement, sold as a monthly
/// subscription or a lifetime unlock. cc_core's `isUnlimited()` is true
/// for either (premium includes the unlock), so the whole app gates on
/// that single answer.
const clStoreProducts = StoreProducts(
  lifetimeUnlock: ProductIds.proLifetime,
  premiumSubscription: ProductIds.proMonthly,
);
