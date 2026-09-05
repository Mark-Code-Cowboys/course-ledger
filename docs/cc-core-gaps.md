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
| A | Round notes/photos as journal entries (entry/rating/photo models, Drift repo) | `journal/` | empty — and Table Encore has no journal tables to extract either (its notes/photos are domain-table columns), so factory Phase 4 is a design job across both apps. Phase A shipped app-local `rounds.notes` + `round_photos`, shaped like the donor for a later lift. |
| D | Scorecard photo scan → transcribe → confirm | `scan/` | empty (factory Phase 5) |
| D | Shoebox batch import (shoot 20 cards → review list → bulk insert) | `notebook_import/` | empty (factory Phase 5) |
| E | Courses/yr, rounds/yr, score trend line, counters | `trends/` | empty (factory Phase 4) |
| E | Export/backup archive behind entitlement | `io/` | README promises CSV/JSON export + zip backup/restore, but only cloud backup is coded (factory Phase 3 partially shipped) |
| F | First-run flow with positioning line, consent screen | `onboarding/` | empty (factory Phase 6) |
| 0 | Base theme from per-app tokens (`CcThemeTokens`) | `theme/` | empty — `lib/core/theme/app_theme.dart` here is a hand copy of Table Encore's `AppTheme` shape; third copy = extract |

## New generic candidates surfaced by this app

- **CSV import mapper** (`io/`): Phase D.2 "spreadsheet keepers" importer —
  pick file → map columns to fields → preview → bulk insert. Every CC app
  has spreadsheet keepers; belongs beside export in `io/`.
- **Coverage map widget** (`trends/`): Phase E "played map" — region fill
  (states/countries visited) + optional pins. Generic "where have I done X"
  map; reusable by any travel-ish ledger (Hitch Post, Loadbook).
- **Count headline** (`trends/` or `text/`): "47 courses · 12 states" —
  a generic multi-count stat headline formatter/widget for Home screens.
- **Minimum-data trend guard** (`trends/`): "trend line only if ≥5 scored
  rounds" — a generic `TrendGate(minPoints)` so sparse data renders a
  nudge instead of a junk chart. Anti-stats-cosplay is house positioning.
- **DEMO_SEED seam**: `--dart-define=DEMO_SEED` screenshot-data hook —
  Table Encore has `SEED_DEV_DATA` ad hoc; worth one blessed pattern in
  core docs or a tiny helper.
- **Photo file store seam**: Table Encore's `PhotoFileStore` (repo discards
  files when rows referencing them go) is being re-needed here for round
  photos (Phase B composer). Third consumer of the pattern = extract into
  cc_core (`journal/` or a small `photos/` module).
- **Bucket list** (`journal/`?): courseId-XOR-freeText "want to do"
  list with done-linkage to a real entry. Feels generalizable (restaurants
  to try, trails to ride) — flag for review after Phase B proves the shape.

## Done

(nothing yet)
