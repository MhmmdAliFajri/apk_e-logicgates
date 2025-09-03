import 'package:apk_logic_gate/app/modules/home/controllers/home_controller.dart';
import 'package:apk_logic_gate/app/routes/app_pages.dart';
import 'package:apk_logic_gate/service/auth_service.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  final isLoading = true.obs;

  var currentIndex = 0.obs;

  @override
  void onInit() async {
    super.onInit();
    await Get.find<HomeController>().loadProfile();
    await Get.find<HomeController>().fetchJobsheets();
  }

  void changeTab(int index) {
    currentIndex.value = index;
  }

  void logout() async {
    await AuthService().logout();
    Get.offAllNamed(Routes.LOGIN);
  }
}
