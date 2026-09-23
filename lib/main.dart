import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyKasApp());
}

class MyKasApp extends StatefulWidget {
  const MyKasApp({super.key});

  @override
  State<MyKasApp> createState() => _MyKasAppState();
}

class _MyKasAppState extends State<MyKasApp> {
  bool _isDark = false;

  void _toggleTheme(bool isDark) {
    setState(() {
      _isDark = isDark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyKas - Financial Engine',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme.copyWith(
        textTheme: GoogleFonts.plusJakartaSansTextTheme(
          AppTheme.lightTheme.textTheme,
        ),
      ),
      darkTheme: AppTheme.darkTheme.copyWith(
        textTheme: GoogleFonts.plusJakartaSansTextTheme(
          AppTheme.darkTheme.textTheme,
        ),
      ),
      themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
      home: App(
        onThemeChanged: _toggleTheme,
      ),
    );
  }
}
