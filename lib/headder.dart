import 'package:apk_logic_gate/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:apk_logic_gate/app/routes/app_pages.dart';
import 'package:apk_logic_gate/config.dart';
import 'package:apk_logic_gate/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class header extends StatelessWidget {
  const header({super.key});
  @override
  Widget build(BuildContext context) {
    final dashboardC = Get.find<DashboardController>();
    final photoPath = GetStorage().read('photo');
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(Icons.dashboard, size: 32, color: primary),
        GestureDetector(
          onTap: () => dashboardC.changeTab(3),
          child: CircleAvatar(
            radius: 15,
            backgroundImage:
                photoPath != null
                    ? NetworkImage("$baseUrlStorage/${photoPath!}")
                    : const AssetImage('assets/icons/akun_tanpa_image.png')
                        as ImageProvider,
          ),
        ),
      ],
    );
  }
}
