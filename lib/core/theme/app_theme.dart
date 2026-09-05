import 'package:cc_core/cc_core.dart';
import 'package:flutter/material.dart';

/// Placeholder palette seeded from fairway green (#1E5631) per the build
/// prompt; the hand-tuned ledger-book palette lands with real brand art.
/// Layout/base behavior comes from cc_core's theme module.
abstract final class AppTheme {
  static const _fairway = Color(0xFF1E5631);

  static final _tokens = CcThemeTokens(
    seed: _fairway,
    lightScheme: ColorScheme.fromSeed(seedColor: _fairway).copyWith(
      primary: _fairway,
      onPrimary: Colors.white,
    ),
  );

  static ThemeData light() => ccLightTheme(_tokens);

  static ThemeData dark() => ccDarkTheme(_tokens);
}
