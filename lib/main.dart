import 'package:flutter/material.dart';
import 'package:mykas/app.dart'; // <--- Gunakan package import agar CI/CD Gradle menemukan App

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyKasApp());
}

class MyKasApp extends StatelessWidget {
  const MyKasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyKas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0052FF),
          primary: const Color(0xFF0052FF),
          secondary: const Color(0xFFFF9F00),
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xFFF1F4F9),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB),
          primary: const Color(0xFF3B82F6),
          secondary: const Color(0xFFFFB703),
          surface: const Color(0xFF0F172A),
        ),
        scaffoldBackgroundColor: const Color(0xFF060A12),
      ),
      themeMode: ThemeMode.system,
      home: const App(),
    );
  }
}
