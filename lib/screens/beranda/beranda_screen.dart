import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final surfaceBg = isDark ? AppTheme.bgDark : AppTheme.bgLight;
    final cardBg = isDark ? AppTheme.cardDark : AppTheme.cardLight;
    final textColor = isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight;
    final textMuted = isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight;
    final borderColor = isDark ? AppTheme.borderDark : AppTheme.borderLight;

    return Scaffold(
      backgroundColor: surfaceBg,
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
                    // 1. SLIVER PERSISTENT HEADER (ROYAL BLUE KONSISTEN)
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: _BerandaHeaderDelegate(
                        minHeight: 70.0,
                        maxHeight: 180.0,
                        summaryData: widget.summaryData,
                        isBalanceVisible: _isBalanceVisible,
                        onToggleBalance: () {
                          setState(() {
                            _isBalanceVisible = !_isBalanceVisible;
                          });
                        },
                        onNotificationTap: () => _showNotificationSheet(context),
                      ),
                    ),

                    // 2. KONTEN UTAMA BERANDA
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // SECTION 1: KANTONG KEUANGAN
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Kantong Keuangan',
                                      style: GoogleFonts.urbanist(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                        color: textColor,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppTheme.brandPrimary.withOpacity(0.12),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Text(
                                        '3 Terhubung',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.brandPrimary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                TextButton(
                                  onPressed: () {},
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: const Size(50, 30),
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: const Row(
                                    children: [
                                      Text(
                                        'Lihat Semua',
                                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.brandPrimary),
                                      ),
                                      Icon(LucideIcons.chevronRight, size: 14, color: AppTheme.brandPrimary),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            // GRID KANTONG (RESPONSIF DESKTOP/MOBILE)
                            GridView.count(
                              crossAxisCount: isDesktop ? 3 : 2,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              childAspectRatio: isDesktop ? 2.2 : 1.75,
                              children: [
                                _buildWalletCard(
                                  tag: 'BSI',
                                  tagColor: const Color(0xFF00A39D),
                                  title: 'BSI Debit Hasanah',
                                  balance: _isBalanceVisible ? 'Rp 186.750.000' : '••••••••',
                                  cardBg: cardBg,
                                  borderColor: borderColor,
                                  textColor: textColor,
                                  textMuted: textMuted,
                                ),
                                _buildWalletCard(
                                  tag: 'MANDIRI',
                                  tagColor: const Color(0xFFF59E0B),
                                  title: 'Taplus Muda Mandiri',
                                  balance: _isBalanceVisible ? 'Rp 12.400.000' : '••••••••',
                                  cardBg: cardBg,
                                  borderColor: borderColor,
                                  textColor: textColor,
                                  textMuted: textMuted,
                                ),
                                _buildWalletCard(
                                  tag: 'GOPAY',
                                  tagColor: const Color(0xFF00AED6),
                                  title: 'GoPay Wallet',
                                  balance: _isBalanceVisible ? 'Rp 5.000.000' : '••••••••',
                                  cardBg: cardBg,
                                  borderColor: borderColor,
                                  textColor: textColor,
                                  textMuted: textMuted,
                                ),
                              ],
                            ),

                            const SizedBox(height: 28),

                            // SECTION 2: QUICK ACTIONS
                            Text(
                              'Aksi Cepat',
                              style: GoogleFonts.urbanist(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: textColor,
                              ),
                            ),
                            const SizedBox(height: 14),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildQuickActionButton(
                                  icon: LucideIcons.qrCode,
                                  label: 'Scan Struk',
                                  color: const Color(0xFFD97706),
                                  isDark: isDark,
                                  onTap: () {},
                                ),
                                _buildQuickActionButton(
                                  icon: LucideIcons.arrowLeftRight,
                                  label: 'Transfer',
                                  color: AppTheme.brandPrimary,
                                  isDark: isDark,
                                  onTap: () {},
                                ),
                                _buildQuickActionButton(
                                  icon: LucideIcons.repeat,
                                  label: 'Berulang',
                                  color: const Color(0xFF10B981),
                                  isDark: isDark,
                                  onTap: () {},
                                ),
                                _buildQuickActionButton(
                                  icon: LucideIcons.target,
                                  label: 'Tujuan Kas',
                                  color: const Color(0xFF8B5CF6),
                                  isDark: isDark,
                                  onTap: () {},
                                ),
                              ],
                            ),

                            const SizedBox(height: 28),

                            // SECTION 3: MY INSIGHT CARD
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: cardBg,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: borderColor, width: 1),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF59E0B).withOpacity(0.12),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(LucideIcons.sparkles, color: Color(0xFFF59E0B), size: 20),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Analisis AI Kas',
                                          style: GoogleFonts.urbanist(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: textColor,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'Pengeluaran bulan ini hemat 12%! Kamu berhasil mengalokasikan Rp1.450.000 ke tabungan.',
                                          style: TextStyle(fontSize: 11, color: textMuted, height: 1.3),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (widget.onNavigateToAnalisis != null)
                                    IconButton(
                                      icon: const Icon(LucideIcons.arrowRight, size: 18, color: AppTheme.brandPrimary),
                                      onPressed: widget.onNavigateToAnalisis,
                                    ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 28),

                            // SECTION 4: RIWAYAT TRANSAKSI TERAKHIR
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Transaksi Terakhir',
                                  style: GoogleFonts.urbanist(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: textColor,
                                  ),
                                ),
                                TextButton(
                                  onPressed: widget.onNavigateToAnalisis,
                                  child: const Text(
                                    'Lihat Riwayat',
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.brandPrimary),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),

                            _buildRecentTransactionsList(cardBg, borderColor, textColor, textMuted, isDark),

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

  // WIDGET KARTU KANTONG
  Widget _buildWalletCard({
    required String tag,
    required Color tagColor,
    required String title,
    required String balance,
    required Color cardBg,
    required Color borderColor,
    required Color textColor,
    required Color textMuted,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: tagColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              tag,
              style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: tagColor),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 11, color: textMuted, fontWeight: FontWeight.w500),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                balance,
                style: GoogleFonts.urbanist(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: textColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // WIDGET AKSI CEPAT
  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: color.withOpacity(0.2), width: 1),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight,
          ),
        ),
      ],
    );
  }

  // DAFTAR TRANSAKSI RINGKAS BERANDA
  Widget _buildRecentTransactionsList(Color cardBg, Color borderColor, Color textColor, Color textMuted, bool isDark) {
    final List rawRiwayat = widget.summaryData['riwayat'] as List? ?? [
      {'Keterangan': 'Uang Bulanan', 'Nominal': '2500000', 'Jenis': 'Pemasukan', 'Kategori': 'Gaji', 'Tanggal': '28/06/2026'},
      {'Keterangan': 'Aeon Mall', 'Nominal': '111812', 'Jenis': 'Pengeluaran', 'Kategori': 'Makanan', 'Tanggal': '28/06/2026'},
      {'Keterangan': 'CO Masker', 'Nominal': '68000', 'Jenis': 'Pengeluaran', 'Kategori': 'Lainnya', 'Tanggal': '28/06/2026'},
    ];

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: rawRiwayat.length > 3 ? 3 : rawRiwayat.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final item = rawRiwayat[index];
        final jenis = (item['Jenis'] ?? item['jenis'] ?? '').toString().toLowerCase();
        final isPemasukan = jenis.contains('pema') || jenis.contains('in');
        final title = item['Keterangan'] ?? item['keterangan'] ?? item['judul'] ?? 'Transaksi';
        final nominal = item['Nominal'] ?? item['nominal'] ?? '0';

        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor, width: 1),
          ),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: isPemasukan ? const Color(0xFF10B981).withOpacity(0.12) : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  isPemasukan ? LucideIcons.arrowDownLeft : LucideIcons.arrowUpRight,
                  color: isPemasukan ? const Color(0xFF10B981) : (isDark ? Colors.white70 : const Color(0xFF475569)),
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title.toString(),
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textColor),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      item['Tanggal']?.toString() ?? 'Hari ini',
                      style: TextStyle(fontSize: 10, color: textMuted),
                    ),
                  ],
                ),
              ),
              Text(
                '${isPemasukan ? '+' : '-'}Rp $nominal',
                style: GoogleFonts.urbanist(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: isPemasukan ? const Color(0xFF10B981) : textColor,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showNotificationSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(LucideIcons.bell, size: 36, color: AppTheme.brandPrimary),
            const SizedBox(height: 12),
            Text('Notifikasi Kas', style: GoogleFonts.urbanist(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Semua catatan kas kamu telah tersinkronisasi otomatis.', style: TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// HEADER DELEGATE DENGAN WARNA ROYAL BLUE KONSISTEN ALA GOPAY
// ============================================================================
class _BerandaHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Map<String, dynamic> summaryData;
  final bool isBalanceVisible;
  final VoidCallback onToggleBalance;
  final VoidCallback onNotificationTap;

  _BerandaHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.summaryData,
    required this.isBalanceVisible,
    required this.onToggleBalance,
    required this.onNotificationTap,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final rawProgress = (shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0);
    final progress = Curves.easeInOutCubic.transform(rawProgress);

    final contentOpacity = (1.0 - (progress * 2.2)).clamp(0.0, 1.0);
    final topPosition = (1.0 - progress) * 12.0 + 2.0;

    // WARNA ROYAL BLUE KONSISTEN (KEDUA MODE TETAP MEMILIKI BRANDING BIRU)
    const BoxDecoration headerDecoration = BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF0052FF), // Royal Blue Primary
          Color(0xFF0038FF), // Deep Sapphire Blue
        ],
      ),
    );

    final saldo = summaryData['saldo']?.toString() ?? 'Rp 11.250.000';

    return Container(
      decoration: headerDecoration.copyWith(
        boxShadow: shrinkOffset > 30
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // PATTERN TOPOGRAFI
          CustomPaint(
            painter: _HeaderContourPainter(),
          ),

          // TITLE BAR
          Positioned(
            top: topPosition,
            left: 20,
            right: 20,
            height: 36,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(LucideIcons.wallet, color: Colors.white, size: 18),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'MyKas',
                      style: GoogleFonts.urbanist(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: onNotificationTap,
                  icon: const Icon(LucideIcons.bell, color: Colors.white, size: 20),
                  tooltip: 'Notifikasi',
                ),
              ],
            ),
          ),

          // CARD TOTAL SALDO
          if (contentOpacity > 0.0)
            Positioned(
              bottom: 16,
              left: 20,
              right: 20,
              child: Opacity(
                opacity: contentOpacity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: onToggleBalance,
                      borderRadius: BorderRadius.circular(6),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Total Saldo Kas',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withOpacity(0.85),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Icon(
                              isBalanceVisible ? LucideIcons.eye : LucideIcons.eyeOff,
                              size: 14,
                              color: Colors.white.withOpacity(0.85),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isBalanceVisible ? saldo : '••••••••••••',
                      style: GoogleFonts.urbanist(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -0.6,
                      ),
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
  bool shouldRebuild(covariant _BerandaHeaderDelegate oldDelegate) {
    return oldDelegate.minHeight != minHeight ||
        oldDelegate.maxHeight != maxHeight ||
        oldDelegate.summaryData != summaryData ||
        oldDelegate.isBalanceVisible != isBalanceVisible;
  }
}

// PAINTER POLA GARIS TOPOGRAFI
class _HeaderContourPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final path1 = Path();
    path1.moveTo(0, size.height * 0.2);
    path1.cubicTo(
      size.width * 0.3, size.height * 0.05,
      size.width * 0.6, size.height * 0.5,
      size.width, size.height * 0.15,
    );

    final path2 = Path();
    path2.moveTo(0, size.height * 0.4);
    path2.cubicTo(
      size.width * 0.35, size.height * 0.2,
      size.width * 0.70, size.height * 0.8,
      size.width, size.height * 0.35,
    );

    canvas.drawPath(path1, paint);
    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
