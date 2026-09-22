import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:mykas/theme/app_theme.dart';
import 'package:mykas/widgets/pwa_install_prompt_card.dart';

class BerandaScreen extends StatefulWidget {
  final Map<String, dynamic>? summaryData;
  final VoidCallback? onNavigateToAnalisis;

  const BerandaScreen({
    super.key,
    this.summaryData,
    this.onNavigateToAnalisis,
  });

  @override
  State<BerandaScreen> createState() => _BerandaScreenState();
}

class _BerandaScreenState extends State<BerandaScreen> {
  bool _showAllKantongSubPage = false;
  bool _isSaldoVisible = true;

  String _formatCurrency(dynamic rawNominal) {
    if (rawNominal == null) return 'Rp0';
    String strVal = rawNominal.toString().replaceAll(RegExp(r'[^0-9]'), '');
    if (strVal.isEmpty) return 'Rp0';

    final intValue = int.tryParse(strVal) ?? 0;
    final buffer = StringBuffer();
    final numStr = intValue.toString();

    for (int i = 0; i < numStr.length; i++) {
      if (i > 0 && (numStr.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(numStr[i]);
    }
    return 'Rp$buffer';
  }

  void _openTambahAkunModal(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 1024;

    if (isDesktop) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => Dialog(
          backgroundColor: Colors.transparent,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: const TambahAkunFormContent(),
          ),
        ),
      );
    } else {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: const TambahAkunFormContent(),
        ),
      );
    }
  }

  void _openPengaturanKantongBottomSheet(BuildContext context, String namaKantong) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppTheme.cardDark : AppTheme.cardLight;
    final textColor = isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight;
    final subtitleColor = isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight;
    final tileBg = isDark ? const Color(0xFF1E222D) : const Color(0xFFF8FAFC);
    final borderColor = isDark ? AppTheme.borderDark : AppTheme.borderLight;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? AppTheme.borderDark : const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pengaturan Kantong',
                        style: GoogleFonts.urbanist(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: textColor,
                        ),
                      ),
                      Text(
                        namaKantong,
                        style: TextStyle(fontSize: 12, color: subtitleColor),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(LucideIcons.x, size: 18, color: textColor),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildSettingTileItem(
                icon: LucideIcons.pencil,
                title: 'Ubah Nama & Kategori',
                subtitle: 'Ganti nama, jenis, atau ikon kantong',
                tileBg: tileBg,
                borderColor: borderColor,
                textColor: textColor,
                subtitleColor: subtitleColor,
                onTap: () => Navigator.pop(context),
              ),
              _buildSettingTileItem(
                icon: LucideIcons.sliders,
                title: 'Atur Limit Pengeluaran',
                subtitle: 'Pasang batas budget bulanan kantong ini',
                tileBg: tileBg,
                borderColor: borderColor,
                textColor: textColor,
                subtitleColor: subtitleColor,
                onTap: () => Navigator.pop(context),
              ),
              _buildSettingTileItem(
                icon: LucideIcons.checkCircle2,
                title: 'Jadikan Kantong Utama',
                subtitle: 'Gunakan sebagai sumber dana default',
                tileBg: tileBg,
                borderColor: borderColor,
                textColor: textColor,
                subtitleColor: subtitleColor,
                onTap: () => Navigator.pop(context),
              ),
              _buildSettingTileItem(
                icon: LucideIcons.trash2,
                title: 'Hapus Kantong',
                subtitle: 'Keluarkan kantong ini dari daftar MyKas',
                tileBg: tileBg,
                borderColor: borderColor,
                textColor: const Color(0xFFEF4444),
                subtitleColor: subtitleColor,
                iconColor: const Color(0xFFEF4444),
                onTap: () => Navigator.pop(context),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSettingTileItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color tileBg,
    required Color borderColor,
    required Color textColor,
    required Color subtitleColor,
    Color iconColor = AppTheme.brandPrimary,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: tileBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: iconColor),
        ),
        title: Text(
          title,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: textColor),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: 10, color: subtitleColor),
        ),
        trailing: Icon(LucideIcons.chevronRight, size: 16, color: subtitleColor),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
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

    final rawSaldo = widget.summaryData?['saldo'] ?? 'Rp 2.345.833';

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
      {
        'judul': 'Supermarket Transmart',
        'kategori': 'Kebutuhan Harian',
        'tanggal': '22 Agu 2026',
        'nominal': '235000',
        'jenis': 'pengeluaran',
        'icon': LucideIcons.shoppingCart,
        'iconBg': const Color(0xFF8B5CF6),
      },
      {
        'judul': 'Transfer Ke Rekening BSI',
        'kategori': 'Pindah Kas',
        'tanggal': '20 Agu 2026',
        'nominal': '500000',
        'jenis': 'pengeluaran',
        'icon': LucideIcons.arrowUpRight,
        'iconBg': const Color(0xFF00A39D),
      },
    ];

    final recentTransactions = riwayat.take(5).toList();

    final surfaceColor = isDark ? AppTheme.bgDark : AppTheme.bgLight;
    final cardBg = isDark ? AppTheme.cardDark : AppTheme.cardLight;
    final borderColor = isDark ? AppTheme.borderDark : AppTheme.borderLight;
    final textColor = isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight;
    final textMuted = isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight;

    return PopScope(
      canPop: !_showAllKantongSubPage,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _showAllKantongSubPage) {
          _handleBackPress();
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF0052FF),
        body: SafeArea(
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
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
                  ? _buildSemuaKantongSubPage(textColor, textMuted, cardBg, borderColor, surfaceColor, isDark)
                  : _buildMainBerandaView(
                      rawSaldo,
                      recentTransactions,
                      textColor,
                      textMuted,
                      cardBg,
                      borderColor,
                      surfaceColor,
                      isDark,
                    ),
            ),
          ),
        ),
      ),
    );
  }

  // =========================================================================
  // MAIN BERANDA VIEW
  // =========================================================================
  Widget _buildMainBerandaView(
    String rawSaldo,
    List recentTransactions,
    Color textColor,
    Color textMuted,
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
            child: CustomScrollView(
              physics: const ClampingScrollPhysics(),
              slivers: [
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _OvoStyleTopBarDelegate(),
                ),

                SliverToBoxAdapter(
                  child: Container(
                    color: const Color(0xFF0052FF),
                    padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Total Saldo',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(width: 6),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _isSaldoVisible = !_isSaldoVisible;
                                });
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Icon(
                                  _isSaldoVisible ? LucideIcons.eye : LucideIcons.eyeOff,
                                  color: Colors.white70,
                                  size: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 220),
                          transitionBuilder: (Widget child, Animation<double> animation) {
                            return FadeTransition(opacity: animation, child: child);
                          },
                          child: Text(
                            _isSaldoVisible ? rawSaldo : '••••••••••••',
                            key: ValueKey<bool>(_isSaldoVisible),
                            style: GoogleFonts.urbanist(
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
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

                SliverToBoxAdapter(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.18),
                          blurRadius: 16,
                          offset: const Offset(0, -4),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(isDesktop ? 32.0 : 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: 38,
                            height: 4,
                            decoration: BoxDecoration(
                              color: isDark ? AppTheme.borderDark : AppTheme.borderLight,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),

                        const PwaInstallPromptCard(),

                        _buildKantongKeuanganSection(textColor, textMuted, cardBg, borderColor, isDark, isDesktop),
                        const SizedBox(height: 24),

                        _buildQuickActionsSection(textColor, isDark, isDesktop),
                        const SizedBox(height: 20),

                        _buildMyInsightCard(textColor, textMuted, isDark),
                        const SizedBox(height: 20),

                        _buildOverviewKeuanganSection(textColor, textMuted, cardBg, borderColor, isDark, isDesktop),
                        const SizedBox(height: 24),

                        _buildRecentTransactionsSection(recentTransactions, textColor, textMuted, cardBg, borderColor, isDark),
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
    );
  }

  // =========================================================================
  // OVERVIEW KEUANGAN
  // =========================================================================
  Widget _buildOverviewKeuanganSection(
    Color textColor,
    Color textMuted,
    Color cardBg,
    Color borderColor,
    bool isDark,
    bool isDesktop,
  ) {
    final rawPemasukan = widget.summaryData?['pemasukan'] ?? 'Rp 5.250.000';
    final rawPengeluaran = widget.summaryData?['pengeluaran'] ?? 'Rp 2.804.178';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Overview Keuangan',
              style: GoogleFonts.urbanist(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: textColor,
              ),
            ),
            InkWell(
              onTap: widget.onNavigateToAnalisis,
              child: const Text(
                'Lihat Detail >',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.brandPrimary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
         
