import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../services/api_service.dart';

class BerandaScreen extends StatelessWidget {
  const BerandaScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          final saldo = data['saldo'] ?? 'Rp 0';
          final pemasukan = data['pemasukan'] ?? 'Rp 0';
          final pengeluaran = data['pengeluaran'] ?? 'Rp 0';
          final riwayat = data['riwayat'] as List<dynamic>? ?? [];

          return RefreshIndicator(
            onRefresh: () async {
              (context as Element).markNeedsBuild();
            },
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(color: const Color(0xFF0052FF), borderRadius: BorderRadius.circular(12)),
                          child: const Icon(FontAwesomeIcons.wallet, color: Colors.white, size: 16),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('RINGKASAN', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                            Text('MyKas', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                          ],
                        ),
                      ],
                    ),
                    CircleAvatar(backgroundColor: Colors.blue.shade100, child: const Text('IF', style: TextStyle(color: Colors.blue))),
                  ],
                ),
                const SizedBox(height: 20),
                
                // Card Kekayaan
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF0052FF), Color(0xFF0044D6)]),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('TOTAL KEKAYAAN', style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(12)),
                            child: const Text('Premium 🌟', style: TextStyle(color: Colors.amberAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                          )
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(saldo, style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildMiniInfo(FontAwesomeIcons.arrowDown, 'Pemasukan', pemasukan, Colors.greenAccent),
                          _buildMiniInfo(FontAwesomeIcons.arrowUp, 'Pengeluaran', pengeluaran, Colors.redAccent),
                        ],
                      )
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                const Text('Transaksi Terakhir', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                
                // List Transaksi Terakhir
                ...riwayat.take(10).map((item) {
                  bool isMasuk = item['jenis'].toString().toLowerCase().contains('pemasukan');
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: isMasuk ? Colors.green.shade50 : Colors.red.shade50,
                      child: Icon(isMasuk ? FontAwesomeIcons.arrowDown : FontAwesomeIcons.arrowUp, 
                                  color: isMasuk ? Colors.green : Colors.red, size: 16),
                    ),
                    title: Text(item['keterangan'] ?? '-', style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("${item['kategori']} • ${item['dompet']}", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    trailing: Text("Rp ${item['nominal']}", style: TextStyle(fontWeight: FontWeight.bold, color: isMasuk ? Colors.green : Colors.red)),
                  );
                }).toList(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMiniInfo(IconData icon, String label, String amount, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 12),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.white70, fontSize: 10)),
            Text(amount, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        )
      ],
    );
  }
}
