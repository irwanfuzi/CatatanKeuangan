import 'package:flutter/material.dart';
import 'theme/app_theme.dart';

// 1. IMPORT FILE POPUP-NYA DI SINI
import 'widgets/cta_bottom_sheet.dart'; 

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catatan Keuangan',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const MainWrapper(), 
    );
  }
}

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _currentIndex = 0;

  // Placeholder untuk halaman-halaman lu nanti
  final List<Widget> _screens = [
    const Center(child: Text('Ini Halaman Beranda\nNanti diganti UI Beranda', textAlign: TextAlign.center)),
    const Center(child: Text('Ini Halaman Analisis\nNanti diganti UI Analisis', textAlign: TextAlign.center)),
    const Center(child: Text('Ini Halaman Dompet\nNanti diganti UI Dompet', textAlign: TextAlign.center)),
    const Center(child: Text('Ini Halaman Profil\nNanti diganti UI Profil', textAlign: TextAlign.center)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      
      // ==========================================
      // 2. INI TOMBOL PLUS (+) DI TENGAH BAWAH
      // ==========================================
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF0052FF), // Warna biru brand lu
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // Biar tombolnya agak kotak kekinian
        ),
        onPressed: () {
          // 3. PANGGIL FUNGSI POPUP DARI FILE cta_bottom_sheet.dart
          showCtaBottomSheet(context);
        },
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      // Posisi tombol dibikin ngambang di tengah bawah
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      
      // ==========================================
      // NAVIGASI BAWAH (BOTTOM NAVBAR)
      // ==========================================
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed, 
        selectedItemColor: const Color(0xFF0052FF),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.pie_chart), label: 'Analisis'),
          // Dikasih label kosong biar ada jarak buat tombol Plus (+) di tengah
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet, color: Colors.transparent), label: ''), 
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: 'Dompet'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}
