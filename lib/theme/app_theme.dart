import 'package:flutter/material.dart';

/// AppTheme MyKas - Clean, High-Contrast System Font Palette
/// Compatible with Flutter 3.24.3+ Web & Native
class AppTheme {
// Brand Colors
static const Color brandPrimary = Color(0xFF0052FF); // Electric Blue
static const Color brandSecondary = Color(0xFFFFB800); // Amber Gold Accent

// Light Theme Colors
static const Color bgLight = Color(0xFFF8FAFC);
static const Color cardLight = Colors.white;
static const Color borderLight = Color(0xFFE2E8F0);
static const Color textPrimaryLight = Color(0xFF0F172A);
static const Color textSecondaryLight = Color(0xFF64748B);

// Dark Theme Colors
static const Color bgDark = Color(0xFF0F172A);
static const Color cardDark = Color(0xFF1E293B);
static const Color borderDark = Color(0xFF334155);
static const Color textPrimaryDark = Color(0xFFF8FAFC);
static const Color textSecondaryDark = Color(0xFF94A3B8);

// Status Colors
static const Color expenseRed = Color(0xFFEF4444);
static const Color successGreen = Color(0xFF10B981);

static ThemeData get lightTheme {
return ThemeData(
useMaterial3: true,
brightness: Brightness.light,
primaryColor: brandPrimary,
scaffoldBackgroundColor: bgLight,
colorScheme: const ColorScheme.light(
primary: brandPrimary,
secondary: brandSecondary,
surface: cardLight,
onSurface: textPrimaryLight,
onSurfaceVariant: textSecondaryLight,
outline: borderLight,
error: expenseRed,
),
fontFamily: 'sans-serif',
dividerColor: borderLight,
cardTheme: CardTheme(
color: cardLight,
elevation: 0,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(16),
side: const BorderSide(color: borderLight, width: 1),
),
),
);
}

static ThemeData get darkTheme {
return ThemeData(
useMaterial3: true,
brightness: Brightness.dark,
primaryColor: brandPrimary,
scaffoldBackgroundColor: bgDark,
colorScheme: const ColorScheme.dark(
primary: brandPrimary,
secondary: brandSecondary,
surface: cardDark,
onSurface: textPrimaryDark,
onSurfaceVariant: textSecondaryDark,
outline: borderDark,
error: expenseRed,
),
fontFamily: 'sans-serif',
dividerColor: borderDark,
cardTheme: CardTheme(
color: cardDark,
elevation: 0,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(16),
side: const BorderSide(color: borderDark, width: 1),
),
),
);
}
}
