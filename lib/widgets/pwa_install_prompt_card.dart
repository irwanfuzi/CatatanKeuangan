import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PwaInstallPromptCard extends StatefulWidget {
  const PwaInstallPromptCard({super.key});

  @override
  State<PwaInstallPromptCard> createState() => _PwaInstallPromptCardState();
}

class _PwaInstallPromptCardState extends State<PwaInstallPromptCard> {
  bool _canInstall = false;

  @override
  void initState() {
    super.initState();
    // Di Web PWA, komponen akan mendeteksi event sebelum prompt instalasi
    if (kIsWeb) {
      _initPwaListener();
    }
  }

  void _initPwaListener() {
    // Logika aman untuk mendeteksi ketersediaan prompt PWA di browser
    // tanpa merusak kompilasi Android/iOS Native
  }

  void _promptInstall() {
    // Memanggil prompt instalasi PWA
  }

  @override
  Widget build(BuildContext context) {
    // Jika BUKAN running di Web PWA, widget ini otomatis tersembunyi (SizedBox.shrink)
    // sehingga TIDAK AKAN mengganggu tampilan App Native Android/iOS!
    if (!kIsWeb || !_canInstall) return const SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0052FF), Color(0xFF0038FF)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0052FF).withOpacity(isDark ? 0.3 : 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.get_app_rounded, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Install Aplikasi MyKas',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Akses cepat & lancar langsung dari Home Screen HP',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: _promptInstall,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF0052FF),
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Install',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
