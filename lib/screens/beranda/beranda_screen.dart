import 'package:flutter/material.dart';

class BerandaScreen extends StatelessWidget {
  final Map<String, dynamic>? summaryData;
  final VoidCallback? onNavigateToAnalisis;

  const BerandaScreen({
    super.key,
    this.summaryData,
    this.onNavigateToAnalisis,
  });

  static const Color primaryRoyalBlue = Color(0xFF0052FF);
  static const Color accentHoneyGold = Color(0xFFFF9F00);
  static const Color emeraldGreen = Color(0xFF10B981);
  static const Color crimsonRed = Color(0xFFEF4444);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final backgroundColor = isDark ? const Color(0xFF060A12) : const Color(0xFFF1F4F9);
    final surfaceColor = isDark ? const Color(0xFF0F172A) : Colors.white;
    final borderColor = isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final subTextColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    final saldo = summaryData?['saldo'] ?? 'Rp 11.250.000';
    final pemasukan = summaryData?['pemasukan'] ?? 'Rp 5.250.000';
    final pengeluaran = summaryData?['pengeluaran'] ?? 'Rp 2.804.178';
    final List riwayat = summaryData?['riwayat'] as List? ?? [];

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 1024;

            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: isDesktop ? 1080 : 540),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? 32.0 : 16.0,
                    vertical: 16.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. HEADER USER
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: primaryRoyalBlue.withOpacity(0.15),
                                child: const Icon(Icons.person_rounded, color: primaryRoyalBlue, size: 22),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Selamat Datang,', style: TextStyle(fontSize: 11, color: subTextColor, fontWeight: FontWeight.w600)),
                                  Text('Pengguna MyKas', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: textColor)),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(color: surfaceColor, shape: BoxShape.circle, border: Border.all(color: borderColor)),
                            child: const Icon(Icons.notifications_outlined, size: 18, color: primaryRoyalBlue),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // 2. HERO CARD SALDO UTAMA
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF0052FF), Color(0xFF1E40AF)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(color: primaryRoyalBlue.withOpacity(0.3), blurRadius: 16, offset: const Offset(0, 6)),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('TOTAL SALDO UTAMA', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white70, letterSpacing: 1.2)),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(6)),
                                  child: const Text('Aktif', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              saldo,
                              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.white, fontFamily: 'monospace', letterSpacing: -0.8),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(color: emeraldGreen.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                                        child: const Icon(Icons.arrow_downward_rounded, color: emeraldGreen, size: 14),
                                      ),
                                      const SizedBox(width: 8),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text('Masuk', style: TextStyle(fontSize: 9, color: Colors.white70, fontWeight: FontWeight.bold)),
                                          Text(pemasukan, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'monospace')),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Container(width: 1, height: 28, color: Colors.white24),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(color: crimsonRed.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                                        child: const Icon(Icons.arrow_upward_rounded, color: crimsonRed, size: 14),
                                      ),
                                      const SizedBox(width: 8),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text('Keluar', style: TextStyle(fontSize: 9, color: Colors.white70, fontWeight: FontWeight.bold)),
                                          Text(pengeluaran, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'monospace')),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // 3. SHORTCUT MENU TO ANALISIS
                      InkWell(
                        onTap: onNavigateToAnalisis,
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: surfaceColor,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: borderColor),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(color: primaryRoyalBlue.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                                child: const Icon(Icons.analytics_rounded, color: primaryRoyalBlue, size: 20),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Lihat Analisis Keuangan', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: textColor)),
                                    const SizedBox(height: 2),
                                    Text('Cek distribusi pengeluaran & tren bulanan', style: TextStyle(fontSize: 11, color: subTextColor)),
                                  ],
                                ),
                              ),
                              const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: primaryRoyalBlue),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // 4. RIWAYAT TRANSAKSI TERAKHIR
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Riwayat Transaksi', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: textColor)),
                          Text('Lihat Semua', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: primaryRoyalBlue)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (riwayat.isEmpty)
                        Center(child: Padding(padding: const EdgeInsets.all(24.0), child: Text('Belum ada transaksi', style: TextStyle(color: subTextColor))))
                      else
                        Column(
                          children: riwayat.map((item) {
                            final isPemasukan = item['jenis'].toString().toLowerCase().contains('pemasukan');
                            return Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: surfaceColor,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: borderColor),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: (isPemasukan ? emeraldGreen : crimsonRed).withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      isPemasukan ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
                                      color: isPemasukan ? emeraldGreen : crimsonRed,
                                      size: 16,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(item['judul'] ?? item['kategori'] ?? 'Transaksi', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: textColor)),
                                        const SizedBox(height: 2),
                                        Text(item['tanggal'] ?? 'Hari ini', style: TextStyle(fontSize: 10, color: subTextColor)),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    item['nominal'].toString(),
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w900,
                                      color: isPemasukan ? emeraldGreen : crimsonRed,
                                      fontFamily: 'monospace',
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      const SizedBox(height: 36),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
