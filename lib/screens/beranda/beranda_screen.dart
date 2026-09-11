import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../services/api_service.dart';

class BerandaScreen extends StatefulWidget {
  const BerandaScreen({super.key});

  @override
  State<BerandaScreen> createState() => _BerandaScreenState();
}

class _BerandaScreenState extends State<BerandaScreen> {
  // Key unik untuk memicu reload data saat pull-to-refresh
  Key _refreshKey = UniqueKey();

  Future<void> _handleRefresh() async {
    setState(() {
      _refreshKey = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: FutureBuilder<Map<String, dynamic>>(
          key: _refreshKey,
          future: ApiService.getSummary(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final data = snapshot.data ?? {};
            final saldo = data['saldo']?.toString() ?? 'Rp 0';
            final pemasukan = data['pemasukan']?.toString() ?? 'Rp 0';
            final pengeluaran = data['pengeluaran']?.toString() ?? 'Rp 0';
            final riwayat = data['riwayat'] as List<dynamic>? ?? [];

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Topbar Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0052FF), 
                            borderRadius: BorderRadius.circular(12)
                          ),
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
                    CircleAvatar(
                      backgroundColor: Colors.blue.shade100, 
                      child: const Text('IF', style: TextStyle(color: Color(0xFF0052FF), fontWeight: FontWeight.bold))
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                
                // Card Kekayaan Utama
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
                if (riwayat.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF131C33) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: Text('Belum ada transaksi', style: TextStyle(color: Colors.grey)),
                    ),
                  )
                else
                  ...riwayat.take(10).map((item) {
                    bool isMasuk = item['jenis'].toString().toLowerCase().contains('pemasukan');
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF131C33) : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade200),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: isMasuk ? Colors.green.shade50 : Colors.red.shade50,
                          child: Icon(
                            isMasuk ? FontAwesomeIcons.arrowDown : FontAwesomeIcons.arrowUp, 
                            color: isMasuk ? Colors.green : Colors.red, 
                            size: 16
                          ),
                        ),
                        title: Text(
                          item['keterangan']?.toString() ?? '-', 
                          style: const TextStyle(fontWeight: FontWeight.bold)
                        ),
                        subtitle: Text(
                          "${item['kategori'] ?? '-'} • ${item['dompet'] ?? '-'}", 
                          style: const TextStyle(fontSize: 12, color: Colors.grey)
                        ),
                        trailing: Text(
                          "Rp ${item['nominal'] ?? '0'}", 
                          style: TextStyle(
                            fontWeight: FontWeight.bold, 
                            color: isMasuk ? Colors.green : Colors.red
                          )
                        ),
                      ),
                    );
                  }).toList(),
              ],
            );
          },
        ),
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
