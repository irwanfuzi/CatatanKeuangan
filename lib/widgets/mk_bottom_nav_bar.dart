import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/app_icons.dart';

/// Solid Docked Bottom Navigation Bar khas MyKas.
/// Menempel rapi di bawah layar dengan Flat Center FAB (+) & Label "Catat".
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
      decoration: BoxDecoration(
        color: navBgColor,
        border: Border(
          top: BorderSide(color: borderColor, width: 1.0),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 66,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              // Row Tab Navigasi Utama
              Row(
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

                  // Space Presisi untuk Center FAB (+) "Catat"
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

              // Tombol Flat Center FAB (+) dengan Label "Catat" (Tanpa Bayangan)
              Positioned(
                top: -16,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: onAddPressed,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppTheme.brandPrimary, Color(0xFF0040C8)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: navBgColor,
                              width: 3.0,
                            ),
                            // BoxShadow Dihapus Total (No Shadow)
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              const Icon(
                                AppIcons.plus,
                                color: Colors.white,
                                size: 24,
                              ),
                              // Kancing Aksen Emas (Logo MyKas)
                              Positioned(
                                right: 10,
                                top: 10,
                                child: Container(
                                  width: 5,
                                  height: 5,
                                  decoration: const BoxDecoration(
                                    color: AppTheme.brandSecondary,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Catat',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.brandPrimary,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
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
          // Indikator Garis Atas & Soft Glow Gradient saat Aktif
          if (isSelected) ...[
            Container(
              width: double.infinity,
              height: 44,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    activeColor.withOpacity(0.12),
                    activeColor.withOpacity(0.0),
                  ],
                ),
              ),
            ),
            Container(
              width: 28,
              height: 3,
              decoration: const BoxDecoration(
                color: activeColor,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(2),
                ),
              ),
            ),
          ],

          // Ikon dan Teks Label
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 2),
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
