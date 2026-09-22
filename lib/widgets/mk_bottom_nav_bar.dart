import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

// Import widget gabungan MKBottomNavBar & FormTambahTransaksi yang sudah dibuat sebelumnya
import 'package:mykas/widgets/mk_bottom_nav_bar.dart';
// Import screen beranda buatanmu
import 'package:mykas/screens/beranda/beranda_screen.dart';
import 'package:mykas/theme/app_theme.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onAddTapped() {
    // Panggil fungsi modal bottom sheet catat transaksi
    showCtaBottomSheet(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDesktop = MediaQuery.of(context).size.width >= 1024;

    // Daftar Halaman Sesuai Tab (4 Tab Utama + 1 Central CTA Button)
    final List<Widget> pages = [
      BerandaScreen(
        onNavigateToAnalisis: () => setState(() => _currentIndex = 1),
      ),
      _buildPlaceholderPage('Halaman Analisis Keuangan', LucideIcons.barChart3, isDark),
      _buildPlaceholderPage('Halaman Riwayat Transaksi', LucideIcons.receipt, isDark),
      _buildPlaceholderPage('Halaman Profil Pengguna', LucideIcons.user, isDark),
    ];

    return Scaffold(
      backgroundColor: isDark ? AppTheme.bgDark : AppTheme.bgLight;
      // extendBody Bikin Floating Curved BottomBar Tampil Melayang di Atas Konten
      extendBody: true,
      body: isDesktop
          ? Row(
              children: [
                _buildDesktopSidebar(isDark),
                Expanded(
                  child: IndexedStack(
                    index: _currentIndex,
                    children: pages,
                  ),
                ),
              ],
            )
          : IndexedStack(
              index: _currentIndex,
              children: pages,
            ),
      // MEMANGGIL BOTTOM NAVBAR BARU DENGAN 5 TOMBOL (BERANDA, ANALISIS, CATAT (+), RIWAYAT, PROFIL)
      bottomNavigationBar: isDesktop
          ? null
          : MKBottomNavBar(
              currentIndex: _currentIndex,
              onTap: _onTabTapped,
              onAddTap: _onAddTapped,
            ),
    );
  }

  // =========================================================================
  // DESKTOP WEB SIDEBAR NAVIGATION
  // =========================================================================
  Widget _buildDesktopSidebar(bool isDark) {
    final sidebarBg = isDark ? AppTheme.cardDark : Colors.white;
    final borderColor = isDark ? AppTheme.borderDark : AppTheme.borderLight;
    final textColor = isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight;

    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: sidebarBg,
        border: Border(right: BorderSide(color: borderColor)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 28),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppTheme.brandPrimary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Icon(LucideIcons.wallet, color: Colors.white, size: 20),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'MyKas',
                  style: GoogleFonts.urbanist(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          _buildSidebarTile(0, 'Beranda', LucideIcons.home),
          _buildSidebarTile(1, 'Analisis', LucideIcons.barChart3),
          _buildSidebarTile(2, 'Riwayat', LucideIcons.receipt),
          _buildSidebarTile(3, 'Profil', LucideIcons.user),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: _onAddTapped,
                icon: const Icon(LucideIcons.plus, size: 18, color: Colors.white),
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
    );
  }

  Widget _buildSidebarTile(int index, String title, IconData icon) {
    final isSelected = _currentIndex == index;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? AppTheme.brandPrimary.withOpacity(0.12) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: () => _onTabTapped(index),
        leading: Icon(
          icon,
          size: 20,
          color: isSelected ? AppTheme.brandPrimary : const Color(0xFF64748B),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            color: isSelected ? AppTheme.brandPrimary : const Color(0xFF64748B),
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildPlaceholderPage(String title, IconData icon, bool isDark) {
    final textColor = isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight;
    final textMuted = isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 54, color: AppTheme.brandPrimary.withOpacity(0.5)),
          const SizedBox(height: 16),
          Text(
            title,
            style: GoogleFonts.urbanist(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: textColor,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Fitur sedang dalam tahap sinkronisasi.',
            style: TextStyle(fontSize: 12, color: textMuted),
          ),
        ],
      ),
    );
  }
}
