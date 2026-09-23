import 'package:flutter/material.dart';
import '../utils/app_icons.dart';

class QuickActionItem {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  bool isEnabled;

  QuickActionItem({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    this.isEnabled = false,
  });

  /// 13 Fitur Lengkap Kustomisasi Quick Actions MyKas (Aman & Bebas Crash)
  static List<QuickActionItem> get defaultList => [
        QuickActionItem(
          id: 'scan_struk',
          title: 'Scan Struk',
          description: 'Pindai struk belanjaan otomatis',
          icon: AppIcons.qrCode,
          isEnabled: true,
        ),
        QuickActionItem(
          id: 'transfer',
          title: 'Transfer',
          description: 'Pindah uang antar rekening/dompet',
          icon: AppIcons.transfer,
          isEnabled: true,
        ),
        QuickActionItem(
          id: 'berulang',
          title: 'Transaksi Berulang',
          description: 'Gaji, kos, langganan, cicilan',
          icon: AppIcons.repeat,
          isEnabled: true,
        ),
        QuickActionItem(
          id: 'tujuan',
          title: 'Tujuan Keuangan',
          description: 'Menabung untuk target tertentu',
          icon: AppIcons.target,
          isEnabled: true,
        ),
        QuickActionItem(
          id: 'budget',
          title: 'Budget',
          description: 'Atur batas pengeluaran bulanan',
          icon: AppIcons.sliders,
          isEnabled: false,
        ),
        QuickActionItem(
          id: 'tagihan',
          title: 'Tagihan',
          description: 'Catat & pantau tagihan rutin',
          icon: AppIcons.receipt,
          isEnabled: false,
        ),
        QuickActionItem(
          id: 'hutang_piutang',
          title: 'Hutang/Piutang',
          description: 'Uang dipinjamkan atau dipinjam',
          icon: AppIcons.wallet,
          isEnabled: false,
        ),
        QuickActionItem(
          id: 'cari_transaksi',
          title: 'Cari Transaksi',
          description: 'Menemukan riwayat transaksi lama',
          icon: AppIcons.search,
          isEnabled: false,
        ),
        QuickActionItem(
          id: 'laporan',
          title: 'Laporan',
          description: 'Melihat kondisi & pola keuangan',
          icon: AppIcons.barChart,
          isEnabled: false,
        ),
        QuickActionItem(
          id: 'import_data',
          title: 'Import Data',
          description: 'Masukkan mutasi bank / CSV',
          icon: AppIcons.receipt, // FIXED: Menggantikan AppIcons.fileText yang tidak ada
          isEnabled: false,
        ),
        QuickActionItem(
          id: 'ai_catat',
          title: 'AI Catat',
          description: 'Catat dengan bahasa natural',
          icon: AppIcons.sparkles,
          isEnabled: false,
        ),
        QuickActionItem(
          id: 'tambah_akun',
          title: 'Tambah Akun',
          description: 'Tambah bank, e-wallet, cash',
          icon: AppIcons.plus,
          isEnabled: false,
        ),
        QuickActionItem(
          id: 'kelola_kategori',
          title: 'Kelola Kategori',
          description: 'Buat & edit kategori transaksi',
          icon: AppIcons.layoutGrid,
          isEnabled: false,
        ),
      ];
}
