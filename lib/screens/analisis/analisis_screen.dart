import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_theme.dart';
import '../../utils/app_icons.dart';

class AnalisisScreen extends StatefulWidget {
  final Map<String, dynamic>? summaryData;

  const AnalisisScreen({
    super.key,
    this.summaryData,
  });

  @override
  State<AnalisisScreen> createState() => _AnalisisScreenState();
}

class _AnalisisScreenState extends State<AnalisisScreen> {
  String _selectedRentang = 'Bulan Ini';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bgColor = isDark ? AppTheme.bgDark : AppTheme.bgLight;
    final cardBg = isDark ? AppTheme.cardDark : AppTheme.cardLight;
    final borderColor = isDark ? AppTheme.borderDark : AppTheme.borderLight;
    final textColor = isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight;
    final textMuted = isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 1024;

            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: isDesktop ? 1000 : 540),
                child: ListView(
                  padding: EdgeInsets.all(isDesktop ? 28.0 : 16.0),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Analisis Keuangan',
                              style: GoogleFonts.urbanist(
                                fontSize: isDesktop ? 26 : 22,
                                fontWeight: FontWeight.w900,
                                color: textColor,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Rincian dan tren alokasi kas bulanan',
                              style: TextStyle(fontSize: 12, color: textMuted),
                            ),
                          ],
                        ),
                        DropdownButton<String>(
                          value: _selectedRentang,
                          dropdownColor: cardBg,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.brandPrimary,
                          ),
                          underline: const SizedBox(),
                          icon: const Icon(AppIcons.chevronRight, size: 16, color: AppTheme.brandPrimary),
                          items: ['Minggu Ini', 'Bulan Ini', 'Tahun Ini']
                              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                              .toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() {
                                _selectedRentang = val;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: borderColor),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Penggunaan Budget',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                              const Text(
                                '62%',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                  color: AppTheme.brandPrimary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: const LinearProgressIndicator(
                              value: 0.62,
                              minHeight: 10,
                              backgroundColor: Color(0xFFE2E8F0),
                              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.brandPrimary),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Terpakai Rp 2.804.178 dari batas budget bulanan Rp 4.500.000',
                            style: TextStyle(fontSize: 11, color: textMuted),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: borderColor),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Kategori Pengeluaran Terbesar',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 18),
                          _buildCategoryRow(
                            'Kuliner & Makanan',
                            'Rp 1.250.000',
                            '44.5%',
                            AppIcons.utensils,
                            const Color(0xFFF97316),
                            textColor,
                            textMuted,
                          ),
                          Divider(color: borderColor, height: 24),
                          _buildCategoryRow(
                            'Kebutuhan Harian',
                            'Rp 850.000',
                            '30.3%',
                            AppIcons.shoppingCart,
                            const Color(0xFF8B5CF6),
                            textColor,
                            textMuted,
                          ),
                          Divider(color: borderColor, height: 24),
                          _buildCategoryRow(
                            'Layanan Antar / GoFood',
                            'Rp 384.178',
                            '13.7%',
                            AppIcons.shoppingBag,
                            const Color(0xFF00AED6),
                            textColor,
                            textMuted,
                          ),
                          Divider(color: borderColor, height: 24),
                          _buildCategoryRow(
                            'Utilitas & Tagihan',
                            'Rp 320.000',
                            '11.5%',
                            AppIcons.zap,
                            const Color(0xFFEAB308),
                            textColor,
                            textMuted,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCategoryRow(
    String category,
    String amount,
    String percentage,
    IconData icon,
    Color iconBg,
    Color textColor,
    Color textMuted,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconBg.withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 20, color: iconBg),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                category,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: textColor),
              ),
              const SizedBox(height: 2),
              Text(
                'Porsi $percentage dari pengeluaran',
                style: TextStyle(fontSize: 11, color: textMuted),
              ),
            ],
          ),
        ),
        Text(
          amount,
          style: GoogleFonts.urbanist(fontSize: 14, fontWeight: FontWeight.w900, color: textColor),
        ),
      ],
    );
  }
}
