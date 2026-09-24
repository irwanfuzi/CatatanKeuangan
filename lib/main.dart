import 'package:flutter/material.dart';

import 'screens/analisis/analisis_screen.dart';
import 'screens/beranda/beranda_screen.dart';
import 'screens/profil/profil_screen.dart';
import 'screens/riwayat/riwayat_screen.dart';
import 'theme/app_theme.dart';
import 'utils/app_icons.dart';
import 'widgets/mk_bottom_nav_bar.dart' hide AppTheme, AppIcons;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
      themeMode: ThemeMode.dark,
      home: const MainShellNavigation(),
    );
  }
}

class MainShellNavigation extends StatefulWidget {
  const MainShellNavigation({super.key});

  @override
  State<MainShellNavigation> createState() => _MainShellNavigationState();
}

class _MainShellNavigationState extends State<MainShellNavigation> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _navigateToAnalisis() {
    setState(() {
      _currentIndex = 1;
    });
  }

  void _onAddPressed() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const ModalTambahTransaksiSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Menghubungkan 4 tab utama ke Screen resmi aplikasi MyKas
    final List<Widget> pages = [
      BerandaScreen(onNavigateToAnalisis: _navigateToAnalisis),
      const AnalisisScreen(),
      const RiwayatScreen(),
      const ProfilScreen(),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 1024;

        return Scaffold(
          body: Row(
            children: [
              if (isDesktop) ...[
                NavigationRail(
                  selectedIndex: _currentIndex,
                  backgroundColor: AppTheme.bgDark,
                  selectedIconTheme: const IconThemeData(color: AppTheme.brandPrimary),
                  unselectedIconTheme: const IconThemeData(color: AppTheme.textSecondaryDark),
                  onDestinationSelected: _onTabTapped,
                  labelType: NavigationRailLabelType.all,
                  destinations: const [
                    NavigationRailDestination(icon: Icon(AppIcons.layoutGrid), label: Text('Beranda')),
                    NavigationRailDestination(icon: Icon(AppIcons.barChart), label: Text('Analisis')),
                    NavigationRailDestination(icon: Icon(AppIcons.history), label: Text('Riwayat')),
                    NavigationRailDestination(icon: Icon(AppIcons.user), label: Text('Profil')),
                  ],
                ),
                const VerticalDivider(width: 1, color: AppTheme.borderDark),
              ],

              Expanded(
                child: IndexedStack(
                  index: _currentIndex,
                  children: pages,
                ),
              ),
            ],
          ),

          bottomNavigationBar: isDesktop
              ? null
              : MKBottomNavBar(
                  currentIndex: _currentIndex,
                  onTap: _onTabTapped,
                  onAddPressed: _onAddPressed,
                ),
        );
      },
    );
  }
}

class ModalTambahTransaksiSheet extends StatefulWidget {
  const ModalTambahTransaksiSheet({super.key});

  @override
  State<ModalTambahTransaksiSheet> createState() => _ModalTambahTransaksiSheetState();
}

class _ModalTambahTransaksiSheetState extends State<ModalTambahTransaksiSheet> {
  String _jenisTransaksi = 'Pengeluaran';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppTheme.cardDark : AppTheme.cardLight;
    final textColor = isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight;

    return Container(
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 38,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? AppTheme.borderDark : const Color(0xFFCBD5E1),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tambah Transaksi Baru',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: textColor,
                  fontFamily: 'sans-serif',
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(AppIcons.x, size: 18, color: textColor),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ChoiceChip(
                  label: const Center(child: Text('Pemasukan')),
                  selected: _jenisTransaksi == 'Pemasukan',
                  selectedColor: const Color(0xFF10B981),
                  labelStyle: TextStyle(
                    color: _jenisTransaksi == 'Pemasukan' ? Colors.white : textColor,
                    fontWeight: FontWeight.bold,
                  ),
                  onSelected: (selected) {
                    if (selected) setState(() => _jenisTransaksi = 'Pemasukan');
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ChoiceChip(
                  label: const Center(child: Text('Pengeluaran')),
                  selected: _jenisTransaksi == 'Pengeluaran',
                  selectedColor: const Color(0xFFEF4444),
                  labelStyle: TextStyle(
                    color: _jenisTransaksi == 'Pengeluaran' ? Colors.white : textColor,
                    fontWeight: FontWeight.bold,
                  ),
                  onSelected: (selected) {
                    if (selected) setState(() => _jenisTransaksi = 'Pengeluaran');
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Nominal (Rp)',
              prefixText: 'Rp ',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            decoration: InputDecoration(
              labelText: 'Keterangan / Judul',
              hintText: 'Contoh: Belanja Bulanan / Gaji',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('✅ Transaksi berhasil disimpan!'),
                    backgroundColor: Color(0xFF10B981),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.brandPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Simpan Transaksi',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  fontFamily: 'sans-serif',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
