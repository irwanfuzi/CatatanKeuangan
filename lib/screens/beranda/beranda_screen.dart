import 'package:flutter/material.dart';

void main() {
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFEF4444)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.warning_amber_rounded, color: Color(0xFFEF4444), size: 48),
              const SizedBox(height: 16),
              const Text('Terjadi Kesalahan Visual', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 8),
              Text(details.exceptionAsString(), textAlign: TextAlign.center, style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  };

  runApp(const MyKasApp());
}

class MyKasApp extends StatelessWidget {
  const MyKasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyKas Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4F46E5),
          brightness: Brightness.light,
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F6FB),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.dark,
          surface: const Color(0xFF0F172A),
        ),
        scaffoldBackgroundColor: const Color(0xFF070C18),
      ),
      themeMode: ThemeMode.system,
      home: const BerandaScreen(
        summaryData: {
          'saldo': 'Rp 12.500.000',
          'riwayat': [
            {'keterangan': 'Makan Siang', 'kategori': 'Makanan', 'dompet': 'Tunai', 'nominal': '45.000', 'jenis': 'pengeluaran'},
            {'keterangan': 'Gaji Bulan Ini', 'kategori': 'Pendapatan', 'dompet': 'BCA', 'nominal': '8.500.000', 'jenis': 'pemasukan'},
            {'keterangan': 'Belanja Bulanan', 'kategori': 'Kebutuhan', 'dompet': 'ShopeePay', 'nominal': '120.000', 'jenis': 'pengeluaran'},
            {'keterangan': 'Kopi Kenangan', 'kategori': 'Hiburan', 'dompet': 'GoPay', 'nominal': '35.000', 'jenis': 'pengeluaran'},
          ]
        },
      ),
    );
  }
}

class BerandaScreen extends StatefulWidget {
  final Map<String, dynamic>? summaryData;
  final VoidCallback? onNavigateToAnalisis;

  const BerandaScreen({
    super.key,
    this.summaryData,
    this.onNavigateToAnalisis,
  });

  @override
  State<BerandaScreen> createState() => _BerandaScreenState();
}

class _BerandaScreenState extends State<BerandaScreen> {
  bool _isBalanceVisible = true;
  int _selectedDesktopNav = 0;

  final List<Map<String, dynamic>> _quickActions = const [
    {'id': 'scan', 'label': 'Scan QRIS', 'icon': Icons.qr_code_scanner_rounded, 'color': Color(0xFF4F46E5), 'badge': 'PROMO'},
    {'id': 'transfer', 'label': 'Transfer', 'icon': Icons.swap_horiz_rounded, 'color': Color(0xFF059669), 'badge': 'GRATIS'},
    {'id': 'budget', 'label': 'Budgeting', 'icon': Icons.track_changes_rounded, 'color': Color(0xFFD97706), 'badge': null},
    {'id': 'laporan', 'label': 'Laporan', 'icon': Icons.analytics_rounded, 'color': Color(0xFF9333EA), 'badge': 'BARU'},
    {'id': 'kategori', 'label': 'Kategori', 'icon': Icons.grid_view_rounded, 'color': Color(0xFF0284C7), 'badge': null},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth >= 1024;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isDesktop)
                SizedBox(
                  width: 270,
                  child: _buildDesktopSidebar(isDark, colorScheme),
                ),
              Expanded(
                child: SafeArea(
                  child: RefreshIndicator(
                    onRefresh: () async {},
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                      child: Column(
                        children: [
                          // 1. TOP HEADER & HERO CARD (WITH PASTEL AMBIENT GLOW)
                          _buildTopAmbientHeader(isDark, colorScheme, isDesktop),

                          // 2. MAIN BODY CONTENT
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: isDesktop ? 36.0 : 16.0,
                              vertical: 20.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // QUICK ACTIONS GRID (LIVELY BADGES)
                                _buildLivelyQuickActions(colorScheme, isDark),
                                const SizedBox(height: 24),

                                // DOMPET SAYA (HORIZONTAL SCROLL WITH PROGRESS)
                                _buildSectionTitle('Dompet Saya', colorScheme),
                                const SizedBox(height: 12),
                                _buildDompetCards(colorScheme, isDark),
                                const SizedBox(height: 24),

                                // RESPONSIVE RECENT TRANSACTIONS & BUDGET
                                if (isDesktop)
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(child: _buildRecentTransactions(colorScheme, isDark)),
                                      const SizedBox(width: 20),
                                      Expanded(child: _buildBudgetCard(colorScheme, isDark)),
                                    ],
                                  )
                                else ...[
                                  _buildRecentTransactions(colorScheme, isDark),
                                  const SizedBox(height: 20),
                                  _buildBudgetCard(colorScheme, isDark),
                                ],

                                const SizedBox(height: 20),
                                _buildPromoBanner(isDark),
                                const SizedBox(height: 32),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // --- TOP AMBIENT HEADER (FINTECH GLOW LOOK) ---
  Widget _buildTopAmbientHeader(bool isDark, ColorScheme colorScheme, bool isDesktop) {
    final String rawSaldo = widget.summaryData?['saldo'] ?? 'Rp 12.500.000';

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? const [Color(0xFF1E1B4B), Color(0xFF0F172A), Color(0xFF070C18)]
              : const [Color(0xFFEEF2FF), Color(0xFFE0E7FF), Color(0xFFF4F6FB)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 36.0 : 16.0,
        vertical: 20.0,
      ),
      child: Column(
        children: [
          // BRAND HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFF6366F1), Color(0xFF4F46E5)]),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6366F1).withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: const Icon(Icons.account_balance_wallet_rounded, color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'MyKas Pro',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                          letterSpacing: -0.5,
                        ),
                      ),
                      const Text(
                        'FINANCIAL PARTNER',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF6366F1),
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))
                      ],
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.notifications_outlined, color: isDark ? Colors.white : const Color(0xFF0F172A), size: 20),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const CircleAvatar(
                    radius: 18,
                    backgroundColor: Color(0xFF6366F1),
                    child: Text('IF', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // HERO CARD (OVO/JAGO STYLE MESH DEPT)
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                colors: [Color(0xFF4338CA), Color(0xFF3730A3), Color(0xFF1E1B4B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4338CA).withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            padding: const EdgeInsets.all(22.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'TOTAL PORTOFOLIO ASET',
                      style: TextStyle(
                        color: Color(0xFFA5B4FC),
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                      ),
                    ),
                    InkWell(
                      onTap: () => setState(() => _isBalanceVisible = !_isBalanceVisible),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Icon(_isBalanceVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: Colors.white, size: 14),
                            const SizedBox(width: 4),
                            Text(_isBalanceVisible ? 'Sembunyikan' : 'Tampilkan', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  _isBalanceVisible ? rawSaldo : 'Rp ••••••••',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1.0,
                    fontFamily: 'monospace',
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFF10B981).withOpacity(0.4)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.trending_down_rounded, color: Color(0xFF34D399), size: 14),
                      SizedBox(width: 6),
                      Text('12% lebih hemat dibanding bulan lalu', style: TextStyle(color: Color(0xFF34D399), fontSize: 11, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- QUICK ACTIONS WITH ATTENTION-GRABBING BADGES ---
  Widget _buildLivelyQuickActions(ColorScheme colorScheme, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 14,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _quickActions.map((act) {
          final color = act['color'] as Color;
          final badge = act['badge'] as String?;

          return InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(act['icon'] as IconData, color: color, size: 22),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        act['label'] as String,
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: isDark ? Colors.white : const Color(0xFF0F172A)),
                      ),
                    ],
                  ),
                ),
                if (badge != null)
                  Positioned(
                    top: -4,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF4444),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        badge,
                        style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // --- DOMPET CARDS ---
  Widget _buildDompetCards(ColorScheme colorScheme, bool isDark) {
    final dompetList = [
      {'title': 'Tunai Utama', 'amount': 'Rp 1.250.000', 'sub': '1 kantong', 'icon': Icons.account_balance_wallet_rounded, 'color': const Color(0xFF10B981), 'progress': 0.4},
      {'title': 'Bank BCA', 'amount': 'Rp 7.850.000', 'sub': '4 rekening', 'icon': Icons.account_balance_rounded, 'color': const Color(0xFF6366F1), 'progress': 0.8},
      {'title': 'GoPay & OVO', 'amount': 'Rp 2.150.000', 'sub': '3 e-wallet', 'icon': Icons.qr_code_2_rounded, 'color': const Color(0xFFF59E0B), 'progress': 0.6},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: dompetList.map((item) {
          final color = item['color'] as Color;
          return Container(
            width: 155,
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
                  child: Icon(item['icon'] as IconData, color: color, size: 20),
                ),
                const SizedBox(height: 12),
                Text(item['title'] as String, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF0F172A))),
                const SizedBox(height: 4),
                Text(
                  _isBalanceVisible ? item['amount'] as String : 'Rp ••••••',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: isDark ? Colors.white : const Color(0xFF0F172A), fontFamily: 'monospace'),
                ),
                const SizedBox(height: 2),
                Text(item['sub'] as String, style: TextStyle(fontSize: 11, color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8))),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: item['progress'] as double,
                    minHeight: 4,
                    backgroundColor: color.withOpacity(0.15),
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // --- RECENT TRANSACTIONS ---
  Widget _buildRecentTransactions(ColorScheme colorScheme, bool isDark) {
    final List transaksi = widget.summaryData?['riwayat'] ?? [];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Transaksi Terbaru', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: isDark ? Colors.white : const Color(0xFF0F172A))),
              GestureDetector(
                onTap: widget.onNavigateToAnalisis,
                child: const Text('Lihat Semua', style: TextStyle(color: Color(0xFF6366F1), fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            children: transaksi.map((item) {
              final isExpense = (item['jenis'] ?? '').toString().toLowerCase().contains('pengeluaran');
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B).withOpacity(0.4) : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isExpense ? const Color(0xFFEF4444).withOpacity(0.12) : const Color(0xFF10B981).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        isExpense ? Icons.arrow_outward_rounded : Icons.south_west_rounded,
                        color: isExpense ? const Color(0xFFEF4444) : const Color(0xFF10B981),
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item['keterangan'] ?? '-', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: isDark ? Colors.white : const Color(0xFF0F172A))),
                          const SizedBox(height: 2),
                          Text('${item['kategori']} • ${item['dompet']}', style: TextStyle(fontSize: 11, color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8))),
                        ],
                      ),
                    ),
                    Text(
                      '${isExpense ? '-' : '+'} ${_isBalanceVisible ? 'Rp ${item['nominal']}' : 'Rp ••••••'}',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                        fontFamily: 'monospace',
                        color: isExpense ? const Color(0xFFEF4444) : const Color(0xFF10B981),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // --- BUDGET CARD ---
  Widget _buildBudgetCard(ColorScheme colorScheme, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Sisa Budget Bulan Ini', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: isDark ? Colors.white : const Color(0xFF0F172A))),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Rp 2.350.000', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: isDark ? Colors.white : const Color(0xFF0F172A), fontFamily: 'monospace')),
              const Text('47%', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF10B981))),
            ],
          ),
          const SizedBox(height: 4),
          Text('dari Rp 5.000.000', style: TextStyle(fontSize: 12, color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8))),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: 0.47,
              minHeight: 8,
              backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
            ),
          ),
        ],
      ),
    );
  }

  // --- PROMO / INSIGHT BANNER ---
  Widget _buildPromoBanner(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? const [Color(0xFF1E1B4B), Color(0xFF311B92)]
              : const [Color(0xFFEEF2FF), Color(0xFFE0E7FF)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF6366F1).withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(color: Color(0xFF6366F1), shape: BoxShape.circle),
            child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Insight Keuangan AI', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF6366F1))),
                const SizedBox(height: 2),
                Text('Pengeluaran kamu 15% lebih rendah dibanding minggu lalu.', style: TextStyle(fontSize: 11, height: 1.3, color: isDark ? Colors.white : const Color(0xFF0F172A))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- SECTION TITLE ---
  Widget _buildSectionTitle(String title, ColorScheme colorScheme) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, letterSpacing: -0.3),
    );
  }

  // --- DESKTOP SIDEBAR ---
  Widget _buildDesktopSidebar(bool isDark, ColorScheme colorScheme) {
    return Container(
      height: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        border: Border(right: BorderSide(color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0))),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.account_balance_wallet, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 12),
              Text('MyKas Pro', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: isDark ? Colors.white : const Color(0xFF0F172A))),
            ],
          ),
          const SizedBox(height: 40),
          _sidebarItem(0, Icons.grid_view_rounded, 'Beranda', isDark),
          _sidebarItem(1, Icons.insights_rounded, 'Analisis', isDark),
          _sidebarItem(2, Icons.account_balance_rounded, 'Dompet & Aset', isDark),
          _sidebarItem(3, Icons.person_outline_rounded, 'Profil & Pengaturan', isDark),
        ],
      ),
    );
  }

  Widget _sidebarItem(int index, IconData icon, String label, bool isDark) {
    final isSelected = _selectedDesktopNav == index;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: InkWell(
        onTap: () => setState(() => _selectedDesktopNav = index),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF6366F1).withOpacity(0.12) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(icon, size: 20, color: isSelected ? const Color(0xFF6366F1) : const Color(0xFF64748B)),
              const SizedBox(width: 14),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? const Color(0xFF6366F1) : const Color(0xFF64748B),
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
