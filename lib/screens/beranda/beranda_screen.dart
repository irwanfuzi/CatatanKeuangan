import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class BerandaScreen extends StatefulWidget {
  final Map<String, dynamic>? summaryData;
  final VoidCallback? onNavigateToAnalisis;

  const BerandaScreen({
    super.key,
    this.summaryData,
    this.onNavigateToAnalisis,
  });

  static const Color primaryRoyalBlue = Color(0xFF0052FF);
  static const Color accentNotificationOrange = Color(0xFFFF9F00);
  static const Color textDark = Color(0xFF0F172A);
  static const Color textMuted = Color(0xFF64748B);

  @override
  State<BerandaScreen> createState() => _BerandaScreenState();
}

class _BerandaScreenState extends State<BerandaScreen> {
  bool _showAllKantongSubPage = false;

  String _formatCurrency(dynamic rawNominal) {
    if (rawNominal == null) return 'Rp 0';
    String strVal = rawNominal.toString().replaceAll(RegExp(r'[^0-9]'), '');
    if (strVal.isEmpty) return 'Rp 0';

    final intValue = int.tryParse(strVal) ?? 0;
    final buffer = StringBuffer();
    final numStr = intValue.toString();

    for (int i = 0; i < numStr.length; i++) {
      if (i > 0 && (numStr.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(numStr[i]);
    }
    return 'Rp $buffer';
  }

  void _handleBackPress() {
    if (_showAllKantongSubPage) {
      setState(() {
        _showAllKantongSubPage = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final saldo = widget.summaryData?['saldo'] ?? 'Rp 2.345.833';

    final List riwayat = widget.summaryData?['riwayat'] as List? ?? [
      {
        'judul': 'Gudeg Bu Dani Solo',
        'kategori': 'Kuliner & Makanan',
        'tanggal': 'Hari Ini, 12:45',
        'nominal': '45000',
        'jenis': 'pengeluaran',
        'icon': LucideIcons.utensils,
        'iconBg': const Color(0xFFF97316),
      },
      {
        'judul': 'Gaji Bulanan Utama',
        'kategori': 'Payroll Inflow',
        'tanggal': '25 Agu 2026',
        'nominal': '8500000',
        'jenis': 'pemasukan',
        'icon': LucideIcons.wallet,
        'iconBg': const Color(0xFF10B981),
      },
      {
        'judul': 'GoFood Indonesia',
        'kategori': 'Layanan Antar',
        'tanggal': '24 Agu 2026',
        'nominal': '68000',
        'jenis': 'pengeluaran',
        'icon': LucideIcons.shoppingBag,
        'iconBg': const Color(0xFF00AED6),
      },
    ];

    final recentTransactions = riwayat.take(3).toList();

    final surfaceColor = isDark ? const Color(0xFF0B0F19) : Colors.white;
    final cardBg = isDark ? const Color(0xFF111827) : const Color(0xFFF8FAFC);
    final borderColor = isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0);
    final textColor = isDark ? Colors.white : BerandaScreen.textDark;

    return PopScope(
      canPop: !_showAllKantongSubPage,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _showAllKantongSubPage) {
          _handleBackPress();
        }
      },
      child: Scaffold(
        backgroundColor: BerandaScreen.primaryRoyalBlue,
        body: SafeArea(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 320),
            reverseDuration: const Duration(milliseconds: 280),
            switchInCurve: Curves.fastOutSlowIn,
            switchOutCurve: Curves.easeInCubic,
            transitionBuilder: (Widget child, Animation<double> animation) {
              final isSubPage = child.key == const ValueKey('SemuaKantongSubPage');

              final Tween<Offset> slideTween = isSubPage
                  ? Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero)
                  : Tween<Offset>(begin: const Offset(-0.25, 0.0), end: Offset.zero);

              return SlideTransition(
                position: slideTween.animate(animation),
                child: child,
              );
            },
            child: _showAllKantongSubPage
                ? _buildSemuaKantongSubPage(textColor, cardBg, borderColor, surfaceColor, isDark)
                : _buildMainBerandaView(
                    saldo,
                    recentTransactions,
                    textColor,
                    cardBg,
                    borderColor,
                    surfaceColor,
                    isDark,
                  ),
          ),
        ),
      ),
    );
  }

  // =========================================================================
  // MAIN BERANDA VIEW (FIT-TO-SCREEN / NO SCROLLBAR)
  // =========================================================================
  Widget _buildMainBerandaView(
    String saldo,
    List recentTransactions,
    Color textColor,
    Color cardBg,
    Color borderColor,
    Color surfaceColor,
    bool isDark,
  ) {
    return LayoutBuilder(
      key: const ValueKey('MainBerandaView'),
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 1024;

        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: isDesktop ? 1200 : 540),
            child: Column(
              children: [
                _buildStaticHeaderBar(saldo),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Center(
                          child: Container(
                            width: 38,
                            height: 4,
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        _buildKantongKeuanganSection(textColor, cardBg, borderColor, isDark, isDesktop),
                        _buildQuickActionsSection(textColor, isDark, isDesktop),
                        _buildMyInsightCard(isDark),
                        _buildOverviewKeuanganSection(textColor, cardBg, borderColor, isDark),
                        _buildRecentTransactionsSection(recentTransactions, textColor, cardBg, borderColor, isDark),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStaticHeaderBar(String saldo) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      color: BerandaScreen.primaryRoyalBlue,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  color: Colors.white24,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 13,
                    child: Icon(
                      LucideIcons.user,
                      color: BerandaScreen.primaryRoyalBlue,
                      size: 16,
                    ),
                  ),
                ),
              ),
              const Expanded(
                child: Center(
                  child: Text(
                    'MyKas',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: -0.4,
                      height: 1.0,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 30,
                height: 30,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Icon(
                      LucideIcons.bell,
                      color: Colors.white,
                      size: 20,
                    ),
                    Positioned(
                      top: 2,
                      right: 2,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                        decoration: BoxDecoration(
                          color: BerandaScreen.accentNotificationOrange,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: BerandaScreen.primaryRoyalBlue, width: 1.5),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 14,
                          minHeight: 14,
                        ),
                        child: const Center(
                          child: Text(
                            '3',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.w900,
                              height: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Row(
            children: [
              Text(
                'Total Saldo',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white70),
              ),
              SizedBox(width: 6),
              Icon(LucideIcons.eye, color: Colors.white70, size: 13),
            ],
          ),
          Text(
            saldo,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              fontFamily: 'monospace',
              letterSpacing: -0.8,
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // SUB-PAGE: SEMUA KANTONG KEUANGAN
  // =========================================================================
  Widget _buildSemuaKantongSubPage(
    Color textColor,
    Color cardBg,
    Color borderColor,
    Color surfaceColor,
    bool isDark,
  ) {
    final List<Map<String, dynamic>> allWallets = [
      {
        'title': 'BSI Debit Hasanah',
        'type': 'Bank Syariah Indonesia',
        'amount': '186750000',
        'badgeText': 'BSI',
        'badgeBg': const Color(0xFF00A39D),
        'accountNumber': '7123 •••• 8819',
        'isPrimary': true,
      },
      {
        'title': 'Taplus Muda Mandiri',
        'type': 'Bank Mandiri',
        'amount': '12400000',
        'badgeText': 'MANDIRI',
        'badgeBg': const Color(0xFFF59E0B),
        'accountNumber': '1370 •••• 4421',
        'isPrimary': false,
      },
      {
        'title': 'GoPay Wallet',
        'type': 'E-Wallet',
        'amount': '5000000',
        'icon': LucideIcons.wallet,
        'iconColor': const Color(0xFF00AED6),
        'accountNumber': '0812 •••• 9920',
        'isPrimary': false,
      },
      {
        'title': 'OVO Cash',
        'type': 'E-Wallet',
        'amount': '1250000',
        'icon': LucideIcons.smartphone,
        'iconColor': const Color(0xFF8B5CF6),
        'accountNumber': '0812 •••• 9920',
        'isPrimary': false,
      },
    ];

    return Container(
      key: const ValueKey('SemuaKantongSubPage'),
      color: surfaceColor,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth >= 1024;

          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: isDesktop ? 1080 : 600),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    decoration: const BoxDecoration(
                      color: BerandaScreen.primaryRoyalBlue,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: _handleBackPress,
                          icon: const Icon(LucideIcons.arrowLeft, color: Colors.white, size: 22),
                          tooltip: 'Kembali',
                        ),
                        const SizedBox(width: 8),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Kantong Keuangan',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              '4 Akun Terhubung',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.white70,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(LucideIcons.plus, size: 16, color: BerandaScreen.primaryRoyalBlue),
                          label: Text(
                            isDesktop ? 'Tambah Kantong' : 'Tambah',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: BerandaScreen.primaryRoyalBlue,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF0052FF), Color(0xFF1E40AF)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'TOTAL AKUMULASI KANTONG',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white70,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Rp 254.450.000',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    fontFamily: 'monospace',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Daftar Kantong Aktif',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: isDesktop ? 2 : 1,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                childAspectRatio: isDesktop ? 2.2 : 2.8,
                              ),
                              itemCount: allWallets.length,
                              itemBuilder: (context, index) {
                                final item = allWallets[index];
                                return _buildFullWalletCardDetail(
                                  item: item,
                                  cardBg: cardBg,
                                  borderColor: borderColor,
                                  textColor: textColor,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFullWalletCardDetail({
    required Map<String, dynamic> item,
    required Color cardBg,
    required Color borderColor,
    required Color textColor,
  }) {
    final title = item['title'] as String;
    final type = item['type'] as String;
    final formattedAmount = _formatCurrency(item['amount']);
    final accountNumber = item['accountNumber'] as String;
    final isPrimary = item['isPrimary'] as bool? ?? false;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isPrimary ? BerandaScreen.primaryRoyalBlue : borderColor,
          width: isPrimary ? 1.5 : 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  if (item['badgeText'] != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: item['badgeBg'] as Color,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        item['badgeText'] as String,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    )
                  else if (item['icon'] != null)
                    Icon(item['icon'] as IconData, color: item['iconColor'] as Color, size: 14),
                  const SizedBox(width: 6),
                  Text(
                    type,
                    style: const TextStyle(fontSize: 10, color: BerandaScreen.textMuted, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              if (isPrimary)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: BerandaScreen.primaryRoyalBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(' Utama ', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: BerandaScreen.primaryRoyalBlue)),
                ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: textColor),
              ),
              Text(
                accountNumber,
                style: const TextStyle(fontSize: 9, color: BerandaScreen.textMuted),
              ),
              const SizedBox(height: 4),
              Text(
                formattedAmount,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: textColor,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- KANTONG KEUANGAN HOME SUMMARY ---
  Widget _buildKantongKeuanganSection(Color textColor, Color cardBg, Color borderColor, bool isDark, bool isDesktop) {
    final whiteCardBg = isDark ? const Color(0xFF111827) : Colors.white;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Kantong Keuangan',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: textColor,
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  _showAllKantongSubPage = true;
                });
              },
              borderRadius: BorderRadius.circular(6),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Row(
                  children: [
                    Text(
                      'Lihat Semua',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: BerandaScreen.primaryRoyalBlue,
                      ),
                    ),
                    Icon(LucideIcons.chevronRight, size: 14, color: BerandaScreen.primaryRoyalBlue),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: isDesktop ? 4 : 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: isDesktop ? 2.0 : 1.8,
          children: [
            _buildFlatWalletCard(
              badgeText: 'BSI',
              badgeBg: const Color(0xFF00A39D),
              title: 'BSI Hasanah',
              amount: 'Rp 186.750.000',
              cardBg: whiteCardBg,
              borderColor: borderColor,
              textColor: textColor,
            ),
            _buildFlatWalletCard(
              badgeText: 'MANDIRI',
              badgeBg: const Color(0xFFF59E0B),
              title: 'Mandiri Muda',
              amount: 'Rp 12.400.000',
              cardBg: whiteCardBg,
              borderColor: borderColor,
              textColor: textColor,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFlatWalletCard({
    String? badgeText,
    Color? badgeBg,
    required String title,
    required String amount,
    required Color cardBg,
    required Color borderColor,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (badgeText != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: badgeBg,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                badgeText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 10, color: BerandaScreen.textMuted, fontWeight: FontWeight.w500),
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  amount,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: textColor,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- QUICK ACTIONS ---
  Widget _buildQuickActionsSection(Color textColor, bool isDark, bool isDesktop) {
    final actions = [
      {'label': 'Scan', 'icon': LucideIcons.qrCode, 'color': const Color(0xFFF59E0B)},
      {'label': 'Transfer', 'icon': LucideIcons.arrowLeftRight, 'color': BerandaScreen.primaryRoyalBlue},
      {'label': 'Berulang', 'icon': LucideIcons.repeat, 'color': const Color(0xFF10B981)},
      {'label': 'Tujuan', 'icon': LucideIcons.target, 'color': const Color(0xFF8B5CF6)},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: actions.map((act) {
        final color = act['color'] as Color;
        return Column(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
              child: Icon(act['icon'] as IconData, color: Colors.white, size: 18),
            ),
            const SizedBox(height: 4),
            Text(
              act['label'] as String,
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: textColor),
            ),
          ],
        );
      }).toList(),
    );
  }

  // --- MY INSIGHT ---
  Widget _buildMyInsightCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111827) : const Color(0xFFF0F7FF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: BerandaScreen.primaryRoyalBlue.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          const Icon(LucideIcons.sparkles, color: Color(0xFFF59E0B), size: 16),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Pengeluaran menurun 12%! Hemat Rp 1.450.000 minggu ini.',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : BerandaScreen.textDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- OVERVIEW KEUANGAN ---
  Widget _buildOverviewKeuanganSection(Color textColor, Color cardBg, Color borderColor, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111827) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('SISA BUDGET', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: BerandaScreen.textMuted)),
                Text('Rp 3.250.000', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: textColor, fontFamily: 'monospace')),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: const LinearProgressIndicator(value: 0.65, minHeight: 4, backgroundColor: Color(0xFFE2E8F0), valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF59E0B))),
                ),
              ],
            ),
          ),
          Container(width: 1, height: 40, color: borderColor, margin: const EdgeInsets.symmetric(horizontal: 12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('TUJUAN KEUANGAN', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: BerandaScreen.textMuted)),
                Text('Rp 15,5 Jt / 20 Jt', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: textColor, fontFamily: 'monospace')),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: const LinearProgressIndicator(value: 0.77, minHeight: 4, backgroundColor: Color(0xFFE2E8F0), valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8B5CF6))),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- RECENT TRANSACTIONS ---
  Widget _buildRecentTransactionsSection(List riwayat, Color textColor, Color cardBg, Color borderColor, bool isDark) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Recent Transactions', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: textColor)),
            const Text('Lihat Riwayat >', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: BerandaScreen.primaryRoyalBlue)),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF111827) : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            children: riwayat.map((item) {
              final isPemasukan = item['jenis'].toString().toLowerCase().contains('pemasukan');
              final iconBg = (item['iconBg'] as Color?) ?? (isPemasukan ? const Color(0xFF10B981) : const Color(0xFF0F172A));
              final formattedNominal = _formatCurrency(item['nominal']);

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: iconBg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon((item['icon'] as IconData?) ?? LucideIcons.receipt, color: Colors.white, size: 15),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['judul']?.toString() ?? 'Transaksi',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textColor),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text('${item['tanggal']} • ${item['kategori']}', style: const TextStyle(fontSize: 9, color: BerandaScreen.textMuted)),
                        ],
                      ),
                    ),
                    Text(
                      isPemasukan ? '+$formattedNominal' : '-$formattedNominal',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        color: isPemasukan ? const Color(0xFF10B981) : BerandaScreen.textDark,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
