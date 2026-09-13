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
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
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
            {'keterangan': 'Nasi Goreng Spesial', 'kategori': 'Makanan', 'dompet': 'Kantong Tunai', 'nominal': '12.345', 'jenis': 'pemasukan', 'icon': Icons.restaurant_rounded, 'color': Color(0xFF10B981)},
            {'keterangan': 'Air + UC1000', 'kategori': 'Makanan', 'dompet': 'Kantong Tunai', 'nominal': '11.000', 'jenis': 'pengeluaran', 'icon': Icons.local_drink_rounded, 'color': Color(0xFFEF4444)},
            {'keterangan': 'Kerupuk & Camilan', 'kategori': 'Makanan', 'dompet': 'Kantong Tunai', 'nominal': '5.000', 'jenis': 'pengeluaran', 'icon': Icons.fastfood_rounded, 'color': Color(0xFFFF9F00)},
            {'keterangan': 'Jajan Tahu Kress', 'kategori': 'Makanan', 'dompet': 'Kantong Tunai', 'nominal': '10.000', 'jenis': 'pengeluaran', 'icon': Icons.bakery_dining_rounded, 'color': Color(0xFF8B5CF6)},
            {'keterangan': 'Bensin Pertamax', 'kategori': 'Transport', 'dompet': 'Kantong Tunai', 'nominal': '50.000', 'jenis': 'pengeluaran', 'icon': Icons.directions_car_rounded, 'color': Color(0xFF0284C7)},
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

  final List<Map<String, dynamic>> _allAvailableActions = const [
    {'id': 'scan', 'label': 'Scan Struk', 'icon': Icons.qr_code_scanner_rounded, 'color': Color(0xFF0052FF)},
    {'id': 'transfer', 'label': 'Transfer', 'icon': Icons.swap_horizontal_circle_rounded, 'color': Color(0xFFFF9F00)},
    {'id': 'laporan', 'label': 'Laporan', 'icon': Icons.insert_chart_outlined_rounded, 'color': Color(0xFF10B981)},
    {'id': 'kategori', 'label': 'Kategori', 'icon': Icons.grid_view_rounded, 'color': Color(0xFF8B5CF6)},
    {'id': 'import', 'label': 'Import CSV', 'icon': Icons.cloud_upload_rounded, 'color': Color(0xFF0284C7)},
    {'id': 'target', 'label': 'Impian', 'icon': Icons.stars_rounded, 'color': Color(0xFFEC4899)},
    {'id': 'tagihan', 'label': 'Tagihan', 'icon': Icons.receipt_long_rounded, 'color': Color(0xFFF59E0B)},
  ];

  late List<Map<String, dynamic>> _userQuickActions;

  @override
  void initState() {
    super.initState();
    _userQuickActions = List.from(_allAvailableActions.take(4));
  }

  void _openCustomActionModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final isDark = Theme.of(context).brightness == Brightness.dark;
            final surfaceColor = isDark ? const Color(0xFF0F172A) : Colors.white;

            return Container(
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 36,
                      height: 4,
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Kustomisasi Quick Action',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Pilih menu akses cepat utama aplikasi',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close_rounded, size: 20),
                        style: IconButton.styleFrom(
                          backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _allAvailableActions.map((action) {
                      final isSelected = _userQuickActions.any((element) => element['id'] == action['id']);
                      final color = action['color'] as Color;

                      return InkWell(
                        onTap: () {
                          setModalState(() {
                            if (isSelected) {
                              if (_userQuickActions.length > 1) {
                                _userQuickActions.removeWhere((item) => item['id'] == action['id']);
                              }
                            } else {
                              if (_userQuickActions.length < 5) {
                                _userQuickActions.add(action);
                              }
                            }
                          });
                          setState(() {});
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF0052FF)
                                : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(action['icon'] as IconData, color: isSelected ? Colors.white : color, size: 16),
                              const SizedBox(width: 6),
                              Text(
                                action['label'] as String,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : (isDark ? Colors.white : const Color(0xFF0F172A)),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0052FF),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Simpan Pengaturan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
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
                  width: 250,
                  child: _buildDesktopSidebar(isDark, colorScheme),
                ),
              Expanded(
                child: SafeArea(
                  child: RefreshIndicator(
                    onRefresh: () async {},
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                      padding: EdgeInsets.symmetric(
                        horizontal: isDesktop ? 32.0 : 16.0,
                        vertical: 16.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildBrandHeader(colorScheme, isDark),
                          const SizedBox(height: 16),
                          _buildHeroCard(isDark),
                          const SizedBox(height: 20),
                          _buildSectionHeader('Dompet Saya', colorScheme),
                          const SizedBox(height: 10),
                          _buildDompetCardsGrid(colorScheme, isDark),
                          const SizedBox(height: 20),
                          _buildQuickActionHeader(colorScheme),
                          const SizedBox(height: 8),
                          _buildUnifiedQuickActionBar(colorScheme, isDark),
                          const SizedBox(height: 24),
                          if (isDesktop)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(flex: 3, child: _buildRecentTransactions(colorScheme, isDark)),
                                const SizedBox(width: 18),
                                Expanded(flex: 2, child: _buildBudgetInsightModule(colorScheme, isDark)),
                              ],
                            )
                          else ...[
                            _buildRecentTransactions(colorScheme, isDark),
                            const SizedBox(height: 20),
                            _buildBudgetInsightModule(colorScheme, isDark),
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

  // --- BRAND HEADER (ASSET IMAGE LOGO) ---
  Widget _buildBrandHeader(ColorScheme colorScheme, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Image.asset(
              'assets/images/logo_mykas.png',
              height: 30,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0052FF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.account_balance_wallet_rounded, color: Colors.amber, size: 16),
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
                letterSpacing: -0.8,
              ),
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.notifications_outlined, color: isDark ? Colors.white : const Color(0xFF0F172A), size: 20),
              style: IconButton.styleFrom(
                backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(8),
              ),
            ),
            const SizedBox(width: 6),
            const CircleAvatar(
              radius: 16,
              backgroundColor: Color(0xFF0052FF),
              child: Text('IF', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
            ),
          ],
        ),
      ],
    );
  }

  // --- HERO TOTAL ASET CARD ---
  Widget _buildHeroCard(bool isDark) {
    final String rawSaldo = widget.summaryData?['saldo'] ?? 'Rp 2.345.833';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : const Color(0xFF0052FF),
        borderRadius: BorderRadius.circular(20),
      ),
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
                    width: 6,
                    height: 6,
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
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () => setState(() => _isBalanceVisible = !_isBalanceVisible),
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _isBalanceVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                        color: Colors.white,
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _isBalanceVisible ? 'Sembunyikan' : 'Tampilkan',
                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600),
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
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withOpacity(0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.trending_up_rounded, color: Color(0xFF34D399), size: 12),
                SizedBox(width: 4),
                Text('+12% vs bln lalu', style: TextStyle(color: Color(0xFF34D399), fontSize: 10, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- DOMPET SAYA ---
  Widget _buildDompetCardsGrid(ColorScheme colorScheme, bool isDark) {
    final dompetList = [
      {'title': 'Tunai Utama', 'amount': 'Rp 1.250.000', 'sub': '1 dompet', 'icon': Icons.account_balance_wallet_rounded, 'color': const Color(0xFF10B981), 'progress': 0.4},
      {'title': 'Rekening Bank', 'amount': 'Rp 7.850.000', 'sub': '4 rekening', 'icon': Icons.account_balance_rounded, 'color': const Color(0xFF0052FF), 'progress': 0.8},
      {'title': 'E-Wallet', 'amount': 'Rp 2.150.000', 'sub': '3 e-wallet', 'icon': Icons.qr_code_2_rounded, 'color': const Color(0xFFFF9F00), 'progress': 0.6},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: dompetList.map((item) {
          final color = item['color'] as Color;

          return Container(
            width: 150,
            margin: const EdgeInsets.only(right: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(item['icon'] as IconData, color: color, size: 16),
                    ),
                    Icon(Icons.more_horiz, size: 14, color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  item['title'] as String,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF0F172A)),
                ),
                const SizedBox(height: 2),
                Text(
                  _isBalanceVisible ? item['amount'] as String : 'Rp ••••••',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                    fontFamily: 'monospace',
                  ),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: item['progress'] as double,
                    minHeight: 3,
                    backgroundColor: color.withOpacity(0.12),
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

  // --- QUICK ACTION HEADER ---
  Widget _buildQuickActionHeader(ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildSectionHeader('Quick Action', colorScheme),
        InkWell(
          onTap: _openCustomActionModal,
          borderRadius: BorderRadius.circular(6),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            child: Row(
              children: [
                Icon(Icons.edit_note_rounded, size: 16, color: Color(0xFF0052FF)),
                SizedBox(width: 2),
                Text(
                  'Edit',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0052FF)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // --- UNIFIED QUICK ACTION DOCK ---
  Widget _buildUnifiedQuickActionBar(ColorScheme colorScheme, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),
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
                        left: index == 0 ? const Radius.circular(16) : Radius.zero,
                        right: index == _userQuickActions.length - 1 ? const Radius.circular(16) : Radius.zero,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.08),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(act['icon'] as IconData, color: color, size: 16),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              act['label'] as String,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 10,
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

  // --- TRANSAKSI TERBARU ---
  Widget _buildRecentTransactions(ColorScheme colorScheme, bool isDark) {
    final List rawTransaksi = widget.summaryData?['riwayat'] ?? [];
    final items = rawTransaksi.take(5).toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Transaksi Terbaru',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: isDark ? Colors.white : const Color(0xFF0F172A)),
              ),
              GestureDetector(
                onTap: widget.onNavigateToAnalisis,
                child: const Text('Lihat Semua', style: TextStyle(color: Color(0xFF0052FF), fontWeight: FontWeight.bold, fontSize: 11)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Column(
            children: items.map((item) {
              final isExpense = (item['jenis'] ?? '').toString().toLowerCase().contains('pengeluaran');
              final iconData = item['icon'] as IconData? ?? Icons.receipt_long_rounded;
              final categoryColor = item['color'] as Color? ?? const Color(0xFF0052FF);

              return Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B).withOpacity(0.3) : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: categoryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        iconData,
                        color: categoryColor,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['keterangan'] ?? '-',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: isDark ? Colors.white : const Color(0xFF0F172A)),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                decoration: BoxDecoration(
                                  color: categoryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  item['kategori'] ?? '',
                                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: categoryColor),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                item['dompet'] ?? '',
                                style: TextStyle(fontSize: 10, color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${isExpense ? '-' : '+'} ${_isBalanceVisible ? 'Rp ${item['nominal']}' : 'Rp ••••••'}',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
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

  // --- BUDGET & INSIGHT MODULE ---
  Widget _buildBudgetInsightModule(ColorScheme colorScheme, bool isDark) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0F172A) : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Sisa Budget Bulan Ini', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: isDark ? Colors.white : const Color(0xFF0F172A))),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: const Color(0xFF10B981).withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                    child: const Text('47% Tersisa', style: TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.bold, fontSize: 10)),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    'Rp 2.350.000',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: isDark ? Colors.white : const Color(0xFF0F172A), fontFamily: 'monospace'),
                  ),
                  Text('dari Rp 5.000.000', style: TextStyle(fontSize: 10, color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8))),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: 0.47,
                  minHeight: 6,
                  backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1B4B) : const Color(0xFFFFFBEB),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFFF9F00).withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: const BoxDecoration(color: Color(0xFFFF9F00), shape: BoxShape.circle),
                child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 14),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Insight Keuangan AI', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFFD97706))),
                    const SizedBox(height: 1),
                    Text(
                      'Pengeluaran kamu 15% lebih hemat dari minggu kemarin.',
                      style: TextStyle(fontSize: 10, height: 1.2, color: isDark ? Colors.white : const Color(0xFF78350F)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- SECTION HEADER ---
  Widget _buildSectionHeader(String title, ColorScheme colorScheme) {
    return Text(
      title,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, letterSpacing: -0.3),
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
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset('assets/images/logo_mykas.png', height: 28),
              const SizedBox(width: 8),
              Text('MyKas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: isDark ? Colors.white : const Color(0xFF0F172A))),
            ],
          ),
          const SizedBox(height: 32),
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
      padding: const EdgeInsets.only(bottom: 6.0),
      child: InkWell(
        onTap: () => setState(() => _selectedDesktopNav = index),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF0052FF).withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(icon, size: 18, color: isSelected ? const Color(0xFF0052FF) : const Color(0xFF64748B)),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? const Color(0xFF0052FF) : const Color(0xFF64748B),
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
