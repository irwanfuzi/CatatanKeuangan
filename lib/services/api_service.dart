class ApiService {
  static Future<Map<String, dynamic>> getSummary() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return {
      'saldo': 'Rp 11.250.000',
      'pemasukan': 'Rp 5.250.000',
      'pengeluaran': 'Rp 2.804.178',
      'riwayat': [
        {
          'judul': 'Gudeg Bu Dani Solo',
          'kategori': 'Kuliner & Makanan',
          'tanggal': 'Hari Ini, 12:45',
          'nominal': '45000',
          'jenis': 'pengeluaran',
        },
        {
          'judul': 'Gaji Bulanan Utama',
          'kategori': 'Payroll Inflow',
          'tanggal': '25 Agu 2026',
          'nominal': '8500000',
          'jenis': 'pemasukan',
        },
        {
          'judul': 'GoFood Indonesia',
          'kategori': 'Layanan Antar',
          'tanggal': '24 Agu 2026',
          'nominal': '68000',
          'jenis': 'pengeluaran',
        },
      ]
    };
  }
}
