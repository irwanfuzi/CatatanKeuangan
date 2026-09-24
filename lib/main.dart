import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyKasApp());
}

// -----------------------------------------------------------------------------
// DESIGN SYSTEM & THEME (MATCHING YOUR SCREENSHOT)
// -----------------------------------------------------------------------------
class AppTheme {
  static const Color brandPrimary = Color(0xFF0052FF); // Electric Blue Top
  static const Color brandSecondary = Color(0xFFFFB800); // Gold Accent
  static const Color bgDark = Color(0xFF0B0E14); // Dark Background Body
  static const Color cardDark = Color(0xFF161B22); // Dark Card Surface
  static const Color borderDark = Color(0xFF21262D); // Subtle Border
  static const Color textSecondary = Color(0xFF8B949E);
  static const Color textPrimary = Color(0xFFF0F6FC);
}

class AppIcons {
  static const IconData layoutGrid = Icons.grid_view_rounded;
  static const IconData barChart = Icons.bar_chart_rounded;
  static const IconData history = Icons.history_rounded;
  static const IconData user = Icons.person_outline_rounded;
  static const IconData plus = Icons.add_rounded;
}

class MyKasApp extends StatelessWidget {
  const MyKasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyKas',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppTheme.bgDark,
        colorScheme: const ColorScheme.dark(
          surface: AppTheme.cardDark,
          primary: AppTheme.brandPrimary,
          secondary: AppTheme.brandSecondary,
          onSurface: AppTheme.textPrimary,
        ),
        fontFamily: 'Roboto',
      ),
      home: const RootHomeScreen(),
    );
  }
}

// -----------------------------------------------------------------------------
// ROOT SCREEN (SCAFFOLD DENGAN BOTTOM NAV BAR UTAMA)
// -----------------------------------------------------------------------------
class RootHomeScreen extends StatefulWidget {
  const RootHomeScreen({super.key});

  @override
  State<RootHomeScreen> createState() => _RootHomeScreenState();
}

class _RootHomeScreenState extends State<RootHomeScreen> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onAddPressed() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.cardDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        height: 220,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Catat Transaksi Baru',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
            ),
            const SizedBox(height: 8),
            const Text(
              'Pilih jenis kas yang ingin Anda perbarui.',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.brandPrimary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_downward_rounded, size: 18),
                    label: const Text('Pemasukan', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.textPrimary,
                      side: const BorderSide(color: AppTheme.borderDark),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_upward_rounded, size: 18),
                    label: const Text('Pengeluaran'),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 1024;

        return Scaffold(
          // BODY UTAMA DENGAN INDEXED STACK
          body: Row(
            children: [
              // Sidebar Navigation untuk Mode Desktop Web
              if (isDesktop) ...[
                NavigationRail(
                  selectedIndex: _currentIndex,
                  backgroundColor: AppTheme.bgDark,
                  selectedIconTheme: const IconThemeData(color: AppTheme.brandPrimary),
                  unselectedItemColor: AppTheme.textSecondary,
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

              // Konten Beranda / Tab
              Expanded(
                child: IndexedStack(
                  index: _currentIndex,
                  children: const [
                    MyKasDashboardView(),
                    _PlaceholderTab(title: 'Modul Analisis'),
                    _PlaceholderTab(title: 'Riwayat Transaksi'),
                    _PlaceholderTab(title: 'Profil Pengguna'),
                  ],
                ),
              ),
            ],
          ),

          // BOTTOM NAV BAR (SANGAT PENTING: DITAMPILKAN DI SCAFFOLD TERLUAR UNTUK MOBILE)
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

// -----------------------------------------------------------------------------
// DASHBOARD VIEW (MATCHING TANGKAPAN LAYAR ANDA)
// -----------------------------------------------------------------------------
class MyKasDashboardView extends StatelessWidget {
  const MyKasDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.bgDark,
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Header Biru Atas (Total Saldo)
            Container(
              padding: const EdgeInsets.fromLTRB(20, 48, 20, 24),
              decoration: const BoxDecoration(
                color: AppTheme.brandPrimary,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.white24,
                        child: Icon(Icons.person_outline_rounded, color: Colors.white, size: 20),
                      ),
                      const Text(
                        'MyKas',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.black, color: Colors.white),
                      ),
                      IconButton(
                        icon: const Icon(Icons.notifications_none_rounded, color: Colors.white),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: const [
                      Text('Total Saldo', style: TextStyle(color: Colors.white70, fontSize: 13)),
                      SizedBox(width: 6),
                      Icon(Icons.remove_red_eye_outlined, color: Colors.white70, size: 16),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Rp 11.250.000',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: const [
                      Icon(Icons.access_time_rounded, color: Colors.white60, size: 12),
                      SizedBox(width: 4),
                      Text('Updated 2m ago', style: TextStyle(color: Colors.white60, fontSize: 11)),
                    ],
                  ),
                ],
              ),
            ),

            // Main Dark Content Body
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Kantong Keuangan Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Kantong Keuangan',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.brandPrimary.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text('3 Terhubung', style: TextStyle(fontSize: 10, color: AppTheme.brandPrimary, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('Lihat Semua >', style: TextStyle(color: AppTheme.brandPrimary, fontSize: 12)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Grid 2x2 Kantong Keuangan
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.4,
                    children: [
                      _buildWalletCard('BSI', 'BSI Hasanah', 'Rp 4.250.000', const Color(0xFF00A884)),
                      _buildWalletCard('MANDIRI', 'Mandiri Utama', 'Rp 6.000.000', const Color(0xFFFF9800)),
                      _buildWalletCard('GOPAY', 'GoPay Wallet', 'Rp 1.000.000', const Color(0xFF00AED6)),
                      Container(
                        decoration: BoxDecoration(
                          color: AppTheme.cardDark,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppTheme.borderDark, style: BorderStyle.solid),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_rounded, color: AppTheme.brandPrimary, size: 24),
                            SizedBox(height: 4),
                            Text('+ Tambah Akun', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Quick Actions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Quick Actions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                      Text('Edit', style: TextStyle(color: AppTheme.brandPrimary, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      _QuickActionButton(icon: Icons.qr_code_scanner_rounded, label: 'Scan Struk'),
                      _QuickActionButton(icon: Icons.swap_horiz_rounded, label: 'Transfer'),
                      _QuickActionButton(icon: Icons.autorenew_rounded, label: 'Transaksi ...'),
                      _QuickActionButton(icon: Icons.track_changes_rounded, label: 'Tujuan Ke...'),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // My Insight Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.cardDark,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.borderDark),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppTheme.brandSecondary.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.auto_awesome_rounded, color: AppTheme.brandSecondary, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('My Insight', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                              SizedBox(height: 2),
                              Text(
                                'Pengeluaran menurun 12%! Hemat Rp1.450.000 pada pos non-primer dibanding minggu lalu.',
                                style: TextStyle(color: AppTheme.textSecondary, fontSize: 11, height: 1.3),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Overview Keuangan
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Overview Keuangan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                      TextButton(
                        onPressed: () {},
                        child: const Text('Lihat Detail >', style: TextStyle(color: AppTheme.brandPrimary, fontSize: 12)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _buildOverviewTile('Pemasukan', 'Rp 5.250.000', Icons.arrow_downward_rounded, const Color(0xFF10B981))),
                      const SizedBox(width: 12),
                      Expanded(child: _buildOverviewTile('Pengeluaran', 'Rp 2.804.178', Icons.arrow_upward_rounded, const Color(0xFFEF4444))),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWalletCard(String tag, String name, String balance, Color tagBg) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: tagBg, borderRadius: BorderRadius.circular(6)),
                child: Text(tag, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
              const Icon(Icons.chevron_right_rounded, color: AppTheme.textSecondary, size: 16),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
              const SizedBox(height: 2),
              Text(balance, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildOverviewTile(String label, String amount, IconData icon, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: iconColor.withOpacity(0.15), shape: BoxShape.circle),
                child: Icon(icon, color: iconColor, size: 14),
              ),
              const SizedBox(width: 8),
              Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 12),
          Text(amount, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
        ],
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const _QuickActionButton({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppTheme.brandPrimary.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppTheme.brandPrimary, size: 22),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
      ],
    );
  }
}

class _PlaceholderTab extends StatelessWidget {
  final String title;
  const _PlaceholderTab({required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(title, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 16)),
    );
  }
}

// -----------------------------------------------------------------------------
// SOLID DOCKED BOTTOM NAVIGATION BAR (MKBottomNavBar)
// -----------------------------------------------------------------------------
class MKBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final VoidCallback onAddPressed;

  const MKBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    const navBgColor = AppTheme.cardDark;
    const borderColor = AppTheme.borderDark;

    return Container(
      decoration: const BoxDecoration(
        color: navBgColor,
        border: Border(
          top: BorderSide(color: borderColor, width: 1.0),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 68,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _NavBarItem(
                      icon: AppIcons.layoutGrid,
                      label: 'Beranda',
                      isSelected: currentIndex == 0,
                      onTap: () => onTap(0),
                    ),
                  ),
                  Expanded(
                    child: _NavBarItem(
                      icon: AppIcons.barChart,
                      label: 'Analisis',
                      isSelected: currentIndex == 1,
                      onTap: () => onTap(1),
                    ),
                  ),
                  const SizedBox(width: 64),
                  Expanded(
                    child: _NavBarItem(
                      icon: AppIcons.history,
                      label: 'Riwayat',
                      isSelected: currentIndex == 2,
                      onTap: () => onTap(2),
                    ),
                  ),
                  Expanded(
                    child: _NavBarItem(
                      icon: AppIcons.user,
                      label: 'Profil',
                      isSelected: currentIndex == 3,
                      onTap: () => onTap(3),
                    ),
                  ),
                ],
              ),
              Positioned(
                top: -14,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: onAddPressed,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppTheme.brandPrimary, Color(0xFF0040C8)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: navBgColor,
                              width: 3.0,
                            ),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              const Icon(
                                AppIcons.plus,
                                color: Colors.white,
                                size: 24,
                              ),
                              Positioned(
                                right: 10,
                                top: 10,
                                child: Container(
                                  width: 5,
                                  height: 5,
                                  decoration: const BoxDecoration(
                                    color: AppTheme.brandSecondary,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Catat',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.brandPrimary,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const activeColor = AppTheme.brandPrimary;
    const inactiveColor = AppTheme.textSecondary;

    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          if (isSelected) ...[
            Container(
              width: double.infinity,
              height: 44,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    activeColor.withOpacity(0.12),
                    activeColor.withOpacity(0.0),
                  ],
                ),
              ),
            ),
            Container(
              width: 28,
              height: 3,
              decoration: const BoxDecoration(
                color: activeColor,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(2),
                ),
              ),
            ),
          ],
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 2),
                Icon(
                  icon,
                  color: isSelected ? activeColor : inactiveColor,
                  size: 20,
                ),
                const SizedBox(height: 3),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                    color: isSelected ? activeColor : inactiveColor,
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
