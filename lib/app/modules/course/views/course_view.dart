import 'package:apk_logic_gate/app/routes/app_pages.dart';
import 'package:apk_logic_gate/headder.dart';
import 'package:apk_logic_gate/theme.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/course_controller.dart';

class CourseView extends GetView<CourseController> {
  const CourseView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value && controller.materis.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              controller.fetchMateri(query: controller.searchText.value);
              controller.loadProfile();
            },
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // Input Pencarian
                header(),
                const SizedBox(height: 20),
                Text('Halo, ${controller.user['name']}!', style: dark1Bold_18),
                SizedBox(height: 6),
                Text('Apa yang ingin Anda pelajari?', style: dark2Regular_16),
                const SizedBox(height: 20),
                TextField(
                  controller: controller.searchController,
                  onChanged: (value) => controller.searchText.value = value,
                  decoration: inputCaristyle("Cari materi..."),
                ),
                const SizedBox(height: 20),
                // Jika data kosong
                if (controller.materis.isEmpty)
                  const Center(child: Text('Tidak ada materi.')),

                // Daftar Materi
                ...controller.materis.map((materi) {
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      title: Text(materi.title, style: dark1Bold_14),
                      subtitle: Row(
                        children: [
                          const Icon(Icons.access_time_filled, size: 16),
                          const SizedBox(width: 4),
                          Text('${materi.duration} menit'),
                        ],
                      ),
                      trailing: Icon(
                        materi.accessed
                            ? Icons.check_circle
                            : Icons.arrow_right,
                        color: materi.accessed ? Colors.green : Colors.grey,
                      ),
                      onTap: () async {
                        await Get.toNamed(
                          Routes.MATERI_DETAIL,
                          arguments: materi.id,
                        );
                        controller.fetchMateri();
                      },
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        );
      }),
    );
  }
}
