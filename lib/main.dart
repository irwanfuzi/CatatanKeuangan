import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyKasApp());
}

// -----------------------------------------------------------------------------
// DESIGN SYSTEM & THEME CONFIGURATION (Obsidian Luxe Theme)
// -----------------------------------------------------------------------------
class AppTheme {
  static const Color brandPrimary = Color(0xFF0052FF); // Electric Blue
  static const Color brandSecondary = Color(0xFFFFB800); // Gold Accent
  static const Color cardDark = Color(0xFF1E293B); // Slate 800
  static const Color borderDark = Color(0xFF334155); // Slate 700
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color textSecondaryDark = Color(0xFF94A3B8);
  static const Color textSecondaryLight = Color(0xFF64748B);
  static const Color bgDark = Color(0xFF0F172A); // Slate 900
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
      title: 'MyKas - Own Your Money',
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
          onSurface: Color(0xFFF8FAFC),
        ),
      ),
      home: const MainLayoutScreen(),
    );
  }
}

// -----------------------------------------------------------------------------
// MAIN LAYOUT (ADAPTIVE DESKTOP & PWA MOBILE)
// -----------------------------------------------------------------------------
class MainLayoutScreen extends StatefulWidget {
  const MainLayoutScreen({super.key});

  @override
  State<MainLayoutScreen> createState() => _MainLayoutScreenState();
}

class _MainLayoutScreenState extends State<MainLayoutScreen> {
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
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8),
            const Text(
              'Pilih jenis kas yang ingin diperbarui dalam pencatatan Anda.',
              style: TextStyle(color: AppTheme.textSecondaryDark, fontSize: 13),
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
                      foregroundColor: Colors.white,
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
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: const BoxDecoration(
                color: AppTheme.bgDark,
                border: Border(bottom: BorderSide(color: AppTheme.borderDark)),
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    const Text(
                      'MyKas',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.black, letterSpacing: -0.5),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.notifications_none_rounded, color: AppTheme.textSecondaryDark),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: Row(
            children: [
              if (isDesktop) ...[
                NavigationRail(
                  selectedIndex: _currentIndex,
                  backgroundColor: AppTheme.bgDark,
                  selectedIconTheme: const IconThemeData(color: AppTheme.brandPrimary),
                  unselectedItemColor: AppTheme.textSecondaryDark,
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
                  children: const [
                    _DashboardOverview(),
                    _PlaceholderPage(title: 'Modul Analisis Finansial'),
                    _PlaceholderPage(title: 'Riwayat Transaksi Kas'),
                    _PlaceholderPage(title: 'Pengaturan Profil'),
                  ],
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

// -----------------------------------------------------------------------------
// DASHBOARD OVERVIEW VIEW
// -----------------------------------------------------------------------------
class _DashboardOverview extends StatelessWidget {
  const _DashboardOverview();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppTheme.cardDark,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppTheme.borderDark),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Total Kas Aktif', style: TextStyle(color: AppTheme.textSecondaryDark, fontSize: 13)),
              const SizedBox(height: 6),
              const Text(
                'Rp 142.850.000',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.black, letterSpacing: -0.5),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '+14.2% dibanding bulan lalu',
                  style: TextStyle(color: Color(0xFF10B981), fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PlaceholderPage extends StatelessWidget {
  final String title;
  const _PlaceholderPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(title, style: const TextStyle(color: AppTheme.textSecondaryDark, fontSize: 16)),
    );
  }
}

// -----------------------------------------------------------------------------
// DOCKED BOTTOM NAV BAR WITH CENTER FAB
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final navBgColor = isDark ? AppTheme.cardDark : Colors.white;
    final borderColor = isDark ? AppTheme.borderDark : AppTheme.borderLight;

    return Container(
      decoration: BoxDecoration(
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const activeColor = AppTheme.brandPrimary;
    final inactiveColor = isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight;

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
