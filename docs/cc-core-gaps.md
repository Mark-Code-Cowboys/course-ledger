# cc_core gaps & new-generic candidates (tracked from Course Ledger)

Standing rule: cc_core gaps get fixed in cc_core, not worked around here.
This file is the running ledger of what Course Ledger needs from core.
Updated per phase; items move to "Done" when they land in a tagged cc_core.

Baseline: cc_core v0.6.1. Implemented modules: `paywall/` (complete),
`io/` (cloud backup + legacy Android prefs only), `text/` (fuzzy match,
number format). Empty barrels: `journal/`, `trends/`, `onboarding/`,
`theme/`, `scan/`, `notebook_import/`.

## Empty modules this app needs, by phase

| Phase | Needs | cc_core module | Status |
| --- | --- | --- | --- |
| A | Round notes/photos as journal entries (entry/rating/photo models, Drift repo) | `journal/` | DESIGN PROPOSAL in CC_Core/docs/journal-module-design.md (recommends minimal photo-seam scope, no shipped-app migrations) — awaiting the call |
| D | Scorecard photo scan → transcribe → confirm | `scan/` | DONE in cc_core 0.8.0 |
| D | Shoebox batch import (shoot 20 cards → review list → bulk insert) | `notebook_import/` | DONE in cc_core 0.8.0 |
| E | Courses/yr, rounds/yr, score trend line, counters | `trends/` | DONE in cc_core 0.9.0 (YearlyBars, SimpleLineChart, TrendGate; Trace Elements heatmap extraction still open) |
| E | Export/backup archive behind entitlement | `io/` | DONE in cc_core 0.9.0 (backup archive, buildCsv, ShareLauncher seam) |
| F | First-run flow with positioning line, consent screen | `onboarding/` | DONE in cc_core 0.10.0 (FirstRunFlag + OnboardingScaffold, designed fresh — no donor flow existed) |
| 0 | Base theme from per-app tokens (`CcThemeTokens`) | `theme/` | DONE in cc_core 0.11.0 — both apps' AppTheme now thin token wrappers |

## New generic candidates surfaced by this app

- **DEMO_SEED seam**: `--dart-define=DEMO_SEED` screenshot-data hook —
  Table Encore has `SEED_DEV_DATA` ad hoc; Course Ledger now has
  `DEMO_SEED` following the same shape. Worth one blessed name in core
  docs when a third app appears.
- **Photo file store seam**: Table Encore's `PhotoFileStore` (repo discards
  files when rows referencing them go) is being re-needed here for round
  photos (Phase B composer). Third consumer of the pattern = extract into
  cc_core (`journal/` or a small `photos/` module).
- **Single-entry share/exchange** (`io/`): friends and golf parties
  sharing a scorecard scan — nothing exists yet (the scanned card image
  isn't even persisted; only whole-book CSV/backup export ships).
  Three privacy-first shapes, no cloud, all share-sheet/file based:
  1. share the card photo + a text line out (group-chat bragging —
     needs the scan to persist as a round photo first);
  2. a tiny `.courseledger` round file another install opens into its
     composer pre-filled (one scan feeds the whole foursome; needs
     intent-filter/UTI registration);
  3. "party scan": batch review picks which partners get a copy of (2).
  (2) generalizes to every CC app as an `io/` single-entry exchange
  format (one journal entry as a shareable file + confirm-on-open).
  Post-1.0; positioning stays "the notebook", not a social app.
- **Bucket list** (`journal/`?): courseId-XOR-freeText "want to do"
  list with done-linkage to a real entry. Feels generalizable (restaurants
  to try, trails to ride) — flag for review after Phase B proves the shape.

## Done

- **theme/ module + countHeadline** (cc_core 0.11.0): CcThemeTokens with
  ccLightTheme/ccDarkTheme; countHeadline/CountedSubject in trends.
  Course Ledger consumes both.
- **Table Encore shed its duplicates** (adopted cc_core 0.11.0): OCR
  types/ML Kit services, mergeOcrRows, tally logic (historical key
  pinned), backup zip (journal.json/photos/ entry names pinned), and
  the ShareLauncher interface are now shims over core — -244 lines,
  113 tests unchanged.

- **onboarding/ module** (cc_core 0.10.0, Phase F): FirstRunFlag +
  OnboardingScaffold with the kPrivacyBoilerplate promise. Designed
  fresh with Course Ledger (Table Encore has no first-run flow), so the
  API may shift when a second consumer adopts it.

- **trends/ first contents** (cc_core 0.9.0, Phase E): TrendGate
  (anti-stats-cosplay minimum-data guard), YearlyBars, SimpleLineChart,
  RegionTileGrid + usStateTiles (the coverage-map candidate, realized
  as an offline tile cartogram — course *pins* deferred until a lat/lon
  capture UI exists). Trace Elements heatmap extraction still open.
- **io export/backup** (cc_core 0.9.0, Phase E): single-file backup
  archive lifted from Table Encore (entry names parameterized),
  buildCsv encoder, ShareLauncher seam + fake.

- **scan/ + notebook_import/ modules** (cc_core 0.8.0, Phase D):
  extracted from Table Encore's OCR core — OcrLine/mergeOcrRows,
  DocumentScanService (+ multi-page scanAll) and TextRecognitionService
  with ML Kit impls and fakes; batchTranscribe + BatchReviewScreen.
  Table Encore's `core/ocr/` is now a duplicate to migrate off.
- **CSV import parsing** (`io/` in cc_core 0.8.0, Phase D):
  parseCsv/CsvDocument. The column-mapping *screen* stayed app-side —
  extract once a second app builds one.

- **`LifetimeTally`** (cc_core 0.7.0, Phase C): extracted from Table
  Encore's `RestaurantTally` when Course Ledger became the second
  consumer — free tier counts lifetime creations under an injected
  key. Table Encore can adopt it with its existing
  `restaurants_created_lifetime` key.
- **`PaywallSheetScaffold` scrolls** (cc_core 0.7.0, Phase C): content
  taller than the sheet (long benefit lists, small screens) scrolled
  instead of overflowing — found when Course Ledger's three-benefit
  sheet overflowed by 80px.
