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

  final List<Map<String, dynamic>> _quickActions = [
    {'id': 'scan', 'label': 'Scan Struk', 'icon': Icons.qr_code_scanner_rounded, 'color': const Color(0xFF1E40AF), 'bg': const Color(0xFFEFF6FF)},
    {'id': 'transfer', 'label': 'Transfer', 'icon': Icons.swap_horizontal_circle_rounded, 'color': const Color(0xFFD97706), 'bg': const Color(0xFFFFFBEB)},
    {'id': 'laporan', 'label': 'Laporan', 'icon': Icons.insights_rounded, 'color': const Color(0xFF059669), 'bg': const Color(0xFFECFDF5)},
    {'id': 'kategori', 'label': 'Kategori', 'icon': Icons.category_rounded, 'color': const Color(0xFF6D28D9), 'bg': const Color(0xFFF5F3FF)},
    {'id': 'import', 'label': 'Import CSV', 'icon': Icons.cloud_upload_rounded, 'color': const Color(0xFF0284C7), 'bg': const Color(0xFFF0F9FF)},
  ];

  final List<Map<String, dynamic>> _allAvailableActions = [
    {'id': 'scan', 'label': 'Scan Struk (OCR)', 'icon': Icons.qr_code_scanner_rounded},
    {'id': 'transfer', 'label': 'Transfer Rekening', 'icon': Icons.swap_horiz_rounded},
    {'id': 'laporan', 'label': 'Laporan Keuangan', 'icon': Icons.insights_rounded},
    {'id': 'kategori', 'label': 'Kelola Kategori', 'icon': Icons.category_rounded},
    {'id': 'import', 'label': 'Import Mutasi CSV', 'icon': Icons.cloud_upload_rounded},
    {'id': 'target', 'label': 'Target Tabungan', 'icon': Icons.stars_rounded},
    {'id': 'statistik', 'label': 'Statistik Arus Kas', 'icon': Icons.pie_chart_outline_rounded},
  ];

  void _showCustomizeActionsDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Kelola Akses Cepat', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Pilih menu utama yang tampil di beranda:',
                style: TextStyle(fontSize: 12, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
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
                      activeColor: const Color(0xFF1E40AF),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      secondary: Icon(item['icon'] as IconData, color: const Color(0xFF1E40AF)),
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

    final Color textPrimary = isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A);
    final Color textSecondary = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final Color surfaceColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final Color borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: RefreshIndicator(
              onRefresh: () async {},
              color: const Color(0xFF1E40AF),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildRefinedHeader(textPrimary, borderColor, isDark),
                    const SizedBox(height: 20),
                    _buildHeroCard(),
                    const SizedBox(height: 24),
                    _buildSectionHeader('Dompet Saya', textPrimary, onSeeAll: () {}),
                    const SizedBox(height: 12),
                    _buildDompetList(textPrimary, textSecondary, surfaceColor, borderColor, isDark),
                    const SizedBox(height: 24),
                    _buildQuickActionHeader('Akses Cepat', textPrimary),
                    const SizedBox(height: 14),
                    _buildQuickActionGrid(textPrimary, surfaceColor),
                    const SizedBox(height: 24),
                    
                    Row(
                      children: [
                        Expanded(
                          child: _buildBentoCard(
                            title: 'Budget Bulan Ini',
                            value: 'Rp 1.950.000',
                            badgeText: '35% Sisa',
                            badgeBg: const Color(0xFFECFDF5),
                            badgeColor: const Color(0xFF059669),
                            progress: 0.65,
                            progressColor: const Color(0xFF1E40AF),
                            icon: Icons.pie_chart_rounded,
                            textPrimary: textPrimary,
                            textSecondary: textSecondary,
                            surfaceColor: surfaceColor,
                            borderColor: borderColor,
                            isDark: isDark,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildBentoCard(
                            title: 'Dana Darurat',
                            value: 'Rp 7.500.000',
                            badgeText: '75% Goal',
                            badgeBg: const Color(0xFFF5F3FF),
                            badgeColor: const Color(0xFF6D28D9),
                            progress: 0.75,
                            progressColor: const Color(0xFF6D28D9),
                            icon: Icons.stars_rounded,
                            textPrimary: textPrimary,
                            textSecondary: textSecondary,
                            surfaceColor: surfaceColor,
                            borderColor: borderColor,
                            isDark: isDark,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),
                    _buildAIInsightCard(isDark),
                    const SizedBox(height: 24),
                    _buildSectionHeader('Transaksi Terbaru', textPrimary, onSeeAll: widget.onNavigateToAnalisis),
                    const SizedBox(height: 12),
                    _buildCleanTransactionsList(empatTransaksiTerbaru, textPrimary, textSecondary, surfaceColor, borderColor, isDark),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRefinedHeader(Color textPrimary, Color borderColor, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFF1E40AF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.account_balance_wallet_rounded, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            Text(
              'MyKas',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: textPrimary, letterSpacing: -0.5),
            ),
          ],
        ),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: borderColor),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 10,
                    backgroundColor: Color(0xFF1E40AF),
                    child: Text('I', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 6),
                  Text('Irwan Fuzi', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textPrimary)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.notifications_none_rounded, color: textPrimary, size: 22),
              style: IconButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: borderColor)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeroCard() {
    final String rawSaldo = widget.summaryData['saldo'] ?? 'Rp 2.345.833';
    final String displaySaldo = _isBalanceVisible ? rawSaldo : 'Rp ••••••••';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: const Color(0xFF0F172A),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
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
                style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.1),
              ),
              InkWell(
                onTap: () => setState(() => _isBalanceVisible = !_isBalanceVisible),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Icon(_isBalanceVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: Colors.white, size: 13),
                      const SizedBox(width: 4),
                      Text(_isBalanceVisible ? 'Sembunyi' : 'Tampil', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(displaySaldo, style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w800, letterSpacing: -0.5)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.06),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.trending_down_rounded, color: Color(0xFF34D399), size: 16),
                const SizedBox(width: 8),
                const Text('12% lebih hemat dari bulan lalu', style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDompetList(Color textPrimary, Color textSecondary, Color surfaceColor, Color borderColor, bool isDark) {
    final dompet = widget.summaryData['dompet'] ?? {};
    final listDompet = [
      {'nama': 'Tunai', 'saldo': dompet['tunai'] ?? 'Rp 148.845', 'icon': Icons.payments_rounded, 'color': const Color(0xFF059669)},
      {'nama': 'Rekening Bank', 'saldo': dompet['bank'] ?? 'Rp 2.196.988', 'icon': Icons.account_balance_rounded, 'color': const Color(0xFF1E40AF)},
      {'nama': 'E-Wallet', 'saldo': dompet['digital'] ?? 'Rp 0', 'icon': Icons.account_balance_wallet_rounded, 'color': const Color(0xFFD97706)},
    ];

    return SizedBox(
      height: 96,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: listDompet.length,
        itemBuilder: (context, index) {
          final item = listDompet[index];
          return Container(
            width: 150,
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(item['icon'] as IconData, color: item['color'] as Color, size: 18),
                    Text(item['nama'] as String, style: TextStyle(fontSize: 11, color: textSecondary, fontWeight: FontWeight.w500)),
                  ],
                ),
                Text(
                  _isBalanceVisible ? (item['saldo'] as String) : 'Rp ••••••',
                  style: TextStyle(color: textPrimary, fontWeight: FontWeight.w700, fontSize: 14),
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
        Text(title, style: TextStyle(color: textPrimary, fontSize: 15, fontWeight: FontWeight.w700)),
        TextButton.icon(
          onPressed: _showCustomizeActionsDialog,
          icon: const Icon(Icons.tune_rounded, size: 14),
          label: const Text('Atur', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
          style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
        ),
      ],
    );
  }

  Widget _buildQuickActionGrid(Color textPrimary, Color surfaceColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: _quickActions.map((act) {
        return Column(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: act['bg'] as Color,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(act['icon'] as IconData, color: act['color'] as Color, size: 22),
            ),
            const SizedBox(height: 6),
            Text(act['label'] as String, style: TextStyle(fontSize: 11, color: textPrimary, fontWeight: FontWeight.w500)),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildBentoCard({
    required String title,
    required String value,
    required String badgeText,
    required Color badgeBg,
    required Color badgeColor,
    required double progress,
    required Color progressColor,
    required IconData icon,
    required Color textPrimary,
    required Color textSecondary,
    required Color surfaceColor,
    required Color borderColor,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: progressColor, size: 18),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(color: badgeBg, borderRadius: BorderRadius.circular(8)),
                child: Text(badgeText, style: TextStyle(color: badgeColor, fontSize: 10, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(title, style: TextStyle(color: textSecondary, fontSize: 11, fontWeight: FontWeight.w500)),
          Text(value, style: TextStyle(color: textPrimary, fontWeight: FontWeight.w700, fontSize: 14)),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: progress,
            minHeight: 5,
            borderRadius: BorderRadius.circular(4),
            backgroundColor: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
            valueColor: AlwaysStoppedAnimation<Color>(progressColor),
          ),
        ],
      ),
    );
  }

  Widget _buildAIInsightCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1B4B) : const Color(0xFFEEF2FF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFC7D2FE)),
      ),
      child: Row(
        children: [
          const Icon(Icons.auto_awesome_rounded, color: Color(0xFF4F46E5), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Pengeluaran "Makanan" mendominasi 55% anggaranmu. Hemat Rp 200rb lagi untuk mencapai target tabungan!',
              style: TextStyle(fontSize: 11, color: isDark ? const Color(0xFFE0E7FF) : const Color(0xFF3730A3), height: 1.3, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCleanTransactionsList(List transaksi, Color textPrimary, Color textSecondary, Color surfaceColor, Color borderColor, bool isDark) {
    if (transaksi.isEmpty) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: transaksi.length,
        separatorBuilder: (context, index) => Divider(height: 1, color: borderColor),
        itemBuilder: (context, index) {
          final item = transaksi[index];
          final bool isPengeluaran = (item['jenis'] ?? '').toString().toLowerCase().contains('pengeluaran');
          final String displayNominal = _isBalanceVisible ? 'Rp ${item['nominal']}' : 'Rp ••••••';

          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            leading: CircleAvatar(
              radius: 18,
              backgroundColor: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
              child: Icon(
                isPengeluaran ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                color: isPengeluaran ? const Color(0xFFEF4444) : const Color(0xFF10B981),
                size: 16,
              ),
            ),
            title: Text(item['keterangan'] ?? '-', style: TextStyle(color: textPrimary, fontWeight: FontWeight.w600, fontSize: 13)),
            subtitle: Text('${item['kategori']} • ${item['dompet']}', style: TextStyle(color: textSecondary, fontSize: 11)),
            trailing: Text(
              '${isPengeluaran ? '-' : '+'} $displayNominal',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: isPengeluaran ? const Color(0xFFEF4444) : const Color(0xFF10B981),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color textPrimary, {VoidCallback? onSeeAll}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(color: textPrimary, fontSize: 15, fontWeight: FontWeight.w700)),
        if (onSeeAll != null)
          GestureDetector(
            onTap: onSeeAll,
            child: const Text('Lihat Semua', style: TextStyle(color: Color(0xFF1E40AF), fontSize: 11, fontWeight: FontWeight.w600)),
          ),
      ],
    );
  }
}
