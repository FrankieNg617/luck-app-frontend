import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FortuneTheme {
  // Token-ish colors (matches your Tailwind theme intent)
  static const background = Color(0xFFFCFAF8);
  static const foreground = Color(0xFF32241B);

  static const card = Color(0xFFFAF8F4);
  static const border = Color(0xFFE8E2D9);
  static const muted = Color(0xFFEBE6E0);
  static const mutedForeground = Color(0xFF847062);

  static const primary = Color(0xFFF59F0A);
  static const secondary = Color(0xFFF1EBE4);

  static const gold = Color(0xFFFBBD23);
  static const goldLight = Color(0xFFFFDB70);
  static const goldDark = Color(0xFFC18215);

  static const amber = Color(0xFFF59F0A);
  static const coral = Color(0xFFEB7047);
  static const sage = Color(0xFF75A385);

  static const radius = 13.0;

  static const gradientGold = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [gold, amber],
  );

  static const gradientWarm = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFAF8F4),
      Color(0xFFF3EEE6),
    ],
  );

  static const gradientCard = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFCFAF7),
      Color(0xFFF2EDE3),
    ],
  );

  static const shadowSoft = [
    BoxShadow(
      blurRadius: 28,
      spreadRadius: -8,
      offset: Offset(0, 6),
      color: Color(0x1FA57533),
    ),
  ];

  static const shadowGoldGlow = [
    BoxShadow(
      blurRadius: 28,
      spreadRadius: -2,
      offset: Offset(0, 6),
      color: Color(0x33A57533),
    ),
  ];

  static BoxDecoration cardDecoration({
    bool useCardGradient = false,
    Color? borderColor,
    Color? backgroundColor,
    List<BoxShadow>? shadows,
  }) {
    return BoxDecoration(
      color: useCardGradient ? null : (backgroundColor ?? card),
      gradient: useCardGradient ? gradientCard : null,
      borderRadius: BorderRadius.circular(radius * 1.25),
      border: Border.all(color: (borderColor ?? border).withValues(alpha: 80), width: 0.6),
      boxShadow: shadows ?? shadowSoft,
    );
  }

  static ThemeData lightTheme() {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: gold,
        brightness: Brightness.light,
        primary: primary,
        secondary: secondary,
        surface: card,
      ),
    );

    //final inter = GoogleFonts.interTextTheme(base.textTheme);

    // Headings use Playfair Display (your "font-display")
    return base.copyWith(
      textTheme: base.textTheme.copyWith(
        headlineSmall: GoogleFonts.playfairDisplay(textStyle: base.textTheme.headlineSmall),
        headlineMedium: GoogleFonts.playfairDisplay(textStyle: base.textTheme.headlineMedium),
        headlineLarge: GoogleFonts.playfairDisplay(textStyle: base.textTheme.headlineLarge),
        titleLarge: GoogleFonts.playfairDisplay(textStyle: base.textTheme.titleLarge),
        titleMedium: GoogleFonts.playfairDisplay(textStyle: base.textTheme.titleMedium),
      ),
    );
  }
}
