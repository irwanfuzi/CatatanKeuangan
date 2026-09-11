import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../services/api_service.dart';

class AnalisisScreen extends StatelessWidget {
  const AnalisisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: FutureBuilder<Map<String, dynamic>>(
        future: ApiService.getSummary(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final data = snapshot.data ?? {};
          final pemasukan = data['pemasukan'] ?? 'Rp 0';
          final pengeluaran = data['pengeluaran'] ?? 'Rp 0';
          final riwayat = data['riwayat'] as List<dynamic>? ?? [];

          Map<String, double> kategoriMap = {};
          double totalPengeluaranAngka = 0;

          // Parsing data pengeluaran dengan konversi tipe data yang aman
          for (var item in riwayat) {
            if (item['jenis'].toString().toLowerCase().contains('pengeluaran')) {
              String namaKategori = item['kategori']?.toString() ?? 'Lainnya';
              
              // Konversi aman untuk string/int/double dari Google Apps Script
              double nominal = double.tryParse(item['nominal']?.toString() ?? '0') ?? 0.0;
              
              kategoriMap[namaKategori] = (kategoriMap[namaKategori] ?? 0) + nominal;
              totalPengeluaranAngka += nominal;
            }
          }

          List<Color> chartColors = [
            Colors.redAccent, 
            Colors.blueAccent, 
            Colors.orangeAccent, 
            Colors.greenAccent, 
            Colors.purpleAccent,
            Colors.tealAccent,
          ];
          
          int colorIndex = 0;
          List<PieChartSectionData> pieSections = [];
          
          if (totalPengeluaranAngka > 0) {
            kategoriMap.forEach((kategori, jumlah) {
              double persentase = (jumlah / totalPengeluaranAngka) * 100;
              pieSections.add(
                PieChartSectionData(
                  color: chartColors[colorIndex % chartColors.length], 
                  value: persentase, 
                  title: '${persentase.toStringAsFixed(0)}%', 
                  radius: 50, 
                  titleStyle: const TextStyle(
                    fontSize: 12, 
                    fontWeight: FontWeight.bold, 
                    color: Colors.white
                  )
                ),
              );
              colorIndex++;
            });
          } else {
            pieSections.add(
              PieChartSectionData(
                color: Colors.grey.shade400, 
                value: 100, 
                title: '0%', 
                radius: 50
              )
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                'Analisis Keuangan', 
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)
              ),
              const SizedBox(height: 20),
              
              // Ringkasan Pemasukan & Pengeluaran
              Row(
                children: [
                  Expanded(
                    child: _buildSummaryBox('Pemasukan', pemasukan, FontAwesomeIcons.arrowDown, Colors.green, isDark),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildSummaryBox('Pengeluaran', pengeluaran, FontAwesomeIcons.arrowUp, Colors.red, isDark),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Grafik Pie Chart
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF131C33) : Colors.white, 
                  borderRadius: BorderRadius.circular(24), 
                  border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade200)
                ),
                child: Column(
                  children: [
                    const Text(
                      'Distribusi Pengeluaran', 
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 200, 
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 2, 
                          centerSpaceRadius: 40, 
                          sections: pieSections
                        )
                      )
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              const Text(
                'Rincian Kategori', 
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
              ),
              const SizedBox(height: 12),
              
              // List Rincian Per Kategori
              if (kategoriMap.isEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF131C33) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Text('Belum ada data pengeluaran', style: TextStyle(color: Colors.grey)),
                  ),
                )
              else
                ...kategoriMap.entries.map((entry) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF131C33) : Colors.white, 
                      borderRadius: BorderRadius.circular(16), 
                      border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade200)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          entry.key, 
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)
                        ),
                        Text(
                          'Rp ${entry.value.toInt()}', 
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.red)
                        ),
                      ],
                    ),
                  );
                }).toList(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSummaryBox(String title, String amount, IconData icon, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF131C33) : Colors.white, 
        borderRadius: BorderRadius.circular(20), 
        border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade200)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 12),
              const SizedBox(width: 6),
              Text(
                title, 
                style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold)
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            amount, 
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900)
          ),
        ],
      ),
    );
  }
}
