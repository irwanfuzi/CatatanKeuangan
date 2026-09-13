import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

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

  // 5 Quick Actions Utama di Beranda (Tanpa Pengeluaran/Pemasukan karena sudah ada di CTA)
  List<Map<String, dynamic>> _quickActions = [
    {'id': 'scan', 'label': 'Scan Struk', 'icon': Icons.document_scanner_rounded, 'color': AppTheme.brandPrimary},
    {'id': 'transfer', 'label': 'Transfer', 'icon': Icons.swap_horiz_rounded, 'color': Colors.amber.shade800},
    {'id': 'laporan', 'label': 'Laporan', 'icon': Icons.bar_chart_rounded, 'color': Colors.green.shade600},
    {'id': 'kategori', 'label': 'Kategori', 'icon': Icons.grid_view_rounded, 'color': Colors.purple.shade600},
    {'id': 'import', 'label': 'Import CSV', 'icon': Icons.file_upload_rounded, 'color': Colors.teal.shade600},
  ];

  // Daftar Seluruh Pilihan Menu Pintasan untuk Kustomisasi
  final List<Map<String, dynamic>> _allAvailableActions = [
    {'id': 'scan', 'label': 'Scan Struk (OCR)', 'icon': Icons.document_scanner_rounded},
    {'id': 'transfer', 'label': 'Transfer Rekening', 'icon': Icons.swap_horiz_rounded},
    {'id': 'laporan', 'label': 'Laporan Keuangan', 'icon': Icons.bar_chart_rounded},
    {'id': 'kategori', 'label': 'Kelola Kategori', 'icon': Icons.grid_view_rounded},
    {'id': 'import', 'label': 'Import Mutasi CSV', 'icon': Icons.file_upload_rounded},
    {'id': 'target', 'label': 'Target Tabungan', 'icon': Icons.stars_rounded},
    {'id': 'statistik', 'label': 'Statistik Arus Kas', 'icon': Icons.pie_chart_outline_rounded},
    {'id': 'tagihan', 'label': 'Pengingat Tagihan', 'icon': Icons.event_note_rounded},
  ];

  void _showCustomizeActionsDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Kelola Akses Cepat', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                'Pilih 5 pintasan yang ingin kamu tampilkan di halaman Beranda:',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _allAvailableActions.length,
                  itemBuilder: (context, index) {
                    final item = _allAvailableActions[index];
                    final bool isSelected = _quickActions.any((element) => element['id'] == item['id']);

                    return CheckboxListTile(
                      activeColor: AppTheme.brandPrimary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      secondary: Icon(item['icon'] as IconData, color: AppTheme.brandPrimary),
                      title: Text(item['label'] as String, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                      value: isSelected,
                      onChanged: (bool? value) {
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final List riwayat = widget.summaryData['riwayat'] ?? [];
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
                _buildExecutiveHeroCard(),
                const SizedBox(height: 24),
                _buildSectionHeader('Dompet Saya', textPrimary, onSeeAll: () {}),
                const SizedBox(height: 12),
                _buildDompetHorizontalList(textPrimary, textSecondary, cardBg, borderTheme),
                const SizedBox(height: 24),
                _buildQuickActionHeader('Akses Cepat', textPrimary),
                const SizedBox(height: 12),
                _buildQuickActionGrid(textSecondary, cardBg, borderTheme),
                const SizedBox(height: 24),

                // Layout Bento Grid (2-Kolom) untuk Budget & Target Tabungan
                Row(
                  children: [
                    Expanded(
                      child: _buildBentoBudgetCard(textPrimary, textSecondary, cardBg, borderTheme, isDark),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _buildBentoGoalCard(textPrimary, textSecondary, cardBg, borderTheme, isDark),
                    ),
                  ],
                ),

                const SizedBox(height: 24),
                _buildModernAIInsightCard(textPrimary, isDark),
                const SizedBox(height: 24),
                _buildSectionHeader('Transaksi Terbaru', textPrimary, onSeeAll: widget.onNavigateToAnalisis),
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

  // 1. Header dengan Gambar Asset Logo
  Widget _buildTopHeader(Color textPrimary, Color textSecondary, Color cardBg, Color borderTheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Pemanggilan Asset Gambar Logo
        Row(
          children: [
            Image.asset(
              'assets/images/logo_mykas.png',
              height: 36,
              errorBuilder: (context, error, stackTrace) {
                // Placeholder jika file belum di-upload ke repo
                return Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(color: AppTheme.brandPrimary, borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.account_balance_wallet_rounded, color: Colors.white, size: 20),
                );
              },
            ),
            const SizedBox(width: 8),
            RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: 'My',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFFF59E0B), // Honey Gold
                      letterSpacing: -0.5,
                    ),
                  ),
                  TextSpan(
                    text: 'Kas',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0D47A1), // Royal Blue
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        // Badge User Profile
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: borderTheme),
              ),
              child: const Row(
                children: [
                  CircleAvatar(
                    radius: 10,
                    backgroundColor: AppTheme.brandPrimary,
                    child: Text('I', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(width: 6),
                  Text(
                    'Irwan Fuzi',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderTheme),
              ),
              child: IconButton(
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                padding: EdgeInsets.zero,
                icon: Icon(Icons.notifications_none_rounded, color: textPrimary, size: 20),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ],
    );
  }

  // 2. Executive Hero Card
  Widget _buildExecutiveHeroCard() {
    final String rawSaldo = widget.summaryData['saldo'] ?? 'Rp 0';
    final String displaySaldo = _isBalanceVisible ? rawSaldo : 'Rp ••••••••';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [AppTheme.brandPrimary, Color(0xFF1976D2)],
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
                style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.2),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isBalanceVisible = !_isBalanceVisible;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isBalanceVisible ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            displaySaldo,
            style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: -0.5),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.trending_down_rounded, color: Colors.lightGreenAccent, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    '12% lebih hemat bulan ini',
                    style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 11, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('Terupdate', style: TextStyle(color: Colors.white70, fontSize: 9, fontWeight: FontWeight.w500)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 3. Dompet Saya
  Widget _buildDompetHorizontalList(Color textPrimary, Color textSecondary, Color cardBg, Color borderTheme) {
    final dompet = widget.summaryData['dompet'] ?? {};
    final listDompet = [
      {'nama': 'Tunai', 'saldo': dompet['tunai'] ?? 'Rp 0', 'icon': Icons.account_balance_wallet_rounded, 'color': Colors.green.shade600},
      {'nama': 'Rekening Bank', 'saldo': dompet['bank'] ?? 'Rp 0', 'icon': Icons.account_balance_rounded, 'color': AppTheme.brandPrimary},
      {'nama': 'E-Wallet', 'saldo': dompet['digital'] ?? 'Rp 0', 'icon': Icons.qr_code_scanner_rounded, 'color': Colors.orange.shade700},
    ];

    return SizedBox(
      height: 88,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: listDompet.length + 1,
        itemBuilder: (context, index) {
          if (index == listDompet.length) {
            return Container(
              width: 100,
              margin: const EdgeInsets.only(right: 14),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: borderTheme),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_circle_outline_rounded, color: textSecondary, size: 22),
                  const SizedBox(height: 4),
                  Text('+ Kelola', style: TextStyle(fontSize: 11, color: textSecondary, fontWeight: FontWeight.w600)),
                ],
              ),
            );
          }

          final item = listDompet[index];
          final String saldoText = _isBalanceVisible ? (item['saldo'] as String) : 'Rp ••••••';

          return Container(
            width: 146,
            margin: const EdgeInsets.only(right: 14),
            padding: const EdgeInsets.all(12),
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
                    Icon(item['icon'] as IconData, color: item['color'] as Color, size: 16),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        item['nama'] as String,
                        style: TextStyle(fontSize: 11, color: textSecondary, fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  saldoText,
                  style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 13),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // 4. Quick Action Grid
  Widget _buildQuickActionHeader(String title, Color textPrimary) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(color: textPrimary, fontSize: 15, fontWeight: FontWeight.bold),
        ),
        GestureDetector(
          onTap: _showCustomizeActionsDialog,
          child: const Row(
            children: [
              Icon(Icons.tune_rounded, size: 14, color: AppTheme.brandPrimary),
              SizedBox(width: 4),
              Text('Atur', style: TextStyle(color: AppTheme.brandPrimary, fontSize: 11, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionGrid(Color textSecondary, Color cardBg, Color borderTheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: _quickActions.map((act) {
        return Column(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: borderTheme),
              ),
              child: Icon(act['icon'] as IconData, color: act['color'] as Color, size: 22),
            ),
            const SizedBox(height: 6),
            Text(
              act['label'] as String,
              style: TextStyle(fontSize: 10, color: textSecondary, fontWeight: FontWeight.w600),
            ),
          ],
        );
      }).toList(),
    );
  }

  // 5A. Bento Grid: Budget Card (Kolom Kiri)
  Widget _buildBentoBudgetCard(Color textPrimary, Color textSecondary, Color cardBg, Color borderTheme, bool isDark) {
    double progress = 0.65;

    return Container(
      padding: const EdgeInsets.all(16),
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
              const Icon(Icons.pie_chart_rounded, color: AppTheme.brandPrimary, size: 18),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(8)),
                child: Text('${((1 - progress) * 100).toInt()}% Sisa', style: TextStyle(color: Colors.green.shade700, fontSize: 9, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text('Budget Bulan Ini', style: TextStyle(color: textSecondary, fontSize: 10, fontWeight: FontWeight.w500)),
          const SizedBox(height: 2),
          Text('Rp 1.950.000', style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.brandPrimary),
            ),
          ),
        ],
      ),
    );
  }

  // 5B. Bento Grid: Target Tabungan (Kolom Kanan)
  Widget _buildBentoGoalCard(Color textPrimary, Color textSecondary, Color cardBg, Color borderTheme, bool isDark) {
    double goalProgress = 0.75;

    return Container(
      padding: const EdgeInsets.all(16),
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
              const Icon(Icons.stars_rounded, color: Colors.purple, size: 18),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: Colors.purple.shade50, borderRadius: BorderRadius.circular(8)),
                child: Text('${(goalProgress * 100).toInt()}% Goal', style: TextStyle(color: Colors.purple.shade700, fontSize: 9, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text('Dana Darurat', style: TextStyle(color: textSecondary, fontSize: 10, fontWeight: FontWeight.w500)),
          const SizedBox(height: 2),
          Text('Rp 7.500.000', style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: goalProgress,
              minHeight: 6,
              backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.purple),
            ),
          ),
        ],
      ),
    );
  }

  // 6. Dynamic AI Smart Insight Card
  Widget _buildModernAIInsightCard(Color textPrimary, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF1E1B4B), const Color(0xFF311B92)]
              : [const Color(0xFFEEF2FF), const Color(0xFFE0E7FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: isDark ? const Color(0xFF4338CA) : const Color(0xFFC7D2FE)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Color(0xFF6366F1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'AI SMART INSIGHT',
                  style: TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF4338CA), fontSize: 10, letterSpacing: 0.8),
                ),
                const SizedBox(height: 2),
                Text(
                  'Pengeluaran "Makanan" mendominasi 55% anggaranmu. Hemat Rp 200rb lagi untuk mencapai target tabungan!',
                  style: TextStyle(fontSize: 11, color: isDark ? Colors.white : const Color(0xFF1E1B4B), height: 1.3, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 7. Recent Transactions List
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
        final String kategori = (item['kategori'] ?? '').toString();
        final String rawNominal = 'Rp ${item['nominal']}';
        final String displayNominal = _isBalanceVisible ? rawNominal : 'Rp ••••••';

        IconData categoryIcon = Icons.receipt_long_rounded;
        Color categoryBg = Colors.blue.shade50;
        Color categoryColor = Colors.blue.shade700;

        if (kategori.toLowerCase().contains('makan')) {
          categoryIcon = Icons.fastfood_rounded;
          categoryBg = Colors.orange.shade50;
          categoryColor = Colors.orange.shade700;
        } else if (kategori.toLowerCase().contains('belanja')) {
          categoryIcon = Icons.shopping_bag_rounded;
          categoryBg = Colors.pink.shade50;
          categoryColor = Colors.pink.shade700;
        } else if (kategori.toLowerCase().contains('gaji') || !isPengeluaran) {
          categoryIcon = Icons.account_balance_wallet_rounded;
          categoryBg = Colors.green.shade50;
          categoryColor = Colors.green.shade700;
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderTheme),
          ),
          child: Row(
            children: [
              Stack(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: categoryBg,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(categoryIcon, color: categoryColor, size: 20),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: isPengeluaran ? Colors.red : Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isPengeluaran ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                        color: Colors.white,
                        size: 8,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['keterangan'] ?? '-',
                      style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 13),
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
                '${isPengeluaran ? '-' : '+'} $displayNominal',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
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
          style: TextStyle(color: textPrimary, fontSize: 15, fontWeight: FontWeight.bold),
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

