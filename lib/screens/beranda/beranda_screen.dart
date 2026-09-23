import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_theme.dart';
import '../../utils/app_icons.dart';

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
                    icon: Icon(AppIcons.x, size: 18, color: textColor),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildSettingTileItem(
                icon: AppIcons.pencil,
                title: 'Ubah Nama & Kategori',
                subtitle: 'Ganti nama, jenis, atau ikon kantong',
                tileBg: tileBg,
                borderColor: borderColor,
                textColor: textColor,
                subtitleColor: subtitleColor,
                onTap: () => Navigator.pop(context),
              ),
              _buildSettingTileItem(
                icon: AppIcons.sliders,
                title: 'Atur Limit Pengeluaran',
                subtitle: 'Pasang batas budget bulanan kantong ini',
                tileBg: tileBg,
                borderColor: borderColor,
                textColor: textColor,
                subtitleColor: subtitleColor,
                onTap: () => Navigator.pop(context),
              ),
              _buildSettingTileItem(
                icon: AppIcons.checkCircle2,
                title: 'Jadikan Kantong Utama',
                subtitle: 'Gunakan sebagai sumber dana default',
                tileBg: tileBg,
                borderColor: borderColor,
                textColor: textColor,
                subtitleColor: subtitleColor,
                onTap: () => Navigator.pop(context),
              ),
              _buildSettingTileItem(
                icon: AppIcons.trash2,
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
        trailing: Icon(AppIcons.chevronRight, size: 16, color: subtitleColor),
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
        'icon': AppIcons.utensils,
        'iconBg': const Color(0xFFF97316),
      },
      {
        'judul': 'Gaji Bulanan Utama',
        'kategori': 'Payroll Inflow',
        'tanggal': '25 Agu 2026',
        'nominal': '8500000',
        'jenis': 'pemasukan',
        'icon': AppIcons.wallet,
        'iconBg': const Color(0xFF10B981),
      },
      {
        'judul': 'GoFood Indonesia',
        'kategori': 'Layanan Antar',
        'tanggal': '24 Agu 2026',
        'nominal': '68000',
        'jenis': 'pengeluaran',
        'icon': AppIcons.shoppingBag,
        'iconBg': const Color(0xFF00AED6),
      },
      {
        'judul': 'Supermarket Transmart',
        'kategori': 'Kebutuhan Harian',
        'tanggal': '22 Agu 2026',
        'nominal': '235000',
        'jenis': 'pengeluaran',
        'icon': AppIcons.shoppingCart,
        'iconBg': const Color(0xFF8B5CF6),
      },
      {
        'judul': 'Transfer Ke Rekening BSI',
        'kategori': 'Pindah Kas',
        'tanggal': '20 Agu 2026',
        'nominal': '500000',
        'jenis': 'pengeluaran',
        'icon': AppIcons.arrowUpRight,
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
                                  _isSaldoVisible ? AppIcons.eye : AppIcons.eyeOff,
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
                            Icon(AppIcons.clock, color: Colors.white60, size: 11),
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
                  color: cardBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981).withOpacity(0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(AppIcons.arrowDownLeft, size: 14, color: Color(0xFF10B981)),
                        ),
                        const SizedBox(width: 8),
                        Text('Pemasukan', style: TextStyle(fontSize: 11, color: textMuted)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _isSaldoVisible ? rawPemasukan : '••••••••',
                      style: GoogleFonts.urbanist(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEF4444).withOpacity(0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(AppIcons.arrowUpRight, size: 14, color: Color(0xFFEF4444)),
                        ),
                        const SizedBox(width: 8),
                        Text('Pengeluaran', style: TextStyle(fontSize: 11, color: textMuted)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _isSaldoVisible ? rawPengeluaran : '••••••••',
                      style: GoogleFonts.urbanist(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildKantongKeuanganSection(
    Color textColor,
    Color textMuted,
    Color cardBg,
    Color borderColor,
    bool isDark,
    bool isDesktop,
  ) {
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
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    '4 Terhubung',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.brandPrimary,
                    ),
                  ),
                ),
              ],
            ),
            InkWell(
              onTap: () {
                setState(() {
                  _showAllKantongSubPage = true;
                });
              },
              borderRadius: BorderRadius.circular(8),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Text(
                  'Lihat Semua >',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.brandPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: isDesktop ? 4 : 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: isDesktop ? 1.6 : 1.35,
          children: [
            _buildWalletCard('BSI', const Color(0xFF00A39D), 'BSI Debit Hasanah', 'Rp186.750.000', cardBg, borderColor, textColor, textMuted),
            _buildWalletCard('MANDIRI', const Color(0xFFF59E0B), 'Taplus Muda Mandiri', 'Rp12.400.000', cardBg, borderColor, textColor, textMuted),
            _buildWalletCard('GOPAY', const Color(0xFF00AED6), 'GoPay Wallet', 'Rp5.000.000', cardBg, borderColor, textColor, textMuted),
            _buildAddAccountCard(isDark, textMuted),
          ],
        ),
      ],
    );
  }

  Widget _buildWalletCard(
    String badge,
    Color badgeBg,
    String title,
    String amount,
    Color cardBg,
    Color borderColor,
    Color textColor,
    Color textMuted,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: badgeBg, borderRadius: BorderRadius.circular(6)),
                child: Text(
                  badge,
                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900),
                ),
              ),
              InkWell(
                onTap: () => _openPengaturanKantongBottomSheet(context, title),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Icon(AppIcons.chevronRight, size: 14, color: textMuted),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 11, color: textMuted),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                _isSaldoVisible ? amount : '••••••••',
                style: GoogleFonts.urbanist(fontSize: 14, fontWeight: FontWeight.w900, color: textColor),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddAccountCard(bool isDark, Color textMuted) {
    return InkWell(
      onTap: () => _openTambahAkunModal(context),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isDark ? AppTheme.borderDark : AppTheme.borderLight,
            width: 1.5,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.brandPrimary.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(AppIcons.plus, color: AppTheme.brandPrimary, size: 18),
              ),
              const SizedBox(height: 6),
              Text(
                '+ Tambah Akun',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textMuted),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionsSection(Color textColor, bool isDark, bool isDesktop) {
    final actions = [
      {'label': 'Scan Struk', 'icon': AppIcons.qrCode, 'color': const Color(0xFFF59E0B)},
      {'label': 'Transfer', 'icon': AppIcons.transfer, 'color': AppTheme.brandPrimary},
      {'label': 'Berulang', 'icon': AppIcons.repeat, 'color': const Color(0xFF10B981)},
      {'label': 'Tujuan', 'icon': AppIcons.target, 'color': const Color(0xFF8B5CF6)},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Quick Actions',
              style: GoogleFonts.urbanist(fontSize: 15, fontWeight: FontWeight.w800, color: textColor),
            ),
            InkWell(
              onTap: () {},
              child: const Text(
                'Edit',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.brandPrimary),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: actions.map((act) {
            final color = act['color'] as Color;
            return Column(
              children: [
                InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: isDark ? color.withOpacity(0.18) : color.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(act['icon'] as IconData, color: color, size: 20),
                  ),
                ),
                const SizedBox(height: 6),
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

  Widget _buildMyInsightCard(Color textColor, Color textMuted, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.cardDark : const Color(0xFFF0F7FF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? AppTheme.borderDark : AppTheme.brandPrimary.withOpacity(0.2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF59E0B).withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(AppIcons.sparkles, color: Color(0xFFF59E0B), size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Insight',
                  style: GoogleFonts.urbanist(fontSize: 13, fontWeight: FontWeight.w900, color: textColor),
                ),
                const SizedBox(height: 2),
                Text(
                  'Pengeluaran menurun 12%! Hemat Rp1.450.000 pada pos non-primer dibanding minggu lalu.',
                  style: TextStyle(fontSize: 11, color: textMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTransactionsSection(
    List recentTransactions,
    Color textColor,
    Color textMuted,
    Color cardBg,
    Color borderColor,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Riwayat Transaksi',
              style: GoogleFonts.urbanist(fontSize: 15, fontWeight: FontWeight.w800, color: textColor),
            ),
            if (widget.onNavigateToAnalisis != null)
              InkWell(
                onTap: widget.onNavigateToAnalisis,
                child: const Text(
                  'Lihat Semua >',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.brandPrimary),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: borderColor),
          ),
          child: recentTransactions.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Center(
                    child: Text('Belum ada transaksi dicatat.', style: TextStyle(color: textMuted, fontSize: 12)),
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: recentTransactions.length,
                  separatorBuilder: (context, index) => Divider(color: borderColor, height: 1),
                  itemBuilder: (context, index) {
                    final item = recentTransactions[index];
                    final isPemasukan = item['jenis'] == 'pemasukan';
                    final formattedNominal = _formatCurrency(item['nominal']);

                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: ((item['iconBg'] as Color?) ?? AppTheme.brandPrimary).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          (item['icon'] as IconData?) ?? AppIcons.receipt,
                          color: (item['iconBg'] as Color?) ?? AppTheme.brandPrimary,
                          size: 18,
                        ),
                      ),
                      title: Text(
                        item['judul'] ?? 'Transaksi',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: textColor),
                      ),
                      subtitle: Text(
                        '${item['tanggal'] ?? 'Hari ini'} • ${item['kategori'] ?? 'Umum'}',
                        style: TextStyle(fontSize: 11, color: textMuted),
                      ),
                      trailing: Text(
                        '${isPemasukan ? '+' : '-'}$formattedNominal',
                        style: GoogleFonts.urbanist(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: isPemasukan ? const Color(0xFF10B981) : textColor,
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildSemuaKantongSubPage(
    Color textColor,
    Color textMuted,
    Color cardBg,
    Color borderColor,
    Color surfaceColor,
    bool isDark,
  ) {
    return Container(
      key: const ValueKey('SemuaKantongSubPage'),
      color: surfaceColor,
      child: Column(
        children: [
          Container(
            color: const Color(0xFF0052FF),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                IconButton(
                  onPressed: _handleBackPress,
                  icon: const Icon(AppIcons.arrowLeft, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 8),
                Text(
                  'Semua Kantong Keuangan',
                  style: GoogleFonts.urbanist(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildSubPageWalletTile('BSI Debit Hasanah', 'BSI', const Color(0xFF00A39D), 'Rp186.750.000', cardBg, borderColor, textColor, textMuted),
                _buildSubPageWalletTile('Taplus Muda Mandiri', 'MANDIRI', const Color(0xFFF59E0B), 'Rp12.400.000', cardBg, borderColor, textColor, textMuted),
                _buildSubPageWalletTile('GoPay Wallet', 'GOPAY', const Color(0xFF00AED6), 'Rp5.000.000', cardBg, borderColor, textColor, textMuted),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: () => _openTambahAkunModal(context),
                    icon: const Icon(AppIcons.plus, size: 16, color: AppTheme.brandPrimary),
                    label: const Text(
                      'Tambah Kantong Baru',
                      style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.brandPrimary),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppTheme.brandPrimary),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubPageWalletTile(
    String title,
    String badge,
    Color badgeBg,
    String amount,
    Color cardBg,
    Color borderColor,
    Color textColor,
    Color textMuted,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: badgeBg, borderRadius: BorderRadius.circular(8)),
            child: Text(
              badge,
              style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w900),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 12, color: textMuted)),
                const SizedBox(height: 2),
                Text(
                  _isSaldoVisible ? amount : '••••••••',
                  style: GoogleFonts.urbanist(fontSize: 15, fontWeight: FontWeight.w900, color: textColor),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _openPengaturanKantongBottomSheet(context, title),
            icon: Icon(AppIcons.moreVertical, size: 18, color: textMuted),
          ),
        ],
      ),
    );
  }
}

class TambahAkunFormContent extends StatefulWidget {
  const TambahAkunFormContent({super.key});

  @override
  State<TambahAkunFormContent> createState() => _TambahAkunFormContentState();
}

class _TambahAkunFormContentState extends State<TambahAkunFormContent> {
  String _jenisKantong = 'Bank';
  final TextEditingController _namaCtrl = TextEditingController();
  final TextEditingController _saldoCtrl = TextEditingController();

  @override
  void dispose() {
    _namaCtrl.dispose();
    _saldoCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppTheme.cardDark : AppTheme.cardLight;
    final textColor = isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight;
    final fillColor = isDark ? const Color(0xFF1E222D) : const Color(0xFFF1F5F9);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(24),
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
              Text(
                'Tambah Kantong Keuangan',
                style: GoogleFonts.urbanist(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: textColor,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(AppIcons.x, size: 18, color: textColor),
              ),
            ],
          ),
          const SizedBox(height: 20),
          DropdownButtonFormField<String>(
            value: _jenisKantong,
            decoration: InputDecoration(
              labelText: 'Jenis Kantong',
              filled: true,
              fillColor: fillColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
            items: ['Bank', 'E-Wallet', 'Tunai', 'Investasi']
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (val) {
              if (val != null) setState(() => _jenisKantong = val);
            },
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _namaCtrl,
            decoration: InputDecoration(
              labelText: 'Nama Kantong / Akun',
              hintText: 'Contoh: Mandiri Utama / GoPay',
              filled: true,
              fillColor: fillColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _saldoCtrl,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Saldo Awal (Rp)',
              hintText: 'Contoh: 1000000',
              filled: true,
              fillColor: fillColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('✅ Kantong berhasil ditambahkan!'),
                    backgroundColor: Color(0xFF10B981),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.brandPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Simpan Kantong',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OvoStyleTopBarDelegate extends SliverPersistentHeaderDelegate {
  @override
  double get minExtent => 52.0;

  @override
  double get maxExtent => 52.0;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: const Color(0xFF0052FF),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(AppIcons.user, color: Colors.white, size: 16),
          ),
          Expanded(
            child: Center(
              child: Text(
                'MyKas',
                style: GoogleFonts.urbanist(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
            ),
          ),
          Stack(
            children: [
              const Icon(AppIcons.bell, color: Colors.white, size: 20),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEF4444),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => false;
}
