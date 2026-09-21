import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// AppTheme MyKas - Definisi Sistem Desain Multi-Platform (Light & Dark Mode)
class AppTheme {
  // --------------------------------------------------------------------------
  // BRAND COLORS (IDENTITAS UTAMA MYKAS)
  // --------------------------------------------------------------------------
  static const Color brandPrimary = Color(0xFF0D47A1);   // Royal Blue Utama
  static const Color brandLightBlue = Color(0xFF1976D2); // Royal Blue Sedang
  static const Color brandAccent = Color(0xFF42A5F5);    // Soft Accent Blue
  static const Color brandAmber = Color(0xFFFF9F00);     // Warm Amber (Warna Kancing Logo)

  // --------------------------------------------------------------------------
  // LIGHT THEME PALETTE
  // --------------------------------------------------------------------------
  static const Color bgLight = Color(0xFFF8FAFC);
  static const Color cardLight = Colors.white;
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textSecondaryLight = Color(0xFF64748B);

  // --------------------------------------------------------------------------
  // DARK THEME PALETTE (Deep Charcoal Matte ala Bibit & GoPay + Mesh Royal Accent)
  // --------------------------------------------------------------------------
  static const Color bgDark = Color(0xFF0F1117);          // Charcoal dasar (soft di mata)
  static const Color cardDark = Color(0xFF181B22);        // Elevated surface matte
  static const Color borderDark = Color(0xFF262A36);      // Stroke divider halus
  static const Color textPrimaryDark = Color(0xFFF1F5F9);   // Off-white (tidak menyilaukan)
  static const Color textSecondaryDark = Color(0xFF94A3B8); // Muted slate text

  // --------------------------------------------------------------------------
  // LIGHT THEME CONFIGURATION
  // --------------------------------------------------------------------------
  static ThemeData get lightTheme {
    final baseTextTheme = ThemeData.light().textTheme;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: bgLight,
      primaryColor: brandPrimary,
      colorScheme: const ColorScheme.light(
        primary: brandPrimary,
        secondary: brandLightBlue,
        tertiary: brandAmber,
        surface: cardLight,
        background: bgLight,
        outline: borderLight,
      ),
      fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
      textTheme: GoogleFonts.plusJakartaSansTextTheme(baseTextTheme).copyWith(
        displayLarge: GoogleFonts.urbanist(
          fontWeight: FontWeight.w900,
          color: textPrimaryLight,
        ),
        titleLarge: GoogleFonts.urbanist(
          fontWeight: FontWeight.w800,
          color: textPrimaryLight,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: bgLight,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: textPrimaryLight),
      ),
      cardTheme: CardTheme(
        color: cardLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: borderLight),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: cardLight,
        surfaceTintColor: Colors.transparent,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: cardLight,
        selectedItemColor: brandPrimary,
        unselectedItemColor: textSecondaryLight,
        elevation: 0,
      ),
    );
  }

  // --------------------------------------------------------------------------
  // DARK THEME CONFIGURATION
  // --------------------------------------------------------------------------
  static ThemeData get darkTheme {
    final baseTextTheme = ThemeData.dark().textTheme;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bgDark,
      primaryColor: brandPrimary,
      colorScheme: const ColorScheme.dark(
        primary: brandAccent,
        secondary: brandLightBlue,
        tertiary: brandAmber,
        surface: cardDark,
        background: bgDark,
        outline: borderDark,
      ),
      fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
      textTheme: GoogleFonts.plusJakartaSansTextTheme(baseTextTheme).copyWith(
        displayLarge: GoogleFonts.urbanist(
          fontWeight: FontWeight.w900,
          color: textPrimaryDark,
        ),
        titleLarge: GoogleFonts.urbanist(
          fontWeight: FontWeight.w800,
          color: textPrimaryDark,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: bgDark,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: textPrimaryDark),
      ),
      cardTheme: CardTheme(
        color: cardDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: borderDark),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: cardDark,
        surfaceTintColor: Colors.transparent,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: cardDark,
        selectedItemColor: brandAccent,
        unselectedItemColor: textSecondaryDark,
        elevation: 0,
      ),
    );
  }
}
