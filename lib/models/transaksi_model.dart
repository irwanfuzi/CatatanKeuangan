class TransaksiModel {
  final String id;
  final String tanggal;
  final String jenis;
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

  factory TransaksiModel.fromJson(Map<String, dynamic> json) {
    return TransaksiModel(
      id: json['id']?.toString() ?? '',
      tanggal: json['tanggal']?.toString() ?? '',
      jenis: json['jenis']?.toString() ?? '',
      nominal: double.tryParse(json['nominal']?.toString() ?? '0') ?? 0.0,
      keterangan: json['keterangan']?.toString() ?? '',
      kategori: json['kategori']?.toString() ?? '',
      dompet: json['dompet']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tanggal': tanggal,
      'jenis': jenis,
      'nominal': nominal,
      'keterangan': keterangan,
      'kategori': kategori,
      'dompet': dompet,
    };
  }
}
