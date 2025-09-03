import 'package:apk_logic_gate/app/modules/course/controllers/course_controller.dart';
import 'package:apk_logic_gate/app/modules/home/controllers/home_controller.dart';
import 'package:apk_logic_gate/app/modules/profile/controllers/profile_controller.dart';
import 'package:apk_logic_gate/service/auth_service.dart';
import 'package:apk_logic_gate/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class EditProfileController extends GetxController {
  final _auth = AuthService();

  // TextEditingController untuk form
  final nameC = TextEditingController();
  final emailC = TextEditingController();
  final passC = TextEditingController();
  final confirmPassC = TextEditingController();

  // state loading
  final isSaving = false.obs;

  @override
  void onInit() {
    dynamic arg = Get.arguments;

    Map<String, dynamic>? user;
    if (arg is Map) {
      user = Map<String, dynamic>.from(arg);
    } else if (arg is RxMap) {
      user = Map<String, dynamic>.from(arg);
    }

    if (user != null) {
      nameC.text = user['name'] ?? '';
      emailC.text = user['email'] ?? '';
    }
    super.onInit();
  }

  Future<void> saveProfile() async {
    isSaving.value = true;
    final res = await _auth.updateProfile(name: nameC.text, email: emailC.text);
    isSaving.value = false;

    final homeController = Get.put(HomeController());
    await homeController.loadProfile();
    final profileC = Get.put(ProfileController());
    await profileC.loadProfile();
    final courseC = Get.put(CourseController());
    await courseC.loadProfile();

    Get.snackbar(
      res['success'] ? 'Berhasil' : 'Gagal',
      res['success'] ? 'Profil diperbarui.' : res['message'],
      backgroundColor: res['success'] ? Colors.green : Colors.red,
      colorText: dark4,
    );
  }

  Future<void> changePassword() async {
    if (passC.text != confirmPassC.text) {
      Get.snackbar(
        'Gagal',
        'Konfirmasi password tidak cocok',
        backgroundColor: Colors.red,
        colorText: dark4,
      );
      return;
    }

    isSaving.value = true;
    final res = await _auth.updateProfile(
      password: passC.text,
      confirmPassword: confirmPassC.text,
    );
    isSaving.value = false;

    Get.snackbar(
      res['success'] ? 'Berhasil' : 'Gagal',
      res['success'] ? 'Password diperbarui.' : res['message'],
      backgroundColor: res['success'] ? Colors.green : Colors.red,
      colorText: dark4,
    );

    if (res['success']) {
      passC.clear();
      confirmPassC.clear();
    }
  }
}
