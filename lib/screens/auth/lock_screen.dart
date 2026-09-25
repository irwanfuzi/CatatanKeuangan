import 'package:flutter/material.dart';

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
  String _enteredPin = '';
  bool _isError = false;

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

            // PIN Dots Indicator
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

            // Keypad Num
            Container(
              constraints: const BoxConstraints(maxWidth: 320), // SUDAH DIPERBAIKI (Gunakan BoxConstraints)
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
                        const SizedBox(width: 64, height: 64),
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
