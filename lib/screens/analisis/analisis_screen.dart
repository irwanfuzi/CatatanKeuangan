import 'package:flutter/material.dart';

class AnalisisScreen extends StatefulWidget {
  final Map<String, dynamic>? summaryData;

  const AnalisisScreen({
    super.key,
    this.summaryData,
  });

  @override
  State<AnalisisScreen> createState() => _AnalisisScreenState();
}

class _AnalisisScreenState extends State<AnalisisScreen> {
  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;
  String _selectedWalletCategory = 'Semua';

  final List<String> _namaBulan = const [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
  ];

  static const Color primaryRoyalBlue = Color(0xFF0052FF);
  static const Color accentHoneyGold = Color(0xFFFF9F00);
  static const Color emeraldGreen = Color(0xFF10B981);
  static const Color crimsonRed = Color(0xFFEF4444);
  static const Color purpleAccent = Color(0xFF8B5CF6);

  void _openDateFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final surfaceColor = isDark ? const Color(0xFF111827) : Colors.white;
        int tempMonth = _selectedMonth;
        int tempYear = _selectedYear;

        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                border: Border.all(color: isDark ? const Color(0xFF1F2937) : const Color(0xFFE5E7EB)),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF374151) : const Color(0xFFD1D5DB),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Pilih Periode Analisis',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: isDark ? Colors.white : const Color(0xFF111827),
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text('Tahun', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? Colors.white60 : Colors.black54)),
                  const SizedBox(height: 8),
                  Row(
                    children: [2024, 2025, 2026].map((y) {
                      final isSelected = tempYear == y;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text('$y'),
                          selected: isSelected,
                          selectedColor: primaryRoyalBlue,
                          backgroundColor: isDark ? const Color(0xFF1F2937) : const Color(0xFFF3F4F6),
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          onSelected: (val) => setModalState(() => tempYear = y),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  Text('Bulan', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? Colors.white60 : Colors.black54)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(12, (index) {
                      final monthNum = index + 1;
                      final isSelected = tempMonth == monthNum;
                      return InkWell(
                        onTap: () => setModalState(() => tempMonth = monthNum),
                        borderRadius: BorderRadius.circular(12),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                          decoration: BoxDecoration(
                            color: isSelected ? primaryRoyalBlue : (isDark ? const Color(0xFF1F2937) : const Color(0xFFF3F4F6)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _namaBulan[index],
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                              color: isSelected ? Colors.white : (isDark ? Colors.white70 : const Color(0xFF374151)),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryRoyalBlue,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      onPressed: () {
                        setState(() {
                          _selectedMonth = tempMonth;
                          _selectedYear = tempYear;
                        });
                        Navigator.pop(context);
                      },
                      child: const Text('Terapkan Filter', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final backgroundColor = isDark ? const Color(0xFF0B0F19) : const Color(0xFFF8FAFC);
    final surfaceColor = isDark ? const Color(0xFF111827) : Colors.white;
    final borderColor = isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0);
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final subTextColor = isDark ? const Color(0xFF9CA3AF) : const Color(0xFF64748B);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 1024;

            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: isDesktop ? 1080 : 540),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? 32.0 : 18.0,
                    vertical: 20.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. HEADER TITLE & PERIOD FILTER
                      _buildHeader(textColor, subTextColor, surfaceColor, borderColor, isDark),
                      const SizedBox(height: 20),

                      // 2. RINGKASAN 3 KOLOM NOMINAL (PEMASUKAN, PENGELUARAN, SALDO BERSIH)
                      _buildThreeColumnSummaryCard(surfaceColor, borderColor, textColor, subTextColor, isDark),
                      const SizedBox(height: 24),

                      // 3. RINCIAN DOMPET SAYA (BANK, E-WALLET, TABUNGAN, TUNAI)
                      _buildSectionHeader('Rincian Dompet Saya', textColor),
                      const SizedBox(height: 12),
                      _buildGroupedWalletCategoryChips(isDark),
                      const SizedBox(height: 14),
                      _buildGroupedWalletList(surfaceColor, borderColor, textColor, subTextColor, isDark),
                      const SizedBox(height: 24),

                      // 4. MODUL BUDGETING & TUJUAN KEUANGAN (HIDUP & INTUITIF)
                      if (isDesktop)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: _buildIntuitiveBudgetCard(surfaceColor, borderColor, textColor, subTextColor, isDark)),
                            const SizedBox(width: 16),
                            Expanded(child: _buildIntuitiveGoalsCard(surfaceColor, borderColor, textColor, subTextColor, isDark)),
                          ],
                        )
                      else ...[
                        _buildIntuitiveBudgetCard(surfaceColor, borderColor, textColor, subTextColor, isDark),
                        const SizedBox(height: 16),
                        _buildIntuitiveGoalsCard(surfaceColor, borderColor, textColor, subTextColor, isDark),
                      ],
                      const SizedBox(height: 24),

                      // 5. TREN KEUANGAN 5 BULAN
                      _buildTrenKeuanganCard(surfaceColor, borderColor, textColor, subTextColor, isDark),
                      const SizedBox(height: 24),

                      // 6. PENGELUARAN PER KATEGORI
                      _buildCategoryGraphWithRightLegend(surfaceColor, borderColor, textColor, subTextColor, isDark),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // --- 1. HEADER SECTION ---
  Widget _buildHeader(Color textColor, Color subTextColor, Color surfaceColor, Color borderColor, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Analisis Keuangan',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: textColor,
                letterSpacing: -0.8,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Laporan arus kas dan performa portofolio',
              style: TextStyle(fontSize: 12, color: subTextColor, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        InkWell(
          onTap: _openDateFilterBottomSheet,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor, width: 1),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today_rounded, size: 14, color: primaryRoyalBlue),
                const SizedBox(width: 8),
                Text(
                  '${_namaBulan[_selectedMonth - 1]} $_selectedYear',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: primaryRoyalBlue),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: primaryRoyalBlue),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // --- 2. CARD RINGKASAN 3 KOLOM NOMINAL ---
  Widget _buildThreeColumnSummaryCard(Color surfaceColor, Color borderColor, Color textColor, Color subTextColor, bool isDark) {
    final pemasukan = widget.summaryData?['pemasukan'] ?? 'Rp 15.450.000';
    final pengeluaran = widget.summaryData?['pengeluaran'] ?? 'Rp 7.780.000';
    final saldoBersih = widget.summaryData?['saldo'] ?? 'Rp 7.670.000';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      child: Row(
        children: [
          // Kolom 1: Pemasukan
          Expanded(
            child: _buildSummaryColumnItem(
              title: 'Pemasukan',
              amount: pemasukan,
              percentage: '12,5%',
              isUp: true,
              accentColor: emeraldGreen,
              subTextColor: subTextColor,
              textColor: textColor,
            ),
          ),
          Container(width: 1, height: 64, color: borderColor),
          // Kolom 2: Pengeluaran
          Expanded(
            child: _buildSummaryColumnItem(
              title: 'Pengeluaran',
              amount: pengeluaran,
              percentage: '8,3%',
              isUp: true,
              accentColor: crimsonRed,
              subTextColor: subTextColor,
              textColor: textColor,
            ),
          ),
          Container(width: 1, height: 64, color: borderColor),
          // Kolom 3: Saldo Bersih
          Expanded(
            child: _buildSummaryColumnItem(
              title: 'Saldo Bersih',
              amount: saldoBersih,
              percentage: '10,7%',
              isUp: true,
              accentColor: primaryRoyalBlue,
              subTextColor: subTextColor,
              textColor: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryColumnItem({
    required String title,
    required String amount,
    required String percentage,
    required bool isUp,
    required Color accentColor,
    required Color subTextColor,
    required Color textColor,
  }) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: accentColor,
          ),
        ),
        const SizedBox(height: 6),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(
              amount,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w900,
                color: textColor,
                fontFamily: 'monospace',
                letterSpacing: -0.5,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isUp ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
              size: 13,
              color: accentColor,
            ),
            const SizedBox(width: 3),
            Text(
              percentage,
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: accentColor),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          'dari bulan lalu',
          style: TextStyle(fontSize: 9, color: subTextColor, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  // --- 3. CHIPS CATEGORY & RINCIAN DOMPET KELOMPOK ---
  Widget _buildGroupedWalletCategoryChips(bool isDark) {
    final categories = ['Semua', 'Bank', 'E-Wallet', 'Tabungan', 'Tunai'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: categories.map((cat) {
          final isSelected = _selectedWalletCategory == cat;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(cat),
              selected: isSelected,
              selectedColor: const Color(0xFF0F172A),
              backgroundColor: isDark ? const Color(0xFF1F2937) : const Color(0xFFF1F5F9),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : (isDark ? Colors.white70 : const Color(0xFF475569)),
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
              onSelected: (val) {
                setState(() {
                  _selectedWalletCategory = cat;
                });
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildGroupedWalletList(Color surfaceColor, Color borderColor, Color textColor, Color subTextColor, bool isDark) {
    final showAll = _selectedWalletCategory == 'Semua';

    return Column(
      children: [
        if (showAll || _selectedWalletCategory == 'Bank')
          _buildWalletGroupCard(
            title: 'Rekening Bank',
            totalAmount: 'Rp 7.850.000',
            surfaceColor: surfaceColor,
            borderColor: borderColor,
            textColor: textColor,
            subTextColor: subTextColor,
            isDark: isDark,
            items: [
              _buildWalletItem(name: 'BCA', subtitle: '**** 1234 • Terhubung', amount: 'Rp 3.500.000', icon: Icons.account_balance_rounded, color: primaryRoyalBlue, textColor: textColor, subTextColor: subTextColor),
              _buildWalletItem(name: 'BRI', subtitle: '**** 5678 • Terhubung', amount: 'Rp 2.000.000', icon: Icons.account_balance_rounded, color: primaryRoyalBlue, textColor: textColor, subTextColor: subTextColor),
              _buildWalletItem(name: 'Mandiri', subtitle: '**** 9012 • Terhubung', amount: 'Rp 1.750.000', icon: Icons.account_balance_rounded, color: primaryRoyalBlue, textColor: textColor, subTextColor: subTextColor),
            ],
            onAddTap: () {},
            addLabel: 'Tambah Rekening Bank',
          ),

        if (showAll || _selectedWalletCategory == 'E-Wallet') ...[
          const SizedBox(height: 14),
          _buildWalletGroupCard(
            title: 'E-Wallet',
            totalAmount: 'Rp 2.250.000',
            surfaceColor: surfaceColor,
            borderColor: borderColor,
            textColor: textColor,
            subTextColor: subTextColor,
            isDark: isDark,
            items: [
              _buildWalletItem(name: 'GoPay', subtitle: 'Terhubung', amount: 'Rp 1.200.000', icon: Icons.qr_code_2_rounded, color: const Color(0xFF00AED6), textColor: textColor, subTextColor: subTextColor),
              _buildWalletItem(name: 'OVO', subtitle: 'Terhubung', amount: 'Rp 650.000', icon: Icons.qr_code_2_rounded, color: const Color(0xFF4C2A86), textColor: textColor, subTextColor: subTextColor),
              _buildWalletItem(name: 'DANA', subtitle: 'Terhubung', amount: 'Rp 400.000', icon: Icons.qr_code_2_rounded, color: const Color(0xFF118EEA), textColor: textColor, subTextColor: subTextColor),
            ],
            onAddTap: () {},
            addLabel: 'Tambah E-Wallet',
          ),
        ],

        if (showAll || _selectedWalletCategory == 'Tabungan') ...[
          const SizedBox(height: 14),
          _buildWalletGroupCard(
            title: 'Tabungan',
            totalAmount: 'Rp 1.150.000',
            surfaceColor: surfaceColor,
            borderColor: borderColor,
            textColor: textColor,
            subTextColor: subTextColor,
            isDark: isDark,
            items: [
              _buildSavingsWalletItem(name: 'Tabungan Liburan', target: 'Target: Rp 5.000.000', amount: 'Rp 1.150.000', progress: 0.25, textColor: textColor, subTextColor: subTextColor),
            ],
          ),
        ],

        if (showAll || _selectedWalletCategory == 'Tunai') ...[
          const SizedBox(height: 14),
          _buildWalletGroupCard(
            title: 'Dompet Tunai',
            totalAmount: 'Rp 1.250.000',
            surfaceColor: surfaceColor,
            borderColor: borderColor,
            textColor: textColor,
            subTextColor: subTextColor,
            isDark: isDark,
            items: [
              _buildWalletItem(name: 'Kas Utama', subtitle: 'Tunai Fisik', amount: 'Rp 1.250.000', icon: Icons.account_balance_wallet_rounded, color: emeraldGreen, textColor: textColor, subTextColor: subTextColor),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildWalletGroupCard({
    required String title,
    required String totalAmount,
    required Color surfaceColor,
    required Color borderColor,
    required Color textColor,
    required Color subTextColor,
    required bool isDark,
    required List<Widget> items,
    VoidCallback? onAddTap,
    String? addLabel,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: borderColor, width: 1),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: textColor)),
              Text(totalAmount, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: textColor, fontFamily: 'monospace')),
            ],
          ),
          const SizedBox(height: 12),
          Column(children: items),
          if (onAddTap != null && addLabel != null) ...[
            const SizedBox(height: 8),
            InkWell(
              onTap: onAddTap,
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    const Icon(Icons.add_rounded, size: 16, color: primaryRoyalBlue),
                    const SizedBox(width: 8),
                    Text(addLabel, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: primaryRoyalBlue)),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildWalletItem({
    required String name,
    required String subtitle,
    required String amount,
    required IconData icon,
    required Color color,
    required Color textColor,
    required Color subTextColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: textColor)),
                const SizedBox(height: 2),
                Row(
                  children: [
                    if (subtitle.contains('Terhubung')) ...[
                      const Icon(Icons.check_circle_rounded, size: 10, color: emeraldGreen),
                      const SizedBox(width: 4),
                    ],
                    Text(subtitle, style: TextStyle(fontSize: 10, color: subTextColor, fontWeight: FontWeight.w500)),
                  ],
                ),
              ],
            ),
          ),
          Text(amount, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: textColor, fontFamily: 'monospace')),
        ],
      ),
    );
  }

  Widget _buildSavingsWalletItem({
    required String name,
    required String target,
    required String amount,
    required double progress,
    required Color textColor,
    required Color subTextColor,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: emeraldGreen.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.shopping_bag_outlined, color: emeraldGreen, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: textColor)),
                  const SizedBox(height: 2),
                  Text(target, style: TextStyle(fontSize: 10, color: subTextColor, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            Text(amount, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: textColor, fontFamily: 'monospace')),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 5,
                  backgroundColor: const Color(0xFFE2E8F0),
                  valueColor: const AlwaysStoppedAnimation<Color>(emeraldGreen),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text('${(progress * 100).toInt()}%', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: textColor)),
          ],
        ),
      ],
    );
  }

  // --- 4A. INTUITIVE HEATMAP BUDGET CARD ---
  Widget _buildIntuitiveBudgetCard(Color surfaceColor, Color borderColor, Color textColor, Color subTextColor, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Budget Bulan Ini', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: textColor)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: emeraldGreen.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
                child: const Text('70%', style: TextStyle(color: emeraldGreen, fontSize: 12, fontWeight: FontWeight.w900)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text('Sisa Budget', style: TextStyle(fontSize: 11, color: subTextColor, fontWeight: FontWeight.w600)),
          const SizedBox(height: 2),
          Text(
            'Rp 1.800.000',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: textColor, fontFamily: 'monospace', letterSpacing: -0.5),
          ),
          Text('dari Rp 6.000.000', style: TextStyle(fontSize: 11, color: subTextColor)),
          const SizedBox(height: 18),

          // Dynamic Heatmap Gradient Bar (Hijau -> Oranye -> Merah)
          Container(
            height: 12,
            width: double.infinity,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Stack(
              children: [
                FractionallySizedBox(
                  widthFactor: 0.70,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF10B981), Color(0xFFF59E0B), Color(0xFFEF4444)],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('0%', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
              Text('50%', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
              Text('75%', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
              Text('100%', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 18),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () {},
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Lihat Semua', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: primaryRoyalBlue)),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward_ios_rounded, size: 12, color: primaryRoyalBlue),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- 4B. INTUITIVE MILESTONE GOALS CARD ---
  Widget _buildIntuitiveGoalsCard(Color surfaceColor, Color borderColor, Color textColor, Color subTextColor, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Tujuan Keuangan', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: textColor)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: primaryRoyalBlue.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
                child: const Text('55%', style: TextStyle(color: primaryRoyalBlue, fontSize: 12, fontWeight: FontWeight.w900)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: primaryRoyalBlue.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.shield_outlined, color: primaryRoyalBlue, size: 20),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Dana Darurat', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textColor)),
                  Text('Rp 2.750.000', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: textColor, fontFamily: 'monospace')),
                  Text('dari Rp 5.000.000', style: TextStyle(fontSize: 10, color: subTextColor)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Interactive Milestone Node Slider Bar
          SizedBox(
            height: 20,
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                Container(
                  height: 4,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: 0.55,
                  child: Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: primaryRoyalBlue,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                // Left Node
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: primaryRoyalBlue, width: 3),
                  ),
                ),
                // Glowing Current Node
                Align(
                  alignment: const Alignment(-0.1, 0),
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: primaryRoyalBlue,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: primaryRoyalBlue.withOpacity(0.4), blurRadius: 8, spreadRadius: 2),
                      ],
                    ),
                  ),
                ),
                // End Node
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined, size: 12, color: primaryRoyalBlue),
              const SizedBox(width: 6),
              Text('Target 31 Des 2026', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textColor)),
            ],
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () {},
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Lihat Semua', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: primaryRoyalBlue)),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward_ios_rounded, size: 12, color: primaryRoyalBlue),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- 5. TREN KEUANGAN ---
  Widget _buildTrenKeuanganCard(Color surfaceColor, Color borderColor, Color textColor, Color subTextColor, bool isDark) {
    final mockTrend = [
      {'bulan': 'Mei', 'masuk': 0.6, 'keluar': 0.35},
      {'bulan': 'Jun', 'masuk': 0.8, 'keluar': 0.5},
      {'bulan': 'Jul', 'masuk': 0.65, 'keluar': 0.55},
      {'bulan': 'Agu', 'masuk': 0.9, 'keluar': 0.4},
      {'bulan': 'Sep', 'masuk': 0.85, 'keluar': 0.45},
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Tren Keuangan 5 Bulan', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: textColor)),
              Row(
                children: [
                  _legendDot(primaryRoyalBlue, 'Masuk', subTextColor),
                  const SizedBox(width: 12),
                  _legendDot(accentHoneyGold, 'Keluar', subTextColor),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 130,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: mockTrend.map((item) {
                final double hMasuk = (item['masuk'] as double) * 95;
                final double hKeluar = (item['keluar'] as double) * 95;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(width: 10, height: hMasuk, decoration: BoxDecoration(color: primaryRoyalBlue, borderRadius: BorderRadius.circular(4))),
                        const SizedBox(width: 4),
                        Container(width: 10, height: hKeluar, decoration: BoxDecoration(color: accentHoneyGold, borderRadius: BorderRadius.circular(4))),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(item['bulan'] as String, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: subTextColor)),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _legendDot(Color color, String label, Color subTextColor) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: subTextColor)),
      ],
    );
  }

  // --- 6. CATEGORY GRAPH ---
  Widget _buildCategoryGraphWithRightLegend(Color surfaceColor, Color borderColor, Color textColor, Color subTextColor, bool isDark) {
    final categories = [
      {'nama': 'Makanan & Konsumsi', 'persen': 40, 'nominal': 'Rp 1.121.600', 'color': primaryRoyalBlue},
      {'nama': 'Belanja Harian', 'persen': 25, 'nominal': 'Rp 701.000', 'color': accentHoneyGold},
      {'nama': 'Transportasi', 'persen': 20, 'nominal': 'Rp 560.800', 'color': emeraldGreen},
      {'nama': 'Tagihan & Lainnya', 'persen': 15, 'nominal': 'Rp 420.778', 'color': purpleAccent},
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Pengeluaran Per Kategori', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: textColor)),
          const SizedBox(height: 20),
          Row(
            children: [
              SizedBox(
                width: 110,
                height: 110,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 96,
                      height: 96,
                      child: CircularProgressIndicator(
                        value: 1.0,
                        strokeWidth: 14,
                        valueColor: AlwaysStoppedAnimation<Color>(primaryRoyalBlue.withOpacity(0.15)),
                      ),
                    ),
                    SizedBox(
                      width: 96,
                      height: 96,
                      child: const CircularProgressIndicator(
                        value: 0.40,
                        strokeWidth: 14,
                        valueColor: AlwaysStoppedAnimation<Color>(primaryRoyalBlue),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Total', style: TextStyle(fontSize: 10, color: subTextColor, fontWeight: FontWeight.bold)),
                        Text('100%', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: textColor)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 22),
              Expanded(
                child: Column(
                  children: categories.map((c) {
                    final color = c['color'] as Color;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                              const SizedBox(width: 8),
                              Text(c['nama'] as String, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textColor)),
                            ],
                          ),
                          Text('${c['persen']}%', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: color, fontFamily: 'monospace')),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color textColor) {
    return Text(
      title,
      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: textColor, letterSpacing: -0.3),
    );
  }
}
