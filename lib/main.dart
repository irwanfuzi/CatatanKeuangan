import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/auth/lock_screen.dart';
import 'screens/profil/profil_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyKasApp());
}

class MyKasApp extends StatefulWidget {
  const MyKasApp({super.key});

  @override
  State<MyKasApp> createState() => _MyKasAppState();
}

class _MyKasAppState extends State<MyKasApp> {
  ThemeMode _themeMode = ThemeMode.system;
  bool _isLocked = true;
  bool _hasPinSet = false;
  String _savedPin = '';

  @override
  void initState() {
    super.initState();
    _checkLockStatus();
  }

  Future<void> _checkLockStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final pinEnabled = prefs.getBool('pin_enabled') ?? false;
    final userPin = prefs.getString('user_pin') ?? '';

    setState(() {
      _hasPinSet = pinEnabled && userPin.isNotEmpty;
      _savedPin = userPin;
      _isLocked = _hasPinSet; // Kunci jika PIN aktif
    });
  }

  void _unlockApp() {
    setState(() {
      _isLocked = false;
    });
  }

  void _updatePinState(bool enabled, String newPin) {
    setState(() {
      _hasPinSet = enabled;
      _savedPin = newPin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyKas',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      home: _isLocked && _hasPinSet
          ? LockScreen(
              savedPin: _savedPin,
              onUnlocked: _unlockApp,
            )
          : MainNavigationWrapper(
              currentThemeMode: _themeMode,
              onThemeModeChanged: (mode) => setState(() => _themeMode = mode),
              onPinStateChanged: _updatePinState,
            ),
    );
  }
}

class MainNavigationWrapper extends StatefulWidget {
  final ThemeMode currentThemeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;
  final Function(bool enabled, String newPin) onPinStateChanged;

  const MainNavigationWrapper({
    super.key,
    required this.currentThemeMode,
    required this.onThemeModeChanged,
    required this.onPinStateChanged,
  });

  @override
  State<MainNavigationWrapper> createState() => _MainNavigationWrapperState();
}

class _MainNavigationWrapperState extends State<MainNavigationWrapper> {
  int _currentIndex = 4; // Default ke tab Profil

  @override
  Widget build(BuildContext context) {
    final screens = [
      const Center(child: Text('Beranda')),
      const Center(child: Text('Analisis')),
      const Center(child: Text('Catat')),
      const Center(child: Text('Riwayat')),
      ProfilScreen(
        currentThemeMode: widget.currentThemeMode,
        onThemeModeChanged: widget.onThemeModeChanged,
        onPinStateChanged: widget.onPinStateChanged,
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.grid_view_rounded), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart_rounded), label: 'Analisis'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline_rounded), label: 'Catat'),
          BottomNavigationBarItem(icon: Icon(Icons.history_rounded), label: 'Riwayat'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded), label: 'Profil'),
        ],
      ),
    );
  }
}
