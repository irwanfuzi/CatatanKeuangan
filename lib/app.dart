import 'package:flutter/material.dart';
import 'screens/beranda/beranda_screen.dart';
import 'screens/analisis/analisis_screen.dart';
import 'screens/dompet/dompet_screen.dart';
import 'screens/profil/profil_screen.dart';
import 'widgets/bottom_nav_bar.dart';

class MainAppScreen extends StatefulWidget {
  const MainAppScreen({super.key});

  @override
  State<MainAppScreen> createState() => _MainAppScreenState();
}

class _MainAppScreenState extends State<MainAppScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const BerandaScreen(),
    const AnalisisScreen(),
    const DompetScreen(),
    const ProfilScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: MKBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        onAddTap: () {
          // TODO: Panggil CTA Bottom Sheet Tambah Transaksi
        },
      ),
    );
  }
}
