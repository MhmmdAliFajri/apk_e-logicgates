import 'package:apk_logic_gate/app/routes/app_pages.dart';
import 'package:apk_logic_gate/config.dart';
import 'package:apk_logic_gate/service/auth_service.dart';
import 'package:apk_logic_gate/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              controller.loadProfile();
            },
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // Foto profil + icon camera
                        SizedBox(height: 70),
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundImage:
                                  controller.user['photo'] != null
                                      ? NetworkImage(
                                        "${baseUrlStorage}/${controller.user['photo']}",
                                      )
                                      : const AssetImage(
                                            "assets/icons/akun_tanpa_image.png",
                                          )
                                          as ImageProvider,
                            ),

                            GestureDetector(
                              onTap:
                                  controller
                                      .pickAndUploadPhoto, // ⬅️ panggil fungsi
                              child: const CircleAvatar(
                                radius: 16,
                                backgroundColor: Colors.blue,
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Halo, ${controller.user['name']}!',
                          style: dark1Bold_18,
                        ),
                        const SizedBox(height: 24),

                        // Daftar menu
                        Expanded(
                          child: ListView(
                            children: [
                              ProfileMenuItem(
                                icon: Icons.person_outline,
                                title: 'Informasi Diri',
                                onTap:
                                    () => Get.toNamed(
                                      Routes.EDIT_PROFILE,
                                      // ignore: invalid_use_of_protected_member
                                      arguments: controller.user.value,
                                    ),
                              ),

                              ProfileMenuItem(
                                icon: Icons.settings_outlined,
                                title: 'Pengaturan',
                                onTap: () => Get.toNamed(Routes.PENGATURAN),
                              ),
                              ProfileMenuItem(
                                icon: Icons.help_outline,
                                title: 'Bantuan & Dukungan',
                                onTap:
                                    () => Get.toNamed(Routes.BANTUAN_DUKUNGAN),
                              ),
                              ProfileMenuItem(
                                icon: Icons.info_outline,
                                title: 'Tentang Kami',
                                onTap: () => Get.toNamed(Routes.TENTANG_KAMI),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: Get.width,
                  padding: EdgeInsets.all(20),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Get.defaultDialog(
                        title: 'Konfirmasi Logout',
                        middleText: 'Apakah kamu yakin ingin logout?',
                        textCancel: 'Batal',
                        textConfirm: 'Logout',
                        confirmTextColor: Colors.white,
                        onConfirm: () async {
                          await AuthService().logout();
                          Get.offAllNamed(
                            Routes.LOGIN,
                          ); // sesuaikan dengan route login kamu
                        },
                      );
                    },
                    icon: Icon(Icons.logout, color: dark1),
                    label: Text(
                      'Logout',
                      style: dark4Regular_12.copyWith(color: danger),
                    ),
                    style: buttonDanger,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
