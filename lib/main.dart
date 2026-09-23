import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/app_icons.dart';
import '../../theme/app_theme.dart';

// Import Theme & App Shell Utama
import 'theme/app_theme.dart';
import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Kunci orientasi ke Portrait khusus di perangkat Smartphone Native / PWA
  if (!kIsWeb) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  runApp(const MyKasApp());
}

class MyKasApp extends StatefulWidget {
  const MyKasApp({super.key});

  @override
  State<MyKasApp> createState() => _MyKasAppState();
}

class _MyKasAppState extends State<MyKasApp> {
  // 1. Variabel pengendali tema global
  ThemeMode _themeMode = ThemeMode.dark;

  // 2. Fungsi callback pengubah tema yang dipanggil dari Profil / Settings
  void _toggleTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
    _updateSystemOverlayUI(isDark);
  }

  // Sinkronisasi warna status bar & navigation bar sistem HP Android / iOS
  void _updateSystemOverlayUI(bool isDark) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: isDark ? const Color(0xFF0B0F17) : Colors.white,
        systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _updateSystemOverlayUI(_themeMode == ThemeMode.dark);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyKas - Catatan Keuangan Modern',
      debugShowCheckedModeBanner: false,
      
      // Tema Aplikasi dari AppTheme
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,

      // Custom Scroll Behavior untuk Dukungan Touch, Mouse Drag, & Trackpad Desktop
      scrollBehavior: const AppCustomScrollBehavior(),

      // Home memanggil Shell Navigasi Utama di app.dart
      home: App(
        onThemeChanged: _toggleTheme,
      ),
    );
  }
}

/// Custom Scroll Behavior Lintas Platform (Mobile Touch, PWA, & Web Desktop)
class AppCustomScrollBehavior extends MaterialScrollBehavior {
  const AppCustomScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
      };
}
