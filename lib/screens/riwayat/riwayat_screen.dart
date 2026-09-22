import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../services/api_service.dart';
import '../../theme/app_theme.dart';

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

  void _showDetailTransaksiModal(BuildContext context, Map<String, dynamic> item) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppTheme.cardDark : AppTheme.cardLight;
    final textColor = isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight;
    final textMuted = isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight;
    final borderColor = isDark ? AppTheme.borderDark : AppTheme.borderLight;

    final isPemasukan = item['jenis'].toString().toLowerCase().contains('pemasukan');
    final formattedNominal = _formatCurrency(item['nominal']);

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
                item['judul']?.toString() ?? 'Detail Transaksi',
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
              _buildDetailRow('Tanggal & Waktu', item['tanggal']?.toString() ?? 'Hari ini', textColor, textMuted),
              _buildDetailRow('Kategori', item['kategori']?.toString() ?? 'Umum', textColor, textMuted),
              _buildDetailRow('Sumber Dana', item['kantong']?.toString() ?? 'Utama (Kas)', textColor, textMuted),
              _buildDetailRow('ID Transaksi', '#MK-2026-${(item['judul'].hashCode.abs() % 10000)}', textColor, textMuted),
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
              {'judul': 'Gudeg Bu Dani Solo', 'nominal': '45000', 'jenis': 'pengeluaran', 'kategori': 'Kuliner', 'tanggal': 'Hari Ini, 12:45'},
              {'judul': 'Gaji Bulanan Utama', 'nominal': '8500000', 'jenis': 'pemasukan', 'kategori': 'Gaji', 'tanggal': '25 Agu 2026'},
              {'judul': 'Bubur Ayam Spesial', 'nominal': '22000', 'jenis': 'pengeluaran', 'kategori': 'Kuliner', 'tanggal': '24 Agu 2026'},
              {'judul': 'GoFood Indonesia', 'nominal': '68000', 'jenis': 'pengeluaran', 'kategori': 'Layanan Antar', 'tanggal': '24 Agu 2026'},
              {'judul': 'Supermarket Transmart', 'nominal': '235000', 'jenis': 'pengeluaran', 'kategori': 'Kebutuhan', 'tanggal': '22 Agu 2026'},
              {'judul': 'Transfer Ke Rekening BSI', 'nominal': '500000', 'jenis': 'pengeluaran', 'kategori': 'Pindah Kas', 'tanggal': '20 Agu 2026'},
            ];

            final filteredList = rawList.where((item) {
              final jenis = item['jenis'].toString().toLowerCase();
              final judul = item['judul'].toString().toLowerCase();
              final kategori = item['kategori'].toString().toLowerCase();

              final matchesFilter = _selectedFilter == 'semua' ||
                  (_selectedFilter == 'pemasukan' && jenis.contains('pemasukan')) ||
                  (_selectedFilter == 'pengeluaran' && jenis.contains('pengeluaran'));

              final matchesSearch = _searchQuery.isEmpty ||
                  judul.contains(_searchQuery.toLowerCase()) ||
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
    final isPemasukan = item['jenis'].toString().toLowerCase().contains('pemasukan');
    final formattedNominal = _formatCurrency(item['nominal']);

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
                        : (isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    isPemasukan ? LucideIcons.arrowDownLeft : LucideIcons.arrowUpRight,
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
                        item['judul']?.toString() ?? 'Transaksi',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${item['tanggal']} • ${item['kategori']}',
                        style: TextStyle(fontSize: 10, color: textMuted, fontWeight: FontWeight.w500),
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
