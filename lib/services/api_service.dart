import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String scriptUrl =
      "https://script.google.com/macros/s/AKfycbwk9WxEshShA_NdpfYl_ol9w520n1m9WtzUJ6Kxrv5u-5WzOvqKTeCyLjdMe3QJrAf4/exec";

  // Ambil Data Ringkasan/Summary (GET)
  static Future<Map<String, dynamic>> getSummary() async {
    try {
      // Mengabaikan custom headers agar diproses sebagai Simple Request oleh browser
      final response = await http.get(Uri.parse(scriptUrl));

      if (response.statusCode == 200 || response.statusCode == 302) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Gagal memuat data dari server (${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Error koneksi: $e');
    }
  }

  // Kirim Data Transaksi Baru (POST)
  static Future<bool> tambahTransaksi(
    String jenis,
    String nominal,
    String keterangan,
    String kategori,
    String dompet,
  ) async {
    try {
      // Pembersihan nominal agar murni berupa angka
      final cleanNominal = nominal.replaceAll(RegExp(r'[^0-9]'), '');

      // Menggunakan Content-Type: text/plain untuk bypass CORS preflight di Flutter Web
      final response = await http.post(
        Uri.parse(scriptUrl),
        headers: {
          "Content-Type": "text/plain",
        },
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

      return response.statusCode == 200 || response.statusCode == 302;
    } catch (e) {
      print("Error simpan data: $e");
      return false;
    }
  }
}
