import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/app_icons.dart';

/// Modern Floating Bottom Navigation Bar MyKas.
/// Disesuaikan dengan Identitas Warna Logo Resmi (Electric Blue & Amber Gold).
class MKBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final VoidCallback onAddPressed;

  const MKBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final navBgColor = isDark ? AppTheme.cardDark : Colors.white;
    final borderColor = isDark ? AppTheme.borderDark : AppTheme.borderLight;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      color: Colors.transparent,
      child: SafeArea(
        top: false,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            // 1. Container Utama Navigasi Melayang
            Container(
              height: 68,
              decoration: BoxDecoration(
                color: navBgColor,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: borderColor, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.35 : 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Tab 1: Beranda
                  Expanded(
                    child: _NavBarItem(
                      icon: AppIcons.layoutGrid,
                      label: 'Beranda',
                      isSelected: currentIndex == 0,
                      onTap: () => onTap(0),
                    ),
                  ),
                  // Tab 2: Analisis
                  Expanded(
                    child: _NavBarItem(
                      icon: AppIcons.barChart,
                      label: 'Analisis',
                      isSelected: currentIndex == 1,
                      onTap: () => onTap(1),
                    ),
                  ),

                  // Space Presisi untuk Center FAB (+)
                  const SizedBox(width: 60),

                  // Tab 3: Riwayat
                  Expanded(
                    child: _NavBarItem(
                      icon: AppIcons.history,
                      label: 'Riwayat',
                      isSelected: currentIndex == 2,
                      onTap: () => onTap(2),
                    ),
                  ),
                  // Tab 4: Profil
                  Expanded(
                    child: _NavBarItem(
                      icon: AppIcons.user,
                      label: 'Profil',
                      isSelected: currentIndex == 3,
                      onTap: () => onTap(3),
                    ),
                  ),
                ],
              ),
            ),

            // 2. Floating Action Button (+) dengan Sentuhan Amber Gold Logo MyKas
            Positioned(
              top: -14,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: onAddPressed,
                  child: Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppTheme.brandPrimary, Color(0xFF0040C8)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark ? AppTheme.bgDark : Colors.white,
                        width: 3.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.brandPrimary.withOpacity(0.40),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        const Icon(
                          AppIcons.plus,
                          color: Colors.white,
                          size: 26,
                        ),
                        // Small Amber Gold Accent Dot (Merepresentasikan Kancing Dompet Logo MyKas)
                        Positioned(
                          right: 12,
                          top: 12,
                          child: Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: AppTheme.brandSecondary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    const activeColor = AppTheme.brandPrimary;
    final inactiveColor = isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight;

    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          // Indikator Garis Biru Atas & Gradient Glow
          if (isSelected) ...[
            Container(
              width: double.infinity,
              height: 48,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    activeColor.withOpacity(0.14),
                    activeColor.withOpacity(0.0),
                  ],
                ),
              ),
            ),
            Container(
              width: 32,
              height: 3,
              decoration: const BoxDecoration(
                color: activeColor,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(2),
                ),
              ),
            ),
          ],

          // Content Icon & Label
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 4),
                Icon(
                  icon,
                  color: isSelected ? activeColor : inactiveColor,
                  size: 20,
                ),
                const SizedBox(height: 3),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                    color: isSelected ? activeColor : inactiveColor,
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
