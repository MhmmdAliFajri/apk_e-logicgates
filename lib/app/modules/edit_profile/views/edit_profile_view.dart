import 'package:apk_logic_gate/headder.dart';
import 'package:apk_logic_gate/theme.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/edit_profile_controller.dart';

class EditProfileView extends GetView<EditProfileController> {
  const EditProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    header(),
                    SizedBox(height: 20),
                    Center(
                      child: Text("Informasi Diri", style: primaryBold_18),
                    ),
                    SizedBox(height: 20),
                    // ------------ FORM UPDATE PROFIL ------------
                    Text('Informasi Diri', style: dark1Bold_16),
                    const SizedBox(height: 16),
                    Container(
                      width: Get.width,
                      child: Text("Nama Lengkap", style: primarySemiBold_16),
                    ),
                    SizedBox(height: 4),
                    TextField(
                      controller: controller.nameC,
                      decoration: inputstyle(),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: Get.width,
                      child: Text("Email", style: primarySemiBold_16),
                    ),
                    SizedBox(height: 4),
                    TextField(
                      controller: controller.emailC,
                      decoration: inputstyle(),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: buttonPrimary,
                        onPressed:
                            controller.isSaving.value
                                ? null
                                : controller.saveProfile,
                        child: const Text('Simpan Profil'),
                      ),
                    ),
                    const Divider(height: 40),

                    // ------------ FORM GANTI PASSWORD ------------
                    Text('Ganti Password', style: dark1Bold_16),
                    const SizedBox(height: 16),
                    Container(
                      width: Get.width,
                      child: Text("Password", style: primarySemiBold_16),
                    ),
                    SizedBox(height: 4),
                    TextField(
                      controller: controller.passC,
                      obscureText: true,
                      decoration: inputstyle(),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: Get.width,
                      child: Text(
                        "Konfirmasi Password",
                        style: primarySemiBold_16,
                      ),
                    ),
                    SizedBox(height: 4),
                    TextField(
                      controller: controller.confirmPassC,
                      obscureText: true,
                      decoration: inputstyle(),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: buttonPrimary,
                        onPressed:
                            controller.isSaving.value
                                ? null
                                : controller.changePassword,
                        child: const Text('Simpan Password'),
                      ),
                    ),
                  ],
                ),
              ),

              // Overlay loading
              if (controller.isSaving.value)
                Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
