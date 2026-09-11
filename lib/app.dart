import 'package:flutter/material.dart';
import 'screens/beranda/beranda_screen.dart';
import 'screens/analisis/analisis_screen.dart';
import 'screens/dompet/dompet_screen.dart';
import 'screens/profil/profil_screen.dart';
import 'widgets/mk_bottom_nav_bar.dart';
import 'widgets/add_transaction_bottom_sheet.dart';

class MainAppScreen extends StatefulWidget {
  const MainAppScreen({super.key});

  @override
  State<MainAppScreen> createState() => _MainAppScreenState();
}

class _MainAppScreenState extends State<MainAppScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    BerandaScreen(),
    AnalisisScreen(),
    DompetScreen(),
    ProfilScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
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
          showCtaBottomSheet(context);
        },
      ),
    );
  }
}
