import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfilScreen extends StatelessWidget {
  const ProfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Profil Saya', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.grey.shade200)),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.blue.shade50,
                  child: const Text('IF', style: TextStyle(color: Color(0xFF0052FF), fontWeight: FontWeight.bold, fontSize: 20)),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Irwan Fuzi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text('irwanfuzi23@gmail.com', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 32),
          const Text('PENGATURAN', style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _buildMenuTile(FontAwesomeIcons.googleDrive, 'Hubungkan Google Sheets', Colors.green),
          _buildMenuTile(FontAwesomeIcons.solidBell, 'Notifikasi Telegram', Colors.blue),
          _buildMenuTile(FontAwesomeIcons.lock, 'Keamanan & PIN', Colors.orange),
          _buildMenuTile(FontAwesomeIcons.circleQuestion, 'Bantuan & Panduan', Colors.teal),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade50,
                foregroundColor: Colors.red,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              icon: const Icon(FontAwesomeIcons.arrowRightFromBracket, size: 18),
              label: const Text('Keluar Aplikasi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Fitur keluar akan segera tersedia.')));
              },
            ),
          ),
          const SizedBox(height: 24),
          const Center(child: Text('MyKas v2.0 (Flutter Native)', style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  Widget _buildMenuTile(IconData icon, String title, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, size: 16, color: color),
        ),
        title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        trailing: const Icon(FontAwesomeIcons.chevronRight, size: 14, color: Colors.grey),
        onTap: () {},
      ),
    );
  }
}
