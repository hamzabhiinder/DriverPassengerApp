import 'package:flutter/material.dart';

/// Blackline-style dark palette (matches splash #000000).
abstract final class AppColors {
  static const Color transparent = Color(0x00000000);
  static const Color white = Color(0xFFFFFFFF);

  static const Color background = Color(0xFF000000);
  static const Color surface = Color(0xFF0C0C0C);
  static const Color surfaceElevated = Color(0xFF161616);

  /// [ColorScheme.primaryContainer] (dark surfaces / nested panels).
  static const Color primaryContainer = Color(0xFF1A1A1A);

  /// [ColorScheme.secondaryContainer].
  static const Color secondaryContainer = Color(0xFF222222);
  static const Color onSurface = Color(0xFFF2F2F2);

  /// Pure white for hero headings on `#000000`.
  static const Color onBackgroundBright = Color(0xFFFFFFFF);

  /// Secondary body copy on dark backgrounds (login subtitle).
  static const Color bodySecondary = Color(0xFFD1D1D1);
  static const Color onSurfaceMuted = Color(0xFF5F5E5E);

  /// Hints / placeholders in filled inputs.
  static const Color hint = Color(0xFF666666);
  static const Color outline = Color(0xFF2A2A2A);

  /// Gold CTA gradient + ring (splash “Start ride” pill).
  static const Color goldDeep = Color(0xFF8B6914);
  static const Color goldMid = Color(0xFFC9A227);
  static const Color goldLight = Color(0xFFE8D48B);
  static const Color goldRing = Color(0xFFD4AF37);
}
