import 'package:cc_core/cc_core.dart';

import '../../core/utils/dates.dart';

/// What one scorecard photo transcribed to. Every field is exactly what
/// the camera saw (cased for readability) — the user confirms and edits
/// on the review screen before anything is saved.
class ScorecardDraft {
  ScorecardDraft({this.courseName, this.date, this.totalScore});

  String? courseName;
  DateTime? date;
  int? totalScore;
}

// A plausible 9-or-18-hole total. Wide on purpose: transcription picks
// the printed number, the user corrects outliers on the review screen.
const _minTotal = 25;
const _maxTotal = 170;

final _totalWord =
    RegExp(r'\b(total|gross|net|score)\b', caseSensitive: false);
final _number = RegExp(r'\b(\d{1,3})\b');

// Rows that are scorecard plumbing, never a course name.
final _nameNoise = RegExp(
    r'\b(hole|par|yards?|yardage|handicap|hcp|index|tee|tees|out|in|'
    r'total|gross|net|date|player|scorer|attest|marker|rating|slope)\b',
    caseSensitive: false);

/// Scorecards shout the club name in ALL CAPS; make it readable.
/// Mixed-case names pass through untouched.
String _titleCaseShouted(String s) {
  if (s != s.toUpperCase()) return s;
  return s
      .toLowerCase()
      .split(' ')
      .map((w) => w.isEmpty ? w : w[0].toUpperCase() + w.substring(1))
      .join(' ');
}

/// Transcribes one scorecard photo's OCR into a [ScorecardDraft].
///
/// Course name: the tallest text in the top third of the card that
/// isn't grid plumbing — clubs print their name big at the top.
/// Date: the first parseable date anywhere on the card.
/// Total: a number in playable range on a row that says total/gross/
/// net/score, preferring the rightmost on the best row.
///
/// Null when the photo had no text at all. No field is ever invented —
/// missing stays null for the user to fill in.
ScorecardDraft? parseScorecard(List<OcrLine> lines) {
  if (lines.isEmpty) return null;

  // --- course name ---
  String? name;
  final bottom =
      lines.map((l) => l.top + l.height).reduce((a, b) => a > b ? a : b);
  final topThird = lines.where((l) => l.top < bottom / 3).toList()
    ..sort((a, b) => b.height.compareTo(a.height));
  for (final line in topThird) {
    final text = line.text.trim();
    if (text.length < 4 || _nameNoise.hasMatch(text)) continue;
    if (!RegExp(r'[a-zA-Z]{3}').hasMatch(text)) continue;
    name = _titleCaseShouted(text);
    break;
  }

  // --- date ---
  DateTime? date;
  final rows = mergeOcrRows(lines);
  for (final row in rows) {
    date = parseLooseDate(row);
    if (date != null) break;
  }

  // --- total score ---
  int? total;
  for (final row in rows) {
    if (!_totalWord.hasMatch(row)) continue;
    final inRange = _number
        .allMatches(row)
        .map((m) => int.parse(m.group(1)!))
        .where((n) => n >= _minTotal && n <= _maxTotal)
        .toList();
    if (inRange.isNotEmpty) {
      total = inRange.last; // rightmost printed number on the row
      break;
    }
  }

  if (name == null && date == null && total == null) return null;
  return ScorecardDraft(courseName: name, date: date, totalScore: total);
}
