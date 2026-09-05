# Course Ledger — Google Play Store Listing

Copy-paste source for the Play Console listing. Character limits noted
per field; counts verified at draft time (2026-09-05).

---

## App name (max 30 chars)

> Course Ledger: Golf Journal

(27 chars. Alternatives: "Course Ledger" alone (13); "Course Ledger:
Courses Played" (29) — keyword-heavier but reads clunkier.)

## Short description (max 80 chars)

> The book of everywhere you've played. Not a rangefinder. Not a scorecard.

(74 chars — the positioning line IS the pitch.)

## Full description (max 4000 chars)

> **Not a rangefinder. Not a scorecard. The book of everywhere you've
> played.**
>
> Course Ledger is the notebook golfers keep: every course you've ever
> played — when, with whom, one score, and the story. The birdie on 17
> into the wind. The buddies trip. The nine at sunset you still think
> about.
>
> **Your ledger**
> • Courses A-Z, by state, or by most recently played
> • The headline that matters: "47 courses · 12 states"
> • Course pages with first played, last played, best score
> • Rounds that lead with the story, not the stats
>
> **The shoebox import**
> That shoebox of old scorecards? Shoot them 20 at a time. Course
> Ledger reads each card — course, date, score — you confirm every
> value, and your history files itself. Spreadsheet keeper instead?
> The CSV importer maps your columns.
>
> **The bucket list**
> Courses you haven't played yet. Log a round there and it checks
> itself off.
>
> **Trends (Pro)**
> The played map — your states, filled in. Courses and rounds by year.
> A score trend line once you've logged five scored rounds — this is a
> ledger, not a stats app. Export your book as CSV or a full backup.
>
> **Private by construction**
> No account. No cloud. No analytics. Everything stays on your phone —
> scorecard reading happens on-device. Your first 5 courses are free
> forever; Course Ledger Pro (monthly or one-time lifetime) removes
> the cap.
>
> The ledger is yours. We never see it.

## Keywords (App Store keyword field; woven into Play description above)

golf courses played, golf course tracker, golf journal, courses log,
golf diary, scorecard scanner, golf bucket list, courses played map

## Category

Sports (secondary consideration: Lifestyle)

## Privacy policy URL

https://code-cowboys.com/privacy/courseledger
(Source text: `docs/privacy-policy.md` — publish before submission.)

---

## Screenshots (phone, 1080×2400, DEMO_SEED data)

Run `flutter run --dart-define=DEMO_SEED=true` on the Pixel; the seed
plants 15 courses / 40 rounds / 3 states with stories written for
these shots. Order tells the product story:

1. **The count headline** — Home, A-Z, "15 courses · 3 states" over the
   list. Caption: "The book of everywhere you've played."
2. **The played map** — Trends, states filled in. Caption: "Your states,
   filled in."
3. **The scorecard scan** — batch review screen mid-shoebox-import
   (stage 2–3 cards; screenshot the review list). Caption: "The shoebox
   import. Shoot your old cards, confirm, done."
4. **Course detail** — Pine Hollow: first/last/best row + rounds with
   story previews. Caption: "Every course. First played, last played,
   best round."
5. **The bucket list** — open wishes + "Thumb Coast Links" checked off.
   Caption: "Log a round there and it checks itself off."
6. **The round story** — round composer with the story field filled
   ("Career round. Par save from the bunker on 18…"). Caption: "One
   score. The whole story."

Feature graphic (1024×500) and 512px store icon: derive from
`assets/icon/` art — fairway green, the open-ledger-with-flag mark,
wordmark right. TODO alongside first upload.
