import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class BerandaScreen extends StatelessWidget {
  final Map<String, dynamic> summaryData;

  const BerandaScreen({super.key, required this.summaryData});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final List riwayat = summaryData['riwayat'] ?? [];
    final List empatTransaksiTerbaru = riwayat.take(4).toList();

    final Color textPrimary = isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight;
    final Color textSecondary = isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight;
    final Color cardBg = isDark ? AppTheme.cardDark : AppTheme.cardLight;
    final Color borderTheme = isDark ? AppTheme.borderDark : AppTheme.borderLight;

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {},
          color: AppTheme.brandPrimary,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTopHeader(textPrimary, textSecondary, cardBg, borderTheme),
                const SizedBox(height: 20),
                _buildRoyalHeroCard(),
                const SizedBox(height: 24),
                _buildSectionHeader('Dompet & Rekening', textPrimary, onSeeAll: () {}),
                const SizedBox(height: 12),
                _buildDompetHorizontalList(textPrimary, textSecondary, cardBg, borderTheme),
                const SizedBox(height: 24),
                _buildSectionHeader('Akses Cepat', textPrimary),
                const SizedBox(height: 12),
                _buildQuickActionGrid(context, textSecondary, cardBg, borderTheme),
                const SizedBox(height: 24),
                _buildBudgetProgressBar(textPrimary, textSecondary, cardBg, borderTheme, isDark),
                const SizedBox(height: 24),
                _buildFinancialInsightCard(textPrimary, isDark),
                const SizedBox(height: 24),
                _buildSectionHeader('Transaksi Terbaru', textPrimary, onSeeAll: () {}),
                const SizedBox(height: 12),
                _buildRecentTransactionsList(empatTransaksiTerbaru, textPrimary, textSecondary, cardBg, borderTheme),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopHeader(Color textPrimary, Color textSecondary, Color cardBg, Color borderTheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: AppTheme.brandPrimary,
                shape: BoxShape.circle,
              ),
              child: const CircleAvatar(
                radius: 20,
                backgroundColor: AppTheme.brandPrimary,
                child: Text('IF', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Selamat Datang,', style: TextStyle(color: textSecondary, fontSize: 12)),
                Text('Irwan Fuzi', style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderTheme),
          ),
          child: IconButton(
            icon: Icon(Icons.notifications_none_rounded, color: textPrimary),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildRoyalHeroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [AppTheme.brandPrimary, AppTheme.brandLightBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.brandPrimary.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'TOTAL ASET',
                style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 1.2),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.refresh_rounded, color: Colors.white, size: 12),
                    SizedBox(width: 4),
                    Text('Updated baru saja', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            summaryData['saldo'] ?? 'Rp 0',
            style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: -0.5),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Row(
              children: [
                Icon(Icons.auto_graph_rounded, color: Colors.lightBlueAccent, size: 18),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Pengeluaran bulan ini 12% lebih hemat dari bulan lalu.',
                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDompetHorizontalList(Color textPrimary, Color textSecondary, Color cardBg, Color borderTheme) {
    final dompet = summaryData['dompet'] ?? {};
    final listDompet = [
      {'nama': 'Kantong Tunai', 'saldo': dompet['tunai'] ?? 'Rp 0', 'icon': Icons.account_balance_wallet_rounded, 'color': Colors.green.shade600},
      {'nama': 'Rekening Bank', 'saldo': dompet['bank'] ?? 'Rp 0', 'icon': Icons.account_balance_rounded, 'color': AppTheme.brandPrimary},
      {'nama': 'Dompet Digital', 'saldo': dompet['digital'] ?? 'Rp 0', 'icon': Icons.qr_code_scanner_rounded, 'color': Colors.orange.shade700},
      {'nama': 'Tabungan', 'saldo': dompet['tabungan'] ?? 'Rp 0', 'icon': Icons.savings_rounded, 'color': Colors.purple.shade600},
    ];

    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: listDompet.length,
        itemBuilder: (context, index) {
          final item = listDompet[index];
          return Container(
            width: 160,
            margin: const EdgeInsets.only(right: 14),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: borderTheme),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Icon(item['icon'] as IconData, color: item['color'] as Color, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item['nama'] as String,
                        style: TextStyle(fontSize: 12, color: textSecondary, fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  item['saldo'] as String,
                  style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 15),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuickActionGrid(BuildContext context, Color textSecondary, Color cardBg, Color borderTheme) {
    final actions = [
      {'label': 'Scan Struk', 'icon': Icons.document_scanner_rounded, 'color': AppTheme.brandPrimary},
      {'label': 'Budget', 'icon': Icons.pie_chart_outline_rounded, 'color': Colors.amber.shade800},
      {'label': 'Laporan', 'icon': Icons.bar_chart_rounded, 'color': Colors.green.shade600},
      {'label': 'Kategori', 'icon': Icons.grid_view_rounded, 'color': Colors.purple.shade600},
      {'label': 'Cari', 'icon': Icons.search_rounded, 'color': Colors.pink.shade600},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: actions.map((act) {
        return Column(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: borderTheme),
              ),
              child: Icon(act['icon'] as IconData, color: act['color'] as Color, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              act['label'] as String,
              style: TextStyle(fontSize: 11, color: textSecondary, fontWeight: FontWeight.w500),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildBudgetProgressBar(Color textPrimary, Color textSecondary, Color cardBg, Color borderTheme, bool isDark) {
    double progress = 0.65;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderTheme),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Sisa Budget Bulan Ini', style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 14)),
              Text('${((1 - progress) * 100).toInt()}% Tersisa', style: TextStyle(color: Colors.green.shade600, fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.brandPrimary),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Terpakai: Rp 1.950.000', style: TextStyle(color: textSecondary, fontSize: 11)),
              Text('Limit: Rp 3.000.000', style: TextStyle(color: textSecondary, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialInsightCard(Color textPrimary, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.amber.shade900.withOpacity(0.2) : Colors.amber.shade50,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: isDark ? Colors.amber.shade700.withOpacity(0.3) : Colors.amber.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDark ? Colors.amber.shade600.withOpacity(0.2) : Colors.amber.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.lightbulb_rounded, color: isDark ? Colors.amberAccent : Colors.amber.shade900, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Insight Keuangan', style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.amberAccent : Colors.amber.shade900, fontSize: 13)),
                const SizedBox(height: 2),
                Text(
                  'Kategori "Makanan" mendominasi 60% pengeluaranmu. Yuk, atur ulang batas bulananmu!',
                  style: TextStyle(fontSize: 11, color: textPrimary, height: 1.3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTransactionsList(List transaksi, Color textPrimary, Color textSecondary, Color cardBg, Color borderTheme) {
    if (transaksi.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderTheme),
        ),
        child: Center(
          child: Text('Belum ada transaksi tercatat', style: TextStyle(color: textSecondary, fontSize: 13)),
        ),
      );
    }

    return Column(
      children: transaksi.map((item) {
        final bool isPengeluaran = (item['jenis'] ?? '').toString().toLowerCase().contains('pengeluaran');
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderTheme),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isPengeluaran ? Colors.red.shade50 : Colors.green.shade50,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  isPengeluaran ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                  color: isPengeluaran ? Colors.red.shade600 : Colors.green.shade600,
                  size: 20,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['keterangan'] ?? '-',
                      style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${item['kategori']} • ${item['dompet']}',
                      style: TextStyle(color: textSecondary, fontSize: 11),
                    ),
                  ],
                ),
              ),
              Text(
                '${isPengeluaran ? '-' : '+'} Rp ${item['nominal']}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: isPengeluaran ? Colors.red.shade600 : Colors.green.shade600,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSectionHeader(String title, Color textPrimary, {VoidCallback? onSeeAll}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(color: textPrimary, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        if (onSeeAll != null)
          GestureDetector(
            onTap: onSeeAll,
            child: const Text(
              'Lihat Semua',
              style: TextStyle(color: AppTheme.brandPrimary, fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
      ],
    );
  }
}
