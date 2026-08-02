import 'package:flutter/material.dart';

/// Cadence's palette. Warm, muted green as the single accent; a desaturated
/// ochre reserved for the adaptive-reminder surfaces so it reads as a
/// distinct signal, never decoration.
class AppColors {
  const AppColors({
    required this.paper,
    required this.ground,
    required this.card,
    required this.ink,
    required this.inkSoft,
    required this.muted,
    required this.line,
    required this.lineSoft,
    required this.accent,
    required this.accentDim,
    required this.onAccent,
    required this.signal,
    required this.signalDim,
    required this.onSignal,
    required this.danger,
  });

  final Color paper;
  final Color ground;
  final Color card;
  final Color ink;
  final Color inkSoft;
  final Color muted;
  final Color line;
  final Color lineSoft;
  final Color accent;
  final Color accentDim;
  final Color onAccent;
  final Color signal;
  final Color signalDim;
  final Color onSignal;
  final Color danger;

  static const light = AppColors(
    paper: Color(0xFFF1F3EF),
    ground: Color(0xFFFBFCFA),
    card: Color(0xFFFFFFFF),
    ink: Color(0xFF16211C),
    inkSoft: Color(0xFF3D4A43),
    muted: Color(0xFF79857C),
    line: Color(0xFFDDE2DA),
    lineSoft: Color(0xFFE9EDE6),
    accent: Color(0xFF3F6B4F),
    accentDim: Color(0xFFE3ECE4),
    onAccent: Color(0xFFFFFFFF),
    signal: Color(0xFFB0701F),
    signalDim: Color(0xFFF4E9D9),
    onSignal: Color(0xFFFFFFFF),
    danger: Color(0xFFA6475B),
  );

  static const dark = AppColors(
    paper: Color(0xFF0E1512),
    ground: Color(0xFF121A16),
    card: Color(0xFF18211C),
    ink: Color(0xFFE6EBE5),
    inkSoft: Color(0xFFB6C1B8),
    muted: Color(0xFF7E8C82),
    line: Color(0xFF2A352E),
    lineSoft: Color(0xFF222C26),
    accent: Color(0xFF7BAE8B),
    accentDim: Color(0xFF1E2E23),
    onAccent: Color(0xFF0E1512),
    signal: Color(0xFFD9A05B),
    signalDim: Color(0xFF2E2517),
    onSignal: Color(0xFF231B0E),
    danger: Color(0xFFD98A98),
  );

  /// The five habit accent colours offered in the editor's colour picker.
  static const habitPalette = [
    Color(0xFF3F6B4F), // accent green (default)
    Color(0xFF5B7FA6), // slate blue
    Color(0xFFA6795B), // clay
    Color(0xFF8A6BA6), // plum
    Color(0xFFA65B6B), // rose
  ];
}

/// Exposes the active [AppColors] to the widget tree without wiring a
/// full ThemeExtension boilerplate for every token.
class AppColorsScope extends InheritedWidget {
  const AppColorsScope({
    super.key,
    required this.colors,
    required super.child,
  });

  final AppColors colors;

  static AppColors of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppColorsScope>();
    assert(scope != null, 'AppColorsScope not found in context');
    return scope!.colors;
  }

  @override
  bool updateShouldNotify(AppColorsScope oldWidget) => colors != oldWidget.colors;
}
