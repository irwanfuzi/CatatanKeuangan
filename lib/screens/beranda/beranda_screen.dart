import 'package:flutter/material.dart';

class BerandaScreen extends StatelessWidget {
  final Map<String, dynamic>? summaryData;
  final VoidCallback? onNavigateToAnalisis;

  const BerandaScreen({
    super.key,
    this.summaryData,
    this.onNavigateToAnalisis,
  });

  // Modern Fintech Design System Palette
  static const Color primaryRoyalBlue = Color(0xFF0052FF);
  static const Color accentHoneyGold = Color(0xFFFF9F00);
  static const Color emeraldGreen = Color(0xFF10B981);
  static const Color crimsonRed = Color(0xFFEF4444);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final backgroundColor = isDark ? const Color(0xFF0B0F19) : const Color(0xFFF8FAFC);
    final surfaceColor = isDark ? const Color(0xFF111827) : Colors.white;
    final borderColor = isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0);
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final subTextColor = isDark ? const Color(0xFF9CA3AF) : const Color(0xFF64748B);

    final saldo = summaryData?['saldo'] ?? 'Rp 2.345.833';
    final pemasukan = summaryData?['pemasukan'] ?? 'Rp 3.012.345';
    final pengeluaran = summaryData?['pengeluaran'] ?? 'Rp 666.512';
    final List riwayat = summaryData?['riwayat'] as List? ?? [];

    // Ambil maksimal 5 transaksi terbaru agar layar tidak melar kebawah
    final recentTransactions = riwayat.take(5).toList();

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 1024;

            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: isDesktop ? 1080 : 540),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? 32.0 : 18.0,
                    vertical: 20.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. TOP BAR PROFILE & NOTIFICATION
                      _buildTopBar(textColor, subTextColor, surfaceColor, borderColor, isDark),
                      const SizedBox(height: 20),

                      // 2. HERO TOTAL BALANCE CARD (GLASSMORPHIC BLUE GRADIENT)
                      _buildHeroBalanceCard(saldo, pemasukan, pengeluaran, isDark),
                      const SizedBox(height: 20),

                      // 3. QUICK ACTIONS STRIP
                      _buildQuickActions(surfaceColor, borderColor, textColor, subTextColor),
                      const SizedBox(height: 20),

                      // 4. ANALYTICS PREVIEW BANNER
                      _buildAnalyticsBanner(surfaceColor, borderColor, textColor, subTextColor),
                      const SizedBox(height: 24),

                      // 5. TRANSAKSI TERBARU (BATASI 5 ITEMS TERATAS)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Transaksi Terbaru',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: textColor,
                              letterSpacing: -0.4,
                            ),
                          ),
                          InkWell(
                            onTap: () {},
                            borderRadius: BorderRadius.circular(8),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                              child: Text(
                                'Lihat Semua',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: primaryRoyalBlue,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      if (recentTransactions.isEmpty)
                        _buildEmptyState(surfaceColor, borderColor, subTextColor)
                      else
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: recentTransactions.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final item = recentTransactions[index];
                            final isPemasukan = item['jenis'].toString().toLowerCase().contains('pemasukan');

                            return _buildTransactionItem(
                              item: item,
                              isPemasukan: isPemasukan,
                              surfaceColor: surfaceColor,
                              borderColor: borderColor,
                              textColor: textColor,
                              subTextColor: subTextColor,
                            );
                          },
                        ),

                      const SizedBox(height: 36),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // --- 1. TOP BAR ---
  Widget _buildTopBar(Color textColor, Color subTextColor, Color surfaceColor, Color borderColor, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: primaryRoyalBlue.withOpacity(0.5), width: 1.5),
              ),
              child: const CircleAvatar(
                radius: 18,
                backgroundColor: primaryRoyalBlue,
                child: Text('MK', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Selamat Datang,', style: TextStyle(fontSize: 11, color: subTextColor, fontWeight: FontWeight.w600)),
                Text('Pengguna MyKas', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: textColor)),
              ],
            ),
          ],
        ),
        Row(
          children: [
            _iconButton(Icons.search_rounded, surfaceColor, borderColor),
            const SizedBox(width: 8),
            _iconButton(Icons.notifications_none_rounded, surfaceColor, borderColor),
          ],
        ),
      ],
    );
  }

  Widget _iconButton(IconData icon, Color surfaceColor, Color borderColor) {
    return Container(
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: surfaceColor,
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Icon(icon, size: 18, color: primaryRoyalBlue),
    );
  }

  // --- 2. HERO BALANCE CARD ---
  Widget _buildHeroBalanceCard(String saldo, String pemasukan, String pengeluaran, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0052FF), Color(0xFF1E40AF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: primaryRoyalBlue.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
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
                    decoration: const BoxDecoration(color: emeraldGreen, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'TOTAL SALDO UTAMA',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white70, letterSpacing: 1.0),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.visibility_outlined, color: Colors.white, size: 12),
                    SizedBox(width: 4),
                    Text('Sembunyikan', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            saldo,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              fontFamily: 'monospace',
              letterSpacing: -1.0,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(color: emeraldGreen.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                        child: const Icon(Icons.arrow_downward_rounded, color: emeraldGreen, size: 12),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Masuk', style: TextStyle(fontSize: 9, color: Colors.white70, fontWeight: FontWeight.bold)),
                          Text(pemasukan, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.white, fontFamily: 'monospace')),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(width: 1, height: 24, color: Colors.white24),
                const SizedBox(width: 12),
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(color: crimsonRed.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                        child: const Icon(Icons.arrow_upward_rounded, color: crimsonRed, size: 12),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Keluar', style: TextStyle(fontSize: 9, color: Colors.white70, fontWeight: FontWeight.bold)),
                          Text(pengeluaran, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.white, fontFamily: 'monospace')),
                        ],
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

  // --- 3. QUICK ACTIONS ---
  Widget _buildQuickActions(Color surfaceColor, Color borderColor, Color textColor, Color subTextColor) {
    final actions = [
      {'label': 'Catat', 'icon': Icons.add_circle_outline_rounded, 'color': primaryRoyalBlue},
      {'label': 'Transfer', 'icon': Icons.swap_horiz_rounded, 'color': accentHoneyGold},
      {'label': 'Laporan', 'icon': Icons.insert_chart_outlined_rounded, 'color': emeraldGreen},
      {'label': 'Kategori', 'icon': Icons.grid_view_rounded, 'color': const Color(0xFF8B5CF6)},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.between,
      children: actions.map((act) {
        final color = act['color'] as Color;
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor, width: 1),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: color.withOpacity(0.12), shape: BoxShape.circle),
                  child: Icon(act['icon'] as IconData, color: color, size: 18),
                ),
                const SizedBox(height: 6),
                Text(
                  act['label'] as String,
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textColor),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // --- 4. ANALYTICS BANNER ---
  Widget _buildAnalyticsBanner(Color surfaceColor, Color borderColor, Color textColor, Color subTextColor) {
    return InkWell(
      onTap: onNavigateToAnalisis,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: borderColor, width: 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: primaryRoyalBlue.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.analytics_rounded, color: primaryRoyalBlue, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Analisis Keuangan', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: textColor)),
                  const SizedBox(height: 2),
                  Text('Evaluasi arus kas & alokasi pengeluaran', style: TextStyle(fontSize: 11, color: subTextColor)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: primaryRoyalBlue),
          ],
        ),
      ),
    );
  }

  // --- 5. TRANSACTION ITEM WIDGET ---
  Widget _buildTransactionItem({
    required Map<String, dynamic> item,
    required bool isPemasukan,
    required Color surfaceColor,
    required Color borderColor,
    required Color textColor,
    required Color subTextColor,
  }) {
    final title = item['judul'] ?? item['kategori'] ?? 'Transaksi';
    final date = item['tanggal'] ?? 'Hari ini';
    final amount = item['nominal']?.toString() ?? 'Rp 0';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: (isPemasukan ? emeraldGreen : crimsonRed).withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isPemasukan ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
              color: isPemasukan ? emeraldGreen : crimsonRed,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: textColor),
                ),
                const SizedBox(height: 2),
                Text(
                  date,
                  style: TextStyle(fontSize: 10, color: subTextColor, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          Text(
            isPemasukan ? '+$amount' : '-$amount',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w900,
              color: isPemasukan ? emeraldGreen : crimsonRed,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(Color surfaceColor, Color borderColor, Color subTextColor) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Center(
        child: Text('Belum ada transaksi tercatat', style: TextStyle(color: subTextColor, fontSize: 12)),
      ),
    );
  }
}
