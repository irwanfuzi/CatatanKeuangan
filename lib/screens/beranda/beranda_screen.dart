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

  final List<Map<String, dynamic>> _quickActions = [
    {'id': 'scan', 'label': 'Scan Struk', 'icon': Icons.qr_code_scanner_rounded, 'accent': const Color(0xFF6366F1)},
    {'id': 'transfer', 'label': 'Transfer', 'icon': Icons.swap_horiz_rounded, 'accent': const Color(0xFFF59E0B)},
    {'id': 'laporan', 'label': 'Laporan', 'icon': Icons.analytics_rounded, 'accent': const Color(0xFF10B981)},
    {'id': 'kategori', 'label': 'Kategori', 'icon': Icons.grid_view_rounded, 'accent': const Color(0xFFA855F7)},
    {'id': 'import', 'label': 'Import CSV', 'icon': Icons.file_upload_outlined, 'accent': const Color(0xFF0EA5E9)},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth >= 1024;
          final isDark = Theme.of(context).brightness == Brightness.dark;

          final bgPrimary = isDark ? const Color(0xFF090D16) : const Color(0xFFF8FAFC);
          final surfaceColor = isDark ? const Color(0xFF131C2E) : Colors.white;
          final borderColor = isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9);
          final textPrimary = isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A);
          final textMuted = isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8);

          return Container(
            color: bgPrimary,
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
                          horizontal: isDesktop ? 40.0 : 20.0,
                          vertical: 24.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHeader(textPrimary, textMuted, isDesktop),
                            const SizedBox(height: 28),
                            if (isDesktop)
                              _buildDesktopLayout(surfaceColor, borderColor, textPrimary, textMuted, isDark)
                            else
                              _buildMobileLayout(surfaceColor, borderColor, textPrimary, textMuted, isDark),
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
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF6366F1), Color(0xFF4F46E5)]),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6366F1).withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: const Icon(Icons.account_balance_wallet_rounded, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Text('MyKas Pro', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: textPrimary, letterSpacing: -0.5)),
            ],
          ),
          const SizedBox(height: 40),
          _sidebarItem(0, Icons.dashboard_rounded, 'Beranda'),
          _sidebarItem(1, Icons.insights_rounded, 'Analisis'),
          _sidebarItem(2, Icons.account_balance_rounded, 'Dompet & Aset'),
          _sidebarItem(3, Icons.person_rounded, 'Profil & Pengaturan'),
        ],
      ),
    );
  }

  Widget _sidebarItem(int index, IconData icon, String label) {
    final isSelected = _selectedDesktopNav == index;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () => setState(() => _selectedDesktopNav = index),
          hoverColor: const Color(0xFF6366F1).withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
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
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- HEADER ---
  Widget _buildHeader(Color textPrimary, Color textMuted, bool isDesktop) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ringkasan Keuangan', style: TextStyle(fontSize: isDesktop ? 28 : 22, fontWeight: FontWeight.w900, color: textPrimary, letterSpacing: -0.8)),
            const SizedBox(height: 4),
            Text('Selamat datang kembali, Irwan Fuzi 👋', style: TextStyle(fontSize: 13, color: textMuted, fontWeight: FontWeight.w500)),
          ],
        ),
        Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_outlined),
              style: IconButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                padding: const EdgeInsets.all(12),
              ),
            ),
            const SizedBox(width: 8),
            const CircleAvatar(
              radius: 20,
              backgroundColor: Color(0xFF6366F1),
              child: Text('IF', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
            ),
          ],
        ),
      ],
    );
  }

  // --- DESKTOP LAYOUT ---
  Widget _buildDesktopLayout(Color surfaceColor, Color borderColor, Color textPrimary, Color textMuted, bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 6,
          child: Column(
            children: [
              _buildHeroBalanceCard(),
              const SizedBox(height: 24),
              _buildQuickActionsModern(surfaceColor, borderColor, textPrimary, isDesktop: true),
              const SizedBox(height: 24),
              _buildTransactionsCard(surfaceColor, borderColor, textPrimary, textMuted),
            ],
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          flex: 4,
          child: Column(
            children: [
              _buildWalletsCard(surfaceColor, borderColor, textPrimary, textMuted),
              const SizedBox(height: 24),
              _buildBentoFinancialGoals(surfaceColor, borderColor, textPrimary, textMuted, isDark),
              const SizedBox(height: 24),
              _buildAIInsightBanner(isDark),
            ],
          ),
        ),
      ],
    );
  }

  // --- MOBILE LAYOUT ---
  Widget _buildMobileLayout(Color surfaceColor, Color borderColor, Color textPrimary, Color textMuted, bool isDark) {
    return Column(
      children: [
        _buildHeroBalanceCard(),
        const SizedBox(height: 20),
        _buildQuickActionsModern(surfaceColor, borderColor, textPrimary, isDesktop: false),
        const SizedBox(height: 24),
        _buildWalletsCard(surfaceColor, borderColor, textPrimary, textMuted),
        const SizedBox(height: 24),
        _buildBentoFinancialGoals(surfaceColor, borderColor, textPrimary, textMuted, isDark),
        const SizedBox(height: 24),
        _buildAIInsightBanner(isDark),
        const SizedBox(height: 24),
        _buildTransactionsCard(surfaceColor, borderColor, textPrimary, textMuted),
      ],
    );
  }

  // --- HERO BALANCE CARD ---
  Widget _buildHeroBalanceCard() {
    final String rawSaldo = widget.summaryData['saldo'] ?? 'Rp 2.345.833';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [Color(0xFF1E1B4B), Color(0xFF0F172A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withOpacity(0.18),
            blurRadius: 32,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('PORTTOFOLIO ASET', style: TextStyle(color: Color(0xFF818CF8), fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1.5)),
              InkWell(
                onTap: () => setState(() => _isBalanceVisible = !_isBalanceVisible),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(_isBalanceVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: Colors.white70, size: 14),
                      const SizedBox(width: 6),
                      Text(_isBalanceVisible ? 'Sembunyikan' : 'Tampilkan', style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            _isBalanceVisible ? rawSaldo : 'Rp ••••••••',
            style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w900, letterSpacing: -1.0),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF10B981).withOpacity(0.3)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.trending_down_rounded, color: Color(0xFF34D399), size: 16),
                SizedBox(width: 8),
                Text('12% lebih hemat dibanding bulan lalu', style: TextStyle(color: Color(0xFF34D399), fontSize: 12, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- ADAPTIVE QUICK ACTIONS (Scrollable / Desktop Fit) ---
  Widget _buildQuickActionsModern(Color surfaceColor, Color borderColor, Color textPrimary, {required bool isDesktop}) {
    final list = _quickActions.map((act) {
      return Container(
        width: isDesktop ? null : 92,
        margin: EdgeInsets.only(right: isDesktop ? 0 : 8),
        child: Material(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(18),
          child: InkWell(
            onTap: () {},
            hoverColor: (act['accent'] as Color).withOpacity(0.05),
            borderRadius: BorderRadius.circular(18),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: (act['accent'] as Color).withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(act['icon'] as IconData, color: act['accent'] as Color, size: 20),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    act['label'] as String,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 11, color: textPrimary, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }).toList();

    if (isDesktop) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: list.map((w) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: w))).toList(),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(children: list),
    );
  }

  // --- WALLETS CARD ---
  Widget _buildWalletsCard(Color surfaceColor, Color borderColor, Color textPrimary, Color textMuted) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Dompet Saya', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: textPrimary)),
              TextButton(
                onPressed: () {},
                child: const Text('Kelola', style: TextStyle(color: Color(0xFF6366F1), fontWeight: FontWeight.w700, fontSize: 12)),
              )
            ],
          ),
          const SizedBox(height: 12),
          _walletRowItem('Tunai Utama', 'Rp 148.845', Icons.account_balance_wallet_rounded, const Color(0xFF10B981), textPrimary, textMuted),
          _walletRowItem('Rekening Bank', 'Rp 2.196.988', Icons.account_balance_rounded, const Color(0xFF6366F1), textPrimary, textMuted),
          _walletRowItem('E-Wallet', 'Rp 0', Icons.qr_code_2_rounded, const Color(0xFFF59E0B), textPrimary, textMuted),
        ],
      ),
    );
  }

  Widget _walletRowItem(String name, String balance, IconData icon, Color color, Color textPrimary, Color textMuted) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(name, style: TextStyle(color: textMuted, fontSize: 13, fontWeight: FontWeight.w500))),
          Text(_isBalanceVisible ? balance : 'Rp ••••••', style: TextStyle(color: textPrimary, fontWeight: FontWeight.w700, fontSize: 14)),
        ],
      ),
    );
  }

  // --- BENTO FINANCIAL GOALS ---
  Widget _buildBentoFinancialGoals(Color surfaceColor, Color borderColor, Color textPrimary, Color textMuted, bool isDark) {
    return Row(
      children: [
        Expanded(
          child: _bentoItem('Budget Bulan Ini', 'Rp 1.950.000', '35% Sisa', 0.65, const Color(0xFF10B981), surfaceColor, borderColor, textPrimary, textMuted, isDark),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _bentoItem('Dana Darurat', 'Rp 7.500.000', '75% Target', 0.75, const Color(0xFF6366F1), surfaceColor, borderColor, textPrimary, textMuted, isDark),
        ),
      ],
    );
  }

  Widget _bentoItem(String title, String value, String badge, double progress, Color accent, Color surfaceColor, Color borderColor, Color textPrimary, Color textMuted, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: textMuted, fontSize: 11, fontWeight: FontWeight.w600))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: accent.withOpacity(0.15), borderRadius: BorderRadius.circular(6)),
                child: Text(badge, style: TextStyle(color: accent, fontSize: 10, fontWeight: FontWeight.w800)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(value, style: TextStyle(color: textPrimary, fontWeight: FontWeight.w800, fontSize: 15)),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
              valueColor: AlwaysStoppedAnimation<Color>(accent),
            ),
          ),
        ],
      ),
    );
  }

  // --- INSIGHT BANNER ---
  Widget _buildAIInsightBanner(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF1E1B4B), const Color(0xFF311B92)]
              : [const Color(0xFFEEF2FF), const Color(0xFFE0E7FF)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF818CF8).withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: const Color(0xFF6366F1).withOpacity(0.2), shape: BoxShape.circle),
            child: const Icon(Icons.auto_awesome_rounded, color: Color(0xFF818CF8), size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              'Pengeluaran "Makanan" mendominasi 55% anggaranmu. Hemat Rp 200rb lagi untuk mencapai target tabungan!',
              style: TextStyle(fontSize: 12, color: isDark ? const Color(0xFFE0E7FF) : const Color(0xFF3730A3), height: 1.4, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  // --- TRANSACTIONS CARD ---
  Widget _buildTransactionsCard(Color surfaceColor, Color borderColor, Color textPrimary, Color textMuted) {
    final List transaksi = widget.summaryData['riwayat'] ?? [];
    final items = transaksi.take(4).toList();

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: borderColor),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Transaksi Terbaru', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: textPrimary)),
              TextButton(
                onPressed: widget.onNavigateToAnalisis,
                child: const Text('Lihat Semua', style: TextStyle(color: Color(0xFF6366F1), fontWeight: FontWeight.w700, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Text('Belum ada transaksi', style: TextStyle(color: textMuted, fontSize: 13)),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final item = items[index];
                final isExpense = (item['jenis'] ?? '').toString().toLowerCase().contains('pengeluaran');

                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isExpense ? const Color(0xFFEF4444).withOpacity(0.1) : const Color(0xFF10B981).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      isExpense ? Icons.arrow_outward_rounded : Icons.south_west_rounded,
                      color: isExpense ? const Color(0xFFEF4444) : const Color(0xFF10B981),
                      size: 18,
                    ),
                  ),
                  title: Text(item['keterangan'] ?? '-', style: TextStyle(color: textPrimary, fontWeight: FontWeight.w700, fontSize: 14)),
                  subtitle: Text('${item['kategori']} • ${item['dompet']}', style: TextStyle(color: textMuted, fontSize: 12)),
                  trailing: Text(
                    '${isExpense ? '-' : '+'} ${_isBalanceVisible ? 'Rp ${item['nominal']}' : 'Rp ••••••'}',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                      color: isExpense ? const Color(0xFFEF4444) : const Color(0xFF10B981),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
