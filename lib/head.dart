import 'package:flutter/material.dart';
// Pastikan file 'berdon.dart' berisi class Beranda yang benar
import 'berdon.dart';

void main() {
  runApp(const MyApp());
}

// ================= WIDGET UTAMA (Akar Aplikasi) ===================
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aplikasi Donasi Darah',
      theme: ThemeData(
        // Menggunakan warna merah (darah) yang cocok untuk tema
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red.shade700),
        useMaterial3: true,
      ),
      // Aplikasi dimulai dari TampilanUI (Splash Screen)
      home: const TampilanUI(),
    );
  }
}

// ------------------------------------------------------------------

// ================= Tampilan Awal (Logo + Tombol) ===================
class TampilanUI extends StatelessWidget {
  const TampilanUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Background default putih dari Scaffold sudah cukup
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment
              .center, // Tambahkan ini agar logo/tombol tidak melebar
          children: [
            // Logo Gambar
            // PASTIKAN JALUR INI BENAR! ('assets/logo_darah (2).jpg')
            Image.asset(
              'assets/logo_darah (2).jpg',
              width: 200,
              // Tambahkan fit: BoxFit.contain jika Anda khawatir dengan distorsi
              // fit: BoxFit.contain,
            ),
            const SizedBox(height: 30),

            // Tombol Navigasi
            ElevatedButton(
              onPressed: () {
                // Arahkan ke halaman Beranda
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    // Pastikan Beranda() diimpor dengan benar dari 'berdon.dart'
                    builder: (context) => const Beranda(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors
                    .red
                    .shade600, // Sedikit diubah agar terlihat lebih kontras
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 16,
                ),
                elevation: 5,
              ),
              child: const Text(
                "Masuk ke Aplikasi",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
