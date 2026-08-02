import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Type scale. Lora (serif) carries headings and the day's big numbers;
/// the platform sans carries body copy and controls; JetBrains Mono marks
/// captions, timestamps and anything tabular.
class AppText {
  AppText(this.colors);

  final AppColors colors;

  TextStyle get display => TextStyle(
        fontFamily: 'Lora',
        fontWeight: FontWeight.w600,
        fontSize: 34,
        height: 1.08,
        letterSpacing: -0.3,
        color: colors.ink,
      );

  TextStyle get h1 => TextStyle(
        fontFamily: 'Lora',
        fontWeight: FontWeight.w600,
        fontSize: 26,
        height: 1.15,
        letterSpacing: -0.2,
        color: colors.ink,
      );

  TextStyle get h2 => TextStyle(
        fontFamily: 'Lora',
        fontWeight: FontWeight.w600,
        fontSize: 20,
        height: 1.2,
        color: colors.ink,
      );

  TextStyle get ringNumber => TextStyle(
        fontFamily: 'Lora',
        fontWeight: FontWeight.w600,
        fontSize: 40,
        height: 1.0,
        color: colors.ink,
      );

  TextStyle get statNumber => TextStyle(
        fontFamily: 'Lora',
        fontWeight: FontWeight.w600,
        fontSize: 24,
        height: 1.1,
        color: colors.ink,
      );

  TextStyle get body => TextStyle(fontSize: 15, height: 1.45, color: colors.ink);

  TextStyle get bodySoft => TextStyle(fontSize: 15, height: 1.45, color: colors.inkSoft);

  TextStyle get label => const TextStyle(fontSize: 15, height: 1.3, fontWeight: FontWeight.w500);

  TextStyle get sub => TextStyle(fontSize: 12.5, height: 1.35, color: colors.muted);

  TextStyle get kicker => TextStyle(
        fontFamily: 'JetBrainsMono',
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.4,
        color: colors.muted,
      );

  TextStyle get mono => TextStyle(
        fontFamily: 'JetBrainsMono',
        fontSize: 12,
        letterSpacing: 0.2,
        color: colors.inkSoft,
      );

  TextStyle get button => const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: 0.1);
}
