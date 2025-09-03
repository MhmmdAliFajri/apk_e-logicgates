import 'package:apk_logic_gate/headder.dart';
import 'package:apk_logic_gate/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PengaturanView extends StatelessWidget {
  const PengaturanView({super.key});

  @override
  Widget build(BuildContext context) {
    // dummy value (belum pakai controller)
    String selectedLanguage = 'id';
    String selectedTheme = 'light';

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ─────────────────── header
            Padding(padding: const EdgeInsets.all(20.0), child: header()),

            // ─────────────────── judul
            Center(child: Text("Pengaturan", style: primaryBold_18)),
            const SizedBox(height: 20),

            // ─────────────────── konten
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  Text("Bahasa", style: dark1Bold_16),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: selectedLanguage,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'id',
                        child: Text("Bahasa Indonesia"),
                      ),
                      DropdownMenuItem(value: 'en', child: Text("English")),
                    ],
                    onChanged: (val) {},
                  ),

                  const SizedBox(height: 20),
                  Text("Tema Aplikasi", style: dark1Bold_16),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: selectedTheme,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'light', child: Text("Terang")),
                      DropdownMenuItem(value: 'dark', child: Text("Gelap")),
                    ],
                    onChanged: (val) {},
                  ),
                ],
              ),
            ),

            // ─────────────────── tombol simpan
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {}, // belum berfungsi
                  child: const Text("Simpan"),
                  style: buttonPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
