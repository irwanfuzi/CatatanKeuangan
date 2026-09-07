class TransaksiModel {
  final String id; // Nanti digenerate atau dari GAS
  final String tanggal;
  final String jenis; // "Pemasukan" / "Pengeluaran"
  final double nominal;
  final String keterangan;
  final String kategori;
  final String dompet;

  TransaksiModel({
    required this.id,
    required this.tanggal,
    required this.jenis,
    required this.nominal,
    required this.keterangan,
    required this.kategori,
    required this.dompet,
  });

  // Fungsi untuk nerima JSON dari Google Apps Script
  factory TransaksiModel.fromJson(Map<String, dynamic> json) {
    return TransaksiModel(
      id: json['id'] ?? '',
      tanggal: json['tanggal'] ?? '',
      jenis: json['jenis'] ?? '',
      nominal: double.parse(json['nominal'].toString()),
      keterangan: json['keterangan'] ?? '',
      kategori: json['kategori'] ?? '',
      dompet: json['dompet'] ?? '',
    );
  }

  // Fungsi untuk ngirim JSON ke Google Apps Script
  Map<String, dynamic> toJson() {
    return {
      'tanggal': tanggal,
      'jenis': jenis,
      'nominal': nominal,
      'keterangan': keterangan,
      'kategori': kategori,
      'dompet': dompet,
    };
  }
}
