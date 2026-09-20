import 'package:flutter/material.dart';

class BerandaScreen extends StatelessWidget {
  final Map<String, dynamic>? summaryData;
  final VoidCallback? onNavigateToAnalisis;

  const BerandaScreen({
    super.key,
    this.summaryData,
    this.onNavigateToAnalisis,
  });

  // Strict Brand Design Palette
  static const Color primaryRoyalBlue = Color(0xFF0052FF);
  static const Color accentNotificationOrange = Color(0xFFFF9F00);
  static const Color textDark = Color(0xFF0F172A);
  static const Color textMuted = Color(0xFF64748B);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final saldo = summaryData?['saldo'] ?? 'Rp 642.795.000';
    final List riwayat = summaryData?['riwayat'] as List? ?? [
      {
        'judul': 'Apple Store',
        'kategori': 'BSI Debit',
        'tanggal': 'Today, 10:23 AM',
        'nominal': 'Rp 1.950.000',
        'jenis': 'pengeluaran',
        'icon': Icons.apple,
        'iconBg': const Color(0xFF0F172A),
      },
      {
        'judul': 'Tokopedia',
        'kategori': 'Mandiri Virtual',
        'tanggal': 'Yesterday, 19:40',
        'nominal': 'Rp 620.000',
        'jenis': 'pengeluaran',
        'icon': Icons.shopping_bag_outlined,
        'iconBg': const Color(0xFF10B981),
      },
      {
        'judul': 'Transfer BSI',
        'kategori': 'Payroll Inflow',
        'tanggal': '22 Mei, 14:15',
        'nominal': 'Rp 8.500.000',
        'jenis': 'pemasukan',
        'icon': Icons.south_west_rounded,
        'iconBg': const Color(0xFF06B6D4),
      },
      {
        'judul': 'GoFood',
        'kategori': 'GoPay Linked',
        'tanggal': '21 Mei, 12:30',
        'nominal': 'Rp 78.500',
        'jenis': 'pengeluaran',
        'icon': Icons.fastfood_outlined,
        'iconBg': const Color(0xFFF43F5E),
      },
      {
        'judul': 'Starbucks Coffee',
        'kategori': 'QRIS Debit',
        'tanggal': '20 Mei, 08:45',
        'nominal': 'Rp 58.000',
        'jenis': 'pengeluaran',
        'icon': Icons.coffee_outlined,
        'iconBg': const Color(0xFF059669),
      },
    ];

    final surfaceColor = isDark ? const Color(0xFF0B0F19) : Colors.white;
    final cardBg = isDark ? const Color(0xFF111827) : const Color(0xFFF8FAFC);
    final borderColor = isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0);
    final textColor = isDark ? Colors.white : textDark;

    return Scaffold(
      backgroundColor: primaryRoyalBlue,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 1024;

            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: isDesktop ? 1080 : 540),
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    // 1. COLLAPSIBLE ROYAL BLUE HEADER WITH STICKY TOP APP BAR
                    SliverAppBar(
                      pinned: true,
                      expandedHeight: 180.0,
                      backgroundColor: primaryRoyalBlue,
                      elevation: 0,
                      automaticallyImplyLeading: false,
                      flexibleSpace: FlexibleSpaceBar(
                        collapseMode: CollapseMode.pin,
                        background: Padding(
                          padding: const EdgeInsets.only(top: 60.0, left: 24.0, right: 24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Row(
                                children: [
                                  Text(
                                    'Total Saldo',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  SizedBox(width: 6),
                                  Icon(Icons.visibility_outlined, color: Colors.white70, size: 16),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                saldo,
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  fontFamily: 'monospace',
                                  letterSpacing: -1.0,
                                ),
                              ),
                              const SizedBox(height: 6),
                              const Row(
                                children: [
                                  Icon(Icons.access_time_rounded, color: Colors.white60, size: 12),
                                  SizedBox(width: 4),
                                  Text(
                                    'Updated 2m ago',
                                    style: TextStyle(fontSize: 11, color: Colors.white60, fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      title: _buildStickyTopAppBar(context),
                      titleSpacing: 0,
                    ),

                    // 2. WHITE CANVAS SHEET CONTAINING MAIN APP CONTENT
                    SliverToBoxAdapter(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: surfaceColor,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                        ),
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Handle bar
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
                            const SizedBox(height: 18),

                            // KANTONG KEUANGAN (STRICT 2x2 GRID & ALL WHITE FLAT CARDS)
                            _buildKantongKeuanganSection(textColor, cardBg, borderColor, isDark),
                            const SizedBox(height: 24),

                            // QUICK ACTIONS (PERFECT CIRCLES ONLY)
                            _buildQuickActionsSection(textColor, isDark),
                            const SizedBox(height: 20),

                            // MY INSIGHT CARD
                            _buildMyInsightCard(isDark),
                            const SizedBox(height: 20),

                            // OVERVIEW KEUANGAN (BUDGET & GOALS SPLIT)
                            _buildOverviewKeuanganSection(textColor, cardBg, borderColor, isDark),
                            const SizedBox(height: 24),

                            // RECENT TRANSACTIONS
                            _buildRecentTransactionsSection(riwayat, textColor, cardBg, borderColor, isDark),
                            const SizedBox(height: 40),
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
      ),
    );
  }

  // --- 1. STICKY TOP APP BAR ---
  Widget _buildStickyTopAppBar(BuildContext context) {
    return Container(
      color: primaryRoyalBlue,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Left: User Avatar
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 38,
              height: 38,
              decoration: const BoxDecoration(
                color: Colors.white24,
                shape: BoxShape.circle,
              ),
              child: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person_rounded, color: primaryRoyalBlue, size: 22),
              ),
            ),
          ),

          // Center: Title MyKas
          const Text(
            'MyKas',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),

          // Right: Bell + Notification Badge
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(20),
              child: SizedBox(
                width: 38,
                height: 38,
                child: Stack(
                  children: [
                    const Center(
                      child: Icon(
                        Icons.notifications_none_rounded,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                    Positioned(
                      top: 2,
                      right: 2,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: accentNotificationOrange,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 17,
                          minHeight: 17,
                        ),
                        child: const Center(
                          child: Text(
                            '3',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- 2. KANTONG KEUANGAN (2x2 GRID ALL WHITE FLAT CARDS) ---
  Widget _buildKantongKeuanganSection(Color textColor, Color cardBg, Color borderColor, bool isDark) {
    final whiteCardBg = isDark ? const Color(0xFF111827) : Colors.white;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  'Kantong Keuangan',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: textColor,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: primaryRoyalBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    '4 Terhubung',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: primaryRoyalBlue,
                    ),
                  ),
                ),
              ],
            ),
            InkWell(
              onTap: () {},
              child: const Row(
                children: [
                  Text(
                    'Lihat Semua',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: primaryRoyalBlue,
                    ),
                  ),
                  SizedBox(width: 2),
                  Icon(Icons.chevron_right_rounded, size: 16, color: primaryRoyalBlue),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Strict 2x2 Grid (2 Columns, 2 Rows)
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.4,
          children: [
            // Slot 1: BSI
            _buildFlatWalletCard(
              badgeText: 'BSI',
              badgeBg: const Color(0xFF00A39D),
              title: 'BSI Debit Hasanah',
              amount: 'Rp 186.750.000',
              cardBg: whiteCardBg,
              borderColor: borderColor,
              textColor: textColor,
            ),
            // Slot 2: Mandiri
            _buildFlatWalletCard(
              badgeText: 'MANDIRI',
              badgeBg: const Color(0xFFF59E0B),
              title: 'Taplus Muda Mandiri',
              amount: 'Rp 12.400.000',
              cardBg: whiteCardBg,
              borderColor: borderColor,
              textColor: textColor,
            ),
            // Slot 3: GoPay Wallet
            _buildFlatWalletCard(
              icon: Icons.account_balance_wallet_rounded,
              iconColor: const Color(0xFF00AED6),
              title: 'GoPay Wallet',
              amount: 'Rp 5.000.000',
              hasArrow: true,
              cardBg: whiteCardBg,
              borderColor: borderColor,
              textColor: textColor,
            ),
            // Slot 4: + Tambah Akun (Dashed Border Card)
            _buildDashedAddAccountCard(isDark),
          ],
        ),
      ],
    );
  }

  Widget _buildFlatWalletCard({
    String? badgeText,
    Color? badgeBg,
    IconData? icon,
    Color? iconColor,
    required String title,
    required String amount,
    bool hasArrow = false,
    required Color cardBg,
    required Color borderColor,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (badgeText != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: badgeBg,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    badgeText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                )
              else if (icon != null)
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: (iconColor ?? primaryRoyalBlue).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: iconColor, size: 16),
                ),
              if (hasArrow)
                const Icon(Icons.chevron_right_rounded, size: 16, color: textMuted),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 11, color: textMuted, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 2),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  amount,
                  style: TextStyle(
                    fontSize: 13,
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

  // Strictly non-const method without illegal const constructors
  Widget _buildDashedAddAccountCard(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF374151) : const Color(0xFFCBD5E1),
          width: 1.5,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFFEFF6FF),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.add_rounded, color: primaryRoyalBlue, size: 20),
          ),
          const SizedBox(height: 6),
          const Text(
            '+ Tambah Akun',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: textMuted,
            ),
          ),
        ],
      ),
    );
  }

  // --- 3. QUICK ACTIONS (PERFECT CIRCLES ONLY) ---
  Widget _buildQuickActionsSection(Color textColor, bool isDark) {
    final actions = [
      {'label': 'Scan Struk', 'icon': Icons.qr_code_scanner_rounded, 'color': const Color(0xFFF59E0B)},
      {'label': 'Transfer', 'icon': Icons.swap_horiz_rounded, 'color': primaryRoyalBlue},
      {'label': 'Berulang', 'icon': Icons.autorenew_rounded, 'color': const Color(0xFF10B981)},
      {'label': 'Tujuan', 'icon': Icons.track_changes_rounded, 'color': const Color(0xFF8B5CF6)},
    ];

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Quick Actions', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: textColor)),
            const Text('Edit', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: primaryRoyalBlue)),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: actions.map((act) {
            final color = act['color'] as Color;
            return Column(
              children: [
                // PERFECT CIRCLE BACKGROUND
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(act['icon'] as IconData, color: Colors.white, size: 24),
                ),
                const SizedBox(height: 8),
                Text(
                  act['label'] as String,
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: textColor),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  // --- 4. MY INSIGHT CARD ---
  Widget _buildMyInsightCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111827) : const Color(0xFFF0F7FF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: primaryRoyalBlue.withOpacity(0.15)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.auto_awesome_rounded, color: Color(0xFFF59E0B), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Insight',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Pengeluaran menurun 12%! Hemat Rp 1.450.000 pada pos non-primer dibanding minggu lalu.',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? const Color(0xFF9CA3AF) : textMuted,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- 5. OVERVIEW KEUANGAN ---
  Widget _buildOverviewKeuanganSection(Color textColor, Color cardBg, Color borderColor, bool isDark) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Overview Keuangan', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: textColor)),
            InkWell(
              onTap: onNavigateToAnalisis,
              child: const Text('Lihat Detail >', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: primaryRoyalBlue)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF111827) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            children: [
              // Sisa Budget
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('SISA BUDGET', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: textMuted)),
                    const SizedBox(height: 4),
                    Text('Rp 3.250.000', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: textColor, fontFamily: 'monospace')),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: const LinearProgressIndicator(value: 0.65, minHeight: 6, backgroundColor: Color(0xFFE2E8F0), valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF59E0B))),
                    ),
                    const SizedBox(height: 6),
                    const Text('Terpakai 65% • 10 hr tersisa', style: TextStyle(fontSize: 9, color: textMuted, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Container(width: 1, height: 60, color: borderColor, margin: const EdgeInsets.symmetric(horizontal: 14)),
              // Tujuan Keuangan
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('TUJUAN KEUANGAN', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: textMuted)),
                    const SizedBox(height: 4),
                    Text('Rp 15,5 Jt / 20 Jt', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: textColor, fontFamily: 'monospace')),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: const LinearProgressIndicator(value: 0.77, minHeight: 6, backgroundColor: Color(0xFFE2E8F0), valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8B5CF6))),
                    ),
                    const SizedBox(height: 6),
                    const Text('3 dari 4 Target On-Track', style: TextStyle(fontSize: 9, color: Color(0xFF10B981), fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- 6. RECENT TRANSACTIONS ---
  Widget _buildRecentTransactionsSection(List riwayat, Color textColor, Color cardBg, Color borderColor, bool isDark) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Recent Transactions', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: textColor)),
            const Text('Lihat Riwayat >', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: primaryRoyalBlue)),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF111827) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: borderColor),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: riwayat.length,
            separatorBuilder: (context, index) => Divider(color: borderColor, height: 1),
            itemBuilder: (context, index) {
              final item = riwayat[index];
              final isPemasukan = item['jenis'].toString().toLowerCase().contains('pemasukan');
              final iconBg = (item['iconBg'] as Color?) ?? (isPemasukan ? const Color(0xFF10B981) : const Color(0xFF0F172A));

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: iconBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon((item['icon'] as IconData?) ?? Icons.receipt_long_rounded, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item['judul']?.toString() ?? 'Transaksi', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: textColor)),
                          const SizedBox(height: 2),
                          Text('${item['tanggal']} • ${item['kategori']}', style: const TextStyle(fontSize: 10, color: textMuted)),
                        ],
                      ),
                    ),
                    Text(
                      isPemasukan ? '+${item['nominal']}' : '-${item['nominal']}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: isPemasukan ? const Color(0xFF10B981) : textDark,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
