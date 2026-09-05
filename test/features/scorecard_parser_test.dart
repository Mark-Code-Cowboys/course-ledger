import 'package:cc_core/cc_core.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:course_ledger/core/utils/dates.dart';
import 'package:course_ledger/features/scan_import/scorecard_parser.dart';

void main() {
  group('parseLooseDate', () {
    test('reads common spreadsheet and scorecard formats', () {
      expect(parseLooseDate('6/15/2026'), DateTime(2026, 6, 15));
      expect(parseLooseDate('06-15-26'), DateTime(2026, 6, 15));
      expect(parseLooseDate('2026-06-15'), DateTime(2026, 6, 15));
      expect(parseLooseDate('June 15, 2026'), DateTime(2026, 6, 15));
      expect(parseLooseDate('played Jun 15 2026 am'), DateTime(2026, 6, 15));
      expect(parseLooseDate('15/6/2026'), DateTime(2026, 6, 15)); // day-first
    });

    test('never invents a date', () {
      expect(parseLooseDate('no date here'), isNull);
      expect(parseLooseDate('par 72 slope 131'), isNull);
      expect(parseLooseDate('2/30/2026'), isNull); // rollover rejected
    });
  });

  group('parseScorecard', () {
    OcrLine line(String text,
            {double left = 0, required double top, double height = 20}) =>
        OcrLine(text, left: left, top: top, height: height);

    test('reads the club name big at the top, the date, and the total', () {
      final draft = parseScorecard([
        line('PINE HOLLOW GOLF CLUB', top: 10, height: 48),
        line('Par 72 · Slope 131', top: 70),
        line('Date: 6/15/2026', top: 100),
        line('HOLE 1 2 3 4 5 6 7 8 9', top: 200),
        line('PAR 4 5 3 4 4 5 3 4 4', top: 230),
        line('TOTAL', top: 400),
        line('92', left: 300, top: 402),
      ]);

      expect(draft!.courseName, 'Pine Hollow Golf Club');
      expect(draft.date, DateTime(2026, 6, 15));
      expect(draft.totalScore, 92);
    });

    test('missing fields stay null — nothing is invented', () {
      final draft = parseScorecard([
        line('Eagle Crest', top: 5, height: 40),
        line('HOLE PAR YARDS', top: 100),
      ]);
      expect(draft!.courseName, 'Eagle Crest');
      expect(draft.date, isNull);
      expect(draft.totalScore, isNull);
    });

    test('grid plumbing is never mistaken for the course name', () {
      final draft = parseScorecard([
        line('HOLE 1 2 3', top: 5, height: 50),
        line('Cedar Bend Muni', top: 60, height: 30),
        line('OUT 44 IN 48 TOTAL 92', top: 400),
      ]);
      expect(draft!.courseName, 'Cedar Bend Muni');
      expect(draft.totalScore, 92);
    });

    test('total outside playable range is ignored', () {
      final draft = parseScorecard([
        line('Birch Run', top: 5, height: 40),
        line('TOTAL YARDS 6800', top: 300),
      ]);
      expect(draft!.totalScore, isNull);
    });

    test('empty OCR yields null', () {
      expect(parseScorecard(const []), isNull);
    });
  });
}
