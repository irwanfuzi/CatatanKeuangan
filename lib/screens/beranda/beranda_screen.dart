import 'package:flutter/material.dart';

void main() {
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Scaffold(
      backgroundColor: const Color(0xFF040711),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF090D16),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFEF4444)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.warning_amber_rounded, color: Color(0xFFEF4444), size: 48),
              const SizedBox(height: 16),
              const Text(
                'Terjadi Kesalahan Visual',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                details.exceptionAsString(),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
              ),
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
          seedColor: const Color(0xFF0052FF),
          brightness: Brightness.light,
          surface: const Color(0xFFF8FAFC),
          surfaceContainerHighest: const Color(0xFFEDF2F7),
        ),
        scaffoldBackgroundColor: const Color(0xFFF1F5F9),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3B82F6),
          brightness: Brightness.dark,
          surface: const Color(0xFF090D16),
          surfaceContainerHighest: const Color(0xFF131C2E),
        ),
        scaffoldBackgroundColor: const Color(0xFF040711),
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
    {'id': 'scan', 'label': 'Scan Struk', 'icon': Icons.crop_free_rounded, 'color': Color(0xFF0052FF)},
    {'id': 'budget', 'label': 'Budget', 'icon': Icons.track_changes_rounded, 'color': Color(0xFF0052FF)},
    {'id': 'laporan', 'label': 'Laporan', 'icon': Icons.description_outlined, 'color': Color(0xFF0052FF)},
    {'id': 'kategori', 'label': 'Kategori', 'icon': Icons.local_offer_outlined, 'color': Color(0xFF0052FF)},
    {'id': 'search', 'label': 'Cari', 'icon': Icons.search_rounded, 'color': Color(0xFF0052FF)},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth >= 1024;
          final isDark = theme.brightness == Brightness.dark;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. DESKTOP PERSISTENT NAVIGATION SIDEBAR
              if (isDesktop)
                SizedBox(
                  width: 260,
                  child: _buildDesktopSidebar(isDark, colorScheme),
                ),

              // 2. MAIN DASHBOARD CONTENT
              Expanded(
                child: SafeArea(
                  child: RefreshIndicator(
                    onRefresh: () async {},
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                      padding: EdgeInsets.symmetric(
                        horizontal: isDesktop ? 36.0 : 16.0,
                        vertical: 20.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // HEADER STANDALONE WITH LOGO
                          _buildBrandHeader(colorScheme, isDesktop),
                          const SizedBox(height: 20),

                          // HERO BALANCE CARD STANDALONE
                          _buildHeroCard(isDark, colorScheme),
                          const SizedBox(height: 24),

                          // DOMPET CARDS
                          _buildSectionHeader('Dompet Saya', colorScheme),
                          const SizedBox(height: 12),
                          _buildDompetCardsGrid(colorScheme, isDesktop),
                          const SizedBox(height: 24),

                          // QUICK ACTION BAR
                          _buildSectionHeader('Quick Action', colorScheme),
                          const SizedBox(height: 12),
                          _buildQuickActionsBar(colorScheme),
                          const SizedBox(height: 24),

                          // RESPONSIVE GRID LAYOUT
                          if (isDesktop)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(child: _buildRecentTransactions(colorScheme)),
                                const SizedBox(width: 20),
                                Expanded(child: _buildBudgetCard(colorScheme, isDark)),
                              ],
                            )
                          else ...[
                            _buildRecentTransactions(colorScheme),
                            const SizedBox(height: 20),
                            _buildBudgetCard(colorScheme, isDark),
                          ],

                          const SizedBox(height: 20),
                          _buildInsightBanner(colorScheme, isDark),
                          const SizedBox(height: 32),
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

  // --- BRAND HEADER WITH LOGO ---
  Widget _buildBrandHeader(ColorScheme colorScheme, bool isDesktop) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withOpacity(0.3),
                    blurRadius: 10,
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
                    color: colorScheme.onSurface,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  'FINANCIAL DASHBOARD',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: colorScheme.primary,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.notifications_outlined, color: colorScheme.onSurface, size: 22),
              style: IconButton.styleFrom(
                backgroundColor: colorScheme.surfaceContainerHighest.withOpacity(0.5),
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(10),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 18,
              backgroundColor: colorScheme.primary,
              child: const Text('IF', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
            ),
          ],
        ),
      ],
    );
  }

  // --- STANDALONE HERO BALANCE CARD ---
  Widget _buildHeroCard(bool isDark, ColorScheme colorScheme) {
    final String rawSaldo = widget.summaryData?['saldo'] ?? 'Rp 12.500.000';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: isDark
              ? const [Color(0xFF0B192C), Color(0xFF1E3E62)]
              : const [Color(0xFF0052FF), Color(0xFF0038B8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.25),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -10,
            bottom: -10,
            child: Icon(
              Icons.account_balance_wallet_rounded,
              size: 160,
              color: Colors.white.withOpacity(0.08),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFF10B981),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'TOTAL PORTOFOLIO ASET',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () => setState(() => _isBalanceVisible = !_isBalanceVisible),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withOpacity(0.2)),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _isBalanceVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                              color: Colors.white,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _isBalanceVisible ? 'Sembunyikan' : 'Tampilkan',
                              style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                            ),
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
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCFCE7),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.arrow_upward_rounded, color: Color(0xFF166534), size: 12),
                          SizedBox(width: 4),
                          Text(
                            '12,5%',
                            style: TextStyle(color: Color(0xFF166534), fontSize: 12, fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'dari bulan lalu',
                      style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- DOMPET CARDS GRID ---
  Widget _buildDompetCardsGrid(ColorScheme colorScheme, bool isDesktop) {
    final dompetList = [
      {'title': 'Tunai', 'amount': 'Rp 1.250.000', 'sub': '1 dompet', 'icon': Icons.crop_16_9_rounded, 'color': Colors.amber, 'progress': 0.4},
      {'title': 'Rekening Bank', 'amount': 'Rp 7.850.000', 'sub': '4 rekening', 'icon': Icons.account_balance_outlined, 'color': colorScheme.primary, 'progress': 0.8},
      {'title': 'E-Wallet', 'amount': 'Rp 2.150.000', 'sub': '3 e-wallet', 'icon': Icons.account_balance_wallet_outlined, 'color': Colors.blue, 'progress': 0.6},
      {'title': 'Tabungan', 'amount': 'Rp 1.250.000', 'sub': '1 tabungan', 'icon': Icons.savings_outlined, 'color': Colors.purple, 'progress': 0.3},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: dompetList.map((item) {
          return Container(
            width: 145,
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(item['icon'] as IconData, color: item['color'] as Color, size: 28),
                const SizedBox(height: 12),
                Text(item['title'] as String, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
                const SizedBox(height: 4),
                Text(
                  _isBalanceVisible ? item['amount'] as String : 'Rp ••••••',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: colorScheme.onSurface, fontFamily: 'monospace'),
                ),
                const SizedBox(height: 2),
                Text(item['sub'] as String, style: TextStyle(fontSize: 11, color: colorScheme.onSurfaceVariant)),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: item['progress'] as double,
                    minHeight: 4,
                    backgroundColor: (item['color'] as Color).withOpacity(0.15),
                    valueColor: AlwaysStoppedAnimation<Color>(item['color'] as Color),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // --- QUICK ACTIONS BAR ---
  Widget _buildQuickActionsBar(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _quickActions.map((act) {
          return InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(act['icon'] as IconData, color: colorScheme.primary, size: 24),
                  const SizedBox(height: 6),
                  Text(
                    act['label'] as String,
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: colorScheme.onSurface),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // --- TRANSAKSI TERBARU ---
  Widget _buildRecentTransactions(ColorScheme colorScheme) {
    final List transaksi = widget.summaryData?['riwayat'] ?? [];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.4)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Transaksi Terbaru', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: colorScheme.onSurface)),
              GestureDetector(
                onTap: widget.onNavigateToAnalisis,
                child: Row(
                  children: [
                    Text('Lihat Semua', style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 12)),
                    Icon(Icons.chevron_right_rounded, color: colorScheme.primary, size: 16),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (transaksi.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text('Belum ada transaksi', style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 12)),
            )
          else
            Column(
              children: transaksi.map((item) {
                final isExpense = (item['jenis'] ?? '').toString().toLowerCase().contains('pengeluaran');
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isExpense ? Colors.red.withOpacity(0.12) : Colors.green.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          isExpense ? Icons.arrow_outward_rounded : Icons.south_west_rounded,
                          color: isExpense ? Colors.red : Colors.green,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item['keterangan'] ?? '-', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: colorScheme.onSurface)),
                            const SizedBox(height: 2),
                            Text('${item['kategori']} • ${item['dompet']}', style: TextStyle(fontSize: 11, color: colorScheme.onSurfaceVariant)),
                          ],
                        ),
                      ),
                      Text(
                        '${isExpense ? '-' : '+'} ${_isBalanceVisible ? 'Rp ${item['nominal']}' : 'Rp ••••••'}',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 13,
                          fontFamily: 'monospace',
                          color: isExpense ? Colors.red : Colors.green,
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

  // --- SISA BUDGET CARD ---
  Widget _buildBudgetCard(ColorScheme colorScheme, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Sisa Budget Bulan Ini', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: colorScheme.onSurface)),
          const SizedBox(height: 16),
          Text('Sisa Budget', style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant)),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Rp 2.350.000', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: colorScheme.onSurface, fontFamily: 'monospace')),
              const Text('47%', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.green)),
            ],
          ),
          const SizedBox(height: 4),
          Text('dari Rp 5.000.000', style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant)),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: 0.47,
              minHeight: 8,
              backgroundColor: colorScheme.surfaceContainerHighest,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.account_balance_wallet_outlined, color: Colors.green, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Masih ada 15 hari lagi', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
                      const SizedBox(height: 2),
                      Text('Ayo gunakan budget-mu dengan bijak 💪', style: TextStyle(fontSize: 11, color: colorScheme.onSurfaceVariant)),
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

  // --- INSIGHT BANNER ---
  Widget _buildInsightBanner(ColorScheme colorScheme, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF131C2E) : const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.primary.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: colorScheme.primary, shape: BoxShape.circle),
            child: const Icon(Icons.bar_chart_rounded, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Insight Keuangan', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: colorScheme.primary)),
                const SizedBox(height: 2),
                Text('Pengeluaran kamu 15% lebih rendah dibanding minggu lalu.', style: TextStyle(fontSize: 11, height: 1.3, color: colorScheme.onSurface)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(Icons.chevron_right_rounded, color: colorScheme.primary),
        ],
      ),
    );
  }

  // --- SECTION HEADER ---
  Widget _buildSectionHeader(String title, ColorScheme colorScheme) {
    return Text(
      title,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: colorScheme.onSurface, letterSpacing: -0.3),
    );
  }

  // --- DESKTOP SIDEBAR ---
  Widget _buildDesktopSidebar(bool isDark, ColorScheme colorScheme) {
    return Container(
      height: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(right: BorderSide(color: colorScheme.outlineVariant.withOpacity(0.4))),
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
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.account_balance_wallet, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 12),
              Text('MyKas Pro', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: colorScheme.onSurface)),
            ],
          ),
          const SizedBox(height: 40),
          _sidebarItem(0, Icons.grid_view_rounded, 'Beranda', colorScheme),
          _sidebarItem(1, Icons.insights_rounded, 'Analisis', colorScheme),
          _sidebarItem(2, Icons.account_balance_rounded, 'Dompet & Aset', colorScheme),
          _sidebarItem(3, Icons.person_outline_rounded, 'Profil & Pengaturan', colorScheme),
        ],
      ),
    );
  }

  Widget _sidebarItem(int index, IconData icon, String label, ColorScheme colorScheme) {
    final isSelected = _selectedDesktopNav == index;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: InkWell(
        onTap: () => setState(() => _selectedDesktopNav = index),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? colorScheme.primary.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(icon, size: 20, color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant),
              const SizedBox(width: 14),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
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
