import 'package:cc_core/cc_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/dates.dart';
import '../../core/utils/labels.dart';
import '../../core/widgets/rating_stars.dart';
import '../../data/database/app_database.dart';
import '../../data/providers.dart';
import '../../data/repositories/round_repository.dart';

/// Log a round: the date, one score, who came along — and the story,
/// front and center. This is a memory, not a stat.
class RoundComposerScreen extends ConsumerStatefulWidget {
  const RoundComposerScreen({super.key, required this.courseId});

  final int courseId;

  @override
  ConsumerState<RoundComposerScreen> createState() =>
      _RoundComposerScreenState();
}

class _RoundComposerScreenState extends ConsumerState<RoundComposerScreen> {
  var _date = DateTime.now();
  final _score = TextEditingController();
  final _partners = TextEditingController();
  final _story = TextEditingController();
  final _tees = TextEditingController();
  final _weather = TextEditingController();
  var _holesPlayed = HolesPlayed.eighteen;
  WalkedOrCart? _walkedOrCart;
  int? _rating;
  final _photos = <JournalPhotoDraft>[];
  var _saving = false;

  @override
  void dispose() {
    for (final c in [_score, _partners, _story, _tees, _weather]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _addPhoto() async {
    final source = await showModalBottomSheet<PhotoSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Take a photo'),
              onTap: () => Navigator.of(context).pop(PhotoSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Pick from gallery'),
              onTap: () => Navigator.of(context).pop(PhotoSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source == null) return;
    final path = await ref.read(photoServiceProvider).acquire(source);
    if (path != null && mounted) {
      setState(() => _photos.add(JournalPhotoDraft(path: path)));
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _save() async {
    if (_saving) return;
    setState(() => _saving = true);
    final draft = RoundDraft(
      date: _date,
      totalScore: int.tryParse(_score.text.trim()),
      holesPlayed: _holesPlayed,
      tees: _tees.text.trim().isEmpty ? null : _tees.text.trim(),
      walkedOrCart: _walkedOrCart,
      partners: _partners.text.trim(),
      weather: _weather.text.trim().isEmpty ? null : _weather.text.trim(),
      rating: _rating,
      notes: _story.text.trim().isEmpty ? null : _story.text.trim(),
      photos: List.of(_photos),
    );
    final roundId = await ref
        .read(roundRepositoryProvider)
        .createRound(widget.courseId, draft);
    // Check-off-on-round-add: playing a bucket-list course completes it.
    final checkedOff = await ref
        .read(bucketListRepositoryProvider)
        .completeItemsForCourse(widget.courseId, roundId);
    if (!mounted) return;
    if (checkedOff > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Checked off your bucket list.')),
      );
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log a round'),
        actions: [
          TextButton(
            onPressed: _saving ? null : _save,
            child: const Text('Save'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _pickDate,
                  icon: const Icon(Icons.event),
                  label: Text(formatDate(_date)),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 96,
                child: TextField(
                  controller: _score,
                  decoration: const InputDecoration(labelText: 'Score'),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _partners,
            decoration: const InputDecoration(
              labelText: 'Played with',
              hintText: 'Sam, Dale…',
            ),
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 16),
          // The story is the point of the app — biggest field on the page.
          TextField(
            controller: _story,
            decoration: InputDecoration(
              labelText: 'The story',
              hintText: 'The shot you’ll retell. The birdie on 17. '
                  'Who was there.',
              alignLabelWithHint: true,
              border: const OutlineInputBorder(),
              hintStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant),
            ),
            maxLines: 6,
            textCapitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: 12),
          // The card, the view from 18 — photos ride with the story.
          PhotoAttachmentStrip(
            items: [
              for (final p in _photos)
                PhotoStripItem(
                  file: ref.read(photoServiceProvider).fileFor(p.path),
                  caption: p.caption,
                  onRemove: () => setState(() => _photos.remove(p)),
                ),
            ],
            onAdd: _addPhoto,
          ),
          const SizedBox(height: 24),
          Text('Details', style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
          SegmentedButton<HolesPlayed>(
            segments: [
              for (final h in HolesPlayed.values)
                ButtonSegment(value: h, label: Text(h.label)),
            ],
            selected: {_holesPlayed},
            onSelectionChanged: (s) => setState(() => _holesPlayed = s.single),
          ),
          const SizedBox(height: 12),
          SegmentedButton<WalkedOrCart>(
            emptySelectionAllowed: true,
            segments: [
              for (final w in WalkedOrCart.values)
                ButtonSegment(value: w, label: Text(w.label)),
            ],
            selected: {?_walkedOrCart},
            onSelectionChanged: (s) =>
                setState(() => _walkedOrCart = s.isEmpty ? null : s.single),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _tees,
                  decoration: const InputDecoration(labelText: 'Tees'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _weather,
                  decoration: const InputDecoration(labelText: 'Weather'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text('Day rating'),
              const SizedBox(width: 12),
              RatingStars(
                rating: _rating,
                onChanged: (r) => setState(() => _rating = r),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
