import 'package:flutter/material.dart';
import '../services/api_service.dart';

void showCtaBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 24, right: 24, top: 24,
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

  Future<void> submitData() async {
    if (nominalCtrl.text.isEmpty || ketCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nominal dan keterangan wajib diisi!')));
      return;
    }

    setState(() => isLoading = true);

    bool isSuccess = await ApiService.tambahTransaksi(
      jenis, 
      nominalCtrl.text, 
      ketCtrl.text, 
      kategori, 
      dompet
    );

    setState(() => isLoading = false);

    if (isSuccess && mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Transaksi berhasil disimpan!'), backgroundColor: Colors.green),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ Gagal menyimpan transaksi.'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 48, height: 5, margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
            ),
          ),
          const Text("Tambah Transaksi", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: jenis,
                  decoration: InputDecoration(
                    labelText: 'Jenis', filled: true, fillColor: Colors.grey[100],
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  ),
                  items: ['Pengeluaran', 'Pemasukan'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (val) => setState(() => jenis = val!),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: dompet,
                  decoration: InputDecoration(
                    labelText: 'Dompet', filled: true, fillColor: Colors.grey[100],
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  ),
                  items: ['💳 Kantong Tunai', '🏦 Rekening Bank', '📱 Dompet Digital', '💰 Dompet Tabungan'].map((e) => DropdownMenuItem(value: e, child: Text(e, overflow: TextOverflow.ellipsis))).toList(),
                  onChanged: (val) => setState(() => dompet = val!),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          DropdownButtonFormField<String>(
            value: kategori,
            decoration: InputDecoration(
              labelText: 'Kategori', filled: true, fillColor: Colors.grey[100],
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            ),
            items: [
              '🍔 Makanan', '🚗 Transportasi', '🏠 Tagihan', '🎬 Hiburan', '🏥 Kesehatan', '💼 Gaji', '🚀 Sampingan', '📈 Investasi', '📦 Lainnya'
            ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: (val) => setState(() => kategori = val!),
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: nominalCtrl,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Nominal (Rp)', hintText: 'Contoh: 50000',
              filled: true, fillColor: Colors.grey[100],
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: ketCtrl,
            decoration: InputDecoration(
              labelText: 'Keterangan', hintText: 'Contoh: Bensin / Nasi Goreng',
              filled: true, fillColor: Colors.grey[100],
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isLoading ? null : submitData,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0052FF),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: isLoading 
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Text("Simpan Transaksi", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
