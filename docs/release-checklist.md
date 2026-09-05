# Course Ledger — Release checklist

Work top to bottom; nothing ships with an unchecked box above it.

## Code

- [ ] `pubspec.yaml` version bumped (`1.0.0+1` for the first release)
- [ ] cc_core pinned to a pushed tag (currently `v0.10.0`) —
      `pubspec_overrides.yaml` is git-ignored and must NOT influence the
      release build: `flutter pub get` on a clean checkout resolves
- [ ] `flutter analyze` — zero issues
- [ ] `flutter test` — all green
- [ ] `dart run flutter_launcher_icons` output committed (android/ios)

## On-device (Pixel), release build

- [ ] `flutter run --release` cold start < 2s, no red screens
- [ ] Onboarding shows once; "Just look around" → shell; kill/relaunch
      skips it
- [ ] Add 5 courses → 6th opens the paywall; delete one → still gated
      (lifetime tally)
- [ ] Sandbox purchase monthly → gate lifts, counter gone, Trends live
- [ ] Restore purchase after reinstall
- [ ] Shoebox import with 3 real scorecards: scanner opens, review
      shows transcriptions, edit one, insert; bucket check-off fires
- [ ] CSV import: a Sheets export maps and lands
- [ ] Backup → share to Drive → wipe app data → restore → ledger and
      free-tier tally intact
- [ ] DEMO_SEED build only for screenshots — never the uploaded AAB
- [ ] Dark theme spot-check: home, detail, composer, paywall, trends

## Store

- [ ] Privacy policy live at code-cowboys.com/privacy/courseledger
      (source: `docs/privacy-policy.md`)
- [ ] Listing fields pasted from `docs/play-store-listing.md`
- [ ] 6 screenshots captured per the listing doc (DEMO_SEED)
- [ ] Feature graphic + 512 store icon exported
- [ ] Products created per `docs/play-monetization-setup.md`, Active
- [ ] Data safety form matches the privacy policy

## Build & upload

- [ ] `android/key.properties` + keystore in place (never committed)
- [ ] `flutter build appbundle --release`
- [ ] Internal testing release; license testers verify purchases
- [ ] Promote to closed → production when the boxes above are checked

## Post-launch

- [ ] Tag the app repo `v1.0.0`
- [ ] Note any cc_core friction found during release in
      `docs/cc-core-gaps.md`
- [ ] Backlog: single-entry share for golf parties (gaps doc), round
      photo capture UI, course pins once lat/lon entry exists
