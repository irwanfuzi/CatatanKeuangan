import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Import Theme & Shell Utama buatanmu
import 'theme/app_theme.dart';
import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Mencegah aplikasi berotasi ke mode lanskap pada smartphone (Mobile Native / PWA)
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

  // Synchronize StatusBar & NavigationBar warna sistem HP Android / iOS
  void _updateSystemOverlayUI(bool isDark) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // Transparan agar menyatu dengan header biru
        statusBarIconBrightness: Brightness.light, // Ikon jam & baterai warna putih
        statusBarBrightness: Brightness.dark, // Untuk iOS
        systemNavigationBarColor: isDark ? const Color(0xFF0B0F17) : Colors.white,
        systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Inisialisasi warna status bar pertama kali
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

      // Custom Scroll Behavior agar nyaman di Desktop Web (Mouse Wheel & Drag) & Mobile Touch
      scrollBehavior: const AppCustomScrollBehavior(),

      // Home memanggil Shell Navigasi Utama di app.dart
      home: App(
        onThemeChanged: _toggleTheme,
      ),
    );
  }
}

/// Custom Scroll Behavior untuk Dukungan Touch + Mouse Drag pada Web Desktop & PWA
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
