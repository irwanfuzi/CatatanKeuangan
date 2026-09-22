import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

void main() {
  runApp(const MyKasApp());
}

class MyKasApp extends StatelessWidget {
  const MyKasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyKas',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      home: const MainNavigationScreen(),
    );
  }

  ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final baseTheme = ThemeData(brightness: brightness);

    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF0052FF),
      brightness: brightness,
      primary: const Color(0xFF0052FF),
      surface: isDark ? const Color(0xFF0B0F17) : const Color(0xFFF8FAFC),
      onSurface: isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A),
    );

    return baseTheme.copyWith(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      textTheme: GoogleFonts.urbanistTextTheme(baseTheme.textTheme).apply(
        bodyColor: colorScheme.onSurface,
        displayColor: colorScheme.onSurface,
      ),
      useMaterial3: true,
    );
  }
}

// =========================================================================
// DESIGN SYSTEM CONSTANTS & TOKENS
// =========================================================================
class AppDesignTokens {
  static const Color brandPrimary = Color(0xFF0052FF);
  static const Color brandSecondary = Color(0xFF0038FF);
  static const Color bgLight = Color(0xFFF8FAFC);
  static const Color bgDark = Color(0xFF0B0F17);
  static const Color cardLight = Colors.white;
  static const Color cardDark = Color(0xFF151C2C);
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color borderDark = Color(0xFF1E293B);
  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textSecondaryLight = Color(0xFF64748B);
  static const Color textSecondaryDark = Color(0xFF94A3B8);

  static const double desktopBreakpoint = 1024.0;
}

// =========================================================================
// MAIN NAVIGATION SCREEN (DESKTOP SIDEBAR VS MOBILE 5-BUTTON FLOATING BAR)
// =========================================================================
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  void _navigateToTab(int index) {
    if (index == 2) {
      // Index 2 adalah Tombol Tengah "Catat" (+) -> Buka Modal Bottom Sheet
      showCtaBottomSheet(context);
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= AppDesignTokens.desktopBreakpoint;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final List<Widget> pages = [
      BerandaScreen(onNavigateToAnalisis: () => setState(() => _currentIndex = 1)),
      _buildPlaceholderPage('Halaman Analisis Keuangan', LucideIcons.barChart3, isDark),
      const SizedBox.shrink(), // Placeholder Index 2 (Catat)
      _buildPlaceholderPage('Halaman Riwayat Transaksi', LucideIcons.receipt, isDark),
      _buildPlaceholderPage('Halaman Profil Pengguna', LucideIcons.user, isDark),
    ];

    return Scaffold(
      backgroundColor: isDark ? AppDesignTokens.bgDark : AppDesignTokens.bgLight,
      body: isDesktop
          ? Row(
              children: [
                _buildDesktopSidebar(isDark),
                Expanded(
                  child: IndexedStack(
                    index: _currentIndex,
                    children: pages,
                  ),
                ),
              ],
            )
          : IndexedStack(
              index: _currentIndex,
              children: pages,
            ),
      bottomNavigationBar: isDesktop ? null : _buildMobile5ButtonBottomNavBar(isDark),
    );
  }

  // MOBILE 5-BUTTON FLOATING BOTTOM BAR WITH PILL & HERO CENTER
  Widget _buildMobile5ButtonBottomNavBar(bool isDark) {
    final navBg = isDark ? const Color(0xFF131C33).withAlpha(240) : Colors.white.withAlpha(245);
    final borderColor = isDark ? Colors.white10 : Colors.grey.shade200;
    final activeColor = AppDesignTokens.brandPrimary;
    final inactiveColor = isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8);

    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: navBg,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 80 : 25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 56,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, LucideIcons.home, 'Beranda', activeColor, inactiveColor),
              _buildNavItem(1, LucideIcons.barChart3, 'Analisis', activeColor, inactiveColor),
              _buildHeroCatatButton(),
              _buildNavItem(3, LucideIcons.receipt, 'Riwayat', activeColor, inactiveColor),
              _buildNavItem(4, LucideIcons.user, 'Profil', activeColor, inactiveColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    IconData icon,
    String label,
    Color activeColor,
    Color inactiveColor,
  ) {
    final isSelected = _currentIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => _navigateToTab(index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? activeColor : inactiveColor,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected ? activeColor : inactiveColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroCatatButton() {
    return GestureDetector(
      onTap: () => showCtaBottomSheet(context),
      child: Container(
        height: 50,
        width: 50,
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF0052FF), Color(0xFF0038FF)],
          ),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3.5),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0052FF).withAlpha(100),
              blurRadius: 12,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: const Icon(LucideIcons.plus, color: Colors.white, size: 22),
      ),
    );
  }

  // DESKTOP SIDEBAR RAIL
  Widget _buildDesktopSidebar(bool isDark) {
    final sidebarBg = isDark ? AppDesignTokens.cardDark : Colors.white;
    final borderColor = isDark ? AppDesignTokens.borderDark : AppDesignTokens.borderLight;
    final textColor = isDark ? AppDesignTokens.textPrimaryDark : AppDesignTokens.textPrimaryLight;

    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: sidebarBg,
        border: Border(right: BorderSide(color: borderColor)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 28),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppDesignTokens.brandPrimary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Icon(LucideIcons.wallet, color: Colors.white, size: 20),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'MyKas',
                  style: GoogleFonts.urbanist(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          _buildSidebarTile(0, 'Beranda', LucideIcons.home),
          _buildSidebarTile(1, 'Analisis', LucideIcons.barChart3),
          _buildSidebarTile(3, 'Riwayat', LucideIcons.receipt),
          _buildSidebarTile(4, 'Profil', LucideIcons.user),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () => showCtaBottomSheet(context),
                icon: const Icon(LucideIcons.plus, size: 18, color: Colors.white),
                label: const Text(
                  'Catat Transaksi',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppDesignTokens.brandPrimary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSidebarTile(int index, String title, IconData icon) {
    final isSelected = _currentIndex == index;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? AppDesignTokens.brandPrimary.withAlpha(30) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: () => _navigateToTab(index),
        leading: Icon(
          icon,
          size: 20,
          color: isSelected ? AppDesignTokens.brandPrimary : const Color(0xFF64748B),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            color: isSelected ? AppDesignTokens.brandPrimary : const Color(0xFF64748B),
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildPlaceholderPage(String title, IconData icon, bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 54, color: AppDesignTokens.brandPrimary.withAlpha(120)),
          const SizedBox(height: 16),
          Text(
            title,
            style: GoogleFonts.urbanist(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: isDark ? AppDesignTokens.textPrimaryDark : AppDesignTokens.textPrimaryLight,
            ),
          ),
        ],
      ),
    );
  }
}

// =========================================================================
// HELPER & FORM CATAT TRANSAKSI DENGAN PILL DRAG INDICATOR PRESISI
// =========================================================================
void showCtaBottomSheet(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: isDark ? AppDesignTokens.cardDark : Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 24,
          right: 24,
          top: 16,
        ),
        child: const FormTambahTransaksi(),
      );
    },
  );
}

class FormTambahTransaksi extends StatefulWidget {
  const FormTambahTransaksi({super.key});

  @override
  State<FormTambahTransaksi> createState() => _FormTambahTransaksiState();
}

class _FormTambahTransaksiState extends State<FormTambahTransaksi> {
  String jenis = 'Pengeluaran';
  String kategori = '🍔 Makanan';
  String dompet = '💳 Kantong Tunai';
  bool isLoading = false;

  final TextEditingController nominalCtrl = TextEditingController();
  final TextEditingController ketCtrl = TextEditingController();

  @override
  void dispose() {
    nominalCtrl.dispose();
    ketCtrl.dispose();
    super.dispose();
  }

  void submitData() {
    if (nominalCtrl.text.trim().isEmpty || ketCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nominal dan keterangan wajib diisi!')),
      );
      return;
    }
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ Transaksi berhasil disimpan!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fillColor = isDark ? const Color(0xFF0B132B) : Colors.grey[100];
    final textColor = isDark ? AppDesignTokens.textPrimaryDark : AppDesignTokens.textPrimaryLight;

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // PILL LINE DRAG INDICATOR PADA MODAL
          Center(
            child: Container(
              width: 42,
              height: 4.5,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          Text(
            "Tambah Transaksi",
            style: GoogleFonts.urbanist(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: textColor,
            ),
          ),
          const SizedBox(height: 20),

          // ROW JENIS & DOMPET
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: jenis,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: 'Jenis',
                    filled: true,
                    fillColor: fillColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: ['Pengeluaran', 'Pemasukan']
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e, overflow: TextOverflow.ellipsis),
                          ))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => jenis = val);
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: dompet,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: 'Dompet',
                    filled: true,
                    fillColor: fillColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: [
                    '💳 Kantong Tunai',
                    '🏦 Rekening Bank',
                    '📱 Dompet Digital',
                    '💰 Dompet Tabungan'
                  ]
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e, overflow: TextOverflow.ellipsis),
                          ))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => dompet = val);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // DROPDOWN KATEGORI
          DropdownButtonFormField<String>(
            value: kategori,
            isExpanded: true,
            decoration: InputDecoration(
              labelText: 'Kategori',
              filled: true,
              fillColor: fillColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
            items: [
              '🍔 Makanan',
              '🚗 Transportasi',
              '🏠 Tagihan',
              '🎬 Hiburan',
              '🏥 Kesehatan',
              '💼 Gaji',
              '🚀 Sampingan',
              '📈 Investasi',
              '📦 Lainnya'
            ]
                .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(e, overflow: TextOverflow.ellipsis),
                    ))
                .toList(),
            onChanged: (val) {
              if (val != null) setState(() => kategori = val);
            },
          ),
          const SizedBox(height: 16),

          // INPUT NOMINAL
          TextFormField(
            controller: nominalCtrl,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Nominal (Rp)',
              hintText: 'Contoh: 50000',
              filled: true,
              fillColor: fillColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // INPUT KETERANGAN
          TextFormField(
            controller: ketCtrl,
            decoration: InputDecoration(
              labelText: 'Keterangan',
              hintText: 'Contoh: Bensin / Nasi Goreng',
              filled: true,
              fillColor: fillColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // TOMBOL SIMPAN
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: submitData,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppDesignTokens.brandPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: const Text(
                "Simpan Transaksi",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// =========================================================================
// BERANDA SCREEN (PILL DRAG INDICATOR PADA CANVAS LENGKUNG SHEET KONTEN)
// =========================================================================
class BerandaScreen extends StatefulWidget {
  final VoidCallback? onNavigateToAnalisis;

  const BerandaScreen({super.key, this.onNavigateToAnalisis});

  @override
  State<BerandaScreen> createState() => _BerandaScreenState();
}

class _BerandaScreenState extends State<BerandaScreen> {
  bool _isSaldoVisible = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? AppDesignTokens.bgDark : AppDesignTokens.bgLight;
    final cardBg = isDark ? AppDesignTokens.cardDark : AppDesignTokens.cardLight;
    final borderColor = isDark ? AppDesignTokens.borderDark : AppDesignTokens.borderLight;
    final textColor = isDark ? AppDesignTokens.textPrimaryDark : AppDesignTokens.textPrimaryLight;
    final textMuted = isDark ? AppDesignTokens.textSecondaryDark : AppDesignTokens.textSecondaryLight;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= AppDesignTokens.desktopBreakpoint;

        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: isDesktop ? 1200 : 540),
            child: CustomScrollView(
              physics: const ClampingScrollPhysics(),
              slivers: [
                // 1. PINNED TOP BAR BIRU
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _OvoStyleTopBarDelegate(),
                ),

                // 2. TOTAL SALDO SECTION (TER-SCROLL SAMA KONTEN NYA)
                SliverToBoxAdapter(
                  child: Container(
                    color: const Color(0xFF0052FF),
                    padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Total Saldo',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white70),
                            ),
                            const SizedBox(width: 6),
                            InkWell(
                              onTap: () => setState(() => _isSaldoVisible = !_isSaldoVisible),
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
                        Text(
                          _isSaldoVisible ? 'Rp 2.345.833' : '••••••••••••',
                          style: GoogleFonts.urbanist(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: -0.5,
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

                // 3. CANVAS SHEET KONTEN LENGKUNG DENGAN PILL LINE DRAG INDICATOR
                SliverToBoxAdapter(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(20),
                          blurRadius: 16,
                          offset: const Offset(0, -4),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(isDesktop ? 32.0 : 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // PILL LINE DRAG INDICATOR DI BAGIAN ATAS SHEET
                        Center(
                          child: Container(
                            width: 38,
                            height: 4,
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),

                        _buildKantongKeuanganSection(textColor, textMuted, cardBg, borderColor, isDark, isDesktop),
                        const SizedBox(height: 24),

                        _buildQuickActionsSection(textColor, isDark),
                        const SizedBox(height: 20),

                        _buildMyInsightCard(textColor, textMuted, isDark),
                        const SizedBox(height: 24),

                        _buildRecentTransactionsSection(textColor, textMuted, cardBg, borderColor, isDark),
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

  Widget _buildKantongKeuanganSection(
      Color textColor, Color textMuted, Color cardBg, Color borderColor, bool isDark, bool isDesktop) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Kantong Keuangan',
              style: GoogleFonts.urbanist(fontSize: 16, fontWeight: FontWeight.w800, color: textColor),
            ),
            const Text('Lihat Semua', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppDesignTokens.brandPrimary)),
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
            _buildWalletCard('BSI', const Color(0xFF00A39D), 'BSI Hasanah', 'Rp186.750.000', cardBg, borderColor, textColor, textMuted),
            _buildWalletCard('MANDIRI', const Color(0xFFF59E0B), 'Mandiri Utama', 'Rp12.400.000', cardBg, borderColor, textColor, textMuted),
            _buildWalletCard('GOPAY', const Color(0xFF00AED6), 'GoPay Wallet', 'Rp5.000.000', cardBg, borderColor, textColor, textMuted),
            _buildAddAccountCard(isDark, textMuted),
          ],
        ),
      ],
    );
  }

  Widget _buildWalletCard(
      String badge, Color badgeBg, String title, String amount, Color cardBg, Color borderColor, Color textColor, Color textMuted) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(color: badgeBg, borderRadius: BorderRadius.circular(6)),
            child: Text(badge, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontSize: 11, color: textMuted)),
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
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppDesignTokens.borderDark : AppDesignTokens.borderLight, width: 1.5),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(LucideIcons.plus, color: AppDesignTokens.brandPrimary, size: 20),
            const SizedBox(height: 4),
            Text('+ Tambah', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textMuted)),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionsSection(Color textColor, bool isDark) {
    final actions = [
      {'label': 'Scan Struk', 'icon': LucideIcons.qrCode, 'color': const Color(0xFFF59E0B)},
      {'label': 'Transfer', 'icon': LucideIcons.arrowLeftRight, 'color': AppDesignTokens.brandPrimary},
      {'label': 'Berulang', 'icon': LucideIcons.repeat, 'color': const Color(0xFF10B981)},
      {'label': 'Tujuan', 'icon': LucideIcons.target, 'color': const Color(0xFF8B5CF6)},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quick Actions', style: GoogleFonts.urbanist(fontSize: 15, fontWeight: FontWeight.w800, color: textColor)),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: actions.map((act) {
            final color = act['color'] as Color;
            return Column(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isDark ? color.withAlpha(50) : color,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(act['icon'] as IconData, color: isDark ? color : Colors.white, size: 20),
                ),
                const SizedBox(height: 6),
                Text(act['label'] as String, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: textColor)),
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
        color: isDark ? AppDesignTokens.cardDark : const Color(0xFFF0F7FF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: isDark ? AppDesignTokens.borderDark : AppDesignTokens.brandPrimary.withAlpha(40)),
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
                Text('My Insight', style: GoogleFonts.urbanist(fontSize: 13, fontWeight: FontWeight.w900, color: textColor)),
                const SizedBox(height: 2),
                Text('Pengeluaran menurun 12%! Hemat Rp1.450.000 dibanding minggu lalu.', style: TextStyle(fontSize: 11, color: textMuted)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTransactionsSection(Color textColor, Color textMuted, Color cardBg, Color borderColor, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Recent Transactions', style: GoogleFonts.urbanist(fontSize: 15, fontWeight: FontWeight.w800, color: textColor)),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(20), border: Border.all(color: borderColor)),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            separatorBuilder: (context, index) => Divider(color: borderColor, height: 1),
            itemBuilder: (context, index) {
              return ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: AppDesignTokens.brandPrimary.withAlpha(30), borderRadius: BorderRadius.circular(10)),
                  child: const Icon(LucideIcons.utensils, color: AppDesignTokens.brandPrimary, size: 18),
                ),
                title: Text('Gudeg Bu Dani Solo', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: textColor)),
                subtitle: Text('Hari Ini, 12:45 • Kuliner', style: TextStyle(fontSize: 10, color: textMuted)),
                trailing: Text('-Rp45.000', style: GoogleFonts.urbanist(fontSize: 14, fontWeight: FontWeight.w900, color: textColor)),
              );
            },
          ),
        ),
      ],
    );
  }
}

// PINNED TOP BAR DELEGATE
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
            decoration: BoxDecoration(color: Colors.white.withAlpha(60), shape: BoxShape.circle),
            child: const Icon(LucideIcons.user, color: Colors.white, size: 16),
          ),
          Expanded(
            child: Center(
              child: Text(
                'MyKas',
                style: GoogleFonts.urbanist(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white),
              ),
            ),
          ),
          const Icon(LucideIcons.bell, color: Colors.white, size: 20),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => false;
}
