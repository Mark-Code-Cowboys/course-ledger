import 'package:flutter/material.dart';

/// Placeholder palette seeded from fairway green (#1E5631) per the build
/// prompt; the hand-tuned ledger-book palette lands in the polish phase.
///
/// cc_core gap: this file is the same shape as Table Encore's AppTheme —
/// the base-theme-from-tokens belongs in cc_core `theme/` (tracked in
/// docs/cc-core-gaps.md).
abstract final class AppTheme {
  static const _fairway = Color(0xFF1E5631);

  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(seedColor: _fairway).copyWith(
      primary: _fairway,
      onPrimary: Colors.white,
    );
    return _base(scheme);
  }

  static ThemeData dark() {
    final scheme = ColorScheme.fromSeed(
      seedColor: _fairway,
      brightness: Brightness.dark,
    );
    return _base(scheme);
  }

  static ThemeData _base(ColorScheme scheme) {
    return ThemeData(
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
      ),
    );
  }
}
