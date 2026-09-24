import 'package:flutter/material.dart';

import 'theme/app_theme.dart';
import 'utils/app_icons.dart';
import 'widgets/mk_bottom_nav_bar.dart' hide AppTheme, AppIcons;

const Color _textSecondary = Color(0x99FFFFFF);

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
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppTheme.bgDark,
        colorScheme: ColorScheme.dark(
          surface: AppTheme.cardDark,
          primary: AppTheme.brandPrimary,
          secondary: AppTheme.brandSecondary,
          onSurface: Colors.white,
        ),
        fontFamily: 'Roboto',
      ),
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
              'Pilih jenis kas yang ingin Anda perbarui pencatatannya.',
              style: TextStyle(color: _textSecondary, fontSize: 13),
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
                      side: BorderSide(color: AppTheme.borderDark),
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
          body: Row(
            children: [
              if (isDesktop) ...[
                NavigationRail(
                  selectedIndex: _currentIndex,
                  backgroundColor: AppTheme.bgDark,
                  selectedIconTheme: IconThemeData(color: AppTheme.brandPrimary),
                  unselectedIconTheme: const IconThemeData(color: _textSecondary),
                  onDestinationSelected: _onTabTapped,
                  labelType: NavigationRailLabelType.all,
                  destinations: const [
                    NavigationRailDestination(icon: Icon(AppIcons.layoutGrid), label: Text('Beranda')),
                    NavigationRailDestination(icon: Icon(AppIcons.barChart), label: Text('Analisis')),
                    NavigationRailDestination(icon: Icon(AppIcons.history), label: Text('Riwayat')),
                    NavigationRailDestination(icon: Icon(AppIcons.user), label: Text('Profil')),
                  ],
                ),
                VerticalDivider(width: 1, color: AppTheme.borderDark),
              ],

              Expanded(
                child: IndexedStack(
                  index: _currentIndex,
                  children: const [
                    HomeScreenDashboardView(),
                    _PlaceholderTab(title: 'Modul Analisis Finansial'),
                    _PlaceholderTab(title: 'Riwayat Seluruh Transaksi'),
                    _PlaceholderTab(title: 'Pengaturan Profil'),
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

class HomeScreenDashboardView extends StatelessWidget {
  const HomeScreenDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.bgDark,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
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
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white),
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

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Kantong Keuangan',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.brandPrimary.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text('3 Terhubung', style: TextStyle(fontSize: 10, color: AppTheme.brandPrimary, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text('Lihat Semua >', style: TextStyle(color: AppTheme.brandPrimary, fontSize: 12)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

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
                          border: Border.all(color: AppTheme.borderDark),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_rounded, color: AppTheme.brandPrimary, size: 24),
                            const SizedBox(height: 4),
                            const Text('+ Tambah Akun', style: TextStyle(color: _textSecondary, fontSize: 12, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Quick Actions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
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
                          child: Icon(Icons.auto_awesome_rounded, color: AppTheme.brandSecondary, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('My Insight', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                              SizedBox(height: 2),
                              Text(
                                'Pengeluaran menurun 12%! Hemat Rp1.450.000 pada pos non-primer dibanding minggu lalu.',
                                style: TextStyle(color: _textSecondary, fontSize: 11, height: 1.3),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Overview Keuangan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                      TextButton(
                        onPressed: () {},
                        child: Text('Lihat Detail >', style: TextStyle(color: AppTheme.brandPrimary, fontSize: 12)),
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

                  const SizedBox(height: 24),

                  const Text(
                    'Riwayat Transaksi',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.cardDark,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.borderDark),
                    ),
                    child: Column(
                      children: [
                        _buildTransactionTile(
                          icon: Icons.restaurant_rounded,
                          iconBg: const Color(0xFFD97706).withOpacity(0.2),
                          iconColor: const Color(0xFFF59E0B),
                          title: 'Gudeg Bu Dani Solo',
                          subtitle: 'Hari Ini, 12:45 • Kuliner & Makanan',
                          amount: '-Rp45.000',
                          isExpense: true,
                        ),
                        Divider(height: 1, color: AppTheme.borderDark),
                        _buildTransactionTile(
                          icon: Icons.account_balance_wallet_rounded,
                          iconBg: const Color(0xFF10B981).withOpacity(0.2),
                          iconColor: const Color(0xFF10B981),
                          title: 'Gaji Bulanan Utama',
                          subtitle: '25 Agu 2026 • Payroll Inflow',
                          amount: '+Rp8.500.000',
                          isExpense: false,
                        ),
                        Divider(height: 1, color: AppTheme.borderDark),
                        _buildTransactionTile(
                          icon: Icons.shopping_bag_rounded,
                          iconBg: const Color(0xFF0284C7).withOpacity(0.2),
                          iconColor: const Color(0xFF38BDF8),
                          title: 'GoFood Indonesia',
                          subtitle: '24 Agu 2026 • Layanan Antar',
                          amount: '-Rp68.000',
                          isExpense: true,
                        ),
                        Divider(height: 1, color: AppTheme.borderDark),
                        _buildTransactionTile(
                          icon: Icons.shopping_cart_rounded,
                          iconBg: const Color(0xFF7C3AED).withOpacity(0.2),
                          iconColor: const Color(0xFFA78BFA),
                          title: 'Supermarket Transmart',
                          subtitle: '22 Agu 2026 • Kebutuhan Harian',
                          amount: '-Rp235.000',
                          isExpense: true,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),
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
              const Icon(Icons.chevron_right_rounded, color: _textSecondary, size: 16),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(color: _textSecondary, fontSize: 11)),
              const SizedBox(height: 2),
              Text(balance, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
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
              // FIX 1: Hapus const di sini karena label variabel
              Text(label, style: const TextStyle(color: _textSecondary, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 12),
          Text(amount, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildTransactionTile({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String amount,
    required bool isExpense,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
                const SizedBox(height: 2),
                // FIX 2: Hapus const di sini karena subtitle variabel
                Text(subtitle, style: const TextStyle(color: _textSecondary, fontSize: 11)),
              ],
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 14,
              color: isExpense ? Colors.white : const Color(0xFF10B981),
            ),
          ),
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
        Text(label, style: const TextStyle(color: _textSecondary, fontSize: 11)),
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
      child: Text(title, style: const TextStyle(color: _textSecondary, fontSize: 16)),
    );
  }
}
