import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database/app_database.dart';
import '../../data/providers.dart';

class BucketListScreen extends ConsumerWidget {
  const BucketListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(bucketItemsProvider);
    final courses = ref.watch(courseSummariesProvider).value ?? const [];
    final courseNames = {
      for (final s in courses) s.course.id: s.course.name,
    };
    return Scaffold(
      appBar: AppBar(title: const Text('Bucket list')),
      body: items.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (list) =>
            list.isEmpty ? _empty(context) : _list(context, ref, list, courseNames),
      ),
    );
  }

  Widget _empty(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.flag_outlined,
                size: 64, color: theme.colorScheme.primary),
            const SizedBox(height: 16),
            Text('The courses you haven’t played yet.',
                style: theme.textTheme.titleMedium,
                textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(
              'Add one — when you log a round there, it checks itself off.',
              style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _list(BuildContext context, WidgetRef ref, List<BucketItem> list,
      Map<int, String> courseNames) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 88),
      children: [
        for (final item in list)
          Dismissible(
            key: ValueKey('bucket-${item.id}'),
            direction: DismissDirection.endToStart,
            background: Container(
              color: Theme.of(context).colorScheme.error,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 16),
              child: Icon(Icons.delete,
                  color: Theme.of(context).colorScheme.onError),
            ),
            onDismissed: (_) =>
                ref.read(bucketListRepositoryProvider).deleteItem(item.id),
            child: CheckboxListTile(
              value: item.done,
              onChanged: (checked) {
                final repo = ref.read(bucketListRepositoryProvider);
                if (checked == true) {
                  repo.markDone(item.id);
                } else {
                  repo.markOpen(item.id);
                }
              },
              title: Text(
                item.courseId != null
                    ? (courseNames[item.courseId] ?? 'A course')
                    : item.freeText!,
                style: item.done
                    ? const TextStyle(decoration: TextDecoration.lineThrough)
                    : null,
              ),
              subtitle: item.done && item.doneRoundId != null
                  ? const Text('Played it — checked off with your round.')
                  : null,
            ),
          ),
      ],
    );
  }
}

/// Add-a-wish dialog: link a ledger course or write free text — one or
/// the other, mirroring the courseId-XOR-freeText schema rule.
Future<void> showAddBucketItemDialog(BuildContext context, WidgetRef ref) {
  return showDialog<void>(
    context: context,
    builder: (_) => const _AddBucketItemDialog(),
  );
}

class _AddBucketItemDialog extends ConsumerStatefulWidget {
  const _AddBucketItemDialog();

  @override
  ConsumerState<_AddBucketItemDialog> createState() =>
      _AddBucketItemDialogState();
}

class _AddBucketItemDialogState extends ConsumerState<_AddBucketItemDialog> {
  final _controller = TextEditingController();
  int? _selectedCourseId;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _add() {
    final repo = ref.read(bucketListRepositoryProvider);
    final id = _selectedCourseId;
    final text = _controller.text.trim();
    if (id != null) {
      repo.addCourseItem(id);
    } else if (text.isNotEmpty) {
      repo.addFreeTextItem(text);
    } else {
      return; // nothing entered — keep the dialog open
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final courses = ref.watch(courseSummariesProvider).value ?? const [];
    return AlertDialog(
      title: const Text('Add to bucket list'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            autofocus: true,
            enabled: _selectedCourseId == null,
            decoration: const InputDecoration(
              labelText: 'Course you want to play',
              hintText: 'Bandon Dunes…',
            ),
            textCapitalization: TextCapitalization.words,
          ),
          if (courses.isNotEmpty) ...[
            const SizedBox(height: 12),
            DropdownButtonFormField<int?>(
              initialValue: _selectedCourseId,
              decoration: const InputDecoration(
                labelText: 'Or link a course in your ledger',
              ),
              items: [
                const DropdownMenuItem(value: null, child: Text('—')),
                for (final s in courses)
                  DropdownMenuItem(
                      value: s.course.id, child: Text(s.course.name)),
              ],
              onChanged: (id) => setState(() => _selectedCourseId = id),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel')),
        FilledButton(onPressed: _add, child: const Text('Add')),
      ],
    );
  }
}
