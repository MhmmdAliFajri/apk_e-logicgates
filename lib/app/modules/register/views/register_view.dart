import 'package:apk_logic_gate/app/routes/app_pages.dart';
import 'package:apk_logic_gate/theme.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Image.asset('assets/icons/logo_apk.png', height: 120),
              SizedBox(height: 20),
              Text("Silahkan Melakukan Pendaftaran", style: primaryBold_18),
              SizedBox(height: 20),
              Container(
                width: Get.width,
                child: Text("Nama", style: primarySemiBold_16),
              ),
              SizedBox(height: 4),
              TextField(
                controller: controller.nameController,
                decoration: inputstyle(),
              ),
              SizedBox(height: 16),
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
              SizedBox(height: 16),
              Container(
                width: Get.width,
                child: Text("Konfirmasi Password", style: primarySemiBold_16),
              ),
              SizedBox(height: 4),
              Obx(
                () => TextField(
                  controller: controller.confirmPasswordController,
                  obscureText: controller.isConfirmPassHidden.value,
                  decoration: inputstyle().copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isConfirmPassHidden.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: controller.toggleConfirmPass,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
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
                            onPressed: controller.register,
                            child: Text('Register'),
                            style: buttonPrimary,
                          ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Sudah punya akun? ", style: primarySemiBold_14),
                  TextButton(
                    onPressed: () => Get.toNamed(Routes.LOGIN),
                    child: Text('Login'),
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
