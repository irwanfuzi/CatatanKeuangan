import 'package:flutter/material.dart';

class AnalisisScreen extends StatefulWidget {
  final Map<String, dynamic>? summaryData; // <--- Deklarasi parameter resmi

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

  final List<String> _namaBulan = const [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
  ];

  static const Color primaryRoyalBlue = Color(0xFF0052FF);
  static const Color accentHoneyGold = Color(0xFFFF9F00);
  static const Color emeraldGreen = Color(0xFF10B981);
  static const Color crimsonRed = Color(0xFFEF4444);

  void _openDateFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final surfaceColor = isDark ? const Color(0xFF0F172A) : Colors.white;
        int tempMonth = _selectedMonth;
        int tempYear = _selectedYear;

        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 36,
                      height: 4,
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Pilih Periode Analisis',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Tahun', style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white70 : Colors.black87)),
                      Row(
                        children: [2024, 2025, 2026].map((y) {
                          final isSelected = tempYear == y;
                          return Padding(
                            padding: const EdgeInsets.only(left: 6.0),
                            child: ChoiceChip(
                              label: Text('$y'),
                              selected: isSelected,
                              selectedColor: primaryRoyalBlue,
                              labelStyle: TextStyle(color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87), fontWeight: FontWeight.bold),
                              onSelected: (val) => setModalState(() => tempYear = y),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text('Bulan', style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white70 : Colors.black87)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(12, (index) {
                      final monthNum = index + 1;
                      final isSelected = tempMonth == monthNum;
                      return InkWell(
                        onTap: () => setModalState(() => tempMonth = monthNum),
                        borderRadius: BorderRadius.circular(10),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? primaryRoyalBlue : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            _namaBulan[index],
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : (isDark ? Colors.white : const Color(0xFF0F172A)),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryRoyalBlue,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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
    final backgroundColor = isDark ? const Color(0xFF060A12) : const Color(0xFFF1F4F9);
    final surfaceColor = isDark ? const Color(0xFF0F172A) : Colors.white;
    final borderColor = isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final subTextColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

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
                    horizontal: isDesktop ? 32.0 : 16.0,
                    vertical: 16.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeaderWithDateFilter(textColor, subTextColor, surfaceColor, borderColor, isDark),
                      const SizedBox(height: 18),
                      _buildUnifiedSummaryCard(surfaceColor, borderColor, textColor, subTextColor, isDark),
                      const SizedBox(height: 20),
                      Text('Rincian Dompet Saya', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: textColor)),
                      const SizedBox(height: 10),
                      _buildMyWalletTrack(surfaceColor, borderColor, textColor, subTextColor, isDark),
                      const SizedBox(height: 20),
                      _buildTrenKeuanganCard(surfaceColor, borderColor, textColor, subTextColor, isDark),
                      const SizedBox(height: 20),
                      _buildCategoryGraphWithRightLegend(surfaceColor, borderColor, textColor, subTextColor, isDark),
                      const SizedBox(height: 20),
                      if (isDesktop)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: _buildBudgetingModule(surfaceColor, borderColor, textColor, subTextColor, isDark)),
                            const SizedBox(width: 16),
                            Expanded(child: _buildFinancialGoalsModule(surfaceColor, borderColor, textColor, subTextColor, isDark)),
                          ],
                        )
                      else ...[
                        _buildBudgetingModule(surfaceColor, borderColor, textColor, subTextColor, isDark),
                        const SizedBox(height: 16),
                        _buildFinancialGoalsModule(surfaceColor, borderColor, textColor, subTextColor, isDark),
                      ],
                      const SizedBox(height: 36),
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

  Widget _buildHeaderWithDateFilter(Color textColor, Color subTextColor, Color surfaceColor, Color borderColor, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Analisis Keuangan', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: textColor, letterSpacing: -0.8)),
            const SizedBox(height: 2),
            Text('Laporan arus kas dan performa portofolio', style: TextStyle(fontSize: 12, color: subTextColor)),
          ],
        ),
        InkWell(
          onTap: _openDateFilterBottomSheet,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(color: surfaceColor, borderRadius: BorderRadius.circular(14), border: Border.all(color: borderColor)),
            child: Row(
              children: [
                const Icon(Icons.calendar_month_rounded, size: 16, color: primaryRoyalBlue),
                const SizedBox(width: 6),
                Text('${_namaBulan[_selectedMonth - 1]} $_selectedYear', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: primaryRoyalBlue)),
                const SizedBox(width: 4),
                const Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: primaryRoyalBlue),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUnifiedSummaryCard(Color surfaceColor, Color borderColor, Color textColor, Color subTextColor, bool isDark) {
    final saldoTotal = widget.summaryData?['saldo'] ?? 'Rp 11.250.000';
    final pemasukan = widget.summaryData?['pemasukan'] ?? 'Rp 5.250.000';
    final pengeluaran = widget.summaryData?['pengeluaran'] ?? 'Rp 2.804.178';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: surfaceColor, borderRadius: BorderRadius.circular(22), border: Border.all(color: borderColor)),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('TOTAL ASET KESELURUHAN', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: subTextColor, letterSpacing: 1.2)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: primaryRoyalBlue.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                child: const Text('Aktif', style: TextStyle(color: primaryRoyalBlue, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(saldoTotal, style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: textColor, fontFamily: 'monospace')),
          const SizedBox(height: 16),
          Divider(color: borderColor, height: 1),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('PEMASUKAN BULAN INI', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: subTextColor)),
                    const SizedBox(height: 4),
                    Text(pemasukan, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: emeraldGreen, fontFamily: 'monospace')),
                  ],
                ),
              ),
              Container(width: 1, height: 32, color: borderColor),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('PENGELUARAN BULAN INI', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: subTextColor)),
                    const SizedBox(height: 4),
                    Text(pengeluaran, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: crimsonRed, fontFamily: 'monospace')),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMyWalletTrack(Color surfaceColor, Color borderColor, Color textColor, Color subTextColor, bool isDark) {
    final wallets = [
      {'title': 'Tunai Utama', 'amount': 'Rp 1.250.000', 'icon': Icons.account_balance_wallet_rounded, 'color': emeraldGreen},
      {'title': 'Rekening Bank', 'amount': 'Rp 7.850.000', 'icon': Icons.account_balance_rounded, 'color': primaryRoyalBlue},
      {'title': 'E-Wallet', 'amount': 'Rp 2.150.000', 'icon': Icons.qr_code_2_rounded, 'color': accentHoneyGold},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: wallets.map((w) {
          final color = w['color'] as Color;
          return Container(
            width: 150,
            margin: const EdgeInsets.only(right: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: surfaceColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: borderColor)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(w['icon'] as IconData, color: color, size: 16),
                const SizedBox(height: 10),
                Text(w['title'] as String, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textColor)),
                Text(w['amount'] as String, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: textColor, fontFamily: 'monospace')),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTrenKeuanganCard(Color surfaceColor, Color borderColor, Color textColor, Color subTextColor, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: surfaceColor, borderRadius: BorderRadius.circular(20), border: Border.all(color: borderColor)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tren Keuangan 5 Bulan', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: textColor)),
          const SizedBox(height: 20),
          SizedBox(
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: ['Mei', 'Jun', 'Jul', 'Agu', 'Sep'].map((b) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(width: 12, height: 60, decoration: BoxDecoration(color: primaryRoyalBlue, borderRadius: BorderRadius.circular(4))),
                    const SizedBox(height: 6),
                    Text(b, style: TextStyle(fontSize: 10, color: subTextColor)),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryGraphWithRightLegend(Color surfaceColor, Color borderColor, Color textColor, Color subTextColor, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: surfaceColor, borderRadius: BorderRadius.circular(20), border: Border.all(color: borderColor)),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: primaryRoyalBlue, width: 10)),
            child: Center(child: Text('100%', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: textColor))),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Makanan: 40%', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textColor)),
                Text('Belanja: 25%', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textColor)),
                Text('Transport: 20%', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textColor)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetingModule(Color surfaceColor, Color borderColor, Color textColor, Color subTextColor, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: surfaceColor, borderRadius: BorderRadius.circular(20), border: Border.all(color: borderColor)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Budgeting', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: textColor)),
          const SizedBox(height: 8),
          const LinearProgressIndicator(value: 0.47, color: emeraldGreen),
        ],
      ),
    );
  }

  Widget _buildFinancialGoalsModule(Color surfaceColor, Color borderColor, Color textColor, Color subTextColor, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: surfaceColor, borderRadius: BorderRadius.circular(20), border: Border.all(color: borderColor)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tujuan Keuangan', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: textColor)),
          const SizedBox(height: 8),
          const LinearProgressIndicator(value: 0.75, color: accentHoneyGold),
        ],
      ),
    );
  }
}
