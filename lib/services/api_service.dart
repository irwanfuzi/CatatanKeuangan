import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String scriptUrl = "https://script.google.com/macros/s/AKfycbwk9WxEshShA_NdpfYl_ol9w520n1m9WtzUJ6Kxrv5u-5WzOvqKTeCyLjdMe3QJrAf4/exec";

  // Fungsi untuk Mengambil Data Summary (GET)
  static Future<Map<String, dynamic>> getSummary() async {
    try {
      final response = await http.get(Uri.parse(scriptUrl));
      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Gagal memuat data dari server (${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Error koneksi: $e');
    }
  }

  // Fungsi untuk Mengirim Data Transaksi Baru (POST)
  static Future<bool> tambahTransaksi(
    String jenis, 
    String nominal, 
    String keterangan, 
    String kategori, 
    String dompet
  ) async {
    try {
      // Pastikan nominal dikirim dalam bentuk angka murni tanpa titik/koma
      final cleanNominal = nominal.replaceAll(RegExp(r'[^0-9]'), '');

      final response = await http.post(
        Uri.parse(scriptUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "action": "tambahTransaksi",
          "tanggal": DateTime.now().toIso8601String(),
          "jenis": jenis,
          "nominal": cleanNominal,
          "keterangan": keterangan,
          "kategori": kategori,
          "dompet": dompet,
        }),
      );

      // Google Apps Script sering mengembalikan status 200 atau 302 saat redirect sukses
      if (response.statusCode == 200 || response.statusCode == 302) {
        return true;
      }
      return false;
    } catch (e) {
      print("Error simpan data: $e");
      return false;
    }
  }
}
