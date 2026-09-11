import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../services/api_service.dart';

class DompetScreen extends StatelessWidget {
  const DompetScreen({super.key});

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
          final dompet = data['dompet'] is Map<String, dynamic> 
              ? data['dompet'] as Map<String, dynamic> 
              : <String, dynamic>{};

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                'Dompet & Rekening', 
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)
              ),
              const SizedBox(height: 20),
              _buildWalletCard('Kantong Tunai', dompet['tunai']?.toString() ?? 'Rp 0', FontAwesomeIcons.wallet, Colors.teal, isDark),
              _buildWalletCard('Rekening Bank', dompet['bank']?.toString() ?? 'Rp 0', FontAwesomeIcons.buildingColumns, Colors.blue, isDark),
              _buildWalletCard('Dompet Digital', dompet['digital']?.toString() ?? 'Rp 0', FontAwesomeIcons.mobileScreen, Colors.orange, isDark),
              _buildWalletCard('Tabungan', dompet['tabungan']?.toString() ?? 'Rp 0', FontAwesomeIcons.piggyBank, Colors.indigo, isDark),
            ],
          );
        },
      ),
    );
  }

  Widget _buildWalletCard(String name, String balance, IconData icon, Color color, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF131C33) : Colors.white, 
        borderRadius: BorderRadius.circular(20), 
        border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade200)
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withAlpha(26), 
              borderRadius: BorderRadius.circular(16)
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              name, 
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
            )
          ),
          Text(
            balance, 
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900)
          ),
        ],
      ),
    );
  }
}
