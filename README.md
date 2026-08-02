# Cadence

A quiet, fully offline habit tracker. No account, no sync, no server —
Cadence tracks your habits on-device and learns when to remind you from
your own completion history, instead of a reminder time you picked once
during setup and now ignore.

**[Download the latest APK →](https://github.com/vikassethi09/Cadence/releases/latest)**
(Android, arm64 — install from unknown sources when prompted, since this
isn't distributed through the Play Store)

## Why

Most habit apps lean on gamification — streak freezes, XP, badges — to
paper over reminders that arrive at the wrong time. Cadence bets the
other way: keep the surface calm, and put the effort into picking the
moment it speaks. Every completion is timestamped; once a habit has a
week of history, the app nudges you close to when you actually tend to
do it, not an arbitrary time from onboarding.

## Features

- **Four habit types** — yes/no, count (e.g. 8 glasses of water), timed
  (e.g. 10-minute meditation), and quit/avoid habits, where success is
  silence rather than a checkmark.
- **Three reminder modes** — adaptive (learns your rhythm), fixed time,
  or interval (e.g. "every 2 hours, 9am–9pm") for habits like drinking
  water.
- **Actionable notifications** — Done / Snooze / Skip buttons that write
  straight to the database without opening the app.
- **Streaks, stats, and a heatmap** per habit, plus an overall
  completion view.
- **Rest days** — swipe a habit to skip a day without breaking its
  streak, distinct from an ordinary miss.
- **Backfill** — long-press a habit to fix up the last two weeks.
- **JSON backup and restore** — the only safety net for an app with no
  cloud copy of your data.
- **Fully offline** — no analytics, no network calls, nothing leaves
  the phone.

## Project layout

```
app/      Flutter app (see app/README.md for build & run instructions)
design/   Wireframes and design notes
```

## Status

Personal project, actively developed. Builds are debug-signed and meant
for sideloading onto your own device — not yet on the Play Store. iOS
is buildable from the same codebase but hasn't been built or tested
(requires a Mac).
