import 'package:apk_logic_gate/app/modules/home/controllers/home_controller.dart';
import 'package:apk_logic_gate/app/modules/profile/controllers/profile_controller.dart';
import 'package:apk_logic_gate/app/routes/app_pages.dart';
import 'package:apk_logic_gate/constants.dart';
import 'package:apk_logic_gate/service/auth_service.dart';
import 'package:apk_logic_gate/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final isLoading = false.obs;

  final isPassHidden = true.obs;

  /// helper toggle
  void togglePass() => isPassHidden.toggle();

  void login() async {
    isLoading.value = true;
    final result = await AuthService().login(
      emailController.text,
      passwordController.text,
    );
    isLoading.value = false;

    if (result['success']) {
      final homeController = Get.put(HomeController());
      await homeController.loadProfile();
      final profileC = Get.put(ProfileController());
      await profileC.loadProfile();
      Get.snackbar(
        'Berhasil',
        "Selamat Datang",
        backgroundColor: Colors.green,
        colorText: dark4,
      );
      Get.offAllNamed(Routes.DASHBOARD);

      Get.offAllNamed(Routes.DASHBOARD);
    } else {
      Get.snackbar(
        'Error',
        "Username atau password salah",
        backgroundColor: Colors.red,
        colorText: dark4,
      );
    }
  }
}
