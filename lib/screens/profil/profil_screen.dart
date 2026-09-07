import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfilScreen extends StatelessWidget {
  const ProfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Profil Saya', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
          const SizedBox(height: 20),
          
          // User Info Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF131C33) : Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade200),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.blue.shade100,
                  child: const Text('IF', style: TextStyle(color: Color(0xFF0052FF), fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Irwan Fuzi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('irwanfuzi23@gmail.com', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                )
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          const Text('PENGATURAN AKUN', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          
          _buildMenuTile(FontAwesomeIcons.lock, 'Keamanan & Biometrik', isDark),
          _buildMenuTile(FontAwesomeIcons.rotate, 'Sinkronisasi Data Sheet', isDark),
          _buildMenuTile(FontAwesomeIcons.headset, 'Pusat Bantuan', isDark),
          
          const SizedBox(height: 24),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade50,
              foregroundColor: Colors.red,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            icon: const Icon(FontAwesomeIcons.arrowRightFromBracket, size: 16),
            label: const Text('Keluar Akun', style: TextStyle(fontWeight: FontWeight.bold)),
            onAction: () {},
            onPressed: () {},
          )
        ],
      ),
    );
  }

  Widget _buildMenuTile(IconData icon, String title, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF131C33) : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, size: 16, color: const Color(0xFF0052FF)),
        ),
        title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        trailing: const Icon(FontAwesomeIcons.chevronRight, size: 12, color: Colors.grey),
        onTap: () {},
      ),
    );
  }
}
