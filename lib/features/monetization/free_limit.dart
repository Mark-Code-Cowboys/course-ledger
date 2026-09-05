import 'package:cc_core/cc_core.dart';

/// Free tier: this many courses, forever. Existing data is never gated —
/// the limit only blocks *adding* a new course, and it counts lifetime
/// creations (see `courseTallyProvider`), so deleting a course doesn't
/// hand the slot back. This constant must only ever move UP.
const kFreeCourseLimit = 5;

/// Course Ledger's free-tier quota with its own paywall wording.
const courseFreeLimit = FreeLimit(
  kFreeCourseLimit,
  'courses',
  detailBuilder: _freeLimitDetail,
);

String _freeLimitDetail(int remaining) => switch (remaining) {
      0 => 'Free courses all used — go Pro to keep the ledger growing.',
      1 => '1 more course free — then Course Ledger Pro.',
      final n => '$n more courses free — then Course Ledger Pro.',
    };
