import 'package:get/get.dart';

import '../controllers/materi_detail_controller.dart';

class MateriDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MateriDetailController>(
      () => MateriDetailController(),
    );
  }
}
