import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../services/api_service.dart';

class AnalisisScreen extends StatefulWidget {
  const AnalisisScreen({super.key});

  @override
  State<AnalisisScreen> createState() => _AnalisisScreenState();
}

class _AnalisisScreenState extends State<AnalisisScreen> {
  int _touchedPieIndex = -1;
  int _selectedPeriodIndex = 0; // 0: Bulan Ini, 1: 3 Bulan, 2: Tahun Ini

  // Color Palette dengan identitas utama Royal Blue (#0052FF) & Honey Gold (#FF9F00)
  final List<Color> _royalBluePalette = const [
    Color(0xFF0052FF), // MyKas Royal Blue Utama
    Color(0xFFFF9F00), // Honey Gold Accent Logo
    Color(0xFF2563EB), // Vivid Blue
    Color(0xFF10B981), // Emerald Green
    Color(0xFF8B5CF6), // Royal Purple
    Color(0xFF0284C7), // Sky Blue
    Color(0xFFEC4899), // Rose Gold
  ];

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
        child: FutureBuilder<Map<String, dynamic>>(
          future: ApiService.getSummary(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF0052FF),
                  strokeWidth: 3,
                ),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF4444).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.error_outline_rounded, color: Color(0xFFEF4444), size: 36),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'Gagal Mengambil Data Analisis',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textColor),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        snapshot.error.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: subTextColor, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              );
            }

            final data = snapshot.data ?? {};
            final pemasukan = data['pemasukan'] ?? 'Rp 0';
            final pengeluaran = data['pengeluaran'] ?? 'Rp 0';
            final riwayat = data['riwayat'] as List<dynamic>? ?? [];

            Map<String, double> kategoriMap = {};
            double totalPengeluaranAngka = 0;

            // Parsing pengeluaran aman dari API
            for (var item in riwayat) {
              if (item['jenis'].toString().toLowerCase().contains('pengeluaran')) {
                String namaKategori = item['kategori']?.toString() ?? 'Lainnya';
                double nominal = double.tryParse(item['nominal']?.toString() ?? '0') ?? 0.0;
                kategoriMap[namaKategori] = (kategoriMap[namaKategori] ?? 0) + nominal;
                totalPengeluaranAngka += nominal;
              }
            }

            // Membangun Pie Chart Sections dengan Warna Utama Royal Blue
            List<PieChartSectionData> pieSections = [];
            int colorIndex = 0;

            if (totalPengeluaranAngka > 0) {
              kategoriMap.forEach((kategori, jumlah) {
                final isTouched = colorIndex == _touchedPieIndex;
                final double fontSize = isTouched ? 13 : 11;
                final double radius = isTouched ? 54 : 44;
                double persentase = (jumlah / totalPengeluaranAngka) * 100;

                pieSections.add(
                  PieChartSectionData(
                    color: _royalBluePalette[colorIndex % _royalBluePalette.length],
                    value: persentase,
                    title: '${persentase.toStringAsFixed(0)}%',
                    radius: radius,
                    titleStyle: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      fontFamily: 'monospace',
                    ),
                  ),
                );
                colorIndex++;
              });
            } else {
              pieSections.add(
                PieChartSectionData(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                  value: 100,
                  title: '0%',
                  radius: 44,
                  titleStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: subTextColor),
                ),
              );
            }

            return LayoutBuilder(
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
                          // 1. HEADER & PERIOD CONTROL
                          _buildHeader(textColor, subTextColor, surfaceColor, borderColor, isDark),
                          const SizedBox(height: 18),

                          // 2. HERO CASHFLOW EXECUTIVE STRIP
                          _buildRoyalExecutiveSummary(pemasukan, pengeluaran, surfaceColor, borderColor, textColor, subTextColor),
                          const SizedBox(height: 20),

                          // 3. RESPONSIVE DASHBOARD LAYOUT
                          if (isDesktop)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: _buildPieChartCard(pieSections, totalPengeluaranAngka, kategoriMap, surfaceColor, borderColor, textColor, subTextColor, isDark),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  flex: 2,
                                  child: _buildCategoryList(kategoriMap, totalPengeluaranAngka, surfaceColor, borderColor, textColor, subTextColor, isDark),
                                ),
                              ],
                            )
                          else ...[
                            _buildPieChartCard(pieSections, totalPengeluaranAngka, kategoriMap, surfaceColor, borderColor, textColor, subTextColor, isDark),
                            const SizedBox(height: 20),
                            _buildCategoryList(kategoriMap, totalPengeluaranAngka, surfaceColor, borderColor, textColor, subTextColor, isDark),
                          ],

                          const SizedBox(height: 36),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  // --- 1. HEADER & PERIOD SEGMENTED CONTROL ---
  Widget _buildHeader(Color textColor, Color subTextColor, Color surfaceColor, Color borderColor, bool isDark) {
    final periods = ['Bulan Ini', '3 Bulan', 'Tahun Ini'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0052FF).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.analytics_rounded, color: Color(0xFF0052FF), size: 20),
                ),
                const SizedBox(width: 12),
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
                      'Evaluasi arus kas & alokasi pengeluaran',
                      style: TextStyle(fontSize: 12, color: subTextColor),
                    ),
                  ],
                ),
              ],
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.file_download_outlined, size: 20, color: Color(0xFF0052FF)),
              style: IconButton.styleFrom(
                backgroundColor: surfaceColor,
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(9),
                side: BorderSide(color: borderColor, width: 1),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Segmented Control Pill
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: 1),
          ),
          child: Row(
            children: periods.asMap().entries.map((entry) {
              final idx = entry.key;
              final label = entry.value;
              final isSelected = _selectedPeriodIndex == idx;

              return Expanded(
                child: InkWell(
                  onTap: () => setState(() => _selectedPeriodIndex = idx),
                  borderRadius: BorderRadius.circular(12),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF0052FF) : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: const Color(0xFF0052FF).withOpacity(0.25),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              )
                            ]
                          : null,
                    ),
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                        color: isSelected ? Colors.white : subTextColor,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // --- 2. ROYAL BLUE EXECUTIVE CASHFLOW SUMMARY ---
  Widget _buildRoyalExecutiveSummary(
    String pemasukan,
    String pengeluaran,
    Color surfaceColor,
    Color borderColor,
    Color textColor,
    Color subTextColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
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
                          child: const FaIcon(FontAwesomeIcons.arrowDown, color: Color(0xFF10B981), size: 10),
                        ),
                        const SizedBox(width: 8),
                        Text('PEMASUKAN', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: subTextColor, letterSpacing: 1.2)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      pemasukan,
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: textColor, fontFamily: 'monospace'),
                    ),
                  ],
                ),
              ),
              Container(width: 1, height: 38, color: borderColor),
              const SizedBox(width: 16),
              Expanded(
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
                          child: const FaIcon(FontAwesomeIcons.arrowUp, color: Color(0xFFEF4444), size: 10),
                        ),
                        const SizedBox(width: 8),
                        Text('PENGELUARAN', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: subTextColor, letterSpacing: 1.2)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      pengeluaran,
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: textColor, fontFamily: 'monospace'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Micro Cashflow Ratio Track
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: const Row(
              children: [
                Expanded(flex: 62, child: SizedBox(height: 6, child: DecoratedBox(decoration: BoxDecoration(color: Color(0xFF10B981))))),
                SizedBox(width: 3),
                Expanded(flex: 38, child: SizedBox(height: 6, child: DecoratedBox(decoration: BoxDecoration(color: Color(0xFFEF4444))))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- 3. PIE CHART CARD WITH ROYAL BLUE ACCENT ---
  Widget _buildPieChartCard(
    List<PieChartSectionData> pieSections,
    double totalPengeluaran,
    Map<String, double> kategoriMap,
    Color surfaceColor,
    Color borderColor,
    Color textColor,
    Color subTextColor,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Distribusi Pengeluaran',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: textColor),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF0052FF).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text('Proporsional', style: TextStyle(color: Color(0xFF0052FF), fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 22),
          SizedBox(
            height: 180,
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    setState(() {
                      if (!event.isInterestedForInteractions || pieTouchResponse == null || pieTouchResponse.touchedSection == null) {
                        _touchedPieIndex = -1;
                        return;
                      }
                      _touchedPieIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                    });
                  },
                ),
                borderData: FlBorderData(show: false),
                sectionsSpace: 3,
                centerSpaceRadius: 42,
                sections: pieSections,
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Royal Blue Legend Wrap Pills
          if (kategoriMap.isNotEmpty)
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: kategoriMap.keys.toList().asMap().entries.map((entry) {
                final idx = entry.key;
                final name = entry.value;
                final color = _royalBluePalette[idx % _royalBluePalette.length];

                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                    const SizedBox(width: 6),
                    Text(name, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: subTextColor)),
                  ],
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  // --- 4. CATEGORY BREAKDOWN LIST ---
  Widget _buildCategoryList(
    Map<String, double> kategoriMap,
    double totalPengeluaran,
    Color surfaceColor,
    Color borderColor,
    Color textColor,
    Color subTextColor,
    bool isDark,
  ) {
    final entries = kategoriMap.entries.toList();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Rincian Kategori',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: textColor),
          ),
          const SizedBox(height: 16),
          if (entries.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 32),
              width: double.infinity,
              child: Column(
                children: [
                  Icon(Icons.inbox_rounded, size: 36, color: subTextColor.withOpacity(0.5)),
                  const SizedBox(height: 8),
                  Text('Belum ada data pengeluaran', style: TextStyle(color: subTextColor, fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
            )
          else
            Column(
              children: entries.asMap().entries.map((item) {
                final index = item.key;
                final entry = item.value;
                final color = _royalBluePalette[index % _royalBluePalette.length];
                final double percent = totalPengeluaran > 0 ? (entry.value / totalPengeluaran) : 0;

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(7),
                                decoration: BoxDecoration(
                                  color: color.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(9),
                                ),
                                child: Icon(Icons.category_rounded, color: color, size: 14),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                entry.key,
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: textColor),
                              ),
                            ],
                          ),
                          Text(
                            'Rp ${entry.value.toInt()}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFFEF4444),
                              fontFamily: 'monospace',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: percent,
                          minHeight: 4,
                          backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                          valueColor: AlwaysStoppedAnimation<Color>(color),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}
