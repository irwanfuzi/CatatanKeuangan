import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lucide_icons/lucide_icons.dart';

// Import Screen & Services bawaan projekmu
import 'screens/beranda/beranda_screen.dart';
import 'screens/analisis/analisis_screen.dart';
import 'screens/riwayat/riwayat_screen.dart';
import 'screens/profil/profil_screen.dart';
import 'widgets/mk_bottom_nav_bar.dart'; // Menghubungkan MKBottomNavBar 5-Tombol & Modal CTA
import 'services/api_service.dart';
import 'theme/app_theme.dart';

class App extends StatefulWidget {
  final Function(bool isDark)? onThemeChanged;

  const App({
    super.key,
    this.onThemeChanged,
  });

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int _currentIndex = 0;

  Map<String, dynamic> _summaryData = {
    'saldo': 'Rp 11.250.000',
    'pemasukan': 'Rp 5.250.000',
    'pengeluaran': 'Rp 2.804.178',
    'riwayat': [
      {'judul': 'Gaji Bulanan', 'nominal': 'Rp 5.250.000', 'jenis': 'pemasukan', 'kategori': 'Gaji', 'tanggal': '01 Sep'},
      {'judul': 'Belanja Supermarket', 'nominal': 'Rp 650.000', 'jenis': 'pengeluaran', 'kategori': 'Belanja', 'tanggal': '03 Sep'},
      {'judul': 'Makan Malam', 'nominal': 'Rp 120.000', 'jenis': 'pengeluaran', 'kategori': 'Makanan', 'tanggal': '05 Sep'},
    ]
  };

  @override
  void initState() {
    super.initState();
    _fetchSummaryData();
  }

  Future<void> _fetchSummaryData() async {
    try {
      final data = await ApiService.getSummary();
      if (mounted && data.isNotEmpty) {
        setState(() {
          _summaryData = data;
        });
      }
    } catch (_) {}
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onAddTapped() {
    // Membuka modal bottom sheet tambah transaksi cepat
    showCtaBottomSheet(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final surfaceColor = isDark ? AppTheme.bgDark : AppTheme.bgLight;
    final borderColor = isDark ? AppTheme.borderDark : AppTheme.borderLight;
    final textColor = isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 1024;

        // 4 Halaman Utama
        final List<Widget> pages = [
          BerandaScreen(
            summaryData: _summaryData,
            onNavigateToAnalisis: () {
              setState(() {
                _currentIndex = 1;
              });
            },
          ),
          AnalisisScreen(summaryData: _summaryData),
          RiwayatTransaksiScreen(summaryData: _summaryData),
          ProfilScreen(
            onThemeChanged: widget.onThemeChanged,
            onLogout: () {
              setState(() {
                _currentIndex = 0;
              });
            },
          ),
        ];

        return Scaffold(
          backgroundColor: isDark ? AppTheme.bgDark : AppTheme.bgLight;
          // extendBody: true membuat floating navbar melayang halus di atas konten
          extendBody: true,
          body: Row(
            children: [
              // DESKTOP NAVIGATION RAIL
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
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: AppTheme.brandPrimary,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(LucideIcons.wallet, color: Colors.white, size: 20),
                            ),
                            const SizedBox(width: 12),
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
                      const SizedBox(height: 12),
                      _buildDesktopNavItem(0, LucideIcons.layoutGrid, 'Beranda'),
                      _buildDesktopNavItem(1, LucideIcons.barChart3, 'Analisis'),
                      _buildDesktopNavItem(2, LucideIcons.history, 'Riwayat Kas'),
                      _buildDesktopNavItem(3, LucideIcons.user, 'Profil'),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton.icon(
                            onPressed: _onAddTapped,
                            icon: const Icon(FontAwesomeIcons.plus, size: 16, color: Colors.white),
                            label: const Text(
                              'Catat Transaksi',
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.brandPrimary,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              elevation: 0,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              // CONTENT BODY
              Expanded(
                child: IndexedStack(
                  index: _currentIndex,
                  children: pages,
                ),
              ),
            ],
          ),
          // MOBILE FLOATING CURVED NAVBAR 5 TOMBOL
          bottomNavigationBar: isDesktop
              ? null
              : MKBottomNavBar(
                  currentIndex: _currentIndex,
                  onTap: _onTabTapped,
                  onAddTap: _onAddTapped,
                ),
        );
      },
    );
  }

  Widget _buildDesktopNavItem(int index, IconData icon, String label) {
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
            color: isSelected ? AppTheme.brandPrimary.withOpacity(0.12) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(icon, size: 20, color: isSelected ? AppTheme.brandPrimary : const Color(0xFF64748B)),
              const SizedBox(width: 14),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? AppTheme.brandPrimary : const Color(0xFF64748B),
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
}
