/// The four habit models the app supports. Stored as its index in Drift,
/// so the ordering here is load-bearing — append, never reorder.
enum HabitType { yesNo, count, timed, quit }

/// How a habit's reminder time is decided. Appended, never reordered — the
/// index is what's stored in the database.
enum ReminderMode { adaptive, fixed, off, interval }

/// Where a completion was logged from — kept for future tuning of the
/// adaptive engine (e.g. weighting in-app completions over widget taps).
enum LogSource { app, notification, widget }
