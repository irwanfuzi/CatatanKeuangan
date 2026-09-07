import 'package:flutter/material.dart';

void showCtaBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // Biar formnya bisa nyesuain keyboard
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom, // Biar gak ketutup keyboard
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
  final TextEditingController nominalCtrl = TextEditingController();
  final TextEditingController ketCtrl = TextEditingController();

  void submitData() {
    // Nanti logika nembak ke API Google Apps Script ditaruh sini
    print("Submit Data: $jenis, ${nominalCtrl.text}, ${ketCtrl.text}");
    Navigator.pop(context); // Tutup bottom sheet
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Garis Handle di atas
          Center(
            child: Container(
              width: 48,
              height: 5,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          
          const Text("Tambah Transaksi Baru", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
          const Text("Tersimpan otomatis ke Google Sheet", style: TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 20),

          // Jenis Aliran
          DropdownButtonFormField<String>(
            value: jenis,
            decoration: InputDecoration(
              labelText: 'Jenis Aliran',
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            ),
            items: ['Pengeluaran', 'Pemasukan'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: (val) => setState(() => jenis = val!),
          ),
          const SizedBox(height: 16),

          // Nominal
          TextFormField(
            controller: nominalCtrl,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Nominal (Rp)',
              hintText: 'Contoh: 50000',
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 16),

          // Keterangan
          TextFormField(
            controller: ketCtrl,
            decoration: InputDecoration(
              labelText: 'Keterangan Transaksi',
              hintText: 'Contoh: Bensin / Nasi Goreng',
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 16),

          // Tombol Simpan (Mirip bg-gradient Tailwind)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: submitData,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0052FF), // Warna brand biru lu
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text("Simpan Transaksi", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
