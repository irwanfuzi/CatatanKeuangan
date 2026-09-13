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
      title: 'MyKas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0052FF),
          primary: const Color(0xFF0052FF),
          secondary: const Color(0xFFFF9F00),
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F6FB),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB),
          primary: const Color(0xFF3B82F6),
          secondary: const Color(0xFFFFB703),
          surface: const Color(0xFF0F172A),
        ),
        scaffoldBackgroundColor: const Color(0xFF070C18),
      ),
      themeMode: ThemeMode.system,
      home: const BerandaScreen(
        summaryData: {
          'saldo': 'Rp 2.345.833',
          'riwayat': [
            {'keterangan': 'nasi', 'kategori': 'Makanan', 'dompet': 'Kantong Tunai', 'nominal': '12.345', 'jenis': 'pemasukan'},
            {'keterangan': 'Air + UC1000', 'kategori': 'Makanan', 'dompet': 'Kantong Tunai', 'nominal': '11.000', 'jenis': 'pengeluaran'},
            {'keterangan': 'Kerupuk', 'kategori': 'Makanan', 'dompet': 'Kantong Tunai', 'nominal': '5.000', 'jenis': 'pengeluaran'},
            {'keterangan': 'Jajan lia tahu kress', 'kategori': 'Makanan', 'dompet': 'Kantong Tunai', 'nominal': '10.000', 'jenis': 'pengeluaran'},
            {'keterangan': 'Bekel aa', 'kategori': 'Lainnya', 'dompet': 'Kantong Tunai', 'nominal': '50.000', 'jenis': 'pengeluaran'},
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

  // Available Quick Action Options for Customization
  final List<Map<String, dynamic>> _allAvailableActions = [
    {'id': 'scan', 'label': 'Scan Struk', 'icon': Icons.qr_code_scanner_rounded, 'color': const Color(0xFF0052FF)},
    {'id': 'transfer', 'label': 'Transfer', 'icon': Icons.swap_horiz_rounded, 'color': const Color(0xFFFF9F00)},
    {'id': 'laporan', 'label': 'Laporan', 'icon': Icons.analytics_rounded, 'color': const Color(0xFF10B981)},
    {'id': 'kategori', 'label': 'Kategori', 'icon': Icons.grid_view_rounded, 'color': const Color(0xFF8B5CF6)},
    {'id': 'import', 'label': 'Import CSV', 'icon': Icons.file_upload_outlined, 'color': const Color(0xFF0284C7)},
    {'id': 'target', 'label': 'Impian', 'icon': Icons.savings_outlined, 'color': const Color(0xFFEC4899)},
    {'id': 'tagihan', 'label': 'Tagihan', 'icon': Icons.receipt_long_rounded, 'color': const Color(0xFFF59E0B)},
  ];

  late List<Map<String, dynamic>> _userQuickActions;

  @override
  void initState() {
    super.initState();
    // Default selected 4 actions
    _userQuickActions = List.from(_allAvailableActions.take(4));
  }

  void _openCustomActionModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final isDark = Theme.of(context).brightness == Brightness.dark;
            return Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Kustomisasi Quick Action',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Pilih fitur yang paling sering kamu gunakan:',
                    style: TextStyle(color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B), fontSize: 13),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: _allAvailableActions.map((action) {
                      final isSelected = _userQuickActions.any((element) => element['id'] == action['id']);
                      final color = action['color'] as Color;

                      return FilterChip(
                        selected: isSelected,
                        showCheckmark: false,
                        avatar: Icon(action['icon'] as IconData, color: isSelected ? Colors.white : color, size: 18),
                        label: Text(action['label'] as String),
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : (isDark ? Colors.white : const Color(0xFF0F172A)),
                          fontWeight: FontWeight.w700,
                        ),
                        selectedColor: const Color(0xFF0052FF),
                        backgroundColor: color.withOpacity(0.1),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        onSelected: (bool selected) {
                          setModalState(() {
                            if (selected) {
                              if (_userQuickActions.length < 5) {
                                _userQuickActions.add(action);
                              }
                            } else {
                              if (_userQuickActions.length > 1) {
                                _userQuickActions.removeWhere((item) => item['id'] == action['id']);
                              }
                            }
                          });
                          setState(() {});
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0052FF),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Simpan Pengaturan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

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
                      padding: EdgeInsets.symmetric(
                        horizontal: isDesktop ? 36.0 : 16.0,
                        vertical: 20.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 1. BRAND HEADER (LOGO MYKAS SANGAT PRESISI TANPA TEXT EXTRA)
                          _buildBrandHeader(colorScheme, isDark),
                          const SizedBox(height: 16),

                          // 2. HERO CARD TOTAL ASET
                          _buildHeroCard(isDark),
                          const SizedBox(height: 20),

                          // 3. DOMPET SAYA (PREMIUM SOFT GRADIENT TILES)
                          _buildSectionHeader('Dompet Saya', colorScheme),
                          const SizedBox(height: 12),
                          _buildDompetCardsGrid(colorScheme, isDark, isDesktop),
                          const SizedBox(height: 20),

                          // 4. QUICK ACTION (CONTAINER TUNGGAL TERPISAH DIVIDER TIPIS + EDIT BUTTON)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildSectionHeader('Quick Action', colorScheme),
                              IconButton(
                                onPressed: _openCustomActionModal,
                                icon: const Icon(Icons.tune_rounded, size: 20, color: Color(0xFF0052FF)),
                                tooltip: 'Kustomisasi Quick Action',
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          _buildUnifiedQuickActionBar(colorScheme, isDark),
                          const SizedBox(height: 24),

                          // 5. RESPONSIVE TRANSAKSI TERBARU & BUDGET/INSIGHT
                          if (isDesktop)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(child: _buildRecentTransactions(colorScheme, isDark)),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    children: [
                                      _buildBudgetCard(colorScheme, isDark),
                                      const SizedBox(height: 20),
                                      _buildInsightBanner(colorScheme, isDark),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          else ...[
                            _buildRecentTransactions(colorScheme, isDark),
                            const SizedBox(height: 20),
                            _buildBudgetCard(colorScheme, isDark),
                            const SizedBox(height: 16),
                            _buildInsightBanner(colorScheme, isDark),
                          ],

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

  // --- BRAND HEADER (MENGGUNAKAN IMAGE ASSET LOGO MYKAS DENGAN SANGAT PERSISI) ---
  Widget _buildBrandHeader(ColorScheme colorScheme, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            // Target Logo Asset dari GitHub repo user
            Image.asset(
              'assets/images/logo_mykas.png',
              height: 36,
              errorBuilder: (context, error, stackTrace) {
                // Dynamic fallback vector jika gambar aset belum tersinkron di runtime lokal
                return Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0052FF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.account_balance_wallet_rounded, color: Colors.amber, size: 22),
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
                letterSpacing: -0.6,
              ),
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
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(10),
              ),
            ),
            const SizedBox(width: 8),
            const CircleAvatar(
              radius: 18,
              backgroundColor: Color(0xFF0052FF),
              child: Text('IF', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
            ),
          ],
        ),
      ],
    );
  }

  // --- HERO CARD (TOTAL ASET + RINGKASAN RINGAN) ---
  Widget _buildHeroCard(bool isDark) {
    final String rawSaldo = widget.summaryData?['saldo'] ?? 'Rp 2.345.833';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          colors: isDark
              ? const [Color(0xFF0F172A), Color(0xFF1E3A8A)]
              : const [Color(0xFF0052FF), Color(0xFF0038B8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -15,
            bottom: -15,
            child: Icon(
              Icons.account_balance_wallet_rounded,
              size: 150,
              color: Colors.white.withOpacity(0.06),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(22.0),
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
                        const Text(
                          'TOTAL ASET',
                          style: TextStyle(
                            color: Colors.white70,
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
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _isBalanceVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                              color: Colors.white,
                              size: 13,
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
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1.0,
                    fontFamily: 'monospace',
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.trending_up_rounded, color: Color(0xFF34D399), size: 14),
                      SizedBox(width: 4),
                      Text('+12% vs bln lalu', style: TextStyle(color: Color(0xFF34D399), fontSize: 11, fontWeight: FontWeight.bold)),
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

  // --- DOMPET SAYA (MODERN SOFT GRADIENT & TACTILE ENCLOSURE) ---
  Widget _buildDompetCardsGrid(ColorScheme colorScheme, bool isDark, bool isDesktop) {
    final dompetList = [
      {'title': 'Tunai Utama', 'amount': 'Rp 1.250.000', 'sub': '1 dompet', 'icon': Icons.account_balance_wallet_rounded, 'startColor': const Color(0xFF10B981), 'endColor': const Color(0xFF059669), 'progress': 0.4},
      {'title': 'Rekening Bank', 'amount': 'Rp 7.850.000', 'sub': '4 rekening', 'icon': Icons.account_balance_rounded, 'startColor': const Color(0xFF0052FF), 'endColor': const Color(0xFF1D4ED8), 'progress': 0.8},
      {'title': 'E-Wallet', 'amount': 'Rp 2.150.000', 'sub': '3 e-wallet', 'icon': Icons.qr_code_2_rounded, 'startColor': const Color(0xFFFF9F00), 'endColor': const Color(0xFFD97706), 'progress': 0.6},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: dompetList.map((item) {
          final startColor = item['startColor'] as Color;
          final endColor = item['endColor'] as Color;

          return Container(
            width: 170,
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [startColor, endColor]),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(item['icon'] as IconData, color: Colors.white, size: 20),
                ),
                const SizedBox(height: 14),
                Text(
                  item['title'] as String,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF0F172A)),
                ),
                const SizedBox(height: 4),
                Text(
                  _isBalanceVisible ? item['amount'] as String : 'Rp ••••••',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                    fontFamily: 'monospace',
                  ),
                ),
                const SizedBox(height: 2),
                Text(item['sub'] as String, style: TextStyle(fontSize: 11, color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8))),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: item['progress'] as double,
                    minHeight: 4,
                    backgroundColor: startColor.withOpacity(0.15),
                    valueColor: AlwaysStoppedAnimation<Color>(startColor),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // --- UNIFIED QUICK ACTION BAR (SATU CONTAINER DIPISAH DIVIDER TIPIS) ---
  Widget _buildUnifiedQuickActionBar(ColorScheme colorScheme, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: _userQuickActions.asMap().entries.map((entry) {
            final index = entry.key;
            final act = entry.value;
            final color = act['color'] as Color;

            return Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.horizontal(
                        left: index == 0 ? const Radius.circular(20) : Radius.zero,
                        right: index == _userQuickActions.length - 1 ? const Radius.circular(20) : Radius.zero,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.12),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(act['icon'] as IconData, color: color, size: 20),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              act['label'] as String,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (index < _userQuickActions.length - 1)
                    VerticalDivider(
                      width: 1,
                      thickness: 1,
                      color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                    ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // --- TRANSAKSI TERBARU (MAKSIMAL 4-5 ITEM, TACTILE ICON CONTAINER) ---
  Widget _buildRecentTransactions(ColorScheme colorScheme, bool isDark) {
    final List rawTransaksi = widget.summaryData?['riwayat'] ?? [];
    final items = rawTransaksi.take(5).toList();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Transaksi Terbaru',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: isDark ? Colors.white : const Color(0xFF0F172A)),
              ),
              GestureDetector(
                onTap: widget.onNavigateToAnalisis,
                child: const Text('Lihat Semua', style: TextStyle(color: Color(0xFF0052FF), fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            children: items.map((item) {
              final isExpense = (item['jenis'] ?? '').toString().toLowerCase().contains('pengeluaran');

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B).withOpacity(0.3) : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: isDark ? const Color(0xFF334155).withOpacity(0.2) : const Color(0xFFF1F5F9)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isExpense
                              ? const [Color(0xFFFEE2E2), Color(0xFFFECACA)]
                              : const [Color(0xFFD1FAE5), Color(0xFFA7F3D0)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        isExpense ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                        color: isExpense ? const Color(0xFFDC2626) : const Color(0xFF059669),
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['keterangan'] ?? '-',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: isDark ? Colors.white : const Color(0xFF0F172A)),
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
                        color: isExpense ? const Color(0xFFDC2626) : const Color(0xFF059669),
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

  // --- SISA BUDGET (BENTO STYLE MODERN) ---
  Widget _buildBudgetCard(ColorScheme colorScheme, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Sisa Budget Bulan Ini', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: isDark ? Colors.white : const Color(0xFF0F172A))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: const Color(0xFF10B981).withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
                child: const Text('47% Tersisa', style: TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.bold, fontSize: 11)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                'Rp 2.350.000',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: isDark ? Colors.white : const Color(0xFF0F172A), fontFamily: 'monospace'),
              ),
              Text('dari Rp 5.000.000', style: TextStyle(fontSize: 11, color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8))),
            ],
          ),
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

  // --- INSIGHT AI BANNER ---
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
        border: Border.all(color: const Color(0xFF0052FF).withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(color: Color(0xFF0052FF), shape: BoxShape.circle),
            child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Insight Keuangan AI', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0052FF))),
                const SizedBox(height: 2),
                Text(
                  'Pengeluaran kamu 15% lebih hemat dari minggu kemarin.',
                  style: TextStyle(fontSize: 11, height: 1.3, color: isDark ? Colors.white : const Color(0xFF0F172A)),
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
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, letterSpacing: -0.3),
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
              Image.asset('assets/images/logo_mykas.png', height: 32),
              const SizedBox(width: 10),
              Text('MyKas', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: isDark ? Colors.white : const Color(0xFF0F172A))),
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
}
