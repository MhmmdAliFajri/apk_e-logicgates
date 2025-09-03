import 'package:apk_logic_gate/app/modules/blog/controllers/blog_controller.dart';
import 'package:apk_logic_gate/app/modules/course/controllers/course_controller.dart';
import 'package:apk_logic_gate/app/modules/home/controllers/home_controller.dart';
import 'package:apk_logic_gate/app/modules/profile/controllers/profile_controller.dart';
import 'package:get/get.dart';

import '../controllers/dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<CourseController>(() => CourseController());
    Get.lazyPut<ProfileController>(() => ProfileController());
    Get.lazyPut<BlogController>(() => BlogController());
  }
}
