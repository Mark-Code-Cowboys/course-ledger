import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'monetization_providers.dart';
import 'paywall_sheet.dart';

/// "2 of 5 free courses used" — shows free users exactly how close the
/// Pro unlock is, with a progress bar that fills as courses are added.
/// Renders nothing for Pro owners (and while entitlements are still
/// loading, so it never flashes at them).
class FreeTierCounter extends ConsumerWidget {
  const FreeTierCounter({
    super.key,
    this.margin = const EdgeInsets.fromLTRB(16, 8, 16, 0),
  });

  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usage = ref.watch(freeTierUsageProvider);
    if (usage == null) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final radius = BorderRadius.circular(12);

    return Padding(
      padding: margin,
      child: Material(
        color: usage.atLimit
            ? scheme.primaryContainer
            : scheme.surfaceContainerHighest,
        borderRadius: radius,
        child: InkWell(
          borderRadius: radius,
          onTap: () => showPaywallSheet(context),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 4, 10),
            child: Row(
              children: [
                Icon(
                  usage.atLimit
                      ? Icons.star_rounded
                      : Icons.star_outline_rounded,
                  color: scheme.primary,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(usage.label, style: theme.textTheme.titleSmall),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: LinearProgressIndicator(
                          value: usage.used / usage.limit,
                          minHeight: 6,
                          backgroundColor: scheme.surface,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(usage.detail, style: theme.textTheme.bodySmall),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => showPaywallSheet(context),
                  child: const Text('Go Pro'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
