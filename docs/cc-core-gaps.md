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
| A | Round notes/photos as journal entries (entry/rating/photo models, Drift repo) | `journal/` | DONE in cc_core 0.12.0 — option B chosen (full core tables, for the coming fleet). Course Ledger is the proving consumer: schema v2 migration moves notes/rating/round_photos into the journal, tested against a real v1 db and verified live on the emulator. Table Encore adopted at the visit level 2026-09-05 (schema v3, migration tested; dish-level explicitly settled as domain design — see TableEncore/docs/journal-adoption-read.md). No open adoption items remain across the fleet. |
| D | Scorecard photo scan → transcribe → confirm | `scan/` | DONE in cc_core 0.8.0 |
| D | Shoebox batch import (shoot 20 cards → review list → bulk insert) | `notebook_import/` | DONE in cc_core 0.8.0 |
| E | Courses/yr, rounds/yr, score trend line, counters | `trends/` | DONE in cc_core 0.9.0; Trace Elements heatmap extraction landed in 0.13.0 (CalendarMonthGrid + TrendWindowNav) — factory Phase 4 fully closed |
| E | Export/backup archive behind entitlement | `io/` | DONE in cc_core 0.9.0 (backup archive, buildCsv, ShareLauncher seam) |
| F | First-run flow with positioning line, consent screen | `onboarding/` | DONE in cc_core 0.10.0 (FirstRunFlag + OnboardingScaffold, designed fresh — no donor flow existed) |
| 0 | Base theme from per-app tokens (`CcThemeTokens`) | `theme/` | DONE in cc_core 0.11.0 — both apps' AppTheme now thin token wrappers |

## New generic candidates surfaced by this app

- **DEMO_SEED seam**: `--dart-define=DEMO_SEED` screenshot-data hook —
  Table Encore has `SEED_DEV_DATA` ad hoc; Course Ledger now has
  `DEMO_SEED` following the same shape. Worth one blessed name in core
  docs when a third app appears.
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

## New candidates surfaced by Hitch Post (2026-09-05, phases 0-G)

Hitch Post drove four extractions mid-build (RatingStars 0.14.0,
FreeTierCounter 0.15.0, parseLooseDate(s) + CsvMappingScreen
0.16.0/0.16.1). What it left behind as now-visible duplicates:

→ ALL FIVE CLOSED in cc_core 0.17.0 (2026-09-05): SharePlusLauncher
(io, share_plus dep moved into core), dumpJournalTables/
restoreJournalTables on JournalRepository (TE's keys checked — all
three apps already write the identical shape), ProTeaser (paywall),
captureDocumentPages (scan), titleCaseShouted (text). Apps shed their
local copies on next touch; the watch list below stays open.

- **`SharePlusLauncher` impl** (`io/`): the ~25-line share_plus wrapper
  is copy-paste identical in Course Ledger and Hitch Post — cc_core has
  the seam + fake but not the impl, only to keep the share_plus dep out
  of core. Every CC app ships the share sheet; move the impl into core
  (dep and all) on the next core touch. 2 identical consumers.
- **Journal-table backup blocks** (`journal/`): buildExportData's
  entries/photos/tags dump and restore's RawValuesInsertable loops are
  verbatim-identical in both apps' backup_service.dart. Candidate:
  `dumpJournalTables(db)` / `restoreJournalTables(db, rows)` beside
  `collectMedia`. Check Table Encore's pinned backup entry names fit
  before extracting (3rd consumer would settle the API).
- **Pro-teaser screen shape** (`paywall/`): icon + pitch + "See X Pro"
  + divider + ungated "Restore a backup" — near-verbatim in both
  trends screens. Riverpod-free scaffold candidate (app passes copy +
  two callbacks). 2 consumers.
- **Capture preamble** (`scan/`): the pro-gate → `scanAll`-or-picker
  fallback block opens Course Ledger's shoebox and Hitch Post's
  notebook + receipt flows (3 call sites). Candidate:
  `captureDocumentPages(scanner, {limit})` — the paywall half stays
  app-side (riverpod).
- **`_titleCaseShouted`** (`text/`): shouted-print normalizer duplicated
  in scorecard_parser and visit_page_parser. Trivial; take it along
  with the next text/ touch.
- **Watch list**: `parseCostCents` — RESOLVED in cc_core 0.19.0
  (Back Forty was the second consumer; the TE read settled it — TE's
  receipt parser wants line items, not totals, and stays domain).
  parsePageDates moved with it. Hitch Post sheds its local copies on
  next touch; TE also carries a local titleCaseShouted to shed. Still
  watching: `_StatChip` + a chips-wrap over CountedSubject; the
  ExportService stamp/write/share shape.

Fleet adoption debts → ALL CLEARED in the 2026-09-05 shed passes
(see below).

- cc_template skeleton: → DONE 2026-09-05 (Fresh Pot's stamp was the
  template touch): journal registrations + AppDatabase.journal(),
  AppRoot/firstRunSeen gate, FreeTierCounter placeholder home, the
  makeTestDb/testApp/disposeApp harness; default ref v0.17.0. The repo
  still needs its GitHub remote.

**notifications-module consumer setup** (found in Back Forty Phase G's
release build; applies to every future consumer): (1) flutter_timezone
ships Java 11 / Kotlin 1.8 — scope a Kotlin JVM_11 override to that
subproject in android/build.gradle.kts; (2) flutter_local_notifications
requires core-library desugaring (isCoreLibraryDesugaringEnabled +
desugar_jdk_libs 2.1.4) in the app module. Candidates for the
cc_template skeleton's gradle files on its next touch, or a cc_core
notifications README note.

Hitch Post's demo-seed device pass (2026-09-05) surfaced zero cc_core
defects — first fleet app where bring-up + device pass found none.

## Fleet gap analysis (2026-09-05, post Back Forty 0-G, pocket-curio included)

Baseline: cc_core v0.19.0, ten modules, all consumer-proven. Per-app
debts, biggest first:

**pocket-curio** → ADOPTION PASS DONE (2026-09-05, commit in repo):
pin v0.10.0 → v0.21.2. Journal adopted with the Table Encore
precedent: rating/notes into the shared tables (schema v2, migration
proven against a raw v1 file AND live on the emulator's real
pre-migration install — upgraded in place, memories intact); the item
photo stays a domain column (the photo IS the record; see
pocket-curio/docs/journal-adoption-read.md). Backups format 2 with a
format-1 shim. Shed: RatingStars, SharePlusLauncher, restore flow
(runRestoreFlow + PhotoStoreService adapter), export tail. Donated:
continentTiles/continentNames (cc_core 0.21.0/0.21.1) and the
sync-write insight now in shareStampedFile (0.21.2). KEPT local, on
purpose: the dual-limit FreeTierCounter (different widget, not a
duplicate) and PhotoStore (structural; still on the watch list for a
second photo-first consumer). Release gradle also gained the
notifications-module fixes + ML Kit proguard (cc_core ≥0.18 pulls
those plugins transitively — EVERY old app repinning core will need
the same three; template skeleton candidates).

**Shed passes DONE (2026-09-05)** — every app on cc_core v0.21.2,
every duplicated local copy deleted; each pass ended analyzer-clean,
all tests green, release APK built:

- **Hitch Post** (ef08f99): SharePlusLauncher, receipt parser onto
  parseCostCents/parsePageDates, titleCaseShouted, captureDocumentPages
  ×2, ProTeaser, runRestoreFlow (tally raiseTo kept in the callback),
  shareStampedFile ×2, journal dump/restore blocks. Gradle toll.
- **Course Ledger** (425944b): RatingStars, FreeTierCounter,
  SharePlusLauncher, parseLooseDate, titleCaseShouted, the whole local
  CsvImportScreen onto showCsvMappingScreen + CsvField (clCsvFields),
  ProTeaser, runRestoreFlow, shareStampedFile ×2, captureDocumentPages,
  journal dump/restore blocks (format-1 upgrade output already
  canonical — the helper's null-createdAt guard covers it). Gradle
  toll. Net -282 lines.
- **Table Encore** (26ad40a): pin jump v0.11.0 → v0.21.2 with ZERO API
  breakage. RatingStars (rating:/size API swap at 3 call sites;
  RatingSelector stays — input widget), FreeTierCounter (3 call sites
  onto usage/onGoPro, label 'Unlock'), titleCaseShouted (re-exported
  from receipt_parser for the menu parser), SharePlusLauncher, journal
  dump/restore blocks, exporter tail onto shareStampedFile (identical
  date-only stamp). SEED_DEV_DATA → DEMO_SEED everywhere + demo builds
  now fake Unlimited like the fleet. Cloud restore KEPT on its own
  iCloud/Drive backends — runRestoreFlow's pick-a-file shape doesn't
  apply. Gradle toll.
- **Fresh Pot** (960fbca): parsePageDatesFirst → parsePageDates(max: 1),
  shareStampedFile ×2, runRestoreFlow. Gradle toll.
- **Back Forty** (e2a8c90): shareStampedFile ×2, runRestoreFlow (no
  tally raise — live-count free tier). Gradle already tolled at 0-G.

**cc_template**: still pending its next touch — default ref bump to
v0.21.2 and the gradle toll snippets (timezone Kotlin scope, desugaring,
ML Kit proguard).

**Watch list — the two ripe items CLOSED in cc_core 0.20.0**
(shareStampedFile + dateStamp; runRestoreFlow with XFile-based reading
and the flow's first-ever widget tests). CL/HP/FP/BF copies shed
2026-09-05 (passes above).
- Still watching: _StatChip/chips-wrap over CountedSubject;
  PhotoCropper (1 consumer).

**Open work items** (not gaps): Loadbook (prompt-4, store-policy
rails); Fresh Pot incumbent sample file (D-addendum seam ready);
per-app human release checklists.

## Done

- **Trace Elements adoption pass** (cc_core 0.13.0): pin v0.6.1 ->
  v0.13.0, OCR duplicates shed onto the scan module, and its month
  grid/window nav extracted into trends (CalendarMonthGrid +
  TrendWindowNav) — closing the factory's last extraction line item.
  187 tests, same as baseline. Builds on its own Flutter 3.47.2
  (codemagic tracks stable; see per-app-flutter-sdks memory).

- **journal/ module** (cc_core 0.12.0, option B): shared entries/photos/
  tags tables with @UseRowClass row types (apps register thin local
  subclasses — drift can't analyze cross-package table classes, raw-SQL
  FKs carry the constraints), generic JournalRepository, the
  PhotoFileStore/PhotoService seam (closing that candidate), and the
  PhotoAttachmentStrip. Course Ledger v2: journal-backed rounds, photo
  capture in the composer, backup format 2 with format-1 restore.

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
  extract once a second app builds one. → DONE in cc_core 0.16.0
  (Hitch Post Phase D was the second consumer): `CsvMappingScreen` +
  `CsvField`/`guessCsvMapping`. Also extracted then: `parseLooseDate`
  (+ `parseLooseDates` for range rows) into `text/`. Course Ledger
  adopts both on its next touch (csv_import_screen.dart +
  core/utils/dates.dart keep local copies until then).

- **`LifetimeTally`** (cc_core 0.7.0, Phase C): extracted from Table
  Encore's `RestaurantTally` when Course Ledger became the second
  consumer — free tier counts lifetime creations under an injected
  key. Table Encore can adopt it with its existing
  `restaurants_created_lifetime` key.
- **`PaywallSheetScaffold` scrolls** (cc_core 0.7.0, Phase C): content
  taller than the sheet (long benefit lists, small screens) scrolled
  instead of overflowing — found when Course Ledger's three-benefit
  sheet overflowed by 80px.
