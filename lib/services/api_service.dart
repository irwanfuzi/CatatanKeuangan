import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // TODO: Ganti URL ini dengan URL Web App dari Google Apps Script Anda (Deployment terbaru)
  static const String scriptUrl = "https://script.google.com/macros/s/AKfycb.../exec";

  // Fungsi untuk MENGAMBIL data (Contoh: Total Kekayaan)
  static Future<Map<String, dynamic>> getRingkasan() async {
    try {
      final response = await http.get(Uri.parse('$scriptUrl?action=getRingkasan'));

      if (response.statusCode == 200) {
        // Asumsi output dari Apps Script adalah JSON
        return json.decode(response.body);
      } else {
        throw Exception('Gagal memuat data');
      }
    } catch (e) {
      throw Exception('Error koneksi: $e');
    }
  }

  // Fungsi untuk MENGIRIM data (Contoh: Tambah Transaksi Baru)
  static Future<bool> tambahTransaksi(String jenis, String nominal, String kategori, String dompet) async {
    try {
      final response = await http.post(
        Uri.parse(scriptUrl),
        body: {
          "action": "tambahTransaksi",
          "jenis": jenis,       // "Pemasukan" atau "Pengeluaran"
          "nominal": nominal,
          "kategori": kategori,
          "dompet": dompet,
        },
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        return result['status'] == 'success';
      }
      return false;
    } catch (e) {
      print("Error simpan data: $e");
      return false;
    }
  }
}
