import 'package:flutter/material.dart';
import '../models/quick_action_item.dart';
import '../theme/app_theme.dart';
import '../utils/app_icons.dart';

class CustomizeQuickActionsSheet extends StatefulWidget {
  final List<QuickActionItem> currentItems;
  final Function(List<QuickActionItem>) onSave;

  const CustomizeQuickActionsSheet({
    super.key,
    required this.currentItems,
    required this.onSave,
  });

  static void show(
    BuildContext context, {
    required List<QuickActionItem> currentItems,
    required Function(List<QuickActionItem>) onSave,
  }) {
    final isDesktop = MediaQuery.of(context).size.width >= 1024;

    if (isDesktop) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => Dialog(
          backgroundColor: Colors.transparent,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: CustomizeQuickActionsSheet(
              currentItems: currentItems,
              onSave: onSave,
            ),
          ),
        ),
      );
    } else {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => FractionallySizedBox(
          heightFactor: 0.85,
          child: CustomizeQuickActionsSheet(
            currentItems: currentItems,
            onSave: onSave,
          ),
        ),
      );
    }
  }

  @override
  State<CustomizeQuickActionsSheet> createState() =>
      _CustomizeQuickActionsSheetState();
}

class _CustomizeQuickActionsSheetState
    extends State<CustomizeQuickActionsSheet> {
  late List<QuickActionItem> _tempItems;

  @override
  void initState() {
    super.initState();
    // Copy item list agar tidak mutasi state utama sebelum tombol Simpan diklik
    _tempItems = widget.currentItems
        .map((e) => QuickActionItem(
              id: e.id,
              title: e.title,
              description: e.description,
              icon: e.icon,
              isEnabled: e.isEnabled,
            ))
        .toList();
  }

  void _toggleItem(int index) {
    setState(() {
      _tempItems[index].isEnabled = !_tempItems[index].isEnabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppTheme.cardDark : AppTheme.cardLight;
    final textColor =
        isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight;
    final textMuted =
        isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight;
    final borderColor = isDark ? AppTheme.borderDark : AppTheme.borderLight;
    final tileBg = isDark ? const Color(0xFF1E222D) : const Color(0xFFF8FAFC);

    final activeCount = _tempItems.where((element) => element.isEnabled).length;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Atur Quick Actions',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: textColor,
                      fontFamily: 'sans-serif',
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Pilih fitur yang ingin ditampilkan di Beranda ($activeCount terpilih)',
                    style: TextStyle(
                      fontSize: 11,
                      color: textMuted,
                      fontFamily: 'sans-serif',
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(AppIcons.x, color: textColor, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              itemCount: _tempItems.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final item = _tempItems[index];

                return Container(
                  decoration: BoxDecoration(
                    color: tileBg,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: item.isEnabled
                          ? AppTheme.brandPrimary.withOpacity(0.4)
                          : borderColor,
                    ),
                  ),
                  child: SwitchListTile(
                    value: item.isEnabled,
                    activeColor: AppTheme.brandPrimary,
                    onChanged: (val) => _toggleItem(index),
                    secondary: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: item.isEnabled
                            ? AppTheme.brandPrimary.withOpacity(0.12)
                            : borderColor.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        item.icon,
                        color: item.isEnabled
                            ? AppTheme.brandPrimary
                            : textMuted,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                        fontFamily: 'sans-serif',
                      ),
                    ),
                    subtitle: Text(
                      item.description,
                      style: TextStyle(
                        fontSize: 10,
                        color: textMuted,
                        fontFamily: 'sans-serif',
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                widget.onSave(_tempItems);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('✅ Quick Actions berhasil diperbarui!'),
                    backgroundColor: Color(0xFF10B981),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.brandPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Simpan Perubahan',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'sans-serif',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
