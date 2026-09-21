import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

void main() {
  runApp(const MyKasApp());
}

class MyKasApp extends StatelessWidget {
  const MyKasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyKas Mobile & Web',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        fontFamily: 'Inter',
        scaffoldBackgroundColor: const Color(0xFF0052FF),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        fontFamily: 'Inter',
        scaffoldBackgroundColor: const Color(0xFF0B0F19),
      ),
      themeMode: ThemeMode.system,
      home: const BerandaScreen(),
    );
  }
}

class NoScrollbarBehavior extends ScrollBehavior {
  @override
  Widget buildScrollbar(BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

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
  bool _isSaldoVisible = true;

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

  void _openTambahAkunModal(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 1024;

    if (isDesktop) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => const Dialog(
          backgroundColor: Colors.transparent,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 480),
            child: TambahAkunFormContent(),
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
    final bgColor = isDark ? const Color(0xFF111827) : Colors.white;
    final textColor = isDark ? Colors.white : BerandaScreen.textDark;
    final tileBg = isDark ? const Color(0xFF1F2937) : const Color(0xFFF8FAFC);
    final borderColor = isDark ? const Color(0xFF374151) : const Color(0xFFE2E8F0);

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
                    color: isDark ? const Color(0xFF374151) : const Color(0xFFCBD5E1),
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
                      const Text(
                        'Pengaturan Kantong',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                      ),
                      Text(
                        namaKantong,
                        style: const TextStyle(fontSize: 12, color: BerandaScreen.textMuted),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(LucideIcons.x, size: 18),
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
                onTap: () => Navigator.pop(context),
              ),
              _buildSettingTileItem(
                icon: LucideIcons.sliders,
                title: 'Atur Limit Pengeluaran',
                subtitle: 'Pasang batas budget bulanan kantong ini',
                tileBg: tileBg,
                borderColor: borderColor,
                textColor: textColor,
                onTap: () => Navigator.pop(context),
              ),
              _buildSettingTileItem(
                icon: LucideIcons.checkCircle2,
                title: 'Jadikan Kantong Utama',
                subtitle: 'Gunakan sebagai sumber dana default',
                tileBg: tileBg,
                borderColor: borderColor,
                textColor: textColor,
                onTap: () => Navigator.pop(context),
              ),
              _buildSettingTileItem(
                icon: LucideIcons.trash2,
                title: 'Hapus Kantong',
                subtitle: 'Keluarkan kantong ini dari daftar MyKas',
                tileBg: tileBg,
                borderColor: borderColor,
                textColor: const Color(0xFFEF4444),
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
    Color iconColor = BerandaScreen.primaryRoyalBlue,
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
            color: iconColor.withOpacity(0.1),
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
          style: const TextStyle(fontSize: 10, color: BerandaScreen.textMuted),
        ),
        trailing: const Icon(LucideIcons.chevronRight, size: 16, color: BerandaScreen.textMuted),
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
          child: ScrollConfiguration(
            behavior: NoScrollbarBehavior(),
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
                      rawSaldo,
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
      ),
    );
  }

  // =========================================================================
  // MAIN BERANDA VIEW (PERBAIKAN DENGAN MENGHAPUS CONST ILEGAL)
  // =========================================================================
  Widget _buildMainBerandaView(
    String rawSaldo,
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

        // DIBERSIHKAN: Tanpa keyword 'const' pada Center atau ConstrainedBox
        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: isDesktop ? 1200 : 540),
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _CollapsingHeaderDelegate(
                    rawSaldo: rawSaldo,
                    isSaldoVisible: _isSaldoVisible,
                    onToggleSaldoVisibility: () {
                      setState(() {
                        _isSaldoVisible = !_isSaldoVisible;
                      });
                    },
                    minHeight: 42.0,
                    maxHeight: 170.0,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
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
                              color: isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),

                        _buildKantongKeuanganSection(textColor, cardBg, borderColor, isDark, isDesktop),
                        const SizedBox(height: 24),

                        _buildQuickActionsSection(textColor, isDark, isDesktop),
                        const SizedBox(height: 20),

                        _buildMyInsightCard(isDark),
                        const SizedBox(height: 20),

                        _buildOverviewKeuanganSection(textColor, cardBg, borderColor, isDark),
                        const SizedBox(height: 24),

                        _buildRecentTransactionsSection(recentTransactions, textColor, cardBg, borderColor, isDark),
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
  // SUB-PAGE: DETAIL DAFTAR KANTONG KEUANGAN
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
      },
      {
        'title': 'Taplus Muda Mandiri',
        'type': 'Bank Mandiri',
        'amount': '12400000',
        'badgeText': 'MANDIRI',
        'badgeBg': const Color(0xFFF59E0B),
        'accountNumber': '1370 •••• 4421',
      },
      {
        'title': 'GoPay Wallet',
        'type': 'E-Wallet',
        'amount': '5000000',
        'icon': LucideIcons.wallet,
        'iconColor': const Color(0xFF00AED6),
        'accountNumber': '0812 •••• 9920',
      },
      {
        'title': 'OVO Cash',
        'type': 'E-Wallet',
        'amount': '1250000',
        'icon': LucideIcons.smartphone,
        'iconColor': const Color(0xFF8B5CF6),
        'accountNumber': '0812 •••• 9920',
      },
      {
        'title': 'BCA Tahapan Ekpresi',
        'type': 'Bank Central Asia',
        'amount': '48200000',
        'badgeText': 'BCA',
        'badgeBg': const Color(0xFF0052FF),
        'accountNumber': '8830 •••• 1102',
      },
      {
        'title': 'Dompet Tunai & Kas',
        'type': 'Cash Pocket',
        'amount': '850000',
        'icon': LucideIcons.banknote,
        'iconColor': const Color(0xFF10B981),
        'accountNumber': 'Fisik / Tunai',
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
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                    color: BerandaScreen.primaryRoyalBlue,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: _handleBackPress,
                          icon: const Icon(LucideIcons.arrowLeft, color: Colors.white, size: 20),
                          tooltip: 'Kembali',
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Kantong Keuangan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () => _openTambahAkunModal(context),
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Row(
                              children: [
                                Icon(LucideIcons.plus, size: 14, color: Colors.white),
                                SizedBox(width: 4),
                                Text(
                                  'Tambah',
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: allWallets.length,
                            separatorBuilder: (context, index) => const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              final item = allWallets[index];
                              return _buildSlimWalletListItem(
                                item: item,
                                cardBg: cardBg,
                                borderColor: borderColor,
                                textColor: textColor,
                              );
                            },
                          ),
                          const SizedBox(height: 24),
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

  Widget _buildSlimWalletListItem({
    required Map<String, dynamic> item,
    required Color cardBg,
    required Color borderColor,
    required Color textColor,
  }) {
    final title = item['title'] as String;
    final type = item['type'] as String;
    final formattedAmount = _formatCurrency(item['amount']);

    return InkWell(
      onTap: () => _openPengaturanKantongBottomSheet(context, title),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor, width: 1.0),
        ),
        child: Row(
          children: [
            if (item['badgeText'] != null)
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: (item['badgeBg'] as Color).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    item['badgeText'] as String,
                    style: TextStyle(
                      color: item['badgeBg'] as Color,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              )
            else if (item['icon'] != null)
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: (item['iconColor'] as Color).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(item['icon'] as IconData, color: item['iconColor'] as Color, size: 20),
              ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: textColor),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    type,
                    style: const TextStyle(fontSize: 10, color: BerandaScreen.textMuted, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Text(
                _isSaldoVisible ? formattedAmount : '••••••••',
                key: ValueKey(_isSaldoVisible),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: textColor,
                  fontFamily: 'monospace',
                ),
              ),
            ),
            const SizedBox(width: 4),
            const Icon(LucideIcons.chevronRight, size: 16, color: BerandaScreen.textMuted),
          ],
        ),
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
                    color: BerandaScreen.primaryRoyalBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    '4 Terhubung',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: BerandaScreen.primaryRoyalBlue,
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
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                child: Row(
                  children: [
                    Text(
                      'Lihat Semua',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: BerandaScreen.primaryRoyalBlue,
                      ),
                    ),
                    SizedBox(width: 2),
                    Icon(LucideIcons.chevronRight, size: 16, color: BerandaScreen.primaryRoyalBlue),
                  ],
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
          childAspectRatio: isDesktop ? 1.8 : 1.4,
          children: [
            _buildFlatWalletCard(
              badgeText: 'BSI',
              badgeBg: const Color(0xFF00A39D),
              title: 'BSI Debit Hasanah',
              amount: 'Rp 186.750.000',
              cardBg: whiteCardBg,
              borderColor: borderColor,
              textColor: textColor,
              onTap: () => _openPengaturanKantongBottomSheet(context, 'BSI Debit Hasanah'),
            ),
            _buildFlatWalletCard(
              badgeText: 'MANDIRI',
              badgeBg: const Color(0xFFF59E0B),
              title: 'Taplus Muda Mandiri',
              amount: 'Rp 12.400.000',
              cardBg: whiteCardBg,
              borderColor: borderColor,
              textColor: textColor,
              onTap: () => _openPengaturanKantongBottomSheet(context, 'Taplus Muda Mandiri'),
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
              onTap: () => _openPengaturanKantongBottomSheet(context, 'GoPay Wallet'),
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
    required VoidCallback onTap,
  }) {
    return Container(
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(14),
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
                          color: (iconColor ?? BerandaScreen.primaryRoyalBlue).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(icon, color: iconColor, size: 16),
                      ),
                    if (hasArrow)
                      const Icon(LucideIcons.chevronRight, size: 16, color: BerandaScreen.textMuted),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 11, color: BerandaScreen.textMuted, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 2),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: Text(
                          _isSaldoVisible ? amount : '••••••••',
                          key: ValueKey(_isSaldoVisible),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            color: textColor,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _openTambahAkunModal(context),
          borderRadius: BorderRadius.circular(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xFFEFF6FF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(LucideIcons.plus, color: BerandaScreen.primaryRoyalBlue, size: 18),
              ),
              const SizedBox(height: 6),
              const Text(
                '+ Tambah Akun',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: BerandaScreen.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- QUICK ACTIONS ---
  Widget _buildQuickActionsSection(Color textColor, bool isDark, bool isDesktop) {
    final actions = [
      {'label': 'Scan Struk', 'icon': LucideIcons.qrCode, 'color': const Color(0xFFF59E0B)},
      {'label': 'Transfer', 'icon': LucideIcons.arrowLeftRight, 'color': BerandaScreen.primaryRoyalBlue},
      {'label': 'Berulang', 'icon': LucideIcons.repeat, 'color': const Color(0xFF10B981)},
      {'label': 'Tujuan', 'icon': LucideIcons.target, 'color': const Color(0xFF8B5CF6)},
    ];

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Quick Actions', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: textColor)),
            const Text('Edit', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: BerandaScreen.primaryRoyalBlue)),
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
        border: Border.all(color: BerandaScreen.primaryRoyalBlue.withOpacity(0.15)),
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
                    color: isDark ? Colors.white : BerandaScreen.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Pengeluaran menurun 12%! Hemat Rp 1.450.000 pada pos non-primer dibanding minggu lalu.',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? const Color(0xFF9CA3AF) : BerandaScreen.textMuted,
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
              onTap: widget.onNavigateToAnalisis,
              child: const Text('Lihat Detail >', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: BerandaScreen.primaryRoyalBlue)),
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
                    const Text('SISA BUDGET', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: BerandaScreen.textMuted)),
                    const SizedBox(height: 4),
                    Text('Rp 3.250.000', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: textColor, fontFamily: 'monospace')),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: const LinearProgressIndicator(value: 0.65, minHeight: 6, backgroundColor: Color(0xFFE2E8F0), valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF59E0B))),
                    ),
                    const SizedBox(height: 6),
                    const Text('Terpakai 65% • 10 hr tersisa', style: TextStyle(fontSize: 9, color: BerandaScreen.textMuted, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Container(width: 1, height: 60, color: borderColor, margin: const EdgeInsets.symmetric(horizontal: 14)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('TUJUAN KEUANGAN', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: BerandaScreen.textMuted)),
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
            const Text('Lihat Riwayat >', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: BerandaScreen.primaryRoyalBlue)),
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
              final formattedNominal = _formatCurrency(item['nominal']);

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
                          Text(
                            item['judul']?.toString() ?? 'Transaksi',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: textColor),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text('${item['tanggal']} • ${item['kategori']}', style: const TextStyle(fontSize: 10, color: BerandaScreen.textMuted)),
                        ],
                      ),
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: Text(
                        _isSaldoVisible
                            ? (isPemasukan ? '+$formattedNominal' : '-$formattedNominal')
                            : '••••••••',
                        key: ValueKey(_isSaldoVisible),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                          color: isPemasukan ? const Color(0xFF10B981) : BerandaScreen.textDark,
                          fontFamily: 'monospace',
                        ),
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

class TambahAkunFormContent extends StatefulWidget {
  const TambahAkunFormContent({super.key});

  @override
  State<TambahAkunFormContent> createState() => _TambahAkunFormContentState();
}

class _TambahAkunFormContentState extends State<TambahAkunFormContent> {
  int _selectedCategoryIndex = 0;
  final List<String> _categories = ['Bank Transfer', 'E-Wallet', 'Kas Tunai', 'Investasi'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bgColor = isDark ? const Color(0xFF111827) : Colors.white;
    final textColor = isDark ? Colors.white : BerandaScreen.textDark;
    final inputBg = isDark ? const Color(0xFF1F2937) : const Color(0xFFF8FAFC);
    final borderColor = isDark ? const Color(0xFF374151) : const Color(0xFFE2E8F0);

    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28), bottom: Radius.circular(28)),
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
                color: isDark ? const Color(0xFF374151) : const Color(0xFFCBD5E1),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tambah Kantong Baru',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: textColor,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(LucideIcons.x, size: 20),
                style: IconButton.styleFrom(
                  backgroundColor: inputBg,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(_categories.length, (index) {
                final isSelected = _selectedCategoryIndex == index;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(_categories[index]),
                    selected: isSelected,
                    onSelected: (val) {
                      setState(() {
                        _selectedCategoryIndex = index;
                      });
                    },
                    selectedColor: BerandaScreen.primaryRoyalBlue,
                    backgroundColor: inputBg,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : BerandaScreen.textMuted,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: isSelected ? BerandaScreen.primaryRoyalBlue : borderColor,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 20),

          Text(
            'Nama Kantong / Rekening',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textColor),
          ),
          const SizedBox(height: 6),
          TextField(
            style: TextStyle(fontSize: 13, color: textColor),
            decoration: InputDecoration(
              hintText: 'Contoh: Tabungan Darurat BSI',
              hintStyle: const TextStyle(fontSize: 12, color: BerandaScreen.textMuted),
              filled: true,
              fillColor: inputBg,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: BerandaScreen.primaryRoyalBlue, width: 1.8),
              ),
            ),
          ),
          const SizedBox(height: 16),

          Text(
            'Saldo Awal (Rp)',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textColor),
          ),
          const SizedBox(height: 6),
          TextField(
            keyboardType: TextInputType.number,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textColor, fontFamily: 'monospace'),
            decoration: InputDecoration(
              hintText: '0',
              prefixText: 'Rp ',
              prefixStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: BerandaScreen.primaryRoyalBlue),
              hintStyle: const TextStyle(fontSize: 12, color: BerandaScreen.textMuted),
              filled: true,
              fillColor: inputBg,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: BerandaScreen.primaryRoyalBlue, width: 1.8),
              ),
            ),
          ),
          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: BerandaScreen.primaryRoyalBlue,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Simpan Kantong Baru',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TopographicContourPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final path1 = Path();
    path1.moveTo(0, size.height * 0.3);
    path1.cubicTo(
      size.width * 0.25, size.height * 0.1,
      size.width * 0.50, size.height * 0.6,
      size.width, size.height * 0.25,
    );

    final path2 = Path();
    path2.moveTo(0, size.height * 0.5);
    path2.cubicTo(
      size.width * 0.30, size.height * 0.25,
      size.width * 0.60, size.height * 0.85,
      size.width, size.height * 0.45,
    );

    canvas.drawPath(path1, paint);
    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CollapsingHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String rawSaldo;
  final bool isSaldoVisible;
  final VoidCallback onToggleSaldoVisibility;
  final double minHeight;
  final double maxHeight;

  _CollapsingHeaderDelegate({
    required this.rawSaldo,
    required this.isSaldoVisible,
    required this.onToggleSaldoVisibility,
    required this.minHeight,
    required this.maxHeight,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final rawProgress = (shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0);
    final progress = Curves.easeInOutCubic.transform(rawProgress);

    final saldoOpacity = (1.0 - (progress * 2.2)).clamp(0.0, 1.0);
    final topPosition = (1.0 - progress) * 12.0 + 2.0;

    return Container(
      decoration: BoxDecoration(
        color: BerandaScreen.primaryRoyalBlue,
        boxShadow: shrinkOffset > 30
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ]
            : [],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(
            painter: TopographicContourPainter(),
          ),
          Positioned(
            top: topPosition,
            left: 20,
            right: 20,
            height: 36,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: const BoxDecoration(
                    color: Colors.white24,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 15,
                      child: Icon(
                        LucideIcons.user,
                        color: BerandaScreen.primaryRoyalBlue,
                        size: 17,
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
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.4,
                        height: 1.0,
                      ),
                    ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(18),
                    child: SizedBox(
                      width: 36,
                      height: 36,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          const Icon(
                            LucideIcons.bell,
                            color: Colors.white,
                            size: 21,
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
                  ),
                ),
              ],
            ),
          ),
          if (saldoOpacity > 0.0)
            Positioned(
              bottom: 14,
              left: 24,
              right: 24,
              child: Opacity(
                opacity: saldoOpacity,
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
                          onTap: onToggleSaldoVisibility,
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Icon(
                              isSaldoVisible ? LucideIcons.eye : LucideIcons.eyeOff,
                              color: Colors.white70,
                              size: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 220),
                      transitionBuilder: (Widget child, Animation<double> animation) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                      child: Text(
                        isSaldoVisible ? rawSaldo : '••••••••••••',
                        key: ValueKey<bool>(isSaldoVisible),
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          fontFamily: 'monospace',
                          letterSpacing: -1.0,
                        ),
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
    return oldDelegate.rawSaldo != rawSaldo ||
        oldDelegate.isSaldoVisible != isSaldoVisible ||
        oldDelegate.minHeight != minHeight ||
        oldDelegate.maxHeight != maxHeight;
  }
}
