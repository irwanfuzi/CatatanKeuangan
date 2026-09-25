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
  // State Keamanan
  bool _pinLockEnabled = true;
  bool _fingerprintEnabled = true;

  // State Preferensi
  ThemeMode _selectedThemeMode = ThemeMode.dark;
  String _currentLanguage = 'Bahasa Indonesia';

  // State Simulasi Akun Terhubung
  bool _isGoogleConnected = true;
  bool _isAppleConnected = false;
  bool _isFacebookConnected = false;

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
                constraints: BoxConstraints(maxWidth: isDesktop ? 720 : 540),
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? 32.0 : 20.0,
                    vertical: 24.0,
                  ),
                  children: [
                    // TITLE HEADER
                    Text(
                      'Profil & Pengaturan',
                      style: GoogleFonts.urbanist(
                        fontSize: isDesktop ? 28 : 22,
                        fontWeight: FontWeight.w900,
                        color: textColor,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 1. DATA DIRI USER CARD
                    _buildProfileHeaderCard(cardBg, borderColor, textColor, textMuted),

                    const SizedBox(height: 28),

                    // 2. INTEGRASI AKUN
                    _buildSectionTitle('INTEGRASI AKUN', textMuted),
                    const SizedBox(height: 10),
                    _buildCardGroup(cardBg, borderColor, [
                      _buildListTile(
                        icon: Icons.link_rounded,
                        iconColor: AppTheme.brandPrimary,
                        title: 'Akun Terhubung',
                        subtitle: 'Google, Apple ID, atau Facebook',
                        trailingText: _isGoogleConnected ? 'Google Terhubung' : 'Atur',
                        textColor: textColor,
                        textMuted: textMuted,
                        onTap: () => _showConnectedAccountsBottomSheet(
                          context, cardBg, borderColor, textColor, textMuted,
                        ),
                      ),
                    ]),

                    const SizedBox(height: 28),

                    // 3. KEAMANAN & AKSES
                    _buildSectionTitle('KEAMANAN & AKSES', textMuted),
                    const SizedBox(height: 10),
                    _buildCardGroup(cardBg, borderColor, [
                      _buildSwitchTile(
                        icon: Icons.lock_outline_rounded,
                        iconColor: const Color(0xFFA78BFA),
                        title: 'Kunci PIN Aplikasi',
                        subtitle: 'Minta PIN 6-digit saat aplikasi dibuka',
                        value: _pinLockEnabled,
                        textColor: textColor,
                        textMuted: textMuted,
                        onChanged: (val) {
                          setState(() {
                            _pinLockEnabled = val;
                            if (!val) _fingerprintEnabled = false;
                          });
                        },
                      ),
                      Divider(height: 1, color: borderColor),
                      _buildSwitchTile(
                        icon: Icons.fingerprint_rounded,
                        iconColor: const Color(0xFF10B981),
                        title: 'Autentikasi Sidik Jari',
                        subtitle: 'Gunakan sidik jari untuk akses cepat',
                        value: _fingerprintEnabled,
                        textColor: textColor,
                        textMuted: textMuted,
                        onChanged: _pinLockEnabled
                            ? (val) => setState(() => _fingerprintEnabled = val)
                            : null,
                      ),
                      if (_pinLockEnabled) ...[
                        Divider(height: 1, color: borderColor),
                        _buildListTile(
                          icon: Icons.pin_outlined,
                          iconColor: const Color(0xFF38BDF8),
                          title: 'Ubah PIN Kas',
                          subtitle: 'Perbarui kode keamanan 6-digit Anda',
                          textColor: textColor,
                          textMuted: textMuted,
                          onTap: () => _showUbahPinDialog(context, cardBg, borderColor, textColor, textMuted),
                        ),
                      ],
                    ]),

                    const SizedBox(height: 28),

                    // 4. TAMPILAN & PREFERENSI
                    _buildSectionTitle('TAMPILAN & PREFERENSI', textMuted),
                    const SizedBox(height: 10),
                    _buildCardGroup(cardBg, borderColor, [
                      _buildListTile(
                        icon: Icons.dark_mode_outlined,
                        iconColor: const Color(0xFFF59E0B),
                        title: 'Mode Tampilan',
                        subtitle: _getThemeModeSubtitle(_selectedThemeMode),
                        textColor: textColor,
                        textMuted: textMuted,
                        onTap: () => _showThemeModeBottomSheet(context, cardBg, borderColor, textColor, textMuted),
                      ),
                      Divider(height: 1, color: borderColor),
                      _buildListTile(
                        icon: Icons.language_rounded,
                        iconColor: AppTheme.brandPrimary,
                        title: 'Bahasa Aplikasi',
                        subtitle: _currentLanguage,
                        textColor: textColor,
                        textMuted: textMuted,
                        onTap: () => _showLanguageBottomSheet(context, cardBg, borderColor, textColor, textMuted),
                      ),
                    ]),

                    const SizedBox(height: 28),

                    // 5. DATA & LAPORAN
                    _buildSectionTitle('DATA & LAPORAN', textMuted),
                    const SizedBox(height: 10),
                    _buildCardGroup(cardBg, borderColor, [
                      _buildListTile(
                        icon: Icons.file_download_outlined,
                        iconColor: const Color(0xFF10B981),
                        title: 'Ekspor Laporan Kas',
                        subtitle: 'Unduh rekapitulasi format PDF / Excel',
                        textColor: textColor,
                        textMuted: textMuted,
                        onTap: () {},
                      ),
                      Divider(height: 1, color: borderColor),
                      _buildListTile(
                        icon: Icons.cloud_upload_outlined,
                        iconColor: const Color(0xFF38BDF8),
                        title: 'Cadangkan Data',
                        subtitle: 'Simpan file cadangan transaksi secara lokal',
                        textColor: textColor,
                        textMuted: textMuted,
                        onTap: () {},
                      ),
                    ]),

                    const SizedBox(height: 36),

                    // 6. TOMBOL LOGOUT & HAPUS AKUN
                    Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: textColor,
                              side: BorderSide(color: borderColor),
                              backgroundColor: cardBg,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                            onPressed: widget.onLogout ?? () => _showLogoutConfirmationDialog(context, cardBg, borderColor, textColor, textMuted),
                            icon: const Icon(AppIcons.close, size: 18),
                            label: const Text(
                              'Keluar Sesi',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: TextButton.icon(
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(0xFFEF4444),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            onPressed: () => _showDeleteAccountDialog(context, cardBg, borderColor, textColor, textMuted),
                            icon: const Icon(Icons.delete_forever_rounded, size: 18),
                            label: const Text(
                              'Hapus Akun Permanen',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // FOOTER VERSI
                    Center(
                      child: Text(
                        'MyKas v2.4.0 • Own Your Money',
                        style: TextStyle(color: textMuted, fontSize: 11, fontWeight: FontWeight.w500),
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // HELPER BUILDERS & UI COMPONENTS
  // ---------------------------------------------------------------------------

  Widget _buildSectionTitle(String title, Color textColor) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w800,
        color: textColor,
        letterSpacing: 1.0,
      ),
    );
  }

  Widget _buildProfileHeaderCard(Color cardBg, Color borderColor, Color textColor, Color textMuted) {
    return Container(
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
                  'Irwan Fuzi',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'irwan.fuzi@mykas.app',
                  style: TextStyle(fontSize: 12, color: textMuted),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(Icons.phone_android_rounded, size: 12, color: textMuted),
                    const SizedBox(width: 4),
                    Text(
                      '+62 812-3456-7890',
                      style: TextStyle(fontSize: 12, color: textMuted, fontWeight: FontWeight.w500),
                    ),
                  ],
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
    );
  }

  Widget _buildCardGroup(Color cardBg, Color borderColor, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    String? trailingText,
    required Color textColor,
    required Color textMuted,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textColor)),
      subtitle: Text(subtitle, style: TextStyle(fontSize: 11, color: textMuted)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null)
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: Text(trailingText, style: TextStyle(color: textMuted, fontSize: 11, fontWeight: FontWeight.w600)),
            ),
          Icon(Icons.chevron_right_rounded, color: textMuted, size: 18),
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool value,
    required Color textColor,
    required Color textMuted,
    required ValueChanged<bool>? onChanged,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (onChanged != null ? iconColor : textMuted).withOpacity(0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: onChanged != null ? iconColor : textMuted, size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: onChanged != null ? textColor : textMuted,
        ),
      ),
      subtitle: Text(subtitle, style: TextStyle(fontSize: 11, color: textMuted)),
      trailing: Switch.adaptive(
        value: value,
        activeColor: AppTheme.brandPrimary,
        onChanged: onChanged,
      ),
    );
  }

  String _getThemeModeSubtitle(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.dark:
        return 'Mode Gelap (Aktif)';
      case ThemeMode.light:
        return 'Mode Terang (Aktif)';
      case ThemeMode.system:
        return 'Mengikuti Sistem OS';
    }
  }

  // ---------------------------------------------------------------------------
  // MODAL BOTTOMSHEETS & DIALOGS
  // ---------------------------------------------------------------------------

  void _showConnectedAccountsBottomSheet(
    BuildContext context, Color cardBg, Color borderColor, Color textColor, Color textMuted,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(width: 36, height: 4, decoration: BoxDecoration(color: borderColor, borderRadius: BorderRadius.circular(2))),
              ),
              const SizedBox(height: 16),
              Text('Akun Terhubung', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
              const SizedBox(height: 6),
              Text('Tautkan akun Anda untuk kemudahan akses masuk.', style: TextStyle(color: textMuted, fontSize: 12)),
              const SizedBox(height: 20),
              
              _buildSocialTile(
                title: 'Google',
                subtitle: _isGoogleConnected ? 'irwan.fuzi@gmail.com' : 'Belum Terhubung',
                isConnected: _isGoogleConnected,
                icon: Icons.g_mobiledata_rounded,
                iconColor: const Color(0xFFEA4335),
                textColor: textColor,
                textMuted: textMuted,
                borderColor: borderColor,
                onToggle: () {
                  setModalState(() => _isGoogleConnected = !_isGoogleConnected);
                  setState(() {});
                },
              ),
              const SizedBox(height: 10),

              _buildSocialTile(
                title: 'Apple ID',
                subtitle: _isAppleConnected ? 'Terhubung' : 'Belum Terhubung',
                isConnected: _isAppleConnected,
                icon: Icons.apple_rounded,
                iconColor: textColor,
                textColor: textColor,
                textMuted: textMuted,
                borderColor: borderColor,
                onToggle: () {
                  setModalState(() => _isAppleConnected = !_isAppleConnected);
                  setState(() {});
                },
              ),
              const SizedBox(height: 10),

              _buildSocialTile(
                title: 'Facebook',
                subtitle: _isFacebookConnected ? 'Terhubung' : 'Belum Terhubung',
                isConnected: _isFacebookConnected,
                icon: Icons.facebook_rounded,
                iconColor: const Color(0xFF1877F2),
                textColor: textColor,
                textMuted: textMuted,
                borderColor: borderColor,
                onToggle: () {
                  setModalState(() => _isFacebookConnected = !_isFacebookConnected);
                  setState(() {});
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialTile({
    required String title,
    required String subtitle,
    required bool isConnected,
    required IconData icon,
    required Color iconColor,
    required Color textColor,
    required Color textMuted,
    required Color borderColor,
    required VoidCallback onToggle,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textColor)),
                Text(subtitle, style: TextStyle(color: textMuted, fontSize: 11)),
              ],
            ),
          ),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: isConnected ? const Color(0xFFEF4444) : AppTheme.brandPrimary,
              side: BorderSide(color: isConnected ? const Color(0xFFEF4444).withOpacity(0.5) : AppTheme.brandPrimary),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: onToggle,
            child: Text(
              isConnected ? 'Putuskan' : 'Tautkan',
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _showThemeModeBottomSheet(
    BuildContext context, Color cardBg, Color borderColor, Color textColor, Color textMuted,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: cardBg,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 36, height: 4, decoration: BoxDecoration(color: borderColor, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 16),
            Text('Pilih Mode Tampilan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
            const SizedBox(height: 16),
            _buildThemeOptionTile('Mode Gelap (Dark)', Icons.dark_mode_rounded, ThemeMode.dark, textColor, borderColor),
            const SizedBox(height: 8),
            _buildThemeOptionTile('Mode Terang (Light)', Icons.light_mode_rounded, ThemeMode.light, textColor, borderColor),
            const SizedBox(height: 8),
            _buildThemeOptionTile('Ikuti Sistem Perangkat', Icons.settings_suggest_rounded, ThemeMode.system, textColor, borderColor),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOptionTile(String title, IconData icon, ThemeMode mode, Color textColor, Color borderColor) {
    final isSelected = _selectedThemeMode == mode;
    return InkWell(
      onTap: () {
        setState(() => _selectedThemeMode = mode);
        if (widget.onThemeChanged != null) {
          widget.onThemeChanged!(mode == ThemeMode.dark);
        }
        Navigator.pop(context);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? AppTheme.brandPrimary : borderColor, width: isSelected ? 1.5 : 1.0),
          color: isSelected ? AppTheme.brandPrimary.withOpacity(0.08) : Colors.transparent,
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? AppTheme.brandPrimary : textColor, size: 20),
            const SizedBox(width: 12),
            Expanded(child: Text(title, style: TextStyle(fontSize: 14, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: textColor))),
            if (isSelected) const Icon(Icons.check_circle_rounded, color: AppTheme.brandPrimary, size: 20),
          ],
        ),
      ),
    );
  }

  void _showLanguageBottomSheet(
    BuildContext context, Color cardBg, Color borderColor, Color textColor, Color textMuted,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: cardBg,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 36, height: 4, decoration: BoxDecoration(color: borderColor, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 16),
            Text('Pilih Bahasa Aplikasi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
            const SizedBox(height: 16),
            _buildLanguageOptionTile('Bahasa Indonesia', 'ID', textColor, borderColor),
            const SizedBox(height: 8),
            _buildLanguageOptionTile('English (US)', 'EN', textColor, borderColor),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOptionTile(String title, String code, Color textColor, Color borderColor) {
    final isSelected = _currentLanguage == title;
    return InkWell(
      onTap: () {
        setState(() => _currentLanguage = title);
        Navigator.pop(context);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? AppTheme.brandPrimary : borderColor, width: isSelected ? 1.5 : 1.0),
          color: isSelected ? AppTheme.brandPrimary.withOpacity(0.08) : Colors.transparent,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: AppTheme.brandPrimary.withOpacity(0.15), borderRadius: BorderRadius.circular(6)),
              child: Text(code, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.brandPrimary)),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(title, style: TextStyle(fontSize: 14, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: textColor))),
            if (isSelected) const Icon(Icons.check_circle_rounded, color: AppTheme.brandPrimary, size: 20),
          ],
        ),
      ),
    );
  }

  void _showUbahPinDialog(BuildContext context, Color cardBg, Color borderColor, Color textColor, Color textMuted) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: borderColor)),
        title: Text('Ubah PIN Kas', style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 16)),
        content: Text('Masukkan PIN lama dan PIN baru Anda untuk memperbarui keamanan.', style: TextStyle(color: textMuted, fontSize: 12)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Batal', style: TextStyle(color: textMuted))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.brandPrimary, foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(context),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context, Color cardBg, Color borderColor, Color textColor, Color textMuted) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: borderColor)),
        title: Text('Keluar dari MyKas?', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
        content: Text(
          'Data pencatatan kas Anda tersimpan aman di cloud. Anda perlu masuk kembali untuk mengakses akun.',
          style: TextStyle(color: textMuted, fontSize: 13),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Batal', style: TextStyle(color: textMuted))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: textColor, foregroundColor: cardBg),
            onPressed: () => Navigator.pop(context),
            child: const Text('Ya, Keluar'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context, Color cardBg, Color borderColor, Color textColor, Color textMuted) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cardBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFFEF4444)),
        ),
        title: Row(
          children: const [
            Icon(Icons.warning_amber_rounded, color: Color(0xFFEF4444)),
            SizedBox(width: 8),
            Text('Hapus Akun Permanen?', style: TextStyle(color: Color(0xFFEF4444), fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
        content: Text(
          'Tindakan ini tidak dapat dibatalkan. Seluruh data transaksi, pencatatan kas, dan profil Anda akan dihapus secara permanen dari server.',
          style: TextStyle(color: textMuted, fontSize: 12, height: 1.4),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Batal', style: TextStyle(color: textMuted))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text('Ya, Hapus Permanen'),
          ),
        ],
      ),
    );
  }
}
