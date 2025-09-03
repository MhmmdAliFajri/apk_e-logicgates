import 'package:get/get.dart';

import '../controllers/jobsheet_detail_controller.dart';

class JobsheetDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JobsheetDetailController>(
      () => JobsheetDetailController(),
    );
  }
}
