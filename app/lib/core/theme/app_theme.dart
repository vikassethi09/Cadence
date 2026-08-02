import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Builds Flutter's [ThemeData] from an [AppColors] token set so Material
/// widgets (buttons, switches, dialogs) inherit the same palette as the
/// custom widgets that read [AppColorsScope] directly.
ThemeData buildAppTheme(AppColors c, Brightness brightness) {
  final scheme = ColorScheme(
    brightness: brightness,
    primary: c.accent,
    onPrimary: c.onAccent,
    secondary: c.signal,
    onSecondary: c.onSignal,
    error: c.danger,
    onError: c.card,
    surface: c.card,
    onSurface: c.ink,
  );

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: scheme,
    scaffoldBackgroundColor: c.paper,
    canvasColor: c.paper,
    fontFamily: 'Roboto',
    dividerColor: c.line,
    splashFactory: InkSparkle.splashFactory,
    switchTheme: SwitchThemeData(
      trackColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected) ? c.accent : c.line,
      ),
      thumbColor: WidgetStatePropertyAll(c.card),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: c.paper,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      foregroundColor: c.ink,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: c.accent,
        foregroundColor: c.onAccent,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: c.muted),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: c.ground,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: c.line),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: c.line),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: c.accent, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    ),
    pageTransitionsTheme: PageTransitionsTheme(
      builders: {
        TargetPlatform.android: const FadeForwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: const CupertinoPageTransitionsBuilder(),
      },
    ),
  );
}
