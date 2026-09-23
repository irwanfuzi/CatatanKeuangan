import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/beranda/beranda_screen.dart';
import 'theme/app_theme.dart';

void main() {
  // Wajib memastikan Flutter Engine binding siap untuk Web & Mobile Native
  WidgetsFlutterBinding.ensureInitialized();

  // Penguncian orientasi layar portrait untuk mobile PWA
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Penangkap error resmi & standar SDK Flutter (Bebas error dart2js)
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
  };

  runApp(const MyKasApp());
}

class MyKasApp extends StatelessWidget {
  const MyKasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyKas - Own Your Money',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // Otomatis mengikuti preferensi HP/Desktop
      home: const BerandaScreen(),
    );
  }
}
