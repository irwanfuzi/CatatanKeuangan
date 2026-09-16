import 'package:flutter/material.dart';
import 'screens/beranda/beranda_screen.dart';
import 'screens/analisis/analisis_screen.dart';
import 'services/api_service.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int _currentIndex = 0;
  Map<String, dynamic> _summaryData = {};
  bool _isLoading = true;

  // Identitas Warna Utama MyKas (Royal Blue & Honey Gold)
  static const Color primaryRoyalBlue = Color(0xFF0052FF);
  static const Color accentHoneyGold = Color(0xFFFF9F00);

  @override
  void initState() {
    super.initState();
    _fetchSummaryData();
  }

  Future<void> _fetchSummaryData() async {
    try {
      final data = await ApiService.getSummary();
      if (mounted) {
        setState(() {
          _summaryData = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

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

        // Interactive Navigation Pages (Dikelola dalam IndexedStack)
        final List<Widget> pages = [
          _isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: primaryRoyalBlue,
                    strokeWidth: 3,
                  ),
                )
              : BerandaScreen(
                  summaryData: _summaryData,
                  onNavigateToAnalisis: () {
                    setState(() {
                      _currentIndex = 1; // Pindah otomatis ke Tab Analisis dari Beranda
                    });
                  },
                ),
          AnalisisScreen(summaryData: _summaryData),
          _buildPlaceholderPage('Dompet & Aset', Icons.account_balance_wallet_rounded, isDark, textColor, subTextColor),
          _buildPlaceholderPage('Profil & Pengaturan', Icons.person_rounded, isDark, textColor, subTextColor),
        ];

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: Row(
            children: [
              // 1. DESKTOP SIDEBAR NAVIGATION (Untuk Tampilan Web Monitor)
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
                            Image.asset(
                              'assets/images/logo_mykas.png',
                              height: 32,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: primaryRoyalBlue,
                                    borderRadius: BorderRadius.circular(9),
                                  ),
                                  child: const Icon(Icons.account_balance_wallet_rounded, color: accentHoneyGold, size: 18),
                                );
                              },
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

              // 2. MAIN CONTENT STREAM (Menggunakan IndexedStack agar Bebas Reload)
              Expanded(
                child: IndexedStack(
                  index: _currentIndex,
                  children: pages,
                ),
              ),
            ],
          ),

          // 3. MOBILE BOTTOM NAVIGATION BAR (Untuk HP Native & Mobile PWA)
          bottomNavigationBar: isDesktop
              ? null
              : Container(
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    border: Border(top: BorderSide(color: borderColor, width: 1)),
                  ),
                  child: BottomNavigationBar(
                    currentIndex: _currentIndex,
                    onTap: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    backgroundColor: surfaceColor,
                    selectedItemColor: primaryRoyalBlue,
                    unselectedItemColor: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                    selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                    unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 11),
                    type: BottomNavigationBarType.fixed,
                    elevation: 0,
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.grid_view_rounded),
                        activeIcon: Icon(Icons.grid_view_rounded, color: primaryRoyalBlue),
                        label: 'Beranda',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.analytics_outlined),
                        activeIcon: Icon(Icons.analytics_rounded, color: primaryRoyalBlue),
                        label: 'Analisis',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.account_balance_wallet_outlined),
                        activeIcon: Icon(Icons.account_balance_wallet_rounded, color: primaryRoyalBlue),
                        label: 'Dompet',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.person_outline_rounded),
                        activeIcon: Icon(Icons.person_rounded, color: primaryRoyalBlue),
                        label: 'Profil',
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }

  // Helper Item Navigasi Desktop dengan Animated Feedback
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

  // Placeholder Halaman untuk Modul Tambahan
  Widget _buildPlaceholderPage(String title, IconData icon, bool isDark, Color textColor, Color subTextColor) {
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF060A12) : const Color(0xFFF1F4F9),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: primaryRoyalBlue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: primaryRoyalBlue, size: 36),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: textColor,
                letterSpacing: -0.4,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Modul $title sedang dalam tahap sinkronisasi data.',
              style: TextStyle(fontSize: 12, color: subTextColor),
            ),
          ],
        ),
      ),
    );
  }
}
