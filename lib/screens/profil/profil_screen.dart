import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../utils/app_icons.dart';

/// Halaman Profil Pengguna MyKas - Design System Production Grade
class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key});

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  bool _biometricEnabled = true;
  bool _notificationsEnabled = true;

  Widget _buildSectionHeader(String title, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8, top: 16),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: textColor.withOpacity(0.6),
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildTile({
    required IconData icon,
    required String title,
    required Color iconColor,
    required Color textColor,
    required Color cardBg,
    required Color borderColor,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: iconColor),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: textColor.withOpacity(0.6)),
              )
            : null,
        trailing: trailing ?? Icon(LucideIcons.chevronRight, size: 16, color: textColor.withOpacity(0.4)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight;
    final cardBg = isDark ? AppTheme.cardDark : AppTheme.cardLight;
    final borderColor = isDark ? AppTheme.borderDark : AppTheme.borderLight;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil & Pengaturan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.qrCode, size: 20),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('QR Code Akun MyKas Siap Scanned')),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // USER PROFILE HEADER CARD
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF0D47A1), const Color(0xFF1565C0)]
                    : [AppTheme.brandPrimary, AppTheme.brandLightBlue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  child: const Icon(LucideIcons.user, size: 28, color: Colors.white),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pengguna MyKas',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'mykas.user@email.com',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'PRO',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 11),
                  ),
                ),
              ],
            ),
          ),

          _buildSectionHeader('Keamanan & Privasi', textColor),
          _buildTile(
            icon: LucideIcons.fingerprint,
            title: 'Biometrik & Sensor',
            subtitle: 'Gunakan Fingerprint / FaceID',
            iconColor: AppTheme.brandPrimary,
            textColor: textColor,
            cardBg: cardBg,
            borderColor: borderColor,
            trailing: Switch.adaptive(
              value: _biometricEnabled,
              activeColor: AppTheme.brandPrimary,
              onChanged: (val) => setState(() => _biometricEnabled = val),
            ),
          ),
          _buildTile(
            icon: LucideIcons.lock,
            title: 'Ubah PIN Kas',
            iconColor: const Color(0xFF8B5CF6),
            textColor: textColor,
            cardBg: cardBg,
            borderColor: borderColor,
          ),

          _buildSectionHeader('Preferensi Aplikasi', textColor),
          _buildTile(
            icon: LucideIcons.bell,
            title: 'Notifikasi Harian',
            subtitle: 'Pengingat catat pengeluaran',
            iconColor: const Color(0xFFF59E0B),
            textColor: textColor,
            cardBg: cardBg,
            borderColor: borderColor,
            trailing: Switch.adaptive(
              value: _notificationsEnabled,
              activeColor: AppTheme.brandPrimary,
              onChanged: (val) => setState(() => _notificationsEnabled = val),
            ),
          ),
          _buildTile(
            icon: LucideIcons.fileSpreadsheet,
            title: 'Ekspor Laporan (Excel/PDF)',
            iconColor: const Color(0xFF10B981),
            textColor: textColor,
            cardBg: cardBg,
            borderColor: borderColor,
          ),

          _buildSectionHeader('Bantuan', textColor),
          _buildTile(
            icon: LucideIcons.helpCircle,
            title: 'Pusat Bantuan MyKas',
            iconColor: AppTheme.brandPrimary,
            textColor: textColor,
            cardBg: cardBg,
            borderColor: borderColor,
          ),
          _buildTile(
            icon: LucideIcons.info,
            title: 'Versi Aplikasi',
            subtitle: 'MyKas v1.0.0 (Build 2026)',
            iconColor: Colors.grey,
            textColor: textColor,
            cardBg: cardBg,
            borderColor: borderColor,
            trailing: const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
