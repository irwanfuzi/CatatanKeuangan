import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class BerandaScreen extends StatelessWidget {
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
        'icon': LucideIcons.laptop,
        'iconBg': const Color(0xFF0F172A),
      },
      {
        'judul': 'Tokopedia',
        'kategori': 'Mandiri Virtual',
        'tanggal': 'Yesterday, 19:40',
        'nominal': 'Rp 620.000',
        'jenis': 'pengeluaran',
        'icon': LucideIcons.shoppingBag,
        'iconBg': const Color(0xFF10B981),
      },
      {
        'judul': 'Transfer BSI',
        'kategori': 'Payroll Inflow',
        'tanggal': '22 Mei, 14:15',
        'nominal': 'Rp 8.500.000',
        'jenis': 'pemasukan',
        'icon': LucideIcons.arrowDownLeft,
        'iconBg': const Color(0xFF06B6D4),
      },
      {
        'judul': 'GoFood',
        'kategori': 'GoPay Linked',
        'tanggal': '21 Mei, 12:30',
        'nominal': 'Rp 78.500',
        'jenis': 'pengeluaran',
        'icon': LucideIcons.utensils,
        'iconBg': const Color(0xFFF43F5E),
      },
      {
        'judul': 'Starbucks Coffee',
        'kategori': 'QRIS Debit',
        'tanggal': '20 Mei, 08:45',
        'nominal': 'Rp 58.000',
        'jenis': 'pengeluaran',
        'icon': LucideIcons.coffee,
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
                    // DYNAMIC COLLAPSIBLE HEADER WITH SHRINKING TOP BAR
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: _CollapsingHeaderDelegate(
                        saldo: saldo,
                        minHeight: 64.0,
                        maxHeight: 180.0,
                      ),
                    ),

                    // MAIN WHITE SHEET CANVAS
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

                            // KANTONG KEUANGAN (2x2 FLAT WHITE CARDS)
                            _buildKantongKeuanganSection(textColor, cardBg, borderColor, isDark),
                            const SizedBox(height: 24),

                            // QUICK ACTIONS (PERFECT CIRCLE LUCIDE ICONS)
                            _buildQuickActionsSection(textColor, isDark),
                            const SizedBox(height: 20),

                            // MY INSIGHT CARD
                            _buildMyInsightCard(isDark),
                            const SizedBox(height: 20),

                            // OVERVIEW KEUANGAN
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

  // --- KANTONG KEUANGAN ---
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
                  Icon(LucideIcons.chevronRight, size: 16, color: primaryRoyalBlue),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.4,
          children: [
            _buildFlatWalletCard(
              badgeText: 'BSI',
              badgeBg: const Color(0xFF00A39D),
              title: 'BSI Debit Hasanah',
              amount: 'Rp 186.750.000',
              cardBg: whiteCardBg,
              borderColor: borderColor,
              textColor: textColor,
            ),
            _buildFlatWalletCard(
              badgeText: 'MANDIRI',
              badgeBg: const Color(0xFFF59E0B),
              title: 'Taplus Muda Mandiri',
              amount: 'Rp 12.400.000',
              cardBg: whiteCardBg,
              borderColor: borderColor,
              textColor: textColor,
            ),
            _buildFlatWalletCard(
              icon: LucideIcons.wallet,
              iconColor: const Color(0xFF00AED6),
              title: 'GoPay Wallet',
              amount: 'Rp 5.000.000',
              hasArrow: true,
              cardBg: whiteCardBg,
              borderColor: borderColor,
              textColor: textColor,
            ),
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
                const Icon(LucideIcons.chevronRight, size: 16, color: textMuted),
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
            child: const Icon(LucideIcons.plus, color: primaryRoyalBlue, size: 18),
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

  // --- QUICK ACTIONS ---
  Widget _buildQuickActionsSection(Color textColor, bool isDark) {
    final actions = [
      {'label': 'Scan Struk', 'icon': LucideIcons.qrCode, 'color': const Color(0xFFF59E0B)},
      {'label': 'Transfer', 'icon': LucideIcons.arrowLeftRight, 'color': primaryRoyalBlue},
      {'label': 'Berulang', 'icon': LucideIcons.repeat, 'color': const Color(0xFF10B981)},
      {'label': 'Tujuan', 'icon': LucideIcons.target, 'color': const Color(0xFF8B5CF6)},
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
                  child: Icon(act['icon'] as IconData, color: Colors.white, size: 22),
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

  // --- MY INSIGHT ---
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
          const Icon(LucideIcons.sparkles, color: Color(0xFFF59E0B), size: 18),
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

  // --- OVERVIEW KEUANGAN ---
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

  // --- RECENT TRANSACTIONS ---
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
                      child: Icon((item['icon'] as IconData?) ?? LucideIcons.receipt, color: Colors.white, size: 18),
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

// =========================================================================
// CUSTOM SLIVER PERSISTENT HEADER DELEGATE FOR SHRINKING TOP APP BAR
// =========================================================================
class _CollapsingHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String saldo;
  final double minHeight;
  final double maxHeight;

  _CollapsingHeaderDelegate({
    required this.saldo,
    required this.minHeight,
    required this.maxHeight,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    // Rasio scroll dari 0.0 (Expanded) ke 1.0 (Collapsed)
    final progress = (shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0);
    // Skala penyusutan elemen Top Bar dari 1.0 ke 0.78
    final topBarScale = 1.0 - (progress * 0.22);
    // Opacity informasi Total Saldo
    final saldoOpacity = (1.0 - (progress * 1.8)).clamp(0.0, 1.0);

    return Container(
      color: BerandaScreen.primaryRoyalBlue,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 1. DYNAMIC SHRINKING TOP BAR (Avatar, MyKas, Bell)
          Positioned(
            top: 8,
            left: 20,
            right: 20,
            child: Transform.scale(
              scale: topBarScale,
              alignment: Alignment.center,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Kiri: Avatar User (36px)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: Colors.white24,
                        shape: BoxShape.circle,
                      ),
                      child: const CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(LucideIcons.user, color: BerandaScreen.primaryRoyalBlue, size: 20),
                      ),
                    ),
                  ),

                  // Tengah: MyKas (Semi-Bold)
                  const Text(
                    'MyKas',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600, // <--- Semi-Bold
                      color: Colors.white,
                      letterSpacing: -0.4,
                    ),
                  ),

                  // Kanan: Lucide Bell + Badge
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.circular(18),
                      child: SizedBox(
                        width: 36,
                        height: 36,
                        child: Stack(
                          children: [
                            const Center(
                              child: Icon(
                                LucideIcons.bell, // <--- Lucide Icon
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                            Positioned(
                              top: 2,
                              right: 2,
                              child: Container(
                                padding: const EdgeInsets.all(3),
                                decoration: const BoxDecoration(
                                  color: BerandaScreen.accentNotificationOrange,
                                  shape: BoxShape.circle,
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 16,
                                  minHeight: 16,
                                ),
                                child: const Center(
                                  child: Text(
                                    '3',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 9,
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
            ),
          ),

          // 2. TOTAL SALDO SECTION (Fades out on scroll)
          Positioned(
            bottom: 12,
            left: 24,
            right: 24,
            child: Opacity(
              opacity: saldoOpacity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Row(
                    children: [
                      Text(
                        'Total Saldo',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white70,
                        ),
                      ),
                      SizedBox(width: 6),
                      Icon(LucideIcons.eye, color: Colors.white70, size: 14),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    saldo,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      fontFamily: 'monospace',
                      letterSpacing: -1.0,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Row(
                    children: [
                      Icon(LucideIcons.clock, color: Colors.white60, size: 11),
                      SizedBox(width: 4),
                      Text(
                        'Updated 2m ago',
                        style: TextStyle(fontSize: 10, color: Colors.white60, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _CollapsingHeaderDelegate oldDelegate) {
    return oldDelegate.saldo != saldo ||
        oldDelegate.minHeight != minHeight ||
        oldDelegate.maxHeight != maxHeight;
  }
}
