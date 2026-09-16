import 'package:flutter/material.dart';
import 'screens/beranda/beranda_screen.dart';
import 'screens/analisis/analisis_screen.dart'; // <--- Import AnalisisScreen resmi
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

  @override
  void initState() {
    super.initState();
    _fetchSummaryData();
  }

  Future<void> _fetchSummaryData() async {
    try {
      final data = await ApiService.getSummary();
      setState(() {
        _summaryData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final surfaceColor = isDark ? const Color(0xFF0F172A) : Colors.white;
    final borderColor = isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 1024;

        // Interactive Page List
        final List<Widget> pages = [
          _isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Color(0xFF0052FF)),
                )
              : BerandaScreen(
                  summaryData: _summaryData,
                  onNavigateToAnalisis: () {
                    setState(() {
                      _currentIndex = 1; // Pindah otomatis ke Tab Analisis
                    });
                  },
                ),
          
          // TAB 1: ANALISIS KEUANGAN SELESAI & HARI INI DIPASANG
          const AnalisisScreen(),

          // TAB 2 & 3: PLACEHOLDER DENGAN BRANDING CONSISTENCY
          _buildPlaceholderPage('Dompet & Rekening', Icons.account_balance_wallet_rounded, isDark),
          _buildPlaceholderPage('Profil Pengguna', Icons.person_rounded, isDark),
        ];

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: Row(
            children: [
              // DESKTOP SIDEBAR NAVIGATION (Untuk Web Desktop)
              if (isDesktop)
                Container(
                  width: 250,
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
                                    color: const Color(0xFF0052FF),
                                    borderRadius: BorderRadius.circular(9),
                                  ),
                                  child: const Icon(Icons.account_balance_wallet_rounded, color: Colors.amber, size: 18),
                                );
                              },
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'MyKas',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
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

              // MAIN CONTENT STREAM WITH INDEXED STACK (Bikin State Awet)
              Expanded(
                child: IndexedStack(
                  index: _currentIndex,
                  children: pages,
                ),
              ),
            ],
          ),

          // MOBILE BOTTOM NAVIGATION BAR (Untuk Mobile PWA & Touch Native)
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
                    selectedItemColor: const Color(0xFF0052FF), // Royal Blue MyKas
                    unselectedItemColor: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                    selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                    unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 11),
                    type: BottomNavigationBarType.fixed,
                    elevation: 0,
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.grid_view_rounded),
                        activeIcon: Icon(Icons.grid_view_rounded, color: Color(0xFF0052FF)),
                        label: 'Beranda',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.analytics_outlined),
                        activeIcon: Icon(Icons.analytics_rounded, color: Color(0xFF0052FF)),
                        label: 'Analisis',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.account_balance_wallet_outlined),
                        activeIcon: Icon(Icons.account_balance_wallet_rounded, color: Color(0xFF0052FF)),
                        label: 'Dompet',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.person_outline_rounded),
                        activeIcon: Icon(Icons.person_rounded, color: Color(0xFF0052FF)),
                        label: 'Profil',
                      ),
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
            color: isSelected ? const Color(0xFF0052FF).withOpacity(0.12) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(icon, size: 20, color: isSelected ? const Color(0xFF0052FF) : const Color(0xFF64748B)),
              const SizedBox(width: 14),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? const Color(0xFF0052FF) : const Color(0xFF64748B),
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

  Widget _buildPlaceholderPage(String title, IconData icon, bool isDark) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF0052FF).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF0052FF), size: 32),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }
}
