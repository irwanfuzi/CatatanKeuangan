import 'package:flutter/material.dart';
import '../services/api_service.dart';

void showCtaBottomSheet(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: isDark ? const Color(0xFF131C33) : Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 24,
          right: 24,
          top: 24,
        ),
        child: const FormTambahTransaksi(),
      );
    },
  );
}

class FormTambahTransaksi extends StatefulWidget {
  const FormTambahTransaksi({super.key});

  @override
  State<FormTambahTransaksi> createState() => _FormTambahTransaksiState();
}

class _FormTambahTransaksiState extends State<FormTambahTransaksi> {
  String jenis = 'Pengeluaran';
  String kategori = '🍔 Makanan';
  String dompet = '💳 Kantong Tunai';
  bool isLoading = false;

  final TextEditingController nominalCtrl = TextEditingController();
  final TextEditingController ketCtrl = TextEditingController();

  @override
  void dispose() {
    nominalCtrl.dispose();
    ketCtrl.dispose();
    super.dispose();
  }

  Future<void> submitData() async {
    if (nominalCtrl.text.trim().isEmpty || ketCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nominal dan keterangan wajib diisi!')),
      );
      return;
    }

    setState(() => isLoading = true);

    bool isSuccess = await ApiService.tambahTransaksi(
      jenis,
      nominalCtrl.text.trim(),
      ketCtrl.text.trim(),
      kategori,
      dompet,
    );

    if (!mounted) return;

    setState(() => isLoading = false);

    if (isSuccess) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Transaksi berhasil disimpan!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('❌ Gagal menyimpan transaksi.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fillColor = isDark ? const Color(0xFF0B132B) : Colors.grey[100];

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag Handle Bar
          Center(
            child: Container(
              width: 48,
              height: 5,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: isDark ? Colors.white24 : Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          
          const Text(
            "Tambah Transaksi",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 20),

          // Row Jenis & Dompet
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: jenis,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: 'Jenis',
                    filled: true,
                    fillColor: fillColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: ['Pengeluaran', 'Pemasukan']
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e, overflow: TextOverflow.ellipsis),
                          ))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => jenis = val);
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: dompet,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: 'Dompet',
                    filled: true,
                    fillColor: fillColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: [
                    '💳 Kantong Tunai',
                    '🏦 Rekening Bank',
                    '📱 Dompet Digital',
                    '💰 Dompet Tabungan'
                  ]
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e, overflow: TextOverflow.ellipsis),
                          ))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => dompet = val);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Dropdown Kategori
          DropdownButtonFormField<String>(
            value: kategori,
            isExpanded: true,
            decoration: InputDecoration(
              labelText: 'Kategori',
              filled: true,
              fillColor: fillColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
            items: [
              '🍔 Makanan',
              '🚗 Transportasi',
              '🏠 Tagihan',
              '🎬 Hiburan',
              '🏥 Kesehatan',
              '💼 Gaji',
              '🚀 Sampingan',
              '📈 Investasi',
              '📦 Lainnya'
            ]
                .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(e, overflow: TextOverflow.ellipsis),
                    ))
                .toList(),
            onChanged: (val) {
              if (val != null) setState(() => kategori = val);
            },
          ),
          const SizedBox(height: 16),

          // Input Nominal
          TextFormField(
            controller: nominalCtrl,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Nominal (Rp)',
              hintText: 'Contoh: 50000',
              filled: true,
              fillColor: fillColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Input Keterangan
          TextFormField(
            controller: ketCtrl,
            decoration: InputDecoration(
              labelText: 'Keterangan',
              hintText: 'Contoh: Bensin / Nasi Goreng',
              filled: true,
              fillColor: fillColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Tombol Simpan
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isLoading ? null : submitData,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0052FF),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      "Simpan Transaksi",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
