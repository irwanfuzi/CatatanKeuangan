import 'package:flutter/material.dart';

class BerandaScreen extends StatelessWidget {
  final Map<String, dynamic>? summaryData;
  final VoidCallback? onNavigateToAnalisis;

  const BerandaScreen({
    super.key,
    this.summaryData,
    this.onNavigateToAnalisis,
  });

  // Premium Palette Rules
  static const Color primaryRoyalBlue = Color(0xFF0052FF);
  static const Color accentNotificationOrange = Color(0xFFFF9F00);
  static const Color textDark = Color(0xFF0F172A);
  static const Color textMuted = Color(0xFF64748B);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final saldo = summaryData?['saldo'] ?? 'Rp 642.795.000';
    final List riwayat = summaryData?['riwayat'] as List? ?? [];
    final recentTransactions = riwayat.take(5).toList();

    return Scaffold(
      backgroundColor: primaryRoyalBlue, // Latar atas menyatu dengan Top Bar
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 1024;

            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: isDesktop ? 1080 : 540),
                child: Column(
                  children: [
                    // 1. TOP APP BAR (Avatar Kiri | MyKas Tengah | Lonceng + Badge Kanan)
                    _buildTopAppBar(context),

                    // 2. HERO TOTAL SALDO SECTION
                    _buildHeroTotalSaldo(saldo),

                    const SizedBox(height: 16),

                    // 3. MAIN CONTENT SHEET (WHITE ROUNDED SURFACE)
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF0B0F19) : Colors.white,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                        ),
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Indicator handle bar
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

                              // 4. KANTONG KEUANGAN SECTION (GRID 2x2)
                              _buildKantongKeuanganSection(isDark),

                              const SizedBox(height: 24),

                              // 5. TRANSAKSI TERBARU SECTION
                              _buildRecentTransactionsHeader(isDark),
                              const SizedBox(height: 12),

                              if (recentTransactions.isEmpty)
                                _buildEmptyState(isDark)
                              else
                                ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: recentTransactions.length,
                                  separatorBuilder: (context, index) => const SizedBox(height: 10),
                                  itemBuilder: (context, index) {
                                    final item = recentTransactions[index];
                                    final isPemasukan = item['jenis'].toString().toLowerCase().contains('pemasukan');

                                    return _buildTransactionTile(
                                      item: item,
                                      isPemasukan: isPemasukan,
                                      isDark: isDark,
                                    );
                                  },
                                ),

                              const SizedBox(height: 32),
                            ],
                          ),
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

  // --- 1. TOP APP BAR EXACT SPEC ---
  Widget _buildTopAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // KIRI: Avatar User
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 42,
              height: 42,
              decoration: const BoxDecoration(
                color: Colors.white24,
                shape: BoxShape.circle,
              ),
              child: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person_rounded, color: primaryRoyalBlue, size: 24),
              ),
            ),
          ),

          // TENGAH: Title MyKas
          const Text(
            'MyKas',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),

          // KANAN: Lonceng Notifikasi + Badge Angka
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(20),
              child: SizedBox(
                width: 40,
                height: 40,
                child: Stack(
                  children: [
                    const Center(
                      child: Icon(
                        Icons.notifications_none_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    // Badge Jumlah Notifikasi
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
                          minWidth: 18,
                          minHeight: 18,
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

  // --- 2. HERO TOTAL SALDO ---
  Widget _buildHeroTotalSaldo(String saldo) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
    );
  }

  // --- 3. KANTONG KEUANGAN SECTION ---
  Widget _buildKantongKeuanganSection(bool isDark) {
    final textColor = isDark ? Colors.white : textDark;
    final cardBg = isDark ? const Color(0xFF111827) : const Color(0xFFF8FAFC);
    final borderColor = isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0);

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

        // Grid 2x2 Kantong
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.45,
          children: [
            _buildPocketCard(
              badgeText: 'BSI',
              badgeBg: const Color(0xFF00A39D),
              title: 'BSI Debit Hasanah',
              amount: 'Rp 186.750.000',
              cardBg: cardBg,
              borderColor: borderColor,
              textColor: textColor,
            ),
            _buildPocketCard(
              badgeText: 'MANDIRI',
              badgeBg: const Color(0xFFF59E0B),
              title: 'Taplus Muda Mandiri',
              amount: 'Rp 12.400.000',
              cardBg: cardBg,
              borderColor: borderColor,
              textColor: textColor,
            ),
            _buildPocketCard(
              icon: Icons.account_balance_wallet_rounded,
              iconColor: const Color(0xFF00AED6),
              title: 'GoPay Wallet',
              amount: 'Rp 5.000.000',
              hasArrow: true,
              cardBg: cardBg,
              borderColor: borderColor,
              textColor: textColor,
            ),
            _buildAddAccountCard(isDark),
          ],
        ),
      ],
    );
  }

  Widget _buildPocketCard({
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
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor, width: 1),
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

  Widget _buildAddAccountCard(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? const Color(0xFF374151) : const Color(0xFFCBD5E1),
          width: 1.5,
        ),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xFFEFF6FF),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.add_rounded, color: primaryRoyalBlue, size: 20),
          ),
          SizedBox(height: 8),
          Text(
            'Tambah Akun',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: textMuted,
            ),
          ),
        ],
      ),
    );
  }

  // --- 4. TRANSAKSI TERBARU ---
  Widget _buildRecentTransactionsHeader(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Transaksi Terbaru',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: isDark ? Colors.white : textDark,
          ),
        ),
        const Text(
          'Lihat Semua',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: primaryRoyalBlue,
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionTile({
    required Map<String, dynamic> item,
    required bool isPemasukan,
    required bool isDark,
  }) {
    final title = item['judul'] ?? item['kategori'] ?? 'Transaksi';
    final date = item['tanggal'] ?? 'Hari ini';
    final amount = item['nominal']?.toString() ?? 'Rp 0';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111827) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (isPemasukan ? const Color(0xFF10B981) : const Color(0xFFEF4444)).withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isPemasukan ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
              color: isPemasukan ? const Color(0xFF10B981) : const Color(0xFFEF4444),
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
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  date,
                  style: const TextStyle(fontSize: 10, color: textMuted),
                ),
              ],
            ),
          ),
          Text(
            isPemasukan ? '+$amount' : '-$amount',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w900,
              color: isPemasukan ? const Color(0xFF10B981) : const Color(0xFFEF4444),
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111827) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(
        child: Text(
          'Belum ada transaksi tercatat',
          style: TextStyle(color: textMuted, fontSize: 12),
        ),
      ),
    );
  }
}
