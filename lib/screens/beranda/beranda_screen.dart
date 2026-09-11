import 'package:flutter/material.dart';

class BerandaScreen extends StatelessWidget {
  final Map<String, dynamic> summaryData;

  const BerandaScreen({super.key, required this.summaryData});

  // Skema Warna Royal Blue & Dark Theme Premium
  static const Color primaryRoyalBlue = Color(0xFF0D47A1);
  static const Color lightRoyalBlue = Color(0xFF1976D2);
  static const Color accentGlow = Color(0xFF42A5F5);
  static const Color cardDarkBackground = Color(0xFF151C28);
  static const Color surfaceDark = Color(0xFF0B0E14);

  @override
  Widget build(BuildContext context) {
    final List riwayat = summaryData['riwayat'] ?? [];
    final List empatTransaksiTerbaru = riwayat.take(4).toList();

    return Scaffold(
      backgroundColor: surfaceDark,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            // Logika reload data jika diperlukan
          },
          color: accentGlow,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. TOP BAR (HEADER & USER AVATAR)
                _buildTopHeader(),
                const SizedBox(height: 20),

                // 2. HERO CARD (TOTAL ASET & ROYAL GRADIENT)
                _buildRoyalHeroCard(),
                const SizedBox(height: 24),

                // 3. DOMPET & REKENING (SLIDER CARD)
                _buildSectionHeader('Dompet & Rekening', onSeeAll: () {}),
                const SizedBox(height: 12),
                _buildDompetHorizontalList(),
                const SizedBox(height: 24),

                // 4. QUICK ACTIONS (GRID AKSES CEPAT)
                _buildSectionHeader('Akses Cepat'),
                const SizedBox(height: 12),
                _buildQuickActionGrid(context),
                const SizedBox(height: 24),

                // 5. PROGRESS BUDGET BULAN INI
                _buildBudgetProgressBar(),
                const SizedBox(height: 24),

                // 6. FINANCIAL INSIGHT BANNER
                _buildFinancialInsightCard(),
                const SizedBox(height: 24),

                // 7. 4 TRANSAKSI TERBARU
                _buildSectionHeader('Transaksi Terbaru', onSeeAll: () {}),
                const SizedBox(height: 12),
                _buildRecentTransactionsList(empatTransaksiTerbaru),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- WIDGET COMPONENTS ---

  Widget _buildTopHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: accentGlow,
                shape: BoxShape.circle,
              ),
              child: const CircleAvatar(
                radius: 20,
                backgroundColor: primaryRoyalBlue,
                child: Text('IF', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
              ),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Selamat Datang,', style: TextStyle(color: Colors.white54, fontSize: 12)),
                Text('Irwan Fuzi', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            color: cardDarkBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white10),
          ),
          child: IconButton(
            icon: const Icon(Icons.notifications_none_rounded, color: Colors.white),
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
          colors: [primaryRoyalBlue, lightRoyalBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: primaryRoyalBlue.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'TOTAL ASET',
                style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 1.2),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
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
              color: Colors.black.withOpacity(0.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Row(
              children: [
                Icon(Icons.auto_graph_rounded, color: accentGlow, size: 18),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Pengeluaran bulan ini 12% lebih hemat dari bulan lalu.',
                    style: TextStyle(color: Colors.white90, fontSize: 12, fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDompetHorizontalList() {
    final dompet = summaryData['dompet'] ?? {};
    final listDompet = [
      {'nama': 'Kantong Tunai', 'saldo': dompet['tunai'] ?? 'Rp 0', 'icon': Icons.account_balance_wallet_rounded, 'color': Colors.emeraldAccent},
      {'nama': 'Rekening Bank', 'saldo': dompet['bank'] ?? 'Rp 0', 'icon': Icons.account_balance_rounded, 'color': accentGlow},
      {'nama': 'Dompet Digital', 'saldo': dompet['digital'] ?? 'Rp 0', 'icon': Icons.qr_code_scanner_rounded, 'color': Colors.amberAccent},
      {'nama': 'Tabungan', 'saldo': dompet['tabungan'] ?? 'Rp 0', 'icon': Icons.savings_rounded, 'color': Colors.purpleAccent},
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
              color: cardDarkBackground,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withOpacity(0.08)),
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
                        style: const TextStyle(fontSize: 12, color: Colors.white60, fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  item['saldo'] as String,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuickActionGrid(BuildContext context) {
    final actions = [
      {'label': 'Scan Struk', 'icon': Icons.document_scanner_rounded, 'color': accentGlow},
      {'label': 'Budget', 'icon': Icons.pie_chart_outline_rounded, 'color': Colors.amberAccent},
      {'label': 'Laporan', 'icon': Icons.bar_chart_rounded, 'color': Colors.emeraldAccent},
      {'label': 'Kategori', 'icon': Icons.grid_view_rounded, 'color': Colors.purpleAccent},
      {'label': 'Cari', 'icon': Icons.search_rounded, 'color': Colors.pinkAccent},
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
                color: cardDarkBackground,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.08)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Icon(act['icon'] as IconData, color: act['color'] as Color, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              act['label'] as String,
              style: const TextStyle(fontSize: 11, color: Colors.white70, fontWeight: FontWeight.w500),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildBudgetProgressBar() {
    double progress = 0.65; // Persentase budget terpakai

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardDarkBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Sisa Budget Bulan Ini', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
              Text('${((1 - progress) * 100).toInt()}% Tersisa', style: const TextStyle(color: Colors.emeraldAccent, fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: Colors.white10,
              valueColor: const AlwaysStoppedAnimation<Color>(primaryRoyalBlue),
            ),
          ),
          const SizedBox(height: 12),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Terpakai: Rp 1.950.000', style: TextStyle(color: Colors.white54, fontSize: 11)),
              Text('Limit: Rp 3.000.000', style: TextStyle(color: Colors.white54, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialInsightCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.amber.shade900.withOpacity(0.2), Colors.amber.shade700.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.amber.shade600.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.amber.shade600.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.lightbulb_rounded, color: Colors.amberAccent, size: 22),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Insight Keuangan', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amberAccent, fontSize: 13)),
                SizedBox(height: 2),
                Text(
                  'Kategori "Makanan" mendominasi 60% pengeluaranmu. Yuk, atur ulang batas bulananmu!',
                  style: TextStyle(fontSize: 11, color: Colors.white80, height: 1.3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTransactionsList(List transaksi) {
    if (transaksi.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: cardDarkBackground,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Text('Belum ada transaksi tercatat', style: TextStyle(color: Colors.white38, fontSize: 13)),
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
            color: cardDarkBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isPengeluaran ? Colors.redAccent.withOpacity(0.12) : Colors.emeraldAccent.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  isPengeluaran ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                  color: isPengeluaran ? Colors.redAccent : Colors.emeraldAccent,
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
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${item['kategori']} • ${item['dompet']}',
                      style: const TextStyle(color: Colors.white42, fontSize: 11),
                    ),
                  ],
                ),
              ),
              Text(
                '${isPengeluaran ? '-' : '+'} Rp ${item['nominal']}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: isPengeluaran ? Colors.redAccent : Colors.emeraldAccent,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSectionHeader(String title, {VoidCallback? onSeeAll}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        if (onSeeAll != null)
          GestureDetector(
            onTap: onSeeAll,
            child: const Text(
              'Lihat Semua',
              style: TextStyle(color: accentGlow, fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
      ],
    );
  }
}
