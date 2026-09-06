import 'package:cc_core/cc_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/labels.dart';
import '../../data/database/app_database.dart';
import '../../data/providers.dart';
import '../../data/repositories/course_repository.dart';

/// Add or edit a course. Pass [existing] to edit.
class CourseComposerScreen extends ConsumerStatefulWidget {
  const CourseComposerScreen({super.key, this.existing});

  final Course? existing;

  @override
  ConsumerState<CourseComposerScreen> createState() =>
      _CourseComposerScreenState();
}

class _CourseComposerScreenState extends ConsumerState<CourseComposerScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.existing?.name);
  late final _city = TextEditingController(text: widget.existing?.city);
  late final _state = TextEditingController(text: widget.existing?.state);
  late final _country =
      TextEditingController(text: widget.existing?.country ?? 'US');
  late final _par =
      TextEditingController(text: widget.existing?.par?.toString());
  late final _notes = TextEditingController(text: widget.existing?.notes);
  late CourseHoles _holes = widget.existing?.holes ?? CourseHoles.h18;
  late CourseKind _kind = widget.existing?.kind ?? CourseKind.public;
  late int? _rating = widget.existing?.rating;

  @override
  void dispose() {
    for (final c in [_name, _city, _state, _country, _par, _notes]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final draft = CourseDraft(
      name: _name.text.trim(),
      city: _city.text.trim().isEmpty ? null : _city.text.trim(),
      state: _state.text.trim().isEmpty ? null : _state.text.trim(),
      country: _country.text.trim().isEmpty ? 'US' : _country.text.trim(),
      holes: _holes,
      par: int.tryParse(_par.text.trim()),
      kind: _kind,
      rating: _rating,
      notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
      lat: widget.existing?.lat,
      lng: widget.existing?.lng,
    );
    final repo = ref.read(courseRepositoryProvider);
    final existing = widget.existing;
    if (existing == null) {
      await repo.createCourse(draft);
    } else {
      await repo.updateCourse(existing.id, draft);
    }
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existing == null ? 'Add course' : 'Edit course'),
        actions: [
          TextButton(onPressed: _save, child: const Text('Save')),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(labelText: 'Course name'),
              textCapitalization: TextCapitalization.words,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Name the course' : null,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _city,
                    decoration: const InputDecoration(labelText: 'City'),
                    textCapitalization: TextCapitalization.words,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _state,
                    decoration: const InputDecoration(labelText: 'State'),
                    textCapitalization: TextCapitalization.characters,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _country,
                    decoration: const InputDecoration(labelText: 'Country'),
                    textCapitalization: TextCapitalization.characters,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SegmentedButton<CourseHoles>(
              segments: [
                for (final h in CourseHoles.values)
                  ButtonSegment(value: h, label: Text(h.label.split(' ').first)),
              ],
              selected: {_holes},
              onSelectionChanged: (s) => setState(() => _holes = s.single),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<CourseKind>(
                    initialValue: _kind,
                    decoration: const InputDecoration(labelText: 'Kind'),
                    items: [
                      for (final k in CourseKind.values)
                        DropdownMenuItem(value: k, child: Text(k.label)),
                    ],
                    onChanged: (k) => setState(() => _kind = k!),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _par,
                    decoration: const InputDecoration(labelText: 'Par'),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Rating'),
                const SizedBox(width: 12),
                RatingStars(
                  rating: _rating,
                  onChanged: (r) => setState(() => _rating = r),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notes,
              decoration: const InputDecoration(
                labelText: 'Notes',
                alignLabelWithHint: true,
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }
}
