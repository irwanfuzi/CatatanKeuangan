import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'app.dart';

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
  // 1. Variabel penampung state tema global
  ThemeMode _themeMode = ThemeMode.dark; // Default Dark Mode

  // 2. Fungsi pengubah tema yang akan dipanggil dari ProfilScreen
  void _toggleTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyKas',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode, // 3. Mengontrol tema aplikasi
      home: App(
        onThemeChanged: _toggleTheme, // 4. Kirim fungsi ke App
      ),
    );
  }
}
