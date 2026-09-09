import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'app.dart';

void main() {
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
      themeMode: ThemeMode.system,
      home: const MainAppScreen(),
    );
  }
}
