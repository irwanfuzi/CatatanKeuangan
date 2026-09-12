import 'package:flutter/material.dart';
import 'theme.dart';
import 'app.dart';

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
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // Menyesuaikan tema sistem HP secara otomatis
      home: const App(),
    );
  }
}
