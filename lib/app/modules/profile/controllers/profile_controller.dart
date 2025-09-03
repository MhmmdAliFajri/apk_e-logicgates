import 'dart:io';

import 'package:apk_logic_gate/service/auth_service.dart';
import 'package:apk_logic_gate/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  final user = {}.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile() async {
    isLoading.value = true;
    final profile = await AuthService().profile();
    user.value = profile!;
    print("User $user");
    isLoading.value = false;
  }

  Future<void> pickAndUploadPhoto() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
    ); // atau .camera
    if (picked == null) return;

    isLoading.value = true;
    final res = await AuthService().uploadPhoto(File(picked.path));
    isLoading.value = false;

    if (res['success']) {
      user.value = res['user']; // refresh foto
      Get.snackbar(
        'Berhasil',
        'Foto profil diperbarui',
        backgroundColor: Colors.green,
        colorText: dark4,
      );
    } else {
      Get.snackbar(
        'Gagal',
        res['message'],
        backgroundColor: Colors.red,
        colorText: dark4,
      );
    }
  }
}
