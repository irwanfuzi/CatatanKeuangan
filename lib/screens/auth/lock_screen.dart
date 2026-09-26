import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LockScreen extends StatefulWidget {
  final String savedPin;
  final VoidCallback onUnlocked;

  const LockScreen({
    super.key,
    required this.savedPin,
    required this.onUnlocked,
  });

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  final LocalAuthentication _localAuth = LocalAuthentication();
  String _enteredPin = '';
  bool _isError = false;
  bool _isBiometricEnabled = false;

  @override
  void initState() {
    super.initState();
    // Otomatis picu biometrik saat pertama kali layar dikunci
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndPromptBiometrics();
    });
  }

  Future<void> _checkAndPromptBiometrics() async {
    final prefs = await SharedPreferences.getInstance();
    final isEnabled = prefs.getBool('fingerprint_enabled') ?? false;

    if (mounted) {
      setState(() {
        _isBiometricEnabled = isEnabled;
      });
    }

    // Jalankan autentikasi biometrik jika fitur diaktifkan
    if (isEnabled) {
      _authenticateWithBiometrics();
    }
  }

  Future<void> _authenticateWithBiometrics() async {
    try {
      // Pengecekan ketersediaan sensor pada perangkat native
      if (!kIsWeb) {
        final canCheck = await _localAuth.canCheckBiometrics;
        final isSupported = await _localAuth.isDeviceSupported();

        if (!canCheck && !isSupported) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Biometrik tidak tersedia. Masukkan PIN Anda.'),
                backgroundColor: Color(0xFF0052FF),
                duration: Duration(seconds: 2),
              ),
            );
          }
          return;
        }
      }

      // Memunculkan prompt dialog sidik jari/wajah bawaan HP
      final authenticated = await _localAuth.authenticate(
        localizedReason: 'Pindai sidik jari Anda untuk membuka MyKas',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      if (authenticated && mounted) {
        widget.onUnlocked();
      }
    } catch (e) {
      // Jika biometrik gagal / dibatalkan / di-web tidak ada plugin native,
      // fallback aman secara halus tanpa pesan merah mengganggu.
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gunakan PIN 6-digit untuk membuka aplikasi.'),
            backgroundColor: Color(0xFF0052FF),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _onKeyPress(String val) {
    if (_enteredPin.length < 6) {
      setState(() {
        _isError = false;
        _enteredPin += val;
      });

      if (_enteredPin.length == 6) {
        _verifyPin();
      }
    }
  }

  void _onDelete() {
    if (_enteredPin.isNotEmpty) {
      setState(() {
        _isError = false;
        _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
      });
    }
  }

  void _verifyPin() {
    if (_enteredPin == widget.savedPin) {
      widget.onUnlocked();
    } else {
      setState(() {
        _isError = true;
        _enteredPin = '';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('PIN Salah! Silakan coba lagi.'),
          backgroundColor: Color(0xFFEF4444),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final textColor = isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktopWeb = constraints.maxWidth > 768;

            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: isDesktopWeb ? 400 : double.infinity),
                child: Column(
                  children: [
                    const Spacer(),
                    const Icon(Icons.lock_rounded, size: 56, color: Color(0xFF0052FF)),
                    const SizedBox(height: 16),
                    Text(
                      'Masukkan PIN MyKas',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Aplikasi dikunci untuk keamanan data Anda',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Indikator Titik PIN 6 Digit
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(6, (index) {
                        final isFilled = index < _enteredPin.length;
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _isError
                                ? const Color(0xFFEF4444)
                                : (isFilled ? const Color(0xFF0052FF) : Colors.transparent),
                            border: Border.all(
                              color: _isError
                                  ? const Color(0xFFEF4444)
                                  : (isFilled ? const Color(0xFF0052FF) : const Color(0xFF64748B)),
                              width: 2,
                            ),
                          ),
                        );
                      }),
                    ),
                    const Spacer(),

                    // Keypad NumPad
                    Container(
                      constraints: const BoxConstraints(maxWidth: 320),
                      padding: const EdgeInsets.only(bottom: 24),
                      child: Column(
                        children: [
                          for (var row in [
                            ['1', '2', '3'],
                            ['4', '5', '6'],
                            ['7', '8', '9'],
                          ])
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: row.map((num) => _buildKeypadBtn(num, textColor)).toList(),
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // Tombol Biometrik Utama (Picu Pemindaian Manual)
                                SizedBox(
                                  width: 64,
                                  height: 64,
                                  child: IconButton(
                                    onPressed: _authenticateWithBiometrics,
                                    icon: Icon(
                                      Icons.fingerprint_rounded,
                                      size: 32,
                                      color: _isBiometricEnabled
                                          ? const Color(0xFF0052FF)
                                          : textColor.withOpacity(0.3),
                                    ),
                                    tooltip: 'Buka dengan Biometrik',
                                  ),
                                ),
                                _buildKeypadBtn('0', textColor),
                                SizedBox(
                                  width: 64,
                                  height: 64,
                                  child: IconButton(
                                    onPressed: _onDelete,
                                    icon: Icon(Icons.backspace_outlined, color: textColor),
                                  ),
                                ),
                              ],
                            ),
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

  Widget _buildKeypadBtn(String val, Color textColor) {
    return SizedBox(
      width: 64,
      height: 64,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          shape: const CircleBorder(),
          side: BorderSide(color: textColor.withOpacity(0.2)),
        ),
        onPressed: () => _onKeyPress(val),
        child: Text(
          val,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textColor),
        ),
      ),
    );
  }
}
