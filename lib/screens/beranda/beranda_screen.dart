import 'dart:ui';
import 'package:flutter/material.dart';

class BerandaScreen extends StatefulWidget {
  final Map<String, dynamic> summaryData;
  final VoidCallback? onNavigateToAnalisis;

  const BerandaScreen({
    super.key,
    required this.summaryData,
    this.onNavigateToAnalisis,
  });

  @override
  State<BerandaScreen> createState() => _BerandaScreenState();
}

class _BerandaScreenState extends State<BerandaScreen> {
  bool _isBalanceVisible = true;
  int _selectedDesktopNav = 0;

  // --- DESIGN SYSTEM TOKENS ---
  static const Color _royalPrimary = Color(0xFF0052FF);
  static const Color _royalDark = Color(0xFF0A2540);
  static const Color _bgLight = Color(0xFFF7F9FC);
  static const Color _bgDark = Color(0xFF090D16);
  static const Color _textDark = Color(0xFF0F172A);

  final List<Map<String, dynamic>> _quickActions = [
    {'id': 'scan', 'label': 'Scan Struk', 'icon': Icons.crop_free_rounded, 'color': _royalPrimary},
    {'id': 'budget', 'label': 'Budget', 'icon': Icons.track_changes_rounded, 'color': _royalPrimary},
    {'id': 'laporan', 'label': 'Laporan', 'icon': Icons.description_outlined, 'color': _royalPrimary},
    {'id': 'kategori', 'label': 'Kategori', 'icon': Icons.local_offer_outlined, 'color': _royalPrimary},
    {'id': 'search', 'label': 'Cari Transaksi', 'icon': Icons.search_rounded, 'color': _royalPrimary},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth >= 1024;
          final isDark = Theme.of(context).brightness == Brightness.dark;

          final bg = isDark ? _bgDark : _bgLight;
          final surface = isDark ? const Color(0xFF131C2E) : Colors.white;
          final borderColor = isDark ? const Color(0xFF1E293B) : const Color(0xFFEDF2F7);
          final textPrimary = isDark ? Colors.white : _textDark;
          final textMuted = isDark ? const Color(0xFF64748B) : const Color(0xFF64748B);

          return Container(
            color: bg,
            child: Row(
              children: [
                if (isDesktop) _buildDesktopSidebar(isDark, borderColor, textPrimary),
                Expanded(
                  child: SafeArea(
                    child: RefreshIndicator(
                      onRefresh: () async {},
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.symmetric(
                          horizontal: isDesktop ? 36.0 : 16.0,
                          vertical: 20.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 1. TOP APP BAR / HEADER
                            _buildAppHeader(textPrimary, isDesktop),
                            const SizedBox(height: 20),

                            // 2. HERO TOTAL ASSET BANNER
                            _buildHeroCard(isDark),
                            const SizedBox(height: 24),

                            // 3. DOMPET SAYA (HORIZONTAL / GRID CARDS)
                            _buildSectionHeader('Dompet Saya', textPrimary),
                            const SizedBox(height: 12),
                            _buildDompetCardsGrid(surface, borderColor, textPrimary, textMuted, isDesktop),
                            const SizedBox(height: 24),

                            // 4. QUICK ACTION BAR
                            _buildSectionHeader('Quick Action', textPrimary),
                            const SizedBox(height: 12),
                            _buildQuickActionsBar(surface, borderColor, textPrimary),
                            const SizedBox(height: 24),

                            // 5. TRANSAKSI TERBARU & SISA BUDGET (BENTO GRID)
                            if (isDesktop)
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(child: _buildRecentTransactions(surface, borderColor, textPrimary, textMuted)),
                                  const SizedBox(width: 20),
                                  Expanded(child: _buildBudgetCard(surface, borderColor, textPrimary, textMuted, isDark)),
                                ],
                              )
                            else ...[
                              _buildRecentTransactions(surface, borderColor, textPrimary, textMuted),
                              const SizedBox(height: 20),
                              _buildBudgetCard(surface, borderColor, textPrimary, textMuted, isDark),
                            ],
                            const SizedBox(height: 20),

                            // 6. INSIGHT BANNER (WITH SPARKLINE CHART)
                            _buildInsightBanner(isDark),
                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // --- HEADER ---
  Widget _buildAppHeader(Color textPrimary, bool isDesktop) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _royalPrimary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.account_balance_wallet, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 10),
            Text(
              'MyKas',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: textPrimary,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_outlined, size: 24),
              style: IconButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(8),
              ),
            ),
            const SizedBox(width: 8),
            const CircleAvatar(
              radius: 18,
              backgroundColor: _royalPrimary,
              child: Icon(Icons.person, color: Colors.white, size: 20),
            ),
          ],
        ),
      ],
    );
  }

  // --- HERO CARD (GRADIENT & 3D ICON ACCENT) ---
  Widget _buildHeroCard(bool isDark) {
    final String rawSaldo = widget.summaryData['saldo'] ?? 'Rp12.500.000';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFF0052FF), Color(0xFF0038B8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0052FF).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Graphic Accent Background
          Positioned(
            right: -10,
            top: -10,
            bottom: -10,
            child: Opacity(
              opacity: 0.8,
              child: Icon(
                Icons.account_balance_wallet_rounded,
                size: 160,
                color: Colors.white.withOpacity(0.15),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(22.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Total Aset',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: () => setState(() => _isBalanceVisible = !_isBalanceVisible),
                      child: Icon(
                        _isBalanceVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                        color: Colors.white.withOpacity(0.9),
                        size: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _isBalanceVisible ? rawSaldo : 'Rp ••••••••',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCFCE7),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.arrow_upward_rounded, color: Color(0xFF166534), size: 12),
                          SizedBox(width: 4),
                          Text(
                            '12,5%',
                            style: TextStyle(
                              color: Color(0xFF166534),
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                            ),
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
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(Icons.access_time_rounded, color: Colors.white.withOpacity(0.7), size: 13),
                    const SizedBox(width: 6),
                    Text(
                      'Diperbarui 09.30 WIB',
                      style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 11),
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

  // --- DOMPET SAYA (GRID / SCROLLABLE CARDS) ---
  Widget _buildDompetCardsGrid(Color surface, Color borderColor, Color textPrimary, Color textMuted, bool isDesktop) {
    final dompetList = [
      {'title': 'Tunai', 'amount': 'Rp1.250.000', 'sub': '1 dompet', 'icon': Icons.crop_16_9_rounded, 'color': Colors.amber, 'progress': 0.4},
      {'title': 'Rekening Bank', 'amount': 'Rp7.850.000', 'sub': '4 rekening', 'icon': Icons.account_balance_outlined, 'color': const Color(0xFF0A2540), 'progress': 0.8},
      {'title': 'E-Wallet', 'amount': 'Rp2.150.000', 'sub': '3 e-wallet', 'icon': Icons.account_balance_wallet_outlined, 'color': Colors.blue, 'progress': 0.6},
      {'title': 'Tabungan', 'amount': 'Rp1.250.000', 'sub': '1 tabungan', 'icon': Icons.savings_outlined, 'color': Colors.purple, 'progress': 0.3},
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
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
                  color: surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: borderColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(item['icon'] as IconData, color: item['color'] as Color, size: 36),
                    const SizedBox(height: 12),
                    Text(item['title'] as String, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textPrimary)),
                    const SizedBox(height: 4),
                    Text(_isBalanceVisible ? item['amount'] as String : 'Rp ••••••', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: textPrimary)),
                    const SizedBox(height: 4),
                    Text(item['sub'] as String, style: TextStyle(fontSize: 11, color: textMuted)),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: item['progress'] as double,
                        minHeight: 5,
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
      },
    );
  }

  // --- QUICK ACTIONS BAR ---
  Widget _buildQuickActionsBar(Color surface, Color borderColor, Color textPrimary) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _quickActions.map((act) {
          return InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(act['icon'] as IconData, color: _royalPrimary, size: 26),
                const SizedBox(height: 8),
                Text(
                  act['label'] as String,
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: textPrimary),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // --- TRANSAKSI TERBARU ---
  Widget _buildRecentTransactions(Color surface, Color borderColor, Color textPrimary, Color textMuted) {
    final list = [
      {'title': 'Makan Siang', 'sub': 'Tunai • Hari ini', 'amount': '-Rp45.000', 'isExp': true, 'icon': Icons.restaurant_rounded, 'iconBg': Colors.orange.shade100, 'iconColor': Colors.orange},
      {'title': 'Gaji Bulan Juli', 'sub': 'BCA • Kemarin', 'amount': '+Rp8.500.000', 'isExp': false, 'icon': Icons.file_download_outlined, 'iconBg': Colors.green.shade100, 'iconColor': Colors.green},
      {'title': 'Belanja Bulanan', 'sub': 'ShopeePay • Kemarin', 'amount': '-Rp120.000', 'isExp': true, 'icon': Icons.shopping_cart_outlined, 'iconBg': Colors.purple.shade100, 'iconColor': Colors.purple},
      {'title': 'Top Up GoPay', 'sub': 'GoPay • 2 Juli 2025', 'amount': '-Rp50.000', 'isExp': true, 'icon': Icons.account_balance_wallet_outlined, 'iconBg': Colors.blue.shade100, 'iconColor': Colors.blue},
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Transaksi Terbaru', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: textPrimary)),
              GestureDetector(
                onTap: widget.onNavigateToAnalisis,
                child: Row(
                  children: const [
                    Text('Lihat Semua', style: TextStyle(color: _royalPrimary, fontWeight: FontWeight.bold, fontSize: 12)),
                    Icon(Icons.chevron_right_rounded, color: _royalPrimary, size: 16),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            children: list.map((item) {
              final isExp = item['isExp'] as bool;
              return Padding(
                padding: const EdgeInsets.only(bottom: 14.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: item['iconBg'] as Color,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(item['icon'] as IconData, color: item['iconColor'] as Color, size: 20),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item['title'] as String, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textPrimary)),
                          const SizedBox(height: 2),
                          Text(item['sub'] as String, style: TextStyle(fontSize: 11, color: textMuted)),
                        ],
                      ),
                    ),
                    Text(
                      item['amount'] as String,
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                        color: isExp ? Colors.red : Colors.green,
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

  // --- SISA BUDGET BULAN INI ---
  Widget _buildBudgetCard(Color surface, Color borderColor, Color textPrimary, Color textMuted, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Sisa Budget Bulan Ini', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: textPrimary)),
          const SizedBox(height: 16),
          Text('Sisa Budget', style: TextStyle(fontSize: 12, color: textMuted)),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Rp2.350.000', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: textPrimary)),
              const Text('47%', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.green)),
            ],
          ),
          const SizedBox(height: 4),
          Text('dari Rp5.000.000', style: TextStyle(fontSize: 12, color: textMuted)),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: const LinearProgressIndicator(
              value: 0.47,
              minHeight: 8,
              backgroundColor: Color(0xFFE2E8F0),
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.account_balance_wallet_outlined, color: Colors.green, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Masih ada 15 hari lagi', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                      SizedBox(height: 2),
                      Text('Ayo gunakan budget-mu dengan bijak 💪', style: TextStyle(fontSize: 11, color: Colors.black54)),
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

  // --- INSIGHT BANNER WITH SPARKLINE ---
  Widget _buildInsightBanner(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF162032) : const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFBFDBFE)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(color: _royalPrimary, shape: BoxShape.circle),
            child: const Icon(Icons.bar_chart_rounded, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Insight Keuangan', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _royalPrimary)),
                SizedBox(height: 2),
                Text('Pengeluaran kamu 15% lebih rendah dibanding minggu lalu.', style: TextStyle(fontSize: 11, height: 1.3)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right_rounded, color: _royalPrimary),
        ],
      ),
    );
  }

  // --- SECTION HEADER ---
  Widget _buildSectionHeader(String title, Color textPrimary) {
    return Text(
      title,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: textPrimary, letterSpacing: -0.3),
    );
  }

  // --- DESKTOP SIDEBAR ---
  Widget _buildDesktopSidebar(bool isDark, Color borderColor, Color textPrimary) {
    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        border: Border(right: BorderSide(color: borderColor)),
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
                ),
                child: const Icon(Icons.account_balance_wallet, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 12),
              Text('MyKas Pro', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: textPrimary)),
            ],
          ),
          const SizedBox(height: 40),
          _sidebarItem(0, Icons.grid_view_rounded, 'Beranda'),
          _sidebarItem(1, Icons.insights_rounded, 'Analisis'),
          _sidebarItem(2, Icons.account_balance_rounded, 'Dompet & Aset'),
          _sidebarItem(3, Icons.person_outline_rounded, 'Profil & Pengaturan'),
        ],
      ),
    );
  }

  Widget _sidebarItem(int index, IconData icon, String label) {
    final isSelected = _selectedDesktopNav == index;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: InkWell(
        onTap: () => setState(() => _selectedDesktopNav = index),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? _royalPrimary.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(icon, size: 20, color: isSelected ? _royalPrimary : const Color(0xFF64748B)),
              const SizedBox(width: 14),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? _royalPrimary : const Color(0xFF64748B),
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
