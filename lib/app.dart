import 'package:flutter/material.dart';
import 'screens/beranda/beranda_screen.dart';
import 'services/api_service.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int _currentIndex = 0;
  Map<String, dynamic> _summaryData = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSummaryData();
  }

  Future<void> _fetchSummaryData() async {
    try {
      final data = await ApiService.getSummary();
      setState(() {
        _summaryData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // List halaman dengan passing summaryData secara aman ke BerandaScreen
    final List<Widget> pages = [
      _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF42A5F5),
              ),
            )
          : BerandaScreen(summaryData: _summaryData),
      const Center(
        child: Text(
          'Analisis Keuangan',
          style: TextStyle(color: Colors.white),
        ),
      ),
      const Center(
        child: Text(
          'Dompet & Rekening',
          style: TextStyle(color: Colors.white),
        ),
      ),
      const Center(
        child: Text(
          'Profil',
          style: TextStyle(color: Colors.white),
        ),
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0B0E14),
      body: pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF151C28),
          border: Border(
            top: BorderSide(
              color: Colors.white.withOpacity(0.08),
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: const Color(0xFF151C28),
          selectedItemColor: const Color(0xFF42A5F5),
          unselectedItemColor: Colors.white38,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.pie_chart_rounded),
              label: 'Analisis',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet_rounded),
              label: 'Dompet',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}
