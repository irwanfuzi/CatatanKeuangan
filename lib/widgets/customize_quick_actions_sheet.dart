import 'package:flutter/material.dart';
import '../models/quick_action_item.dart';
import '../theme/app_theme.dart';
import '../utils/app_icons.dart';

class CustomizeQuickActionsSheet extends StatefulWidget {
  final List<QuickActionItem> currentItems;
  final ValueChanged<List<QuickActionItem>> onSave;

  const CustomizeQuickActionsSheet({
    super.key,
    required this.currentItems,
    required this.onSave,
  });

  static Future<void> show(
    BuildContext context, {
    required List<QuickActionItem> currentItems,
    required ValueChanged<List<QuickActionItem>> onSave,
  }) async {
    final isDesktop = MediaQuery.of(context).size.width >= 1024;

    if (isDesktop) {
      await showDialog(
        context: context,
        builder: (ctx) => Dialog(
          backgroundColor: Colors.transparent,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 540, maxHeight: 640),
            child: CustomizeQuickActionsSheet(
              currentItems: currentItems,
              onSave: onSave,
            ),
          ),
        ),
      );
    } else {
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (ctx) => FractionallySizedBox(
          heightFactor: 0.82,
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
  late List<QuickActionItem> _workingItems;

  @override
  void initState() {
    super.initState();
    _workingItems = widget.currentItems
        .map((item) => QuickActionItem(
              id: item.id,
              title: item.title,
              description: item.description,
              icon: item.icon,
              isEnabled: item.isEnabled,
            ))
        .toList();
  }

  void _toggleItem(int index) {
    setState(() {
      _workingItems[index].isEnabled = !_workingItems[index].isEnabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppTheme.cardDark : Colors.white;
    final textColor = isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight;
    final subTextColor = isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight;
    final borderColor = isDark ? AppTheme.borderDark : AppTheme.borderLight;

    final activeCount = _workingItems.where((e) => e.isEnabled).length;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 38,
            height: 4,
            decoration: BoxDecoration(
              color: borderColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 14),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kustomisasi Quick Actions',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Atur tombol aksi cepat ($activeCount aktif)',
                      style: TextStyle(fontSize: 11, color: subTextColor),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(AppIcons.x, size: 18, color: textColor),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),
          Divider(color: borderColor, height: 1),

          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: _workingItems.length,
              separatorBuilder: (ctx, i) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final item = _workingItems[index];
                return InkWell(
                  onTap: () => _toggleItem(index),
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: item.isEnabled
                          ? AppTheme.brandPrimary.withOpacity(isDark ? 0.15 : 0.06)
                          : (isDark ? AppTheme.bgDark : const Color(0xFFF8FAFC)),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: item.isEnabled ? AppTheme.brandPrimary : borderColor,
                        width: item.isEnabled ? 1.5 : 1.0,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: item.isEnabled
                                ? AppTheme.brandPrimary
                                : (isDark ? AppTheme.cardDark : Colors.white),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            item.icon,
                            size: 18,
                            color: item.isEnabled ? Colors.white : subTextColor,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: item.isEnabled
                                      ? (isDark ? Colors.white : AppTheme.brandPrimary)
                                      : textColor,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                item.description,
                                style: TextStyle(fontSize: 10, color: subTextColor),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Checkbox(
                          value: item.isEnabled,
                          onChanged: (_) => _toggleItem(index),
                          activeColor: AppTheme.brandPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            decoration: BoxDecoration(
              color: bgColor,
              border: Border(top: BorderSide(color: borderColor, width: 1)),
            ),
            child: SafeArea(
              top: false,
              child: SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: () {
                    widget.onSave(_workingItems);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.brandPrimary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Simpan Kustomisasi',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
