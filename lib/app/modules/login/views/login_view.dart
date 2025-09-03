import 'package:apk_logic_gate/app/routes/app_pages.dart';
import 'package:apk_logic_gate/theme.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/icons/logo_apk.png', height: 120),
              SizedBox(height: 20),
              Text("Selamat Datang Kembali", style: primaryBold_18),
              SizedBox(height: 6),
              Text("Masuk untuk melanjutkan", style: primaryBold_18),
              SizedBox(height: 20),
              Container(
                width: Get.width,
                child: Text("Alamat Email", style: primarySemiBold_16),
              ),
              SizedBox(height: 4),
              TextField(
                controller: controller.emailController,
                decoration: inputstyle(),
              ),
              SizedBox(height: 16),
              Container(
                width: Get.width,
                child: Text("Password", style: primarySemiBold_16),
              ),
              SizedBox(height: 4),
              Obx(
                () => TextField(
                  controller: controller.passwordController,
                  obscureText: controller.isPassHidden.value,
                  decoration: inputstyle().copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isPassHidden.value
                            ? Icons
                                .visibility_off // 👁️ tertutup
                            : Icons.visibility, // 👁️ terbuka
                      ),
                      onPressed: controller.togglePass,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                width: Get.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [Text("Lupa Password", style: primarySemiBold_14)],
                ),
              ),
              SizedBox(height: 40),
              Container(
                width: Get.width,
                child: Obx(
                  () =>
                      controller.isLoading.value
                          ? ElevatedButton(
                            onPressed: () {},
                            child: CircularProgressIndicator(),
                            style: buttonPrimary,
                          )
                          : ElevatedButton(
                            onPressed: controller.login,
                            child: Text('Login'),
                            style: buttonPrimary,
                          ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Belum punya akun? ", style: primarySemiBold_14),
                  TextButton(
                    onPressed: () => Get.toNamed(Routes.REGISTER),
                    child: Text('Register'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
