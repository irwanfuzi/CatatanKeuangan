import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/api_service.dart';
import '../../theme/app_theme.dart';
import '../../utils/app_icons.dart';

class RiwayatTransaksiScreen extends StatefulWidget {
  final Map<String, dynamic>? summaryData;

  const RiwayatTransaksiScreen({
    super.key,
    this.summaryData,
  });

  @override
  State<RiwayatTransaksiScreen> createState() => _RiwayatTransaksiScreenState();
}

class _RiwayatTransaksiScreenState extends State<RiwayatTransaksiScreen> {
  String _selectedFilter = 'semua';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _getItemTitle(Map<String, dynamic> item) {
    final title = item['Keterangan'] ?? 
                  item['keterangan'] ?? 
                  item['judul'] ?? 
                  item['nama'] ?? 
                  item['deskripsi'] ?? 
                  item['title'];
    
    if (title != null && title.toString().trim().isNotEmpty) {
      return title.toString().trim();
    }
    return 'Transaksi Kas';
  }

  String _getItemCategory(Map<String, dynamic> item) {
    final cat = item['Kategori'] ?? item['kategori'] ?? 'Lainnya';
    return cat.toString().replaceAll(RegExp(r'[\u{1F300}-\u{1F9FF}]', unicode: true), '').trim();
  }

  String _getItemSource(Map<String, dynamic> item) {
    final source = item['Sumber'] ?? item['sumber'] ?? item['Kantong'] ?? item['kantong'] ?? item['F'] ?? 'Kas Utama';
    return source.toString().replaceAll(RegExp(r'[\u{1F300}-\u{1F9FF}]', unicode: true), '').trim();
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
    if (katLower.contains('makan') || katLower.contains('kuliner') || katLower.contains('food')) {
      return LucideIcons.utensils;
    } else if (katLower.contains('gaji') || katLower.contains('payroll') || katLower.contains('income')) {
      return LucideIcons.wallet;
    } else if (katLower.contains('belanja') || katLower.contains('supermarket') || katLower.contains('mart')) {
      return LucideIcons.shoppingBag;
    } else if (katLower.contains('trans') || katLower.contains('bensin') || katLower.contains('ride')) {
      return LucideIcons.car;
    } else if (katLower.contains('tagihan') || katLower.contains('token') || katLower.contains('listrik')) {
      return LucideIcons.zap;
    } else if (katLower.contains('pindah') || katLower.contains('transfer') || katLower.contains('bank')) {
      return LucideIcons.arrowLeftRight;
    }
    return LucideIcons.receipt;
  }

  void _showDetailTransaksiModal(BuildContext context, Map<String, dynamic> item) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppTheme.cardDark : AppTheme.cardLight;
    final textColor = isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight;
    final textMuted = isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight;
    final borderColor = isDark ? AppTheme.borderDark : AppTheme.borderLight;

    final jenis = (item['Jenis'] ?? item['jenis'] ?? '').toString().toLowerCase();
    final isPemasukan = jenis.contains('pema') || jenis.contains('in');
    final formattedNominal = _formatCurrency(item['Nominal'] ?? item['nominal']);
    final title = _getItemTitle(item);
    final kategori = _getItemCategory(item);
    final sumber = _getItemSource(item);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? AppTheme.borderDark : const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: isPemasukan
                      ? const Color(0xFF10B981).withOpacity(0.12)
                      : const Color(0xFFEF4444).withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isPemasukan ? LucideIcons.arrowDownLeft : LucideIcons.arrowUpRight,
                  color: isPemasukan ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                  size: 28,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.urbanist(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                isPemasukan ? 'Pemasukan Kas' : 'Pengeluaran Kas',
                style: TextStyle(fontSize: 12, color: textMuted, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              Text(
                isPemasukan ? '+$formattedNominal' : '-$formattedNominal',
                style: GoogleFonts.urbanist(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: isPemasukan ? const Color(0xFF10B981) : textColor,
                ),
              ),
              const SizedBox(height: 24),
              Divider(color: borderColor, height: 1),
              const SizedBox(height: 16),
              _buildDetailRow('Tanggal & Waktu', item['Tanggal']?.toString() ?? item['tanggal']?.toString() ?? 'Hari ini', textColor, textMuted),
              _buildDetailRow('Kategori', kategori, textColor, textMuted),
              _buildDetailRow('Sumber Dana', sumber, textColor, textMuted),
              _buildDetailRow('ID Transaksi', '#MK-2026-${(title.hashCode.abs() % 10000)}', textColor, textMuted),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.brandPrimary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: const Text('Tutup', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value, Color textColor, Color textMuted) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: textMuted)),
          Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textColor)),
        ],
      ),
    );
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
              {'Keterangan': 'Uang Bulanan', 'Nominal': '2500000', 'Jenis': 'Pemasukan', 'Kategori': 'Gaji', 'Tanggal': '28/06/2026 7:00:00'},
              {'Keterangan': 'CO Masker', 'Nominal': '68000', 'Jenis': 'Pengeluaran', 'Kategori': 'Lainnya', 'Tanggal': '28/06/2026 7:00:00'},
              {'Keterangan': 'Aeon Mall', 'Nominal': '111812', 'Jenis': 'Pengeluaran', 'Kategori': 'Makanan', 'Tanggal': '28/06/2026 7:00:00'},
              {'Keterangan': 'Kerupuk+UC1000', 'Nominal': '13000', 'Jenis': 'Pengeluaran', 'Kategori': 'Makanan', 'Tanggal': '28/06/2026 7:00:00'},
              {'Keterangan': 'Nasi Jinggo', 'Nominal': '30000', 'Jenis': 'Pengeluaran', 'Kategori': 'Makanan', 'Tanggal': '27/06/2026 7:00:00'},
              {'Keterangan': 'Bensin', 'Nominal': '25000', 'Jenis': 'Pengeluaran', 'Kategori': 'Transport', 'Tanggal': '27/06/2026 7:00:00'},
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
                                  letterSpacing: -0.4,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Pantau seluruh catatan pemasukan & pengeluaran kas',
                                style: TextStyle(fontSize: 11, color: textMuted),
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: _searchController,
                                onChanged: (val) {
                                  setState(() {
                                    _searchQuery = val;
                                  });
                                },
                                style: TextStyle(fontSize: 13, color: textColor),
                                decoration: InputDecoration(
                                  hintText: 'Cari transaksi atau kategori...',
                                  hintStyle: TextStyle(fontSize: 12, color: textMuted),
                                  prefixIcon: Icon(LucideIcons.search, size: 18, color: textMuted),
                                  suffixIcon: _searchQuery.isNotEmpty
                                      ? IconButton(
                                          icon: Icon(LucideIcons.x, size: 16, color: textColor),
                                          onPressed: () {
                                            _searchController.clear();
                                            setState(() {
                                              _searchQuery = '';
                                            });
                                          },
                                        )
                                      : null,
                                  filled: true,
                                  fillColor: inputBg,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(color: borderColor),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(color: borderColor),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: const BorderSide(color: AppTheme.brandPrimary, width: 1.5),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 14),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    _buildFilterChip('semua', 'Semua Kas', LucideIcons.listFilter, isDark),
                                    const SizedBox(width: 8),
                                    _buildFilterChip('pemasukan', 'Pemasukan', LucideIcons.arrowDownLeft, isDark, const Color(0xFF10B981)),
                                    const SizedBox(width: 8),
                                    _buildFilterChip('pengeluaran', 'Pengeluaran', LucideIcons.arrowUpRight, isDark, const Color(0xFFEF4444)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: filteredList.isEmpty
                              ? _buildEmptyState(textColor, textMuted)
                              : ListView.separated(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  itemCount: filteredList.length,
                                  separatorBuilder: (context, index) => const SizedBox(height: 10),
                                  itemBuilder: (context, index) {
                                    final item = filteredList[index];
                                    return _buildTransactionCard(
                                      item: item,
                                      cardBg: cardBg,
                                      borderColor: borderColor,
                                      textColor: textColor,
                                      textMuted: textMuted,
                                      isDark: isDark,
                                      onTap: () => _showDetailTransaksiModal(context, item),
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

  Widget _buildFilterChip(String key, String label, IconData icon, bool isDark, [Color? activeColor]) {
    final isSelected = _selectedFilter == key;
    final color = activeColor ?? AppTheme.brandPrimary;

    return ChoiceChip(
      showCheckmark: false,
      avatar: Icon(
        icon,
        size: 14,
        color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
      ),
      label: Text(label),
      selected: isSelected,
      onSelected: (val) {
        if (val) {
          setState(() {
            _selectedFilter = key;
          });
        }
      },
      selectedColor: color,
      backgroundColor: isDark ? const Color(0xFF1E222D) : const Color(0xFFF1F5F9),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
        fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
        fontSize: 11,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? color : (isDark ? AppTheme.borderDark : AppTheme.borderLight),
        ),
      ),
    );
  }

  Widget _buildTransactionCard({
    required Map<String, dynamic> item,
    required Color cardBg,
    required Color borderColor,
    required Color textColor,
    required Color textMuted,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    final jenis = (item['Jenis'] ?? item['jenis'] ?? '').toString().toLowerCase();
    final isPemasukan = jenis.contains('pema') || jenis.contains('in');
    final formattedNominal = _formatCurrency(item['Nominal'] ?? item['nominal']);
    final title = _getItemTitle(item);
    final kategori = _getItemCategory(item);
    final tanggal = (item['Tanggal'] ?? item['tanggal'] ?? '').toString();

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1.0),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isPemasukan
                        ? const Color(0xFF10B981).withOpacity(0.12)
                        : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    isPemasukan ? LucideIcons.arrowDownLeft : _getCategoryIcon(kategori),
                    color: isPemasukan ? const Color(0xFF10B981) : (isDark ? Colors.white70 : const Color(0xFF475569)),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          if (tanggal.isNotEmpty) ...[
                            Text(
                              tanggal.split(' ')[0],
                              style: TextStyle(fontSize: 10, color: textMuted, fontWeight: FontWeight.w500),
                            ),
                            Text(' • ', style: TextStyle(fontSize: 10, color: textMuted)),
                          ],
                          Text(
                            kategori,
                            style: TextStyle(fontSize: 10, color: textMuted, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Text(
                  isPemasukan ? '+$formattedNominal' : '-$formattedNominal',
                  style: GoogleFonts.urbanist(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: isPemasukan ? const Color(0xFF10B981) : textColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(Color textColor, Color textMuted) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.brandPrimary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(LucideIcons.receipt, color: AppTheme.brandPrimary, size: 36),
          ),
          const SizedBox(height: 16),
          Text(
            'Tidak ada riwayat transaksi',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: textColor),
          ),
          const SizedBox(height: 4),
          Text(
            'Coba ubah kata kunci pencarian atau filter kamu',
            style: TextStyle(fontSize: 11, color: textMuted),
          ),
        ],
      ),
    );
  }
}
