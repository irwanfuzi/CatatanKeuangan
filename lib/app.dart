import 'package:flutter/material.dart';
import 'package:mykas/screens/analisis/analisis_screen.dart';

class App extends StatefulWidget {
  const App({super.key}); // Standardized const constructor

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int _currentIndex = 1; // Default ke Tab Analisis
  final Map<String, dynamic> _summaryData = {
    'saldo': 'Rp 11.250.000',
    'pemasukan': 'Rp 5.250.000',
    'pengeluaran': 'Rp 2.804.178',
  };

  static const Color primaryRoyalBlue = Color(0xFF0052FF);
  static const Color accentHoneyGold = Color(0xFFFF9F00);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final surfaceColor = isDark ? const Color(0xFF0F172A) : Colors.white;
    final borderColor = isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final subTextColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 1024;

        // IndexedStack menjaga State agar navigasi smooth & tidak reload
        final List<Widget> pages = [
          _buildPlaceholderPage('Beranda', Icons.grid_view_rounded, isDark, textColor, subTextColor),
          AnalisisScreen(summaryData: _summaryData),
          _buildPlaceholderPage('Dompet & Aset', Icons.account_balance_wallet_rounded, isDark, textColor, subTextColor),
          _buildPlaceholderPage('Profil', Icons.person_rounded, isDark, textColor, subTextColor),
        ];

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: Row(
            children: [
              // Navigation Sidebar untuk Web Desktop Dashboard
              if (isDesktop)
                Container(
                  width: 260,
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    border: Border(right: BorderSide(color: borderColor, width: 1)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: primaryRoyalBlue,
                                borderRadius: BorderRadius.circular(9),
                              ),
                              child: const Icon(Icons.account_balance_wallet_rounded, color: accentHoneyGold, size: 18),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'MyKas',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: textColor,
                                letterSpacing: -0.8,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildDesktopNavItem(0, Icons.grid_view_rounded, 'Beranda', isDark),
                      _buildDesktopNavItem(1, Icons.analytics_rounded, 'Analisis', isDark),
                      _buildDesktopNavItem(2, Icons.account_balance_rounded, 'Dompet & Aset', isDark),
                      _buildDesktopNavItem(3, Icons.person_outline_rounded, 'Profil', isDark),
                    ],
                  ),
                ),

              // Viewport utama dengan IndexedStack
              Expanded(
                child: IndexedStack(
                  index: _currentIndex,
                  children: pages,
                ),
              ),
            ],
          ),

          // Bottom Navigation Bar untuk Mobile
          bottomNavigationBar: isDesktop
              ? null
              : Container(
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    border: Border(top: BorderSide(color: borderColor, width: 1)),
                  ),
                  child: BottomNavigationBar(
                    currentIndex: _currentIndex,
                    onTap: (index) => setState(() => _currentIndex = index),
                    backgroundColor: surfaceColor,
                    selectedItemColor: primaryRoyalBlue,
                    unselectedItemColor: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                    selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                    unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 11),
                    type: BottomNavigationBarType.fixed,
                    elevation: 0,
                    items: const [
                      BottomNavigationBarItem(icon: Icon(Icons.grid_view_rounded), label: 'Beranda'),
                      BottomNavigationBarItem(icon: Icon(Icons.analytics_rounded), label: 'Analisis'),
                      BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_rounded), label: 'Dompet'),
                      BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profil'),
                    ],
                  ),
                ),
        );
      },
    );
  }

  Widget _buildDesktopNavItem(int index, IconData icon, String label, bool isDark) {
    final isSelected = _currentIndex == index;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: () => setState(() => _currentIndex = index),
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? primaryRoyalBlue.withOpacity(0.12) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(icon, size: 20, color: isSelected ? primaryRoyalBlue : const Color(0xFF64748B)),
              const SizedBox(width: 14),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? primaryRoyalBlue : const Color(0xFF64748B),
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholderPage(String title, IconData icon, bool isDark, Color textColor, Color subTextColor) {
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF060A12) : const Color(0xFFF1F4F9),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: primaryRoyalBlue, size: 36),
            const SizedBox(height: 12),
            Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
          ],
        ),
      ),
    );
  }
}
