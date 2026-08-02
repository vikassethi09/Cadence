# Cadence (Flutter app)

Offline habit tracker with adaptive local reminders. See the
[repo root README](../README.md) for what the app does and why.

## Stack

- **Flutter / Dart**, state managed with **Riverpod**
- **Drift** over SQLite for local storage — schema in
  `lib/data/db/tables.dart`
- **flutter_local_notifications** for reminders, including background
  action-button handling (`lib/features/reminders/`)
- No backend, no analytics SDK, no network calls anywhere in the app

## Getting started

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # generates lib/data/db/database.g.dart
flutter run
```

The `build_runner` step is required after any change to
`lib/data/db/tables.dart` or `lib/data/db/database.dart` — Drift
generates the actual query/table code from those definitions.

## Building a release APK

```bash
flutter build apk --release --split-per-abi
```

Produces one APK per CPU architecture in
`build/app/outputs/flutter-apk/`. For sideloading onto a real phone,
`app-arm64-v8a-release.apk` is the one that matters — it covers
virtually every Android device from the last ~8 years. The `armeabi-v7a`
build is for very old 32-bit devices, `x86_64` for emulators.

A single "fat" APK with all architectures bundled (`flutter build apk
--release`, no `--split-per-abi`) also works but is roughly 3x the size
for no benefit when sideloading.

## Tests

```bash
flutter test
```

Covers the two pieces of real logic in the app:
`lib/core/utils/habit_logic.dart` (streaks, completion rate, the
skipped-day interaction) and
`lib/features/reminders/adaptive_engine.dart` (the median/IQR-based
nudge-time learning).

## Project structure

```
lib/
  core/           Design tokens (colors, type, spacing) and pure logic (habit_logic.dart)
  data/           Drift schema, seed habit library, JSON backup/restore
  features/
    onboarding/   First-run flow and habit picker
    today/        Home screen — the daily habit list and progress ring
    habit_editor/ Add/edit a habit
    habit_detail/ Per-habit stats and heatmap
    stats/        Cross-habit stats
    settings/     App settings, archived habits
    reminders/    Notification scheduling, adaptive engine, action handling
    shell/        Bottom tab navigation
  providers/      Riverpod providers wiring the database into the UI
test/             Unit tests for habit_logic.dart and adaptive_engine.dart
```

## Known limitations

- **Signing**: debug-signed only. Fine for installing on your own
  device; not suitable for wider distribution as-is.
- **iOS**: the Dart code is platform-agnostic, but building for iOS
  needs Xcode on a Mac, which this project hasn't done yet.
- **Home screen widget**: not implemented — would need native Kotlin
  (Android Glance) and SwiftUI (iOS WidgetKit) code outside Flutter's
  reach.
