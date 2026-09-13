import 'package:flutter/material.dart';

void main() {
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Scaffold(
      backgroundColor: const Color(0xFF070C18),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
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
    // Design System Tokens: Royal Blue & Honey Gold Palette
    return MaterialApp(
      title: 'MyKas Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E40AF), // Royal Blue Deep
          primary: const Color(0xFF1D4ED8), // Royal Blue Primary
          secondary: const Color(0xFFD97706), // Honey Gold Accent
          surface: Colors.white,
          surfaceContainerHighest: const Color(0xFFF1F5F9),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB),
          primary: const Color(0xFF3B82F6),
          secondary: const Color(0xFFF59E0B), // Honey Gold Light
          surface: const Color(0xFF0F172A),
          surfaceContainerHighest: const Color(0xFF1E293B),
          brightness: Brightness.dark,
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
            {'keterangan': 'Top Up E-Money', 'kategori': 'Transportasi', 'dompet': 'BCA', 'nominal': '100.000', 'jenis': 'pengeluaran'},
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

  // Royal Blue & Honey Gold System Colors
  static const Color _royalNavy = Color(0xFF0F172A);
  static const Color _royalPrimary = Color(0xFF1E40AF);
  static const Color _royalAccent = Color(0xFF2563EB);
  static const Color _honeyGold = Color(0xFFD97706);
  static const Color _honeyGoldLight = Color(0xFFF59E0B);
  static const Color _emeraldSuccess = Color(0xFF10B981);

  final List<Map<String, dynamic>> _quickActions = const [
    {'id': 'scan', 'label': 'Scan Struk', 'icon': Icons.qr_code_scanner_rounded, 'color': _royalAccent},
    {'id': 'transfer', 'label': 'Transfer', 'icon': Icons.swap_horiz_rounded, 'color': _honeyGold},
    {'id': 'laporan', 'label': 'Laporan', 'icon': Icons.analytics_rounded, 'color': _emeraldSuccess},
    {'id': 'kategori', 'label': 'Kategori', 'icon': Icons.grid_view_rounded, 'color': Color(0xFF8B5CF6)},
    {'id': 'import', 'label': 'Import CSV', 'icon': Icons.file_upload_outlined, 'color': Color(0xFF0284C7)},
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
              // 1. WEB DESKTOP PERSISTENT SIDEBAR
              if (isDesktop)
                SizedBox(
                  width: 270,
                  child: _buildDesktopSidebar(isDark, colorScheme),
                ),

              // 2. MAIN SCROLLABLE DASHBOARD
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
                          // BRAND HEADER (CUSTOM LOGO ICON + HONEY GOLD ACCENT)
                          _buildBrandHeader(colorScheme, isDark, isDesktop),
                          const SizedBox(height: 20),

                          // HERO BALANCE CARD (BALANCED ELEVATION)
                          _buildHeroCard(isDark, colorScheme),
                          const SizedBox(height: 20),

                          // QUICK ACTION BAR (DEDICATED MYKAS SPECIFICATION)
                          _buildSectionHeader('Aksi Cepat', colorScheme),
                          const SizedBox(height: 12),
                          _buildQuickActionsBar(colorScheme, isDark, isDesktop),
                          const SizedBox(height: 24),

                          // DOMPET SAYA (HORIZONTAL TONAL CARDS)
                          _buildSectionHeader('Dompet Saya', colorScheme),
                          const SizedBox(height: 12),
                          _buildDompetCardsGrid(colorScheme, isDark, isDesktop),
                          const SizedBox(height: 24),

                          // RESPONSIVE LAYOUT (TRANSAKSI TERBARU & SISA BUDGET)
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

  // --- BRAND HEADER (NO EXTERNAL ASSETS, HONEY GOLD ACCENT) ---
  Widget _buildBrandHeader(ColorScheme colorScheme, bool isDark, bool isDesktop) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            // Custom Generated Emblem Logo
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [_royalPrimary, _royalNavy],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _honeyGold.withOpacity(0.5), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: _royalPrimary.withOpacity(0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: const [
                  Icon(Icons.account_balance_wallet_rounded, color: Colors.white, size: 20),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: CircleAvatar(radius: 3, backgroundColor: _honeyGoldLight),
                  )
                ],
              ),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'MyKas',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: isDark ? Colors.white : _royalNavy,
                        letterSpacing: -0.8,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: _honeyGold.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: _honeyGold.withOpacity(0.4)),
                      ),
                      child: const Text(
                        'PRO',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          color: _honeyGold,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  'FINANCIAL MANAGEMENT',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: colorScheme.onSurfaceVariant,
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
                backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: BorderSide(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                ),
                padding: const EdgeInsets.all(10),
              ),
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: _honeyGold, width: 2),
              ),
              child: const CircleAvatar(
                radius: 17,
                backgroundColor: _royalPrimary,
                child: Text('IF', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // --- HERO BALANCE CARD (BALANCED ELEVATION) ---
  Widget _buildHeroCard(bool isDark, ColorScheme colorScheme) {
    final String rawSaldo = widget.summaryData?['saldo'] ?? 'Rp 12.500.000';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: isDark
              ? const [Color(0xFF0F172A), Color(0xFF1E3A8A), Color(0xFF172554)]
              : const [Color(0xFF0F172A), Color(0xFF1E40AF), Color(0xFF1D4ED8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: _honeyGold.withOpacity(0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: _royalPrimary.withOpacity(0.18),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            bottom: -20,
            child: Icon(
              Icons.account_balance_wallet_rounded,
              size: 160,
              color: Colors.white.withOpacity(0.05),
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
                            color: _emeraldSuccess,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'TOTAL PORTOFOLIO ASET',
                          style: TextStyle(
                            color: Color(0xFF93C5FD),
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.5,
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
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withOpacity(0.15)),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _isBalanceVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                              color: Colors.white,
                              size: 14,
                            ),
                            const SizedBox(width: 6),
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
                const SizedBox(height: 14),
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
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _emeraldSuccess.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: _emeraldSuccess.withOpacity(0.35)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.trending_down_rounded, color: Color(0xFF34D399), size: 14),
                      SizedBox(width: 6),
                      Text(
                        '12% lebih hemat dibanding bulan lalu',
                        style: TextStyle(color: Color(0xFF34D399), fontSize: 12, fontWeight: FontWeight.w700),
                      ),
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

  // --- DEDICATED MYKAS QUICK ACTIONS BAR ---
  Widget _buildQuickActionsBar(ColorScheme colorScheme, bool isDark, bool isDesktop) {
    final list = _quickActions.map((act) {
      final color = act['color'] as Color;
      return Expanded(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          child: Material(
            color: isDark ? const Color(0xFF0F172A) : Colors.white,
            borderRadius: BorderRadius.circular(18),
            child: InkWell(
              onTap: () {},
              hoverColor: color.withOpacity(0.06),
              borderRadius: BorderRadius.circular(18),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    )
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(act['icon'] as IconData, color: color, size: 20),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      act['label'] as String,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : _royalNavy,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }).toList();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: list,
    );
  }

  // --- DOMPET CARDS GRID ---
  Widget _buildDompetCardsGrid(ColorScheme colorScheme, bool isDark, bool isDesktop) {
    final dompetList = [
      {'title': 'Tunai Utama', 'amount': 'Rp 1.250.000', 'sub': '1 dompet', 'icon': Icons.account_balance_wallet_rounded, 'color': _emeraldSuccess, 'progress': 0.4},
      {'title': 'Rekening Bank', 'amount': 'Rp 7.850.000', 'sub': '4 rekening', 'icon': Icons.account_balance_rounded, 'color': _royalAccent, 'progress': 0.8},
      {'title': 'E-Wallet', 'amount': 'Rp 2.150.000', 'sub': '3 e-wallet', 'icon': Icons.qr_code_2_rounded, 'color': _honeyGold, 'progress': 0.6},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: dompetList.map((item) {
          final color = item['color'] as Color;
          return Container(
            width: 165,
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(item['icon'] as IconData, color: color, size: 20),
                ),
                const SizedBox(height: 12),
                Text(
                  item['title'] as String,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? Colors.white : _royalNavy),
                ),
                const SizedBox(height: 4),
                Text(
                  _isBalanceVisible ? item['amount'] as String : 'Rp ••••••',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : _royalNavy,
                    fontFamily: 'monospace',
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item['sub'] as String,
                  style: TextStyle(fontSize: 11, color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
                ),
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

  // --- TRANSAKSI TERBARU (STRICT 4-5 ITEMS LIMIT) ---
  Widget _buildRecentTransactions(ColorScheme colorScheme, bool isDark) {
    final List rawTransaksi = widget.summaryData?['riwayat'] ?? [];
    // Strictly limited to 5 latest transactions
    final items = rawTransaksi.take(5).toList();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Transaksi Terbaru',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: isDark ? Colors.white : _royalNavy),
              ),
              GestureDetector(
                onTap: widget.onNavigateToAnalisis,
                child: const Text(
                  'Lihat Semua',
                  style: TextStyle(color: _royalAccent, fontWeight: FontWeight.w700, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Text(
                'Belum ada transaksi',
                style: TextStyle(color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8), fontSize: 12),
              ),
            )
          else
            Column(
              children: items.map((item) {
                final isExpense = (item['jenis'] ?? '').toString().toLowerCase().contains('pengeluaran');
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B).withOpacity(0.4) : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: isDark ? const Color(0xFF334155).withOpacity(0.3) : const Color(0xFFF1F5F9)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isExpense ? const Color(0xFFEF4444).withOpacity(0.12) : _emeraldSuccess.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          isExpense ? Icons.arrow_outward_rounded : Icons.south_west_rounded,
                          color: isExpense ? const Color(0xFFEF4444) : _emeraldSuccess,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['keterangan'] ?? '-',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                                color: isDark ? Colors.white : _royalNavy,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${item['kategori']} • ${item['dompet']}',
                              style: TextStyle(fontSize: 11, color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${isExpense ? '-' : '+'} ${_isBalanceVisible ? 'Rp ${item['nominal']}' : 'Rp ••••••'}',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 13,
                          fontFamily: 'monospace',
                          color: isExpense ? const Color(0xFFEF4444) : _emeraldSuccess,
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
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sisa Budget Bulan Ini',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: isDark ? Colors.white : _royalNavy),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Rp 2.350.000',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: isDark ? Colors.white : _royalNavy,
                  fontFamily: 'monospace',
                ),
              ),
              const Text('47%', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: _emeraldSuccess)),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'dari Rp 5.000.000',
            style: TextStyle(fontSize: 12, color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: 0.47,
              minHeight: 8,
              backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
              valueColor: const AlwaysStoppedAnimation<Color>(_emeraldSuccess),
            ),
          ),
        ],
      ),
    );
  }

  // --- AI INSIGHT BANNER ---
  Widget _buildInsightBanner(ColorScheme colorScheme, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? const [Color(0xFF0F172A), Color(0xFF1E3A8A)]
              : const [Color(0xFFEFF6FF), Color(0xFFDBEAFE)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _royalAccent.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(color: _royalAccent, shape: BoxShape.circle),
            child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Insight Keuangan AI', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _royalAccent)),
                const SizedBox(height: 2),
                Text(
                  'Pengeluaran kamu 15% lebih rendah dibanding minggu lalu.',
                  style: TextStyle(fontSize: 11, height: 1.3, color: isDark ? Colors.white : _royalNavy),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- SECTION HEADER ---
  Widget _buildSectionHeader(String title, ColorScheme colorScheme) {
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
                  color: _royalPrimary,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _honeyGold, width: 1.5),
                ),
                child: const Icon(Icons.account_balance_wallet, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 12),
              Text(
                'MyKas Pro',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: isDark ? Colors.white : _royalNavy),
              ),
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
            color: isSelected ? _royalAccent.withOpacity(0.12) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(icon, size: 20, color: isSelected ? _royalAccent : const Color(0xFF64748B)),
              const SizedBox(width: 14),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? _royalAccent : const Color(0xFF64748B),
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
