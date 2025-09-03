// lib/app/modules/register/controllers/register_controller.dart

import 'package:apk_logic_gate/service/auth_service.dart';
import 'package:apk_logic_gate/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class RegisterController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isLoading = false.obs;

  final isPassHidden = true.obs;
  final isConfirmPassHidden = true.obs;

  /// helper toggle
  void togglePass() => isPassHidden.toggle();
  void toggleConfirmPass() => isConfirmPassHidden.toggle();

  void register() async {
    isLoading.value = true;

    final result = await AuthService().register(
      nameController.text,
      emailController.text,
      passwordController.text,
      confirmPasswordController.text,
    );

    isLoading.value = false;

    if (result['success']) {
      Get.snackbar(
        'Berhasil',
        'Pendaftaran berhasil, silakan login.',
        colorText: dark4,
        backgroundColor: Colors.green,
      );
      Get.offAllNamed(Routes.LOGIN);
    } else {
      Get.snackbar(
        'Gagal',
        result['message'] ?? 'Terjadi kesalahan',
        colorText: dark4,
        backgroundColor: Colors.red,
      );
    }
  }
}
