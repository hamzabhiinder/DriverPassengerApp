import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Central font-size tokens. Change values here to update the whole app.
abstract final class AppFontSize {
  static const double display = 40;
  static const double headline = 26;
  static const double title = 20;
  static const double titleSmall = 18;
  static const double subtitle = 18;
  static const double body = 15;
  static const double bodySmall = 14;
  static const double label = 15;
  static const double caption = 12;
  static const double overline = 11;
  static const double micro = 10;
}

abstract final class AppTypography {
  static TextTheme textThemeFor(Brightness brightness) {
    final TextTheme base = ThemeData(brightness: brightness).textTheme;
    final TextTheme body = base.apply(fontFamily: 'Geist');
    final TextTheme headings = GoogleFonts.castoroTextTheme(base);
    return body.copyWith(
      displayLarge: headings.displayLarge?.copyWith(fontSize: AppFontSize.display),
      displayMedium: headings.displayMedium?.copyWith(fontSize: AppFontSize.headline),
      displaySmall: headings.displaySmall?.copyWith(fontSize: AppFontSize.title),
      headlineLarge: headings.headlineLarge?.copyWith(fontSize: AppFontSize.headline),
      headlineMedium: headings.headlineMedium?.copyWith(fontSize: AppFontSize.title),
      headlineSmall: headings.headlineSmall?.copyWith(fontSize: AppFontSize.titleSmall),
      titleLarge: headings.titleLarge?.copyWith(fontSize: AppFontSize.title),
      titleMedium: body.titleMedium?.copyWith(fontSize: AppFontSize.subtitle),
      titleSmall: body.titleSmall?.copyWith(fontSize: AppFontSize.bodySmall),
      bodyLarge: body.bodyLarge?.copyWith(fontSize: AppFontSize.body),
      bodyMedium: body.bodyMedium?.copyWith(fontSize: AppFontSize.bodySmall),
      bodySmall: body.bodySmall?.copyWith(fontSize: AppFontSize.caption),
      labelLarge: body.labelLarge?.copyWith(fontSize: AppFontSize.label),
      labelMedium: body.labelMedium?.copyWith(fontSize: AppFontSize.caption),
      labelSmall: body.labelSmall?.copyWith(fontSize: AppFontSize.overline),
    );
  }

  /// Serif display/heading style. Pass [AppFontSize] tokens for consistency.
  static TextStyle castoro({
    double fontSize = AppFontSize.headline,
    FontWeight? fontWeight,
    Color? color,
    double? height,
    double? letterSpacing,
    TextDecoration? decoration,
  }) {
    return GoogleFonts.castoro(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
      decoration: decoration,
    );
  }

  /// Sans body/UI style. Pass [AppFontSize] tokens for consistency.
  static TextStyle geist({
    double fontSize = AppFontSize.body,
    FontWeight? fontWeight,
    Color? color,
    double? height,
    double? letterSpacing,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontFamily: 'Geist',
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
      decoration: decoration,
    );
  }

  // Named styles — prefer these in screens for consistent hierarchy.

  static TextStyle display({Color? color, FontWeight fontWeight = FontWeight.w400}) =>
      castoro(fontSize: AppFontSize.display, fontWeight: fontWeight, color: color, height: 1.15);

  static TextStyle headline({Color? color, FontWeight fontWeight = FontWeight.w400}) =>
      castoro(fontSize: AppFontSize.headline, fontWeight: fontWeight, color: color, height: 1.2);

  static TextStyle title({Color? color, FontWeight fontWeight = FontWeight.w600}) =>
      castoro(fontSize: AppFontSize.title, fontWeight: fontWeight, color: color);

  static TextStyle titleSmall({Color? color, FontWeight fontWeight = FontWeight.w600}) =>
      geist(fontSize: AppFontSize.titleSmall, fontWeight: fontWeight, color: color);

  static TextStyle subtitle({Color? color, FontWeight fontWeight = FontWeight.w500}) =>
      geist(fontSize: AppFontSize.subtitle, fontWeight: fontWeight, color: color);

  static TextStyle body({Color? color, FontWeight fontWeight = FontWeight.w400}) =>
      geist(fontSize: AppFontSize.body, fontWeight: fontWeight, color: color, height: 1.35);

  static TextStyle bodySmall({Color? color, FontWeight fontWeight = FontWeight.w400}) =>
      geist(fontSize: AppFontSize.bodySmall, fontWeight: fontWeight, color: color, height: 1.35);

  static TextStyle label({Color? color, FontWeight fontWeight = FontWeight.w500}) =>
      geist(fontSize: AppFontSize.label, fontWeight: fontWeight, color: color);

  static TextStyle caption({Color? color, FontWeight fontWeight = FontWeight.w400}) =>
      geist(fontSize: AppFontSize.caption, fontWeight: fontWeight, color: color, height: 1.3);

  static TextStyle overline({Color? color, FontWeight fontWeight = FontWeight.w500}) =>
      geist(
        fontSize: AppFontSize.overline,
        fontWeight: fontWeight,
        color: color,
        letterSpacing: 1.2,
      );

  static TextStyle button({Color? color, FontWeight fontWeight = FontWeight.w700}) =>
      geist(fontSize: AppFontSize.subtitle, fontWeight: fontWeight, color: color);

  static TextStyle micro({Color? color, FontWeight fontWeight = FontWeight.w400}) =>
      geist(fontSize: AppFontSize.micro, fontWeight: fontWeight, color: color, height: 1.2);
}
