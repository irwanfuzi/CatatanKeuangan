import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:js_interop' as js;
import 'dart:js_interop_unsafe' as js_util;

import '../theme/app_theme.dart';

class PwaInstallPromptCard extends StatefulWidget {
  const PwaInstallPromptCard({super.key});

  @override
  State<PwaInstallPromptCard> createState() => _PwaInstallPromptCardState();
}

class _PwaInstallPromptCardState extends State<PwaInstallPromptCard> {
  bool _canInstall = false;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      _initPwaListener();
    }
  }

  void _initPwaListener() {
    try {
      // Register callback JavaScript ke Flutter Engine
      js.globalContext.setProperty(
        'onPwaPromptReady'.toJS,
        ((js.JSBoolean canPrompt) {
          if (mounted) {
            setState(() {
              _canInstall = canPrompt.toDart;
            });
          }
        }).toJS,
      );

      // Verifikasi ketersediaan prompt di window.deferredPwaPrompt
      final deferredPrompt = js.globalContext.getProperty('deferredPwaPrompt'.toJS);
      if (deferredPrompt != null && !deferredPrompt.isUndefined) {
        setState(() {
          _canInstall = true;
        });
      }
    } catch (e) {
      debugPrint('PWA Listener Exception: $e');
    }
  }

  void _promptInstall() {
    try {
      if (kIsWeb) {
        if (js.globalContext.hasProperty('triggerPwaInstall'.toJS).toDart) {
          js.globalContext.callMethod('triggerPwaInstall'.toJS);
        }
      }
    } catch (e) {
      debugPrint('Failed to trigger PWA Install: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb || !_canInstall) return const SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0D47A1), Color(0xFF1976D2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0D47A1).withOpacity(isDark ? 0.35 : 0.18),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.asset(
              AppTheme.logoAsset,
              width: 32,
              height: 32,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.get_app_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Install Aplikasi MyKas',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Akses cepat & lancar langsung dari Home Screen HP',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: _promptInstall,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF0D47A1),
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Install',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
