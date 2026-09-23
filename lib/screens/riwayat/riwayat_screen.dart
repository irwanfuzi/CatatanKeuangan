import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_theme.dart';
import '../../utils/app_icons.dart';

class RiwayatScreen extends StatefulWidget {
  final Map<String, dynamic>? summaryData;

  const RiwayatScreen({
    super.key,
    this.summaryData,
  });

  @override
  State<RiwayatScreen> createState() => _RiwayatScreenState();
}

class _RiwayatScreenState extends State<RiwayatScreen> {
  String _selectedFilter = 'Semua';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _defaultTransactions = [
    {
      'judul': 'Gudeg Bu Dani Solo',
      'kategori': 'Kuliner & Makanan',
      'tanggal': 'Hari Ini, 12:45',
      'nominal': 45000,
      'jenis': 'pengeluaran',
      'kantong': 'BSI Hasanah',
      'icon': AppIcons.utensils,
      'iconBg': const Color(0xFFF97316),
    },
    {
      'judul': 'Gaji Bulanan Utama',
      'kategori': 'Payroll Inflow',
      'tanggal': '25 Agu 2026',
      'nominal': 8500000,
      'jenis': 'pemasukan',
      'kantong': 'Mandiri Utama',
      'icon': AppIcons.wallet,
      'iconBg': const Color(0xFF10B981),
    },
    {
      'judul': 'GoFood Indonesia',
      'kategori': 'Layanan Antar',
      'tanggal': '24 Agu 2026',
      'nominal': 68000,
      'jenis': 'pengeluaran',
      'kantong': 'GoPay Wallet',
      'icon': AppIcons.shoppingBag,
      'iconBg': const Color(0xFF00AED6),
    },
    {
      'judul': 'Supermarket Transmart',
      'kategori': 'Kebutuhan Harian',
      'tanggal': '22 Agu 2026',
      'nominal': 235000,
      'jenis': 'pengeluaran',
      'kantong': 'BSI Hasanah',
      'icon': AppIcons.shoppingCart,
      'iconBg': const Color(0xFF8B5CF6),
    },
    {
      'judul': 'Transfer Ke BSI Hasanah',
      'kategori': 'Pindah Kas',
      'tanggal': '20 Agu 2026',
      'nominal': 500000,
      'jenis': 'pemasukan',
      'kantong': 'Mandiri Utama',
      'icon': AppIcons.arrowDownLeft,
      'iconBg': const Color(0xFF00A39D),
    },
    {
      'judul': 'Tagihan Listrik PLN',
      'kategori': 'Utilitas & Tagihan',
      'tanggal': '18 Agu 2026',
      'nominal': 320000,
      'jenis': 'pengeluaran',
      'kantong': 'Mandiri Utama',
      'icon': AppIcons.zap,
      'iconBg': const Color(0xFFEAB308),
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _formatCurrency(dynamic rawNominal) {
    if (rawNominal == null) return 'Rp0';
    num val = 0;
    if (rawNominal is num) {
      val = rawNominal;
    } else {
      String strVal = rawNominal.toString().replaceAll(RegExp(r'[^0-9]'), '');
      val = num.tryParse(strVal) ?? 0;
    }

    final buffer = StringBuffer();
    final numStr = val.toInt().toString();

    for (int i = 0; i < numStr.length; i++) {
      if (i > 0 && (numStr.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(numStr[i]);
    }
    return 'Rp$buffer';
  }

  List<Map<String, dynamic>> _getFilteredList() {
    List rawList = widget.summaryData?['riwayat'] as List? ?? _defaultTransactions;

    return rawList.map((item) {
      if (item is Map<String, dynamic>) return item;
      return Map<String, dynamic>.from(item as Map);
    }).where((tx) {
      final jenis = (tx['jenis'] ?? '').toString().toLowerCase();
      if (_selectedFilter == 'Pemasukan' && jenis != 'pemasukan') return false;
      if (_selectedFilter == 'Pengeluaran' && jenis != 'pengeluaran') return false;

      if (_searchQuery.isNotEmpty) {
        final judul = (tx['judul'] ?? '').toString().toLowerCase();
        final kategori = (tx['kategori'] ?? '').toString().toLowerCase();
        final query = _searchQuery.toLowerCase();
        return judul.contains(query) || kategori.contains(query);
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bgColor = isDark ? AppTheme.bgDark : AppTheme.bgLight;
    final cardBg = isDark ? AppTheme.cardDark : AppTheme.cardLight;
    final borderColor = isDark ? AppTheme.borderDark : AppTheme.borderLight;
    final textColor = isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight;
    final textMuted = isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight;

    final filteredList = _getFilteredList();

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 1024;

            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: isDesktop ? 1000 : 540),
                child: Padding(
                  padding: EdgeInsets.all(isDesktop ? 28.0 : 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Riwayat Transaksi',
                                style: GoogleFonts.urbanist(
                                  fontSize: isDesktop ? 26 : 22,
                                  fontWeight: FontWeight.w900,
                                  color: textColor,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Kelola & pantau arus kas secara berkala',
                                style: TextStyle(fontSize: 12, color: textMuted),
                              ),
                            ],
                          ),
                          IconButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Filter Lanjutan Segera Hadir'),
                                  backgroundColor: AppTheme.brandPrimary,
                                ),
                              );
                            },
                            icon: Icon(AppIcons.filter, color: textColor, size: 20),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),

                      // Input Pencarian
                      Container(
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: borderColor),
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: (val) {
                            setState(() {
                              _searchQuery = val;
                            });
                          },
                          style: TextStyle(color: textColor, fontSize: 13),
                          decoration: InputDecoration(
                            hintText: 'Cari nama transaksi atau kategori...',
                            hintStyle: TextStyle(color: textMuted, fontSize: 13),
                            prefixIcon: Icon(AppIcons.search, size: 18, color: textMuted),
                            suffixIcon: _searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: Icon(AppIcons.x, size: 16, color: textMuted),
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() {
                                        _searchQuery = '';
                                      });
                                    },
                                  )
                                : null,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Filter Chips
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: ['Semua', 'Pemasukan', 'Pengeluaran'].map((filter) {
                            final isSelected = _selectedFilter == filter;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: ChoiceChip(
                                label: Text(filter),
                                selected: isSelected,
                                selectedColor: AppTheme.brandPrimary,
                                backgroundColor: cardBg,
                                side: BorderSide(
                                  color: isSelected ? AppTheme.brandPrimary : borderColor,
                                ),
                                labelStyle: TextStyle(
                                  color: isSelected ? Colors.white : textColor,
                                  fontSize: 12,
                                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                ),
                                onSelected: (selected) {
                                  if (selected) {
                                    setState(() {
                                      _selectedFilter = filter;
                                    });
                                  }
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Daftar Transaksi
                      Expanded(
                        child: filteredList.isEmpty
                            ? _buildEmptyState(textMuted)
                            : Container(
                                decoration: BoxDecoration(
                                  color: cardBg,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: borderColor),
                                ),
                                child: ListView.separated(
                                  itemCount: filteredList.length,
                                  separatorBuilder: (context, index) => Divider(color: borderColor, height: 1),
                                  itemBuilder: (context, index) {
                                    final tx = filteredList[index];
                                    final isPemasukan = tx['jenis'] == 'pemasukan';
                                    final nominal = _formatCurrency(tx['nominal']);

                                    return ListTile(
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                      leading: Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: ((tx['iconBg'] as Color?) ?? AppTheme.brandPrimary).withOpacity(0.12),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Icon(
                                          (tx['icon'] as IconData?) ?? AppIcons.receipt,
                                          color: (tx['iconBg'] as Color?) ?? AppTheme.brandPrimary,
                                          size: 20,
                                        ),
                                      ),
                                      title: Text(
                                        tx['judul'] ?? 'Transaksi',
                                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: textColor),
                                      ),
                                      subtitle: Text(
                                        '${tx['tanggal'] ?? 'Hari ini'} • ${tx['kategori'] ?? 'Umum'}',
                                        style: TextStyle(fontSize: 11, color: textMuted),
                                      ),
                                      trailing: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            '${isPemasukan ? '+' : '-'}$nominal',
                                            style: GoogleFonts.urbanist(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w900,
                                              color: isPemasukan ? const Color(0xFF10B981) : textColor,
                                            ),
                                          ),
                                          if (tx['kantong'] != null)
                                            Text(
                                              tx['kantong'].toString(),
                                              style: TextStyle(fontSize: 10, color: textMuted),
                                            ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState(Color textMuted) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(AppIcons.history, size: 48, color: textMuted.withOpacity(0.5)),
          const SizedBox(height: 12),
          Text(
            'Tidak ada transaksi ditemukan',
            style: TextStyle(color: textMuted, fontSize: 13, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
