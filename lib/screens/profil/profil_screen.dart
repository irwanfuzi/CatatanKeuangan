import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../utils/app_icons.dart';
import '../../theme/app_theme.dart';

// Import AppTheme buatanmu
import 'package:mykas/theme/app_theme.dart';

class ProfilScreen extends StatefulWidget {
  final VoidCallback? onLogout;
  final Function(bool isDark)? onThemeChanged;

  const ProfilScreen({
    super.key,
    this.onLogout,
    this.onThemeChanged,
  });

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  bool _isFingerprintEnabled = true;
  bool _isNotificationEnabled = true;

  // ---------------------------------------------------------------------------
  // MODAL 1: INFORMASI PRIBADI (EDIT PROFIL)
  // ---------------------------------------------------------------------------
  void _showInformasiPribadiModal(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppTheme.cardDark : AppTheme.cardLight;
    final textColor = isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight;
    final textMuted = isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight;
    final inputBg = isDark ? const Color(0xFF1E222D) : const Color(0xFFF8FAFC);
    final borderColor = isDark ? AppTheme.borderDark : AppTheme.borderLight;

    final namaController = TextEditingController(text: 'Irwan Fuzi');
    final emailController = TextEditingController(text: 'irwanfuzi23@gmail.com');
    final hpController = TextEditingController(text: '+62 812-3456-7890');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
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
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Informasi Pribadi',
                      style: GoogleFonts.urbanist(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: textColor,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(LucideIcons.x, size: 20, color: textColor),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text('Nama Lengkap', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textColor)),
                const SizedBox(height: 6),
                TextField(
                  controller: namaController,
                  style: TextStyle(fontSize: 13, color: textColor),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: inputBg,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: borderColor)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: borderColor)),
                  ),
                ),
                const SizedBox(height: 14),
                Text('Alamat Email', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textColor)),
                const SizedBox(height: 6),
                TextField(
                  controller: emailController,
                  style: TextStyle(fontSize: 13, color: textColor),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: inputBg,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: borderColor)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: borderColor)),
                  ),
                ),
                const SizedBox(height: 14),
                Text('Nomor WhatsApp / HP', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textColor)),
                const SizedBox(height: 6),
                TextField(
                  controller: hpController,
                  style: TextStyle(fontSize: 13, color: textColor),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: inputBg,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: borderColor)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: borderColor)),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Informasi pribadi berhasil diperbarui')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.brandPrimary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                    child: const Text('Simpan Perubahan', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // MODAL 2: PIN & KEAMANAN
  // ---------------------------------------------------------------------------
  void _showPinSecurityModal(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppTheme.cardDark : AppTheme.cardLight;
    final textColor = isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight;
    final textMuted = isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight;

    showModalBottomSheet(
      context: context,
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
              const SizedBox(height: 16),
              Icon(LucideIcons.lock, size: 40, color: const Color(0xFF8B5CF6)),
              const SizedBox(height: 12),
              Text(
                'Atur PIN Keamanan',
                style: GoogleFonts.urbanist(fontSize: 18, fontWeight: FontWeight.w800, color: textColor),
              ),
              const SizedBox(height: 6),
              Text(
                'Masukkan 6 digit PIN keamanan untuk mengonfirmasi transaksi dan membuka aplikasi.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: textMuted),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  6,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index < 2 ? AppTheme.brandPrimary : (isDark ? AppTheme.borderDark : const Color(0xFFCBD5E1)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('PIN transaksi berhasil diperbarui')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B5CF6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: const Text('Ubah PIN Sekarang', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // MODAL 3: PERANGKAT TERHUBUNG
  // ---------------------------------------------------------------------------
  void _showDevicesModal(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppTheme.cardDark : AppTheme.cardLight;
    final textColor = isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight;
    final textMuted = isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight;
    final borderColor = isDark ? AppTheme.borderDark : AppTheme.borderLight;

    showModalBottomSheet(
      context: context,
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
            crossAxisAlignment: CrossAxisAlignment.start,
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
              const SizedBox(height: 16),
              Text(
                'Perangkat Terhubung',
                style: GoogleFonts.urbanist(fontSize: 18, fontWeight: FontWeight.w800, color: textColor),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: borderColor),
                ),
                child: Row(
                  children: [
                    const Icon(LucideIcons.smartphone, color: Color(0xFF10B981)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Samsung Galaxy S24 Ultra', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: textColor)),
                          Text('Perangkat Ini • Jakarta, Indonesia', style: TextStyle(fontSize: 11, color: textMuted)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: const Color(0xFF10B981).withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                      child: const Text('Aktif', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF10B981))),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: borderColor),
                ),
                child: Row(
                  children: [
                    const Icon(LucideIcons.laptop, color: Color(0xFF00AED6)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Chrome di macOS (Vercel Web)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: textColor)),
                          Text('Terakhir aktif 2 jam yang lalu', style: TextStyle(fontSize: 11, color: textMuted)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Berhasil keluar dari semua perangkat lain')),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFEF4444)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Keluar Perangkat Lain', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFEF4444))),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // MODAL 4: QR CODE PROFIL
  // ---------------------------------------------------------------------------
  void _showQrCodeModal(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppTheme.cardDark : AppTheme.cardLight;
    final textColor = isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight;

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('QR Profil MyKas', style: GoogleFonts.urbanist(fontSize: 18, fontWeight: FontWeight.w800, color: textColor)),
                    IconButton(onPressed: () => Navigator.pop(context), icon: Icon(LucideIcons.x, size: 20, color: textColor)),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                  child: const Icon(LucideIcons.qrCode, size: 180, color: Colors.black),
                ),
                const SizedBox(height: 16),
                Text('Irwan Fuzi', style: GoogleFonts.urbanist(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
                const Text('Scan untuk transfer kas cepat', style: TextStyle(fontSize: 11, color: Colors.grey)),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // MODAL 5: LOGOUT CONFIRMATION
  // ---------------------------------------------------------------------------
  void _showLogoutConfirmation(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppTheme.cardDark : AppTheme.cardLight;
    final textColor = isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight;
    final textMuted = isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight;

    showModalBottomSheet(
      context: context,
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
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444).withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(LucideIcons.logOut, color: Color(0xFFEF4444), size: 24),
              ),
              const SizedBox(height: 16),
              Text(
                'Keluar dari MyKas?',
                style: GoogleFonts.urbanist(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Sesi akun kamu akan diakhiri. Kamu harus masuk kembali untuk melihat riwayat dan catatan kas.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: textMuted,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(
                          color: isDark ? AppTheme.borderDark : AppTheme.borderLight,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        'Batal',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        if (widget.onLogout != null) {
                          widget.onLogout!();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Sesi berhasil diakhiri')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEF4444),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Ya, Keluar',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
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

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0A192F) : AppTheme.brandPrimary,
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth >= 1024;

              return Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: isDesktop ? 800 : 540),
                  child: CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      // SLIVER HEADER PROFIL DENGAN TOPOGRAPHIC CONTOUR & BRAND GRADIENT
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: _ProfilHeaderDelegate(
                          minHeight: 52.0,
                          maxHeight: 180.0,
                          isDark: isDark,
                          onQrTap: () => _showQrCodeModal(context),
                        ),
                      ),

                      // KONTEN UTAMA PROFIL
                      SliverToBoxAdapter(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: surfaceColor,
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                          ),
                          padding: EdgeInsets.all(isDesktop ? 28.0 : 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Container(
                                  width: 38,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: isDark ? AppTheme.borderDark : const Color(0xFFE2E8F0),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),

                              // SEKSI 1: AKUN & KEAMANAN
                              _buildSectionHeader('AKUN & KEAMANAN', textColor),
                              const SizedBox(height: 10),
                              _buildMenuGroupCard(
                                cardBg: cardBg,
                                borderColor: borderColor,
                                children: [
                                  _buildMenuItem(
                                    icon: LucideIcons.user,
                                    iconColor: AppTheme.brandPrimary,
                                    title: 'Informasi Pribadi',
                                    subtitle: 'Nama lengkap, email, dan nomor HP',
                                    textColor: textColor,
                                    textMuted: textMuted,
                                    onTap: () => _showInformasiPribadiModal(context),
                                  ),
                                  _buildDivider(borderColor),
                                  _buildMenuItem(
                                    icon: LucideIcons.lock,
                                    iconColor: const Color(0xFF8B5CF6),
                                    title: 'PIN & Keamanan',
                                    subtitle: 'Ubah PIN transaksi akun MyKas',
                                    textColor: textColor,
                                    textMuted: textMuted,
                                    onTap: () => _showPinSecurityModal(context),
                                  ),
                                  _buildDivider(borderColor),
                                  _buildSwitchMenuItem(
                                    icon: LucideIcons.fingerprint,
                                    iconColor: const Color(0xFF10B981),
                                    title: 'Biometrik / Sidik Jari',
                                    subtitle: 'Login cepat menggunakan sensor sidik jari',
                                    value: _isFingerprintEnabled,
                                    textColor: textColor,
                                    textMuted: textMuted,
                                    onChanged: (val) {
                                      setState(() {
                                        _isFingerprintEnabled = val;
                                      });
                                    },
                                  ),
                                  _buildDivider(borderColor),
                                  _buildMenuItem(
                                    icon: LucideIcons.smartphone,
                                    iconColor: const Color(0xFF00AED6),
                                    title: 'Perangkat Terhubung',
                                    subtitle: 'Kelola sesi login aktif di HP / Web',
                                    textColor: textColor,
                                    textMuted: textMuted,
                                    badgeText: '2 Perangkat',
                                    onTap: () => _showDevicesModal(context),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 24),

                              // SEKSI 2: PREFERENSI & INTEGRASI (DENGAN SWITCH DARK MODE REAL-TIME)
                              _buildSectionHeader('PREFERENSI & INTEGRASI', textColor),
                              const SizedBox(height: 10),
                              _buildMenuGroupCard(
                                cardBg: cardBg,
                                borderColor: borderColor,
                                children: [
                                  // TILE TOGGLE DARK MODE UTAMA
                                  _buildSwitchMenuItem(
                                    icon: isDark ? LucideIcons.moon : LucideIcons.sun,
                                    iconColor: isDark ? const Color(0xFF38BDF8) : const Color(0xFFF59E0B),
                                    title: 'Tampilan Mode Gelap',
                                    subtitle: isDark ? 'Tema Deep Charcoal aktif' : 'Tema Light Royal Blue aktif',
                                    value: isDark,
                                    textColor: textColor,
                                    textMuted: textMuted,
                                    onChanged: (val) {
                                      if (widget.onThemeChanged != null) {
                                        widget.onThemeChanged!(val);
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text(val ? 'Mode Gelap diaktifkan' : 'Mode Terang diaktifkan')),
                                        );
                                      }
                                    },
                                  ),
                                  _buildDivider(borderColor),
                                  _buildMenuItem(
                                    icon: LucideIcons.fileSpreadsheet,
                                    iconColor: const Color(0xFF10B981),
                                    title: 'Hubungkan Google Sheets',
                                    subtitle: 'Sinkronisasi otomatis catatan kas',
                                    textColor: textColor,
                                    textMuted: textMuted,
                                    badgeText: 'Terhubung',
                                    onTap: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Status Google Sheets: Terhubung secara otomatis')),
                                      );
                                    },
                                  ),
                                  _buildDivider(borderColor),
                                  _buildSwitchMenuItem(
                                    icon: LucideIcons.bell,
                                    iconColor: const Color(0xFFF59E0B),
                                    title: 'Notifikasi & Pengingat',
                                    subtitle: 'Pengingat rutin catat kas via Telegram & App',
                                    value: _isNotificationEnabled,
                                    textColor: textColor,
                                    textMuted: textMuted,
                                    onChanged: (val) {
                                      setState(() {
                                        _isNotificationEnabled = val;
                                      });
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(val ? 'Notifikasi Aktif' : 'Notifikasi Dinonaktifkan')),
                                      );
                                    },
                                  ),
                                  _buildDivider(borderColor),
                                  _buildMenuItem(
                                    icon: LucideIcons.globe,
                                    iconColor: AppTheme.brandPrimary,
                                    title: 'Bahasa & Mata Uang',
                                    subtitle: 'Bahasa Indonesia (IDR - Rp)',
                                    textColor: textColor,
                                    textMuted: textMuted,
                                    onTap: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Mata uang default: IDR (Rupiah)')),
                                      );
                                    },
                                  ),
                                ],
                              ),

                              const SizedBox(height: 24),

                              // SEKSI 3: DUKUNGAN & INFORMASI
                              _buildSectionHeader('DUKUNGAN', textColor),
                              const SizedBox(height: 10),
                              _buildMenuGroupCard(
                                cardBg: cardBg,
                                borderColor: borderColor,
                                children: [
                                  _buildMenuItem(
                                    icon: LucideIcons.helpCircle,
                                    iconColor: const Color(0xFF00AED6),
                                    title: 'Pusat Bantuan & Panduan',
                                    subtitle: 'Panduan penggunaan & dokumentasi MyKas',
                                    textColor: textColor,
                                    textMuted: textMuted,
                                    onTap: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Dokumentasi MyKas v2.4.0')),
                                      );
                                    },
                                  ),
                                  _buildDivider(borderColor),
                                  _buildMenuItem(
                                    icon: LucideIcons.shieldCheck,
                                    iconColor: const Color(0xFF64748B),
                                    title: 'Kebijakan Privasi',
                                    subtitle: 'Perlindungan & keamanan data kas',
                                    textColor: textColor,
                                    textMuted: textMuted,
                                    onTap: () {},
                                  ),
                                  _buildDivider(borderColor),
                                  _buildMenuItem(
                                    icon: LucideIcons.info,
                                    iconColor: const Color(0xFF8B5CF6),
                                    title: 'Tentang Aplikasi',
                                    subtitle: 'MyKas v2.4.0 (Flutter Native & PWA)',
                                    textColor: textColor,
                                    textMuted: textMuted,
                                    onTap: () {},
                                  ),
                                ],
                              ),

                              const SizedBox(height: 28),

                              // TOMBOL LOGOUT
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: OutlinedButton.icon(
                                  onPressed: () => _showLogoutConfirmation(context),
                                  icon: const Icon(LucideIcons.logOut, size: 18, color: Color(0xFFEF4444)),
                                  label: const Text(
                                    'Keluar Aplikasi',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFEF4444),
                                    ),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                      color: const Color(0xFFEF4444).withOpacity(0.3),
                                      width: 1.2,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    backgroundColor: const Color(0xFFEF4444).withOpacity(0.04),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 20),

                              // FOOTER VERSI
                              Center(
                                child: Text(
                                  'MyKas v2.4.0 (Flutter Native & PWA)',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: textMuted,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 40),
                            ],
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
      ),
    );
  }

  // HELPER WIDGETS
  Widget _buildSectionHeader(String title, Color textColor) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w800,
        color: textColor.withOpacity(0.55),
        letterSpacing: 0.8,
      ),
    );
  }

  Widget _buildMenuGroupCard({
    required Color cardBg,
    required Color borderColor,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required Color textColor,
    required Color textMuted,
    String? badgeText,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, size: 18, color: iconColor),
      ),
      title: Text(
        title,
        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: textColor),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 11, color: textMuted),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (badgeText != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                badgeText,
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: iconColor),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Icon(LucideIcons.chevronRight, size: 16, color: textMuted),
        ],
      ),
    );
  }

  Widget _buildSwitchMenuItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool value,
    required Color textColor,
    required Color textMuted,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 18, color: iconColor),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: textColor),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 11, color: textMuted),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: AppTheme.brandPrimary,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(Color borderColor) {
    return Divider(color: borderColor, height: 1, indent: 56, endIndent: 16);
  }
}

// HEADER DELEGATE PROFIL ISOLATED
class _ProfilHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final bool isDark;
  final VoidCallback onQrTap;

  _ProfilHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.isDark,
    required this.onQrTap,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final rawProgress = (shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0);
    final progress = Curves.easeInOutCubic.transform(rawProgress);

    final contentOpacity = (1.0 - (progress * 2.2)).clamp(0.0, 1.0);
    final topPosition = (1.0 - progress) * 12.0 + 2.0;

    final BoxDecoration headerDecoration = isDark
        ? const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF0A192F),
                Color(0xFF0F1117),
              ],
            ),
          )
        : const BoxDecoration(
            color: AppTheme.brandPrimary,
          );

    return Container(
      decoration: headerDecoration.copyWith(
        boxShadow: shrinkOffset > 30
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ]
            : [],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(
            painter: ProfilTopographicPainter(),
          ),
          // HEADER TITLE BAR
          Positioned(
            top: topPosition,
            left: 20,
            right: 20,
            height: 36,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Profil Saya',
                  style: GoogleFonts.urbanist(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.4,
                  ),
                ),
                IconButton(
                  onPressed: onQrTap,
                  icon: const Icon(LucideIcons.qrCode, color: Colors.white, size: 20),
                  tooltip: 'QR Code Profil',
                ),
              ],
            ),
          ),

          // AVATAR USER & DETAILS CARD
          if (contentOpacity > 0.0)
            Positioned(
              bottom: 16,
              left: 20,
              right: 20,
              child: Opacity(
                opacity: contentOpacity,
                child: Row(
                  children: [
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.2),
                        border: Border.all(color: Colors.white.withOpacity(0.4), width: 1.5),
                      ),
                      child: const Center(
                        child: Text(
                          'IF',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Irwan Fuzi',
                            style: GoogleFonts.urbanist(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: -0.4,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'irwanfuzi23@gmail.com',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.white70,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _ProfilHeaderDelegate oldDelegate) {
    return oldDelegate.minHeight != minHeight ||
        oldDelegate.maxHeight != maxHeight ||
        oldDelegate.isDark != isDark;
  }
}

// PAINTER KONTUR TOPOGRAFI ISOLATED KHUSUS PROFIL
class ProfilTopographicPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final path1 = Path();
    path1.moveTo(0, size.height * 0.3);
    path1.cubicTo(
      size.width * 0.25, size.height * 0.1,
      size.width * 0.50, size.height * 0.6,
      size.width, size.height * 0.25,
    );

    final path2 = Path();
    path2.moveTo(0, size.height * 0.5);
    path2.cubicTo(
      size.width * 0.30, size.height * 0.25,
      size.width * 0.60, size.height * 0.85,
      size.width, size.height * 0.45,
    );

    canvas.drawPath(path1, paint);
    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
