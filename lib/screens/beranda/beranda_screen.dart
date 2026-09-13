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
    {'id': 'scan', 'label': 'Scan Struk', 'icon': Icons.qr_code_scanner_rounded, 'color': const Color(0xFF0D47A1), 'bg': const Color(0xFFE3F2FD)},
    {'id': 'transfer', 'label': 'Transfer', 'icon': Icons.swap_horizontal_circle_rounded, 'color': const Color(0xFFD97706), 'bg': const Color(0xFFFEF3C7)},
    {'id': 'laporan', 'label': 'Laporan', 'icon': Icons.insights_rounded, 'color': const Color(0xFF059669), 'bg': const Color(0xFFD1FAE5)},
    {'id': 'kategori', 'label': 'Kategori', 'icon': Icons.category_rounded, 'color': const Color(0xFF7C3AED), 'bg': const Color(0xFFEDE9FE)},
    {'id': 'import', 'label': 'Import CSV', 'icon': Icons.cloud_upload_rounded, 'color': const Color(0xFF0284C7), 'bg': const Color(0xFFE0F2FE)},
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
            color: isDark ? const Color(0xFF151C28) : Colors.white,
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
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
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
                      activeColor: const Color(0xFF0D47A1),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      secondary: Icon(item['icon'] as IconData, color: const Color(0xFF0D47A1)),
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
    final Color borderTheme = isDark ? AppTheme.borderDark : const Color(0xFFCBD5E1);

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {},
          color: const Color(0xFF0D47A1),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildUltraHeader(textPrimary, textSecondary, cardBg, borderTheme, isDark),
                const SizedBox(height: 20),
                _buildUltraHeroCard(),
                const SizedBox(height: 24),
                _buildSectionHeader('Dompet Saya', textPrimary, onSeeAll: () {}),
                const SizedBox(height: 12),
                _buildUltraDompetList(textPrimary, textSecondary, cardBg, borderTheme, isDark),
                const SizedBox(height: 24),
                _buildQuickActionHeader('Akses Cepat', textPrimary),
                const SizedBox(height: 14),
                _buildUltraQuickActionGrid(textPrimary, textSecondary, cardBg),
                const SizedBox(height: 24),
                
                // Bento 2-Kolom untuk Budget & Target Tabungan
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
                _buildGlowingAIInsightCard(isDark),
                const SizedBox(height: 24),
                _buildSectionHeader('Transaksi Terbaru', textPrimary, onSeeAll: widget.onNavigateToAnalisis),
                const SizedBox(height: 12),
                _buildUltraRecentTransactionsList(empatTransaksiTerbaru, textPrimary, textSecondary, cardBg, borderTheme),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 1. Header (Logo Asset MyKas + User Profile Badge)
  Widget _buildUltraHeader(Color textPrimary, Color textSecondary, Color cardBg, Color borderTheme, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Image.asset(
              'assets/images/logo_mykas.png',
              height: 38,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF0D47A1), Color(0xFF1976D2)]),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(color: const Color(0xFF0D47A1).withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 3)),
                    ],
                  ),
                  child: const Icon(Icons.account_balance_wallet_rounded, color: Colors.white, size: 22),
                );
              },
            ),
            const SizedBox(width: 10),
            RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: 'My',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFFF59E0B), letterSpacing: -0.5),
                  ),
                  TextSpan(
                    text: 'Kas',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF0D47A1), letterSpacing: -0.5),
                  ),
                ],
              ),
            ),
          ],
        ),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF151C28) : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: borderTheme.withOpacity(0.5)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(colors: [Color(0xFF0D47A1), Color(0xFF0284C7)]),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text('I', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Irwan Fuzi',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: textPrimary),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF151C28) : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderTheme.withOpacity(0.5)),
              ),
              child: IconButton(
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

  // 2. Ultra-Modern Hero Card
  Widget _buildUltraHeroCard() {
    final String rawSaldo = widget.summaryData['saldo'] ?? 'Rp 0';
    final String displaySaldo = _isBalanceVisible ? rawSaldo : 'Rp ••••••••';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: const LinearGradient(
          colors: [Color(0xFF0A369D), Color(0xFF0D47A1), Color(0xFF0284C7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0D47A1).withOpacity(0.35),
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
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(color: Color(0xFF10B981), shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'TOTAL ASET',
                    style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1.2),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isBalanceVisible = !_isBalanceVisible;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.25)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _isBalanceVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                        color: Colors.white,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _isBalanceVisible ? 'Sembunyi' : 'Tampil',
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
            displaySaldo,
            style: const TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w900, letterSpacing: -0.8),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withOpacity(0.12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(color: const Color(0xFF10B981).withOpacity(0.2), shape: BoxShape.circle),
                      child: const Icon(Icons.trending_down_rounded, color: Color(0xFF34D399), size: 14),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      '12% lebih hemat dari bulan lalu',
                      style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const Icon(Icons.chevron_right_rounded, color: Colors.white60, size: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 3. Dompet Saya
  Widget _buildUltraDompetList(Color textPrimary, Color textSecondary, Color cardBg, Color borderTheme, bool isDark) {
    final dompet = widget.summaryData['dompet'] ?? {};
    final listDompet = [
      {'nama': 'Tunai', 'saldo': dompet['tunai'] ?? 'Rp 0', 'icon': Icons.payments_rounded, 'color': const Color(0xFF059669), 'bg': const Color(0xFFECFDF5)},
      {'nama': 'Rekening Bank', 'saldo': dompet['bank'] ?? 'Rp 0', 'icon': Icons.account_balance_rounded, 'color': const Color(0xFF0D47A1), 'bg': const Color(0xFFEFF6FF)},
      {'nama': 'E-Wallet', 'saldo': dompet['digital'] ?? 'Rp 0', 'icon': Icons.account_balance_wallet_rounded, 'color': const Color(0xFFD97706), 'bg': const Color(0xFFFFFBEB)},
    ];

    return SizedBox(
      height: 104,
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
                color: isDark ? const Color(0xFF151C28) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: borderTheme.withOpacity(0.6)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: const Color(0xFF0D47A1).withOpacity(0.1), shape: BoxShape.circle),
                    child: const Icon(Icons.add_rounded, color: Color(0xFF0D47A1), size: 20),
                  ),
                  const SizedBox(height: 6),
                  Text('Kelola', style: TextStyle(fontSize: 11, color: textPrimary, fontWeight: FontWeight.bold)),
                ],
              ),
            );
          }

          final item = listDompet[index];
          final String saldoText = _isBalanceVisible ? (item['saldo'] as String) : 'Rp ••••••';

          return Container(
            width: 156,
            margin: const EdgeInsets.only(right: 14),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF151C28) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: borderTheme.withOpacity(0.6)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.3 : 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: isDark ? (item['color'] as Color).withOpacity(0.2) : (item['bg'] as Color),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(item['icon'] as IconData, color: item['color'] as Color, size: 16),
                    ),
                    Text(
                      item['nama'] as String,
                      style: TextStyle(fontSize: 11, color: textSecondary, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                Text(
                  saldoText,
                  style: TextStyle(color: textPrimary, fontWeight: FontWeight.w800, fontSize: 15),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // 4. Quick Actions
  Widget _buildQuickActionHeader(String title, Color textPrimary) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(color: textPrimary, fontSize: 16, fontWeight: FontWeight.w800),
        ),
        GestureDetector(
          onTap: _showCustomizeActionsDialog,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF0D47A1).withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.tune_rounded, size: 13, color: Color(0xFF0D47A1)),
                SizedBox(width: 4),
                Text('Atur', style: TextStyle(color: Color(0xFF0D47A1), fontSize: 11, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUltraQuickActionGrid(Color textPrimary, Color textSecondary, Color cardBg) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: _quickActions.map((act) {
        final Color itemColor = act['color'] as Color;
        final Color itemBg = isDark ? itemColor.withOpacity(0.18) : (act['bg'] as Color);

        return Column(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: itemBg,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: itemColor.withOpacity(0.12),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Icon(act['icon'] as IconData, color: itemColor, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              act['label'] as String,
              style: TextStyle(fontSize: 11, color: textPrimary, fontWeight: FontWeight.w600),
            ),
          ],
        );
      }).toList(),
    );
  }

  // 5A. Bento Grid: Budget
  Widget _buildBentoBudgetCard(Color textPrimary, Color textSecondary, Color cardBg, Color borderTheme, bool isDark) {
    double progress = 0.65;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF151C28) : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: borderTheme.withOpacity(0.6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: const Color(0xFF0D47A1).withOpacity(0.1), shape: BoxShape.circle),
                child: const Icon(Icons.pie_chart_rounded, color: Color(0xFF0D47A1), size: 16),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: const Color(0xFFD1FAE5), borderRadius: BorderRadius.circular(10)),
                child: Text('${((1 - progress) * 100).toInt()}% Sisa', style: const TextStyle(color: Color(0xFF059669), fontSize: 10, fontWeight: FontWeight.w800)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text('Budget Bulan Ini', style: TextStyle(color: textSecondary, fontSize: 10, fontWeight: FontWeight.w600)),
          const SizedBox(height: 2),
          Text('Rp 1.950.000', style: TextStyle(color: textPrimary, fontWeight: FontWeight.w900, fontSize: 14)),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 7,
              backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF0D47A1)),
            ),
          ),
        ],
      ),
    );
  }

  // 5B. Bento Grid: Goal Card
  Widget _buildBentoGoalCard(Color textPrimary, Color textSecondary, Color cardBg, Color borderTheme, bool isDark) {
    double goalProgress = 0.75;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF151C28) : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: borderTheme.withOpacity(0.6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: const Color(0xFF7C3AED).withOpacity(0.1), shape: BoxShape.circle),
                child: const Icon(Icons.stars_rounded, color: Color(0xFF7C3AED), size: 16),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: const Color(0xFFEDE9FE), borderRadius: BorderRadius.circular(10)),
                child: Text('${(goalProgress * 100).toInt()}% Goal', style: const TextStyle(color: Color(0xFF7C3AED), fontSize: 10, fontWeight: FontWeight.w800)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text('Dana Darurat', style: TextStyle(color: textSecondary, fontSize: 10, fontWeight: FontWeight.w600)),
          const SizedBox(height: 2),
          Text('Rp 7.500.000', style: TextStyle(color: textPrimary, fontWeight: FontWeight.w900, fontSize: 14)),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: goalProgress,
              minHeight: 7,
              backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF7C3AED)),
            ),
          ),
        ],
      ),
    );
  }

  // 6. Glowing AI Insight Card
  Widget _buildGlowingAIInsightCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF1E1B4B), const Color(0xFF311B92)]
              : [const Color(0xFF4338CA), const Color(0xFF6366F1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withOpacity(0.3),
            blurRadius: 14,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: const Icon(Icons.auto_awesome_rounded, color: Color(0xFFFDE047), size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'AI SMART INSIGHT',
                      style: TextStyle(fontWeight: FontWeight.w900, color: Color(0xFFFDE047), fontSize: 10, letterSpacing: 1.0),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(6)),
                      child: const Text('PRO', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Pengeluaran "Makanan" mendominasi 55% anggaranmu. Hemat Rp 200rb lagi untuk mencapai target tabungan!',
                  style: TextStyle(fontSize: 11, color: Colors.white, height: 1.35, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 7. Recent Transactions List
  Widget _buildUltraRecentTransactionsList(List transaksi, Color textPrimary, Color textSecondary, Color cardBg, Color borderTheme) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (transaksi.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF151C28) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderTheme.withOpacity(0.6)),
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
        Color categoryBg = const Color(0xFFEFF6FF);
        Color categoryColor = const Color(0xFF0D47A1);

        if (kategori.toLowerCase().contains('makan')) {
          categoryIcon = Icons.fastfood_rounded;
          categoryBg = const Color(0xFFFFF7ED);
          categoryColor = const Color(0xFFEA580C);
        } else if (kategori.toLowerCase().contains('belanja')) {
          categoryIcon = Icons.shopping_bag_rounded;
          categoryBg = const Color(0xFFFDF2F8);
          categoryColor = const Color(0xFFDB2777);
        } else if (kategori.toLowerCase().contains('gaji') || !isPengeluaran) {
          categoryIcon = Icons.account_balance_wallet_rounded;
          categoryBg = const Color(0xFFECFDF5);
          categoryColor = const Color(0xFF059669);
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF151C28) : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: borderTheme.withOpacity(0.5)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.2 : 0.02),
                blurRadius: 8,
                offset: const Offset(0, 3),
              )
            ],
          ),
          child: Row(
            children: [
              Stack(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: isDark ? categoryColor.withOpacity(0.18) : categoryBg,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(categoryIcon, color: categoryColor, size: 20),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: isPengeluaran ? const Color(0xFFEF4444) : const Color(0xFF10B981),
                        shape: BoxShape.circle,
                        border: Border.all(color: isDark ? const Color(0xFF151C28) : Colors.white, width: 1.5),
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
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                  color: isPengeluaran ? const Color(0xFFEF4444) : const Color(0xFF10B981),
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
          style: TextStyle(color: textPrimary, fontSize: 16, fontWeight: FontWeight.w800),
        ),
        if (onSeeAll != null)
          GestureDetector(
            onTap: onSeeAll,
            child: const Text(
              'Lihat Semua',
              style: TextStyle(color: Color(0xFF0D47A1), fontSize: 12, fontWeight: FontWeight.w700),
            ),
          ),
      ],
    );
  }
}
