# Course Ledger — Release checklist

Work top to bottom; nothing ships with an unchecked box above it.

## Code

- [x] `pubspec.yaml` version bumped (`1.0.0+1` for the first release)
- [x] cc_core pinned to a pushed tag (currently `v0.10.0`) —
      `pubspec_overrides.yaml` is git-ignored and must NOT influence the
      release build: `flutter pub get` on a clean checkout resolves
- [x] `flutter analyze` — zero issues
- [x] `flutter test` — all green (62)
- [x] `dart run flutter_launcher_icons` output committed (android/ios)

## On-device (Pixel), release build

- [x] `flutter run --release` cold start < 2s (573ms on the emulator; re-check on the Pixel), no red screens
- [x] Onboarding shows once; "Just look around" → shell; kill/relaunch
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
- [x] DEMO_SEED build only for screenshots — never the uploaded AAB
- [x] Dark theme spot-check (home + detail verified on emulator; glance at composer/paywall/trends during the device pass)

## Store

- [ ] Privacy policy live at code-cowboys.com/privacy/courseledger
      (source: `docs/privacy-policy.md`)
- [ ] Listing fields pasted from `docs/play-store-listing.md`
- [~] Screenshots: 5 of 6 captured on the emulator (docs/store-assets/phone/, 1280×2856) + a bonus dark-mode shot; #3 scorecard-scan review still needs real cards on the Pixel
- [x] Feature graphic + 512 store icon exported (docs/store-assets/)
- [ ] Products created per `docs/play-monetization-setup.md`, Active
- [ ] Data safety form matches the privacy policy

## Build & upload

- [ ] `android/key.properties` + keystore in place (never committed)
- [x] `flutter build appbundle --release` (74.2MB, debug-signing fallback — rebuild after key.properties lands)
- [ ] Internal testing release; license testers verify purchases
- [ ] Promote to closed → production when the boxes above are checked

## Post-launch

- [ ] Tag the app repo `v1.0.0`
- [ ] Note any cc_core friction found during release in
      `docs/cc-core-gaps.md`
- [ ] Backlog: single-entry share for golf parties (gaps doc), round
      photo capture UI, course pins once lat/lon entry exists
