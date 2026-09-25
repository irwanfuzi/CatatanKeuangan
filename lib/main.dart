import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/profil/profil_screen.dart';
import 'theme/app_theme.dart';

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
  // STATE TEMA GLOBAL
  ThemeMode _themeMode = ThemeMode.dark;

  void _updateThemeMode(ThemeMode newMode) {
    setState(() {
      _themeMode = newMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyKas - Own Your Money',
      debugShowCheckedModeBanner: false,

      // BINDING STATE TEMA KE MATERIALAPP
      themeMode: _themeMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,

      home: MainShellNavigation(
        currentThemeMode: _themeMode,
        onThemeModeChanged: _updateThemeMode,
      ),
    );
  }
}

class MainShellNavigation extends StatefulWidget {
  final ThemeMode currentThemeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  const MainShellNavigation({
    super.key,
    required this.currentThemeMode,
    required this.onThemeModeChanged,
  });

  @override
  State<MainShellNavigation> createState() => _MainShellNavigationState();
}

class _MainShellNavigationState extends State<MainShellNavigation> {
  int _currentIndex = 3; // Default ke Tab Profil

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          const _DummyTabScreen(title: 'Beranda Kas', icon: Icons.grid_view_rounded),
          const _DummyTabScreen(title: 'Analisis Keuangan', icon: Icons.bar_chart_rounded),
          const _DummyTabScreen(title: 'Riwayat Transaksi', icon: Icons.history_rounded),
          ProfilScreen(
            currentThemeMode: widget.currentThemeMode,
            onThemeModeChanged: widget.onThemeModeChanged,
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: colorScheme.outline, width: 1)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          selectedItemColor: colorScheme.primary,
          unselectedItemColor: colorScheme.onSurfaceVariant,
          backgroundColor: colorScheme.surface,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: GoogleFonts.urbanist(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: GoogleFonts.urbanist(fontWeight: FontWeight.w600, fontSize: 12),
          onTap: (idx) => setState(() => _currentIndex = idx),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.grid_view_rounded), label: 'Beranda'),
            BottomNavigationBarItem(icon: Icon(Icons.bar_chart_rounded), label: 'Analisis'),
            BottomNavigationBarItem(icon: Icon(Icons.history_rounded), label: 'Riwayat'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded), label: 'Profil'),
          ],
        ),
      ),
    );
  }
}

// COMPONENT CONTOH UNTUK VERIFIKASI TEMA DI TAB LAIN
class _DummyTabScreen extends StatelessWidget {
  final String title;
  final IconData icon;

  const _DummyTabScreen({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.urbanist(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: colorScheme.outline),
                ),
                child: Row(
                  children: [
                    Icon(icon, color: colorScheme.primary, size: 32),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Halaman $title ini juga otomatis beradaptasi dengan Mode Gelap / Mode Terang secara global.',
                        style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
