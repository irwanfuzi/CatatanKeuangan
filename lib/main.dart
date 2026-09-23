import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Kunci orientasi ke Portrait khusus di perangkat Smartphone Native
  if (!kIsWeb && (defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS)) {
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
  // Pengendali tema global (Default: Dark Theme)
  ThemeMode _themeMode = ThemeMode.dark;

  /// Callback pengubah tema dari Profil / Pengaturan
  void _toggleTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
    _updateSystemOverlayUI(isDark);
  }

  /// Sinkronisasi warna status bar & navigation bar sistem Android / iOS
  void _updateSystemOverlayUI(bool isDark) {
    if (kIsWeb) return; // Skip di Web Desktop untuk efisiensi render
    
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: isDark ? const Color(0xFF0B0F17) : Colors.white,
        systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        systemNavigationBarContrastEnforced: false,
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
      
      // Sistem Tema Aplikasi
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,

      // Dukungan Scroll Multi-Platform (Touch, Mouse Drag, Trackpad, Stylus)
      scrollBehavior: const AppCustomScrollBehavior(),

      // Shell Navigasi Utama Aplikasi
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
