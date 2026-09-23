import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// AppTheme MyKas - Definisi Sistem Desain Multi-Platform (Light & Dark Mode)
/// Kompatibel dengan Flutter 3.24.3 (Android/iOS, PWA, Web Desktop)
class AppTheme {
  // --------------------------------------------------------------------------
  // ASSET TOKENS
  // --------------------------------------------------------------------------
  static const String logoAsset = 'assets/images/logo_mykas.png';

  // --------------------------------------------------------------------------
  // BRAND COLOR PALETTE
  // --------------------------------------------------------------------------
  static const Color brandPrimary = Color(0xFF0D47A1);   // Royal Blue Utama
  static const Color brandLightBlue = Color(0xFF1976D2); // Royal Blue Medium
  static const Color brandAccent = Color(0xFF42A5F5);    // Soft Accent Blue
  static const Color brandAmber = Color(0xFFFF9F00);     // Warm Amber Accent

  // --------------------------------------------------------------------------
  // LIGHT THEME PALETTE
  // --------------------------------------------------------------------------
  static const Color bgLight = Color(0xFFF8FAFC);
  static const Color cardLight = Colors.white;
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textSecondaryLight = Color(0xFF64748B);

  // --------------------------------------------------------------------------
  // DARK THEME PALETTE (Deep Charcoal Matte)
  // --------------------------------------------------------------------------
  static const Color bgDark = Color(0xFF0F1117);          // Charcoal dasar
  static const Color cardDark = Color(0xFF181B22);        // Elevated surface matte
  static const Color borderDark = Color(0xFF262A36);      // Stroke divider
  static const Color textPrimaryDark = Color(0xFFF1F5F9);   // Off-white
  static const Color textSecondaryDark = Color(0xFF94A3B8); // Muted slate

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
        actionsIconTheme: IconThemeData(color: textPrimaryLight),
      ),

      // FIX UNTUK FLUTTER 3.24.3: Gunakan CardTheme (Bukan CardThemeData)
      cardTheme: CardTheme(
        color: cardLight,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: borderLight, width: 1),
        ),
      ),

      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: cardLight,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: cardLight,
        selectedItemColor: brandPrimary,
        unselectedItemColor: textSecondaryLight,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
      ),

      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: cardLight,
        selectedIconTheme: const IconThemeData(color: brandPrimary),
        unselectedIconTheme: const IconThemeData(color: textSecondaryLight),
        selectedLabelTextStyle: GoogleFonts.plusJakartaSans(
          color: brandPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        unselectedLabelTextStyle: GoogleFonts.plusJakartaSans(
          color: textSecondaryLight,
          fontSize: 12,
        ),
      ),

      dividerTheme: const DividerThemeData(
        color: borderLight,
        thickness: 1,
        space: 1,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardLight,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: brandPrimary, width: 1.5),
        ),
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
        actionsIconTheme: IconThemeData(color: textPrimaryDark),
      ),

      // FIX UNTUK FLUTTER 3.24.3: Gunakan CardTheme (Bukan CardThemeData)
      cardTheme: CardTheme(
        color: cardDark,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: borderDark, width: 1),
        ),
      ),

      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: cardDark,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: cardDark,
        selectedItemColor: brandAccent,
        unselectedItemColor: textSecondaryDark,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
      ),

      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: cardDark,
        selectedIconTheme: const IconThemeData(color: brandAccent),
        unselectedIconTheme: const IconThemeData(color: textSecondaryDark),
        selectedLabelTextStyle: GoogleFonts.plusJakartaSans(
          color: brandAccent,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        unselectedLabelTextStyle: GoogleFonts.plusJakartaSans(
          color: textSecondaryDark,
          fontSize: 12,
        ),
      ),

      dividerTheme: const DividerThemeData(
        color: borderDark,
        thickness: 1,
        space: 1,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardDark,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: brandAccent, width: 1.5),
        ),
      ),
    );
  }
}
