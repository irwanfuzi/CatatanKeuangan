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

  final List<String> _namaBulan = const [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
  ];

  // Colors Palette MyKas Identity
  static const Color primaryRoyalBlue = Color(0xFF0052FF);
  static const Color accentHoneyGold = Color(0xFFFF9F00);
  static const Color emeraldGreen = Color(0xFF10B981);
  static const Color crimsonRed = Color(0xFFEF4444);

  // BottomSheet Filter Bulan & Tahun
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
                  
                  // Filter Tahun
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

                  // Grid Filter Bulan
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
                      // 1. HEADER & DATE FILTER INPUT
                      _buildHeaderWithDateFilter(textColor, subTextColor, surfaceColor, borderColor, isDark),
                      const SizedBox(height: 18),

                      // 2. UNIFIED 1-CARD SUMMARY (TOTAL ASET, PEMASUKAN, PENGELUARAN)
                      _buildUnifiedSummaryCard(surfaceColor, borderColor, textColor, subTextColor, isDark),
                      const SizedBox(height: 20),

                      // 3. RINCIAN MY WALLET TRACK
                      _buildSectionHeader('Rincian Dompet Saya'),
                      const SizedBox(height: 10),
                      _buildMyWalletTrack(surfaceColor, borderColor, textColor, subTextColor, isDark),
                      const SizedBox(height: 20),

                      // 4. TREN KEUANGAN BEBERAPA BULAN
                      _buildTrenKeuanganCard(surfaceColor, borderColor, textColor, subTextColor, isDark),
                      const SizedBox(height: 20),

                      // 5. GRAFIK PENGELUARAN PER KATEGORI (KETERANGAN DI KANAN)
                      _buildCategoryGraphWithRightLegend(surfaceColor, borderColor, textColor, subTextColor, isDark),
                      const SizedBox(height: 20),

                      // 6. 2-KOLOM GRID: BUDGETING & TUJUAN KEUANGAN
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

  // --- 1. HEADER WITH DATE FILTER BUTTON ---
  Widget _buildHeaderWithDateFilter(Color textColor, Color subTextColor, Color surfaceColor, Color borderColor, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Analisis Keuangan',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: textColor,
                letterSpacing: -0.8,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Laporan arus kas dan performa portofolio',
              style: TextStyle(fontSize: 12, color: subTextColor),
            ),
          ],
        ),
        InkWell(
          onTap: _openDateFilterBottomSheet,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderColor, width: 1),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_month_rounded, size: 16, color: primaryRoyalBlue),
                const SizedBox(width: 6),
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

  // --- 2. 1 CONTAINER 3 ITEM (TOTAL ASET, PEMASUKAN, PENGELUARAN) ---
  Widget _buildUnifiedSummaryCard(Color surfaceColor, Color borderColor, Color textColor, Color subTextColor, bool isDark) {
    final saldoTotal = widget.summaryData?['saldo'] ?? 'Rp 11.250.000';
    final pemasukan = widget.summaryData?['pemasukan'] ?? 'Rp 5.250.000';
    final pengeluaran = widget.summaryData?['pengeluaran'] ?? 'Rp 2.804.178';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Saldo Total Aset
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(width: 6, height: 6, decoration: const BoxDecoration(color: primaryRoyalBlue, shape: BoxShape.circle)),
                  const SizedBox(width: 8),
                  Text('TOTAL ASET KESELURUHAN', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: subTextColor, letterSpacing: 1.2)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: primaryRoyalBlue.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                child: const Text('Aktif', style: TextStyle(color: primaryRoyalBlue, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            saldoTotal,
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: textColor, fontFamily: 'monospace', letterSpacing: -0.8),
          ),
          const SizedBox(height: 16),
          Divider(color: borderColor, height: 1),
          const SizedBox(height: 16),

          // Row 2: Grid Pemasukan & Pengeluaran Bulan Berjalan
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.arrow_downward_rounded, size: 12, color: emeraldGreen),
                        const SizedBox(width: 4),
                        Text('PEMASUKAN BULAN INI', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: subTextColor, letterSpacing: 0.8)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(pemasukan, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: emeraldGreen, fontFamily: 'monospace')),
                  ],
                ),
              ),
              Container(width: 1, height: 32, color: borderColor),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.arrow_upward_rounded, size: 12, color: crimsonRed),
                        const SizedBox(width: 4),
                        Text('PENGELUARAN BULAN INI', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: subTextColor, letterSpacing: 0.8)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(pengeluaran, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: crimsonRed, fontFamily: 'monospace')),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- 3. RINCIAN MY WALLET ---
  Widget _buildMyWalletTrack(Color surfaceColor, Color borderColor, Color textColor, Color subTextColor, bool isDark) {
    final wallets = [
      {'title': 'Tunai Utama', 'amount': 'Rp 1.250.000', 'icon': Icons.account_balance_wallet_rounded, 'color': emeraldGreen},
      {'title': 'Rekening Bank', 'amount': 'Rp 7.850.000', 'icon': Icons.account_balance_rounded, 'color': primaryRoyalBlue},
      {'title': 'E-Wallet', 'amount': 'Rp 2.150.000', 'icon': Icons.qr_code_2_rounded, 'color': accentHoneyGold},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: wallets.map((w) {
          final color = w['color'] as Color;

          return Container(
            width: 150,
            margin: const EdgeInsets.only(right: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
                  child: Icon(w['icon'] as IconData, color: color, size: 16),
                ),
                const SizedBox(height: 10),
                Text(w['title'] as String, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textColor)),
                const SizedBox(height: 2),
                Text(w['amount'] as String, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: textColor, fontFamily: 'monospace')),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // --- 4. TREN KEUANGAN BEBERAPA BULAN ---
  Widget _buildTrenKeuanganCard(Color surfaceColor, Color borderColor, Color textColor, Color subTextColor, bool isDark) {
    final mockTrend = [
      {'bulan': 'Mei', 'masuk': 0.6, 'keluar': 0.4},
      {'bulan': 'Jun', 'masuk': 0.8, 'keluar': 0.5},
      {'bulan': 'Jul', 'masuk': 0.7, 'keluar': 0.6},
      {'bulan': 'Agu', 'masuk': 0.9, 'keluar': 0.4},
      {'bulan': 'Sep', 'masuk': 0.85, 'keluar': 0.45},
    ];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Tren Keuangan 5 Bulan', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: textColor)),
              Row(
                children: [
                  _legendDot(primaryRoyalBlue, 'Masuk', subTextColor),
                  const SizedBox(width: 10),
                  _legendDot(accentHoneyGold, 'Keluar', subTextColor),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 120,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: mockTrend.map((item) {
                final double hMasuk = (item['masuk'] as double) * 90;
                final double hKeluar = (item['keluar'] as double) * 90;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(width: 10, height: hMasuk, decoration: BoxDecoration(color: primaryRoyalBlue, borderRadius: BorderRadius.circular(3))),
                        const SizedBox(width: 3),
                        Container(width: 10, height: hKeluar, decoration: BoxDecoration(color: accentHoneyGold, borderRadius: BorderRadius.circular(3))),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(item['bulan'] as String, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: subTextColor)),
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
        Container(width: 7, height: 7, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: subTextColor)),
      ],
    );
  }

  // --- 5. GRAFIK PENGELUARAN PER KATEGORI (KETERANGAN DI KANAN) ---
  Widget _buildCategoryGraphWithRightLegend(Color surfaceColor, Color borderColor, Color textColor, Color subTextColor, bool isDark) {
    final categories = [
      {'nama': 'Makanan', 'persen': 40, 'color': primaryRoyalBlue},
      {'nama': 'Belanja', 'persen': 25, 'color': accentHoneyGold},
      {'nama': 'Transport', 'persen': 20, 'color': emeraldGreen},
      {'nama': 'Lainnya', 'persen': 15, 'color': const Color(0xFF8B5CF6)},
    ];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Pengeluaran Per Kategori', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: textColor)),
          const SizedBox(height: 16),
          Row(
            children: [
              // Ring Donut Custom Visual (Kiri)
              SizedBox(
                width: 100,
                height: 100,
                child: Stack(
                  children: [
                    Center(
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: primaryRoyalBlue, width: 12),
                        ),
                      ),
                    ),
                    Center(
                      child: Text('100%', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: textColor)),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              // Keterangan / Legend (Di Kanan Grafik)
              Expanded(
                child: Column(
                  children: categories.map((c) {
                    final color = c['color'] as Color;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
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
                          Text('${c['persen']}%', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: subTextColor, fontFamily: 'monospace')),
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

  // --- 6A. BUDGETING MODULE ---
  Widget _buildBudgetingModule(Color surfaceColor, Color borderColor, Color textColor, Color subTextColor, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Budgeting', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: textColor)),
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SemuaBudgetScreen()));
                },
                child: const Text('Lihat Semua', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: primaryRoyalBlue)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text('Pengeluaran Bulanan', style: TextStyle(fontSize: 11, color: subTextColor)),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Rp 2.350.000', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: textColor, fontFamily: 'monospace')),
              Text('dari Rp 5.000.000', style: TextStyle(fontSize: 10, color: subTextColor)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: const LinearProgressIndicator(
              value: 0.47,
              minHeight: 6,
              backgroundColor: Color(0xFFE2E8F0),
              valueColor: AlwaysStoppedAnimation<Color>(emeraldGreen),
            ),
          ),
        ],
      ),
    );
  }

  // --- 6B. TUJUAN KEUANGAN MODULE ---
  Widget _buildFinancialGoalsModule(Color surfaceColor, Color borderColor, Color textColor, Color subTextColor, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Tujuan Keuangan', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: textColor)),
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SemuaTujuanKeuanganScreen()));
                },
                child: const Text('Lihat Semua', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: primaryRoyalBlue)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text('Dana Darurat', style: TextStyle(fontSize: 11, color: subTextColor)),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Rp 7.500.000', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: textColor, fontFamily: 'monospace')),
              Text('Target Rp 10.000.000', style: TextStyle(fontSize: 10, color: subTextColor)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: const LinearProgressIndicator(
              value: 0.75,
              minHeight: 6,
              backgroundColor: Color(0xFFE2E8F0),
              valueColor: AlwaysStoppedAnimation<Color>(accentHoneyGold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, letterSpacing: -0.3),
    );
  }
}

// ==========================================
// HALAMAN LIST SEMUA BUDGET
// ==========================================
class SemuaBudgetScreen extends StatelessWidget {
  const SemuaBudgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? const Color(0xFF0F172A) : Colors.white;
    final borderColor = isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);

    final budgetList = [
      {'nama': 'Makanan & Konsumsi', 'terpakai': 'Rp 1.200.000', 'total': 'Rp 2.000.000', 'progress': 0.6, 'color': const Color(0xFF0052FF)},
      {'nama': 'Belanja Bulanan', 'terpakai': 'Rp 650.000', 'total': 'Rp 1.000.000', 'progress': 0.65, 'color': const Color(0xFFFF9F00)},
      {'nama': 'Transportasi & Bensin', 'terpakai': 'Rp 300.000', 'total': 'Rp 500.000', 'progress': 0.6, 'color': const Color(0xFF10B981)},
      {'nama': 'Hiburan & Rekreasi', 'terpakai': 'Rp 200.000', 'total': 'Rp 1.000.000', 'progress': 0.2, 'color': const Color(0xFF8B5CF6)},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Semua Budget', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: budgetList.length,
        itemBuilder: (context, index) {
          final item = budgetList[index];
          final color = item['color'] as Color;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['nama'] as String, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textColor)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(item['terpakai'] as String, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: textColor, fontFamily: 'monospace')),
                    Text('dari ${item['total']}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: item['progress'] as double,
                    minHeight: 6,
                    backgroundColor: const Color(0xFFE2E8F0),
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ==========================================
// HALAMAN LIST SEMUA TUJUAN KEUANGAN
// ==========================================
class SemuaTujuanKeuanganScreen extends StatelessWidget {
  const SemuaTujuanKeuanganScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? const Color(0xFF0F172A) : Colors.white;
    final borderColor = isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);

    final goalList = [
      {'nama': 'Dana Darurat 6 Bulan', 'terkumpul': 'Rp 7.500.000', 'target': 'Rp 10.000.000', 'progress': 0.75, 'color': const Color(0xFFFF9F00)},
      {'nama': 'Liburan Akhir Tahun', 'terkumpul': 'Rp 3.000.000', 'target': 'Rp 5.000.000', 'progress': 0.60, 'color': const Color(0xFF0052FF)},
      {'nama': 'Beli Laptop Baru', 'terkumpul': 'Rp 12.000.000', 'target': 'Rp 15.000.000', 'progress': 0.80, 'color': const Color(0xFF10B981)},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Semua Tujuan Keuangan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: goalList.length,
        itemBuilder: (context, index) {
          final item = goalList[index];
          final color = item['color'] as Color;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['nama'] as String, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textColor)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(item['terkumpul'] as String, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: textColor, fontFamily: 'monospace')),
                    Text('Target ${item['target']}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: item['progress'] as double,
                    minHeight: 6,
                    backgroundColor: const Color(0xFFE2E8F0),
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

