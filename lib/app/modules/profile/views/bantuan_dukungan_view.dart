import 'package:apk_logic_gate/headder.dart';
import 'package:apk_logic_gate/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class BantuanDukunganView extends StatelessWidget {
  const BantuanDukunganView({super.key});

  Future<void> _hubungiWA() async {
    final uri = Uri.parse('https://wa.me/62881024094126');
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok) {
      Get.snackbar('Gagal', 'Tidak dapat membuka WhatsApp');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const header(),
            const SizedBox(height: 20),
            Center(child: Text("Bantuan & Dukungan", style: primaryBold_18)),
            const SizedBox(height: 20),

            Text("Pertanyaan Umum", style: dark1Bold_16),
            const SizedBox(height: 10),

            const ExpansionTile(
              title: Text("Bagaimana cara menggunakan aplikasi ini?"),
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    "Untuk menggunakan aplikasi, silakan login terlebih dahulu. Kemudian pilih materi atau jobsheet yang tersedia pada menu utama.",
                  ),
                ),
              ],
            ),
            const ExpansionTile(
              title: Text("Apakah aplikasi ini gratis?"),
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    "Ya, aplikasi ini dapat digunakan secara gratis oleh siswa dan guru.",
                  ),
                ),
              ],
            ),
            const ExpansionTile(
              title: Text("Bagaimana jika saya lupa password?"),
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    "Silakan hubungi admin untuk melakukan reset password.",
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            Text("Kontak Dukungan", style: dark1Bold_16),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.phone, color: Colors.green),
              title: const Text("Sukron"),
              subtitle: const Text("+62 881-0240-94126"),
              onTap: _hubungiWA,
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            ),
          ],
        ),
      ),
    );
  }
}
