import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color brandPrimary = Color(0xFF0052FF);
  static const Color bgLight = Color(0xFFF8FAFC);
  static const Color cardLight = Colors.white;
  
  static const Color bgDark = Color(0xFF0B132B);
  static const Color cardDark = Color(0xFF131C33);

  static ThemeData get lightTheme {
    final baseTextTheme = ThemeData.light().textTheme;
    
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: bgLight,
      primaryColor: brandPrimary,
      colorScheme: const ColorScheme.light(
        primary: brandPrimary,
        surface: cardLight,
        background: bgLight,
      ),
      fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
      textTheme: GoogleFonts.plusJakartaSansTextTheme(baseTextTheme).copyWith(
        displayLarge: GoogleFonts.urbanist(
          fontWeight: FontWeight.w900,
          color: Colors.black,
        ),
        titleLarge: GoogleFonts.urbanist(
          fontWeight: FontWeight.w800,
          color: Colors.black,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: bgLight,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      cardTheme: CardTheme(
        color: cardLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey.shade200),
        ),
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
        primary: brandPrimary,
        surface: cardDark,
        background: bgDark,
      ),
      fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
      textTheme: GoogleFonts.plusJakartaSansTextTheme(baseTextTheme).copyWith(
        displayLarge: GoogleFonts.urbanist(
          fontWeight: FontWeight.w900,
          color: Colors.white,
        ),
        titleLarge: GoogleFonts.urbanist(
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: bgDark,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      cardTheme: CardTheme(
        color: cardDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Colors.white10),
        ),
      ),
    );
  }
}
