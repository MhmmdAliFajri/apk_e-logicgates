import 'package:apk_logic_gate/headder.dart';
import 'package:apk_logic_gate/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TentangKamiView extends StatelessWidget {
  const TentangKamiView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            header(),
            SizedBox(height: 20),
            Center(child: Text("Tentang Kami", style: primaryBold_18)),
            SizedBox(height: 20),
            Text("Pengembang", style: dark1Bold_16),
            SizedBox(height: 10),
            _avatarTile(
              "assets/images/ali.jpg",
              "Muhammad Ali Fajri",
              "1501621008",
            ),
            SizedBox(height: 20),
            Text("Dosen Pembimbing", style: dark1Bold_16),
            SizedBox(height: 10),
            _avatarTile(
              'assets/images/aris.jpg',
              "Dr. Aris Sunawar., M.T.",
              "198206282009121003",
            ),
            _avatarTile(
              'assets/images/djaohar.jpg',
              "Mochammad Djaohar, M.Sc",
              "197003032006041001",
            ),
            SizedBox(height: 10),
            _avatarTile(
              'assets/images/hanifah.jpg',
              "Nur Hanifah Yuninda., S.T., M.T.",
              "198206112008122001",
            ),
          ],
        ),
      ),
    );
  }
}

Widget _avatarTile(String assetPath, String name, String nip) {
  return ListTile(
    leading: CircleAvatar(
      radius: 24,
      child: const Icon(Icons.person, color: Colors.white),
      backgroundImage: AssetImage(assetPath),
      onBackgroundImageError: (_, __) {},
      backgroundColor: Colors.grey.shade400,
    ),
    title: Text(name),
    subtitle: Text(nip),
  );
}
