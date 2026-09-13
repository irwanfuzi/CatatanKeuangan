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
  // State untuk Privasi Saldo (Hide/Show)
  bool _isBalanceVisible = true;

  // State untuk Quick Actions yang bisa dikustomisasi oleh pengguna
  List<Map<String, dynamic>> _quickActions = [
    {'id': 'scan', 'label': 'Scan Struk', 'icon': Icons.document_scanner_rounded, 'color': AppTheme.brandPrimary},
    {'id': 'transfer', 'label': 'Transfer', 'icon': Icons.swap_horiz_rounded, 'color': Colors.amber.shade800},
    {'id': 'import', 'label': 'Import CSV', 'icon': Icons.file_upload_rounded, 'color': Colors.green.shade600},
    {'id': 'category', 'label': 'Kategori', 'icon': Icons.grid_view_rounded, 'color': Colors.purple.shade600},
  ];

  void _showCustomizeActionsDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pengaturan Akses Cepat',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              const Text(
                'Sesuaikan tombol pintasan yang sering kamu gunakan di Beranda.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.check_circle, color: AppTheme.brandPrimary),
                title: const Text('Simpan Pengaturan Minimalis'),
                subtitle: const Text('Menampilkan 4 menu pilihan utama'),
                onTap: () => Navigator.pop(context),
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
                _buildSectionHeader('Dompet & Rekening', textPrimary, onSeeAll: () {}),
                const SizedBox(height: 12),
                _buildDompetHorizontalList(textPrimary, textSecondary, cardBg, borderTheme),
                const SizedBox(height: 24),
                _buildQuickActionHeader('Akses Cepat', textPrimary),
                const SizedBox(height: 12),
                _buildQuickActionGrid(textSecondary, cardBg, borderTheme),
                const SizedBox(height: 24),
                _buildBudgetProgressBar(textPrimary, textSecondary, cardBg, borderTheme, isDark),
                const SizedBox(height: 24),
                _buildFinancialGoalCard(textPrimary, textSecondary, cardBg, borderTheme, isDark),
                const SizedBox(height: 24),
                _buildDynamicSmartInsightCard(textPrimary, isDark),
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

  Widget _buildTopHeader(Color textPrimary, Color textSecondary, Color cardBg, Color borderTheme) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppTheme.brandPrimary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.account_balance_wallet_rounded, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 10),
                const Text(
                  'MyKas',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.brandPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    _isBalanceVisible ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                    color: textSecondary,
                  ),
                  onPressed: () {
                    setState(() {
                      _isBalanceVisible = !_isBalanceVisible;
                    });
                  },
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
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            const CircleAvatar(
              radius: 18,
              backgroundColor: AppTheme.brandPrimary,
              child: Text('IF', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Selamat Datang,', style: TextStyle(color: textSecondary, fontSize: 11)),
                Text('Irwan Fuzi', style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 15)),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildExecutiveHeroCard() {
    final String rawSaldo = widget.summaryData['saldo'] ?? 'Rp 0';
    final String displaySaldo = _isBalanceVisible ? rawSaldo : 'Rp ••••••••';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
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
                'TOTAL NET WORTH',
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
          const SizedBox(height: 10),
          Text(
            displaySaldo,
            style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold, letterSpacing: -0.5),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Row(
              children: [
                Icon(Icons.trending_down_rounded, color: Colors.lightGreenAccent, size: 18),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Pengeluaran bulan ini 12% lebih hemat dibanding bulan lalu.',
                    style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w400),
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
    final dompet = widget.summaryData['dompet'] ?? {};
    final listDompet = [
      {'nama': 'Kantong Tunai', 'saldo': dompet['tunai'] ?? 'Rp 0', 'icon': Icons.account_balance_wallet_rounded, 'color': Colors.green.shade600},
      {'nama': 'Rekening BCA', 'saldo': dompet['bank'] ?? 'Rp 0', 'icon': Icons.account_balance_rounded, 'color': AppTheme.brandPrimary},
      {'nama': 'GoPay / E-Wallet', 'saldo': dompet['digital'] ?? 'Rp 0', 'icon': Icons.qr_code_scanner_rounded, 'color': Colors.orange.shade700},
      {'nama': 'Tabungan', 'saldo': dompet['tabungan'] ?? 'Rp 0', 'icon': Icons.savings_rounded, 'color': Colors.purple.shade600},
    ];

    return SizedBox(
      height: 96,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: listDompet.length + 1,
        itemBuilder: (context, index) {
          if (index == listDompet.length) {
            return Container(
              width: 120,
              margin: const EdgeInsets.only(right: 14),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: borderTheme),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_circle_outline_rounded, color: textSecondary, size: 24),
                  const SizedBox(height: 6),
                  Text('+ Kelola', style: TextStyle(fontSize: 12, color: textSecondary, fontWeight: FontWeight.w600)),
                ],
              ),
            );
          }

          final item = listDompet[index];
          final String saldoText = _isBalanceVisible ? (item['saldo'] as String) : 'Rp ••••••';

          return Container(
            width: 156,
            margin: const EdgeInsets.only(right: 14),
            padding: const EdgeInsets.all(14),
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
                  style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuickActionHeader(String title, Color textPrimary) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(color: textPrimary, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        GestureDetector(
          onTap: _showCustomizeActionsDialog,
          child: const Icon(Icons.settings_outlined, size: 18, color: AppTheme.brandPrimary),
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
              width: 54,
              height: 54,
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
      padding: const EdgeInsets.all(18),
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
              Text('Sisa Budget Bulan Ini', style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 13)),
              Text('${((1 - progress) * 100).toInt()}% Tersisa', style: TextStyle(color: Colors.green.shade600, fontSize: 11, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.brandPrimary),
            ),
          ),
          const SizedBox(height: 10),
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

  Widget _buildFinancialGoalCard(Color textPrimary, Color textSecondary, Color cardBg, Color borderTheme, bool isDark) {
    double goalProgress = 0.75;

    return Container(
      padding: const EdgeInsets.all(18),
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
              Row(
                children: [
                  const Icon(Icons.flag_rounded, color: Colors.purple, size: 18),
                  const SizedBox(width: 8),
                  Text('Target: Dana Darurat', style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 13)),
                ],
              ),
              Text('${(goalProgress * 100).toInt()}%', style: const TextStyle(color: Colors.purple, fontSize: 11, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: goalProgress,
              minHeight: 8,
              backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.purple),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Terkumpul: Rp 7.500.000', style: TextStyle(color: textSecondary, fontSize: 11)),
              Text('Target: Rp 10.000.000', style: TextStyle(color: textSecondary, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDynamicSmartInsightCard(Color textPrimary, bool isDark) {
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
            child: Icon(Icons.auto_awesome_rounded, color: isDark ? Colors.amberAccent : Colors.amber.shade900, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('AI Smart Insight', style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.amberAccent : Colors.amber.shade900, fontSize: 12)),
                const SizedBox(height: 2),
                Text(
                  'Kategori "Makanan & Minuman" mendominasi 55% pengeluaranmu minggu ini. Pertimbangkan untuk membatasi pengeluaran kencan/hangout.',
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
        final String rawNominal = 'Rp ${item['nominal']}';
        final String displayNominal = _isBalanceVisible ? rawNominal : 'Rp ••••••';

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
                width: 42,
                height: 42,
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
