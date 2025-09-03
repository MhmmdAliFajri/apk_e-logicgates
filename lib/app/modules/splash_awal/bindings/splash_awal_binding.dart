import 'package:get/get.dart';

import '../controllers/splash_awal_controller.dart';

class SplashAwalBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SplashAwalController>(SplashAwalController());
  }
}
