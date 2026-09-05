import 'package:flutter/material.dart';

/// Scaffold-phase shell. The real Home (courses list A-Z / by state /
/// by recent, count headline, FreeLimit chip) lands in Phase B.
class HomeShell extends StatelessWidget {
  const HomeShell({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Course Ledger')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.golf_course, size: 64, color: theme.colorScheme.primary),
              const SizedBox(height: 16),
              Text(
                'The book of everywhere you’ve played.',
                style: theme.textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Not a rangefinder. Not a scorecard.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
