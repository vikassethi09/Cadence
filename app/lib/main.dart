import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'features/onboarding/onboarding_flow.dart';
import 'features/reminders/notification_nav.dart';
import 'features/reminders/notification_service.dart';
import 'features/reminders/reminder_scheduler.dart';
import 'features/shell/app_shell.dart';
import 'providers/database_provider.dart';
import 'providers/settings_providers.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: CadenceApp()));
}

class CadenceApp extends ConsumerWidget {
  const CadenceApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider).valueOrNull ?? ThemeMode.system;

    return MaterialApp(
      navigatorKey: NotificationNav.navigatorKey,
      title: 'Cadence',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: buildAppTheme(AppColors.light, Brightness.light),
      darkTheme: buildAppTheme(AppColors.dark, Brightness.dark),
      builder: (context, child) {
        final brightness = Theme.of(context).brightness;
        final colors = brightness == Brightness.dark ? AppColors.dark : AppColors.light;
        return AppColorsScope(colors: colors, child: child!);
      },
      home: const _AppRoot(),
    );
  }
}

class _AppRoot extends ConsumerStatefulWidget {
  const _AppRoot();

  @override
  ConsumerState<_AppRoot> createState() => _AppRootState();
}

class _AppRootState extends ConsumerState<_AppRoot> {
  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    // Notification setup touches platform channels that can be unavailable
    // (e.g. under test, or a device without Play Services) — a failure here
    // must never block the core habit-tracking loop from working.
    try {
      await NotificationService.instance.init();
      final db = ref.read(databaseProvider);
      // Best-effort re-arm on every app open — Android background execution
      // is never guaranteed, so this is the most reliable trigger available.
      await ReminderScheduler(db).rescheduleAll();

      // If the app was cold-started by tapping a notification body, wait for
      // the first frame so the Navigator exists, then jump to that habit.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        NotificationService.instance.handleColdStartLaunch();
      });
    } catch (e, st) {
      debugPrint('Notification bootstrap failed, continuing without reminders: $e\n$st');
    }
  }

  @override
  Widget build(BuildContext context) {
    final onboardingDone = ref.watch(onboardingDoneProvider);

    return onboardingDone.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('$e'))),
      data: (done) => done ? const AppShell() : const OnboardingFlow(),
    );
  }
}
