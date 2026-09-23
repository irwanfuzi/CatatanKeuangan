import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/beranda/beranda_screen.dart';
import 'theme/app_theme.dart';

void main() {
  // Wajib untuk memastikan binding Flutter Web & Native siap
  WidgetsFlutterBinding.ensureInitialized();

  // Kunci orientasi portrait untuk mobile PWA (opsional)
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Tangkap error tak terduga agar tidak memblokir render UI
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToAppConsole(details);
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
      themeMode: ThemeMode.system, // Menyesuaikan pengaturan HP/Desktop
      home: const BerandaScreen(),
    );
  }
}
