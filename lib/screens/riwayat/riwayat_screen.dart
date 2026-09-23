import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/api_service.dart';
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
  String _selectedFilter = 'semua';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _getItemTitle(Map<String, dynamic> item) {
    final title = item['Keterangan'] ?? item['keterangan'] ?? item['judul'] ?? item['nama'] ?? item['deskripsi'];
    if (title != null && title.toString().trim().isNotEmpty) {
      return title.toString().trim();
    }
    return 'Transaksi Kas';
  }

  String _getItemCategory(Map<String, dynamic> item) {
    final cat = item['Kategori'] ?? item['kategori'] ?? 'Lainnya';
    return cat.toString().replaceAll(RegExp(r'[\u{1F300}-\u{1F9FF}]', unicode: true), '').trim();
  }

  String _formatCurrency(dynamic rawNominal) {
    if (rawNominal == null) return 'Rp0';
    String strVal = rawNominal.toString().replaceAll(RegExp(r'[^0-9]'), '');
    if (strVal.isEmpty) return 'Rp0';

    final intValue = int.tryParse(strVal) ?? 0;
    final buffer = StringBuffer();
    final numStr = intValue.toString();

    for (int i = 0; i < numStr.length; i++) {
      if (i > 0 && (numStr.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(numStr[i]);
    }
    return 'Rp$buffer';
  }

  IconData _getCategoryIcon(String kategori) {
    final katLower = kategori.toLowerCase();
    if (katLower.contains('makan') || katLower.contains('kuliner')) {
      return AppIcons.utensils;
    } else if (katLower.contains('gaji') || katLower.contains('income')) {
      return AppIcons.wallet;
    } else if (katLower.contains('belanja') || katLower.contains('mart')) {
      return AppIcons.shoppingBag;
    } else if (katLower.contains('trans') || katLower.contains('bensin')) {
      return AppIcons.car;
    } else if (katLower.contains('tagihan') || katLower.contains('listrik')) {
      return AppIcons.zap;
    }
    return AppIcons.receipt;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final surfaceColor = isDark ? AppTheme.bgDark : AppTheme.bgLight;
    final cardBg = isDark ? AppTheme.cardDark : AppTheme.cardLight;
    final borderColor = isDark ? AppTheme.borderDark : AppTheme.borderLight;
    final textColor = isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight;
    final textMuted = isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight;
    final inputBg = isDark ? const Color(0xFF1E222D) : const Color(0xFFF8FAFC);

    return Scaffold(
      backgroundColor: surfaceColor,
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>>(
          future: ApiService.getSummary(),
          builder: (context, snapshot) {
            final Map<String, dynamic> data = (snapshot.hasData && snapshot.data!.isNotEmpty)
                ? snapshot.data!
                : (widget.summaryData ?? {});

            final List rawList = data['riwayat'] as List? ?? [
              {'Keterangan': 'Uang Bulanan', 'Nominal': '2500000', 'Jenis': 'Pemasukan', 'Kategori': 'Gaji', 'Tanggal': '28/06/2026'},
              {'Keterangan': 'CO Masker', 'Nominal': '68000', 'Jenis': 'Pengeluaran', 'Kategori': 'Lainnya', 'Tanggal': '28/06/2026'},
            ];

            final filteredList = rawList.where((item) {
              final jenis = (item['Jenis'] ?? item['jenis'] ?? '').toString().toLowerCase();
              final title = _getItemTitle(item).toLowerCase();
              final kategori = _getItemCategory(item).toLowerCase();

              final matchesFilter = _selectedFilter == 'semua' ||
                  (_selectedFilter == 'pemasukan' && (jenis.contains('pema') || jenis.contains('in'))) ||
                  (_selectedFilter == 'pengeluaran' && (jenis.contains('peng') || jenis.contains('out')));

              final matchesSearch = _searchQuery.isEmpty ||
                  title.contains(_searchQuery.toLowerCase()) ||
                  kategori.contains(_searchQuery.toLowerCase());

              return matchesFilter && matchesSearch;
            }).toList();

            return LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = constraints.maxWidth >= 1024;

                return Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: isDesktop ? 960 : 540),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Riwayat Transaksi',
                                style: GoogleFonts.urbanist(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  color: textColor,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text('Pantau seluruh catatan pemasukan & pengeluaran kas', style: TextStyle(fontSize: 11, color: textMuted)),
                              const SizedBox(height: 16),
                              TextField(
                                controller: _searchController,
                                onChanged: (val) => setState(() => _searchQuery = val),
                                style: TextStyle(fontSize: 13, color: textColor),
                                decoration: InputDecoration(
                                  hintText: 'Cari transaksi...',
                                  hintStyle: TextStyle(fontSize: 12, color: textMuted),
                                  prefixIcon: Icon(AppIcons.search, size: 18, color: textMuted),
                                  filled: true,
                                  fillColor: inputBg,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: borderColor)),
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: borderColor)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            itemCount: filteredList.length,
                            separatorBuilder: (context, index) => const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              final item = filteredList[index];
                              final jenis = (item['Jenis'] ?? item['jenis'] ?? '').toString().toLowerCase();
                              final isPemasukan = jenis.contains('pema') || jenis.contains('in');
                              final formattedNominal = _formatCurrency(item['Nominal'] ?? item['nominal']);

                              return Container(
                                decoration: BoxDecoration(
                                  color: cardBg,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: borderColor),
                                ),
                                child: ListTile(
                                  leading: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: isPemasukan ? const Color(0xFF10B981).withOpacity(0.12) : const Color(0xFFEF4444).withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      isPemasukan ? AppIcons.arrowDownLeft : _getCategoryIcon(_getItemCategory(item)),
                                      color: isPemasukan ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                                      size: 20,
                                    ),
                                  ),
                                  title: Text(_getItemTitle(item), style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: textColor)),
                                  subtitle: Text(_getItemCategory(item), style: TextStyle(fontSize: 11, color: textMuted)),
                                  trailing: Text(
                                    '${isPemasukan ? '+' : '-'}$formattedNominal',
                                    style: GoogleFonts.urbanist(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w900,
                                      color: isPemasukan ? const Color(0xFF10B981) : textColor,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
