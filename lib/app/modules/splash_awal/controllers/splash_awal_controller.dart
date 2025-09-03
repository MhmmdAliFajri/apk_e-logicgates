import 'package:apk_logic_gate/app/routes/app_pages.dart';
import 'package:apk_logic_gate/constants.dart';
import 'package:get/get.dart';

class SplashAwalController extends GetxController {
  @override
  // void onReady() {
  //   super.onReady();
  //   _next(); // langsung panggil
  // }
  void onInit() {
    super.onInit();
    print("Inisialisasi Splash");
    _next();
  }

  void _next() async {
    await Future.delayed(const Duration(seconds: 2)); // tampilan logo 2 detik

    final seenIntro = box.read(kIntroDone) ?? false;
    final hasToken = box.read(kAuthToken) != null;
    print("ini seenIntro $seenIntro dan ini hasToken $hasToken");

    if (!seenIntro) {
      Get.offAllNamed(Routes.INTRODUCTION);
    } else if (hasToken) {
      Get.offAllNamed(Routes.DASHBOARD);
    } else {
      Get.offAllNamed(Routes.LOGIN);
    }
  }
}
