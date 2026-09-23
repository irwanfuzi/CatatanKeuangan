import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_theme.dart';
import '../../utils/app_icons.dart';

class ProfilScreen extends StatefulWidget {
  final Function(bool isDark)? onThemeChanged;
  final VoidCallback? onLogout;

  const ProfilScreen({
    super.key,
    this.onThemeChanged,
    this.onLogout,
  });

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  bool _notifikasiAktif = true;

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
                constraints: BoxConstraints(maxWidth: isDesktop ? 800 : 540),
                child: ListView(
                  padding: EdgeInsets.all(isDesktop ? 32.0 : 20.0),
                  children: [
                    Text(
                      'Profil & Pengaturan',
                      style: GoogleFonts.urbanist(
                        fontSize: isDesktop ? 26 : 22,
                        fontWeight: FontWeight.w900,
                        color: textColor,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // User Header Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: borderColor),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: AppTheme.brandPrimary.withOpacity(0.15),
                            child: const Icon(
                              AppIcons.user,
                              color: AppTheme.brandPrimary,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Pengguna MyKas',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'user@mykas.app',
                                  style: TextStyle(fontSize: 13, color: textMuted),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(AppIcons.pencil, size: 18, color: textMuted),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Pengaturan Sesi & Tampilan
                    Text(
                      'PREFERENSI APLIKASI',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: textMuted,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 10),

                    Container(
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: borderColor),
                      ),
                      child: Column(
                        children: [
                          SwitchListTile(
                            value: isDark,
                            title: Text(
                              'Mode Gelap',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                            subtitle: Text(
                              'Gunakan tema gelap untuk kenyamanan mata',
                              style: TextStyle(fontSize: 12, color: textMuted),
                            ),
                            activeColor: AppTheme.brandPrimary,
                            onChanged: (val) {
                              if (widget.onThemeChanged != null) {
                                widget.onThemeChanged!(val);
                              }
                            },
                          ),
                          Divider(color: borderColor, height: 1),
                          SwitchListTile(
                            value: _notifikasiAktif,
                            title: Text(
                              'Notifikasi Transaksi',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                            subtitle: Text(
                              'Pengingat pengeluaran & pengingat kas bulanan',
                              style: TextStyle(fontSize: 12, color: textMuted),
                            ),
                            activeColor: AppTheme.brandPrimary,
                            onChanged: (val) {
                              setState(() {
                                _notifikasiAktif = val;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Keluar Sesi Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton.icon(
                        onPressed: widget.onLogout,
                        icon: const Icon(AppIcons.close, size: 18, color: Color(0xFFEF4444)),
                        label: const Text(
                          'Keluar Sesi',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFEF4444)),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFEF4444)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
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
}
