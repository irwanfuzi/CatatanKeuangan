import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DompetScreen extends StatelessWidget {
  const DompetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Dompet & Rekening', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
              IconButton(
                icon: const Icon(FontAwesomeIcons.circlePlus, color: Color(0xFF0052FF)),
                onPressed: () {},
              )
            ],
          ),
          const SizedBox(height: 16),
          
          // List Dompet Kartu
          _buildWalletCard('wondr by BNI', 'Utama / Pengeluaran', 'Rp 1.450.333', FontAwesomeIcons.buildingColumns, Colors.teal, isDark),
          _buildWalletCard('BYOND by BSI', 'Tabungan Syariah', 'Rp 600.000', FontAwesomeIcons.landmark, Colors.green, isDark),
          _buildWalletCard('ShopeePay / E-Wallet', 'Belanja & Jajan', 'Rp 195.500', FontAwesomeIcons.wallet, Colors.deepOrange, isDark),
          _buildWalletCard('Bibit / Reksa Dana', 'Investasi Portofolio', 'Rp 100.000', FontAwesomeIcons.chartLine, Colors.indigo, isDark),
          
          const SizedBox(height: 24),
          const Text('Aset Fisik', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _buildWalletCard('BRANKAS Logam Mulia (Antam)', 'Investasi Emas', 'Rp 0', FontAwesomeIcons.gem, Colors.amber, isDark),
        ],
      ),
    );
  }

  Widget _buildWalletCard(String name, String type, String balance, IconData icon, Color accentColor, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF131C33) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: accentColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(type, style: const TextStyle(fontSize: 11, color: Colors.grey)),
              ],
            ),
          ),
          Text(balance, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}
