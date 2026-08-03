import 'package:flutter/material.dart';

class AppColors {
  // Dorés islamiques
  static const Color gold = Color(0xFFC9A84C);
  static const Color goldLight = Color(0xFFE8C97A);
  static const Color goldDim = Color(0xFF7A6230);
  static const Color goldGlow = Color(0xFFFFD97030);

  // Sarcelles (eaux de l'oasis)
  static const Color teal = Color(0xFF2A9D8F);
  static const Color tealLight = Color(0xFF48C9BB);

  // Violet (magie / grade 4)
  static const Color purple = Color(0xFF6C4FA3);
  static const Color purpleLight = Color(0xFF9B7DD4);

  // Rose (célébration)
  static const Color rose = Color(0xFFC2566A);
  static const Color roseLight = Color(0xFFE07A8F);

  // Fonds (mode nuit — mode par défaut)
  static const Color bgPrimary = Color(0xFF0F1117);
  static const Color bgCard = Color(0xFF1A1E2A);
  static const Color bgCard2 = Color(0xFF222736);
  static const Color bgCard3 = Color(0xFF1E2438);

  // Texte
  static const Color textPrimary = Color(0xFFE8E0D4);
  static const Color textMuted = Color(0xFF8A8090);
  static const Color textAccent = Color(0xFFC9A84C);

  // Vert foi (arbre)
  static const Color faithGreen = Color(0xFF4CAF50);
  static const Color faithGreenLight = Color(0xFF81C784);

  // Mode jour (Fajr – Asr)
  static const Color bgDayPrimary = Color(0xFFF5F0E8);
  static const Color bgDayCard = Color(0xFFFFFFFF);
  static const Color textDayPrimary = Color(0xFF1A1E2A);
  static const Color textDayMuted = Color(0xFF666070);
}

class AppTheme {
  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.bgPrimary,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.gold,
          secondary: AppColors.teal,
          tertiary: AppColors.purple,
          surface: AppColors.bgCard,
          onPrimary: AppColors.bgPrimary,
          onSecondary: Colors.white,
          onSurface: AppColors.textPrimary,
        ),
        cardColor: AppColors.bgCard,
        dividerColor: Color(0x33C9A84C),
        textTheme: _textTheme(AppColors.textPrimary),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.gold,
            foregroundColor: AppColors.bgPrimary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.bgCard,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          centerTitle: true,
        ),
      );

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.bgDayPrimary,
        colorScheme: const ColorScheme.light(
          primary: AppColors.gold,
          secondary: AppColors.teal,
          surface: AppColors.bgDayCard,
          onPrimary: Colors.white,
          onSurface: AppColors.textDayPrimary,
        ),
        cardColor: AppColors.bgDayCard,
        textTheme: _textTheme(AppColors.textDayPrimary),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.gold,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.bgDayCard,
          foregroundColor: AppColors.textDayPrimary,
          elevation: 0,
          centerTitle: true,
        ),
      );

  static TextTheme _textTheme(Color base) => TextTheme(
        displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: base),
        displayMedium: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: base),
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: base),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: base),
        bodyLarge: TextStyle(fontSize: 15, color: base),
        bodyMedium: TextStyle(fontSize: 13, color: base.withOpacity(0.75)),
        labelSmall: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 0.8, color: base.withOpacity(0.5)),
      );
}
