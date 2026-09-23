import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// AppTheme MyKas - Sistem Desain Selaras (Light & Dark Mode)
class AppTheme {
  static const String logoAsset = 'assets/images/logo_mykas.png';

  // BRAND COLOR PALETTE
  static const Color brandPrimary = Color(0xFF0D47A1);   
  static const Color brandLightBlue = Color(0xFF1976D2); 
  static const Color brandAccent = Color(0xFF42A5F5);    
  static const Color brandAmber = Color(0xFFFF9F00);     

  // LIGHT THEME PALETTE
  static const Color bgLight = Color(0xFFF8FAFC);
  static const Color cardLight = Colors.white;
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textSecondaryLight = Color(0xFF64748B);

  // DARK THEME PALETTE
  static const Color bgDark = Color(0xFF0F1117);          
  static const Color cardDark = Color(0xFF181B22);        
  static const Color borderDark = Color(0xFF262A36);      
  static const Color textPrimaryDark = Color(0xFFF1F5F9);   
  static const Color textSecondaryDark = Color(0xFF94A3B8); 

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
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: cardLight,
        selectedItemColor: brandPrimary,
        unselectedItemColor: textSecondaryLight,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

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
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: cardDark,
        selectedItemColor: brandAccent,
        unselectedItemColor: textSecondaryDark,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
