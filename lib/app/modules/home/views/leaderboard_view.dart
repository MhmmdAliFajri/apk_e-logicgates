import 'package:apk_logic_gate/headder.dart';
import 'package:apk_logic_gate/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class LeaderboardView extends StatelessWidget {
  const LeaderboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    final userId = controller.user.value?['id'];

    // pastikan data diambil saat halaman dibuka
    controller.fetchLeaderboard();

    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          if (controller.isLeaderboardLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final list = controller.leaderboard;
          if (list.isEmpty) {
            return const Center(child: Text('Belum ada data leaderboard.'));
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                header(),
                const SizedBox(height: 20),
                Text("List Peringkat", style: dark1Bold_18),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.separated(
                    itemCount: list.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final item = list[index];
                      final isCurrentUser = item['id'] == userId;

                      // Tentukan icon piala untuk top 3
                      Widget rankWidget;
                      if (index == 0) {
                        rankWidget = const Icon(
                          Icons.emoji_events,
                          color: Colors.amber,
                          size: 28,
                        ); // emas
                      } else if (index == 1) {
                        rankWidget = const Icon(
                          Icons.emoji_events,
                          color: Colors.grey,
                          size: 28,
                        ); // perak
                      } else if (index == 2) {
                        rankWidget = const Icon(
                          Icons.emoji_events,
                          color: Colors.brown,
                          size: 28,
                        ); // perunggu
                      } else {
                        rankWidget = Text(
                          '#${index + 1}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        );
                      }

                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color:
                              isCurrentUser
                                  ? const Color.fromARGB(255, 250, 238, 252)
                                  : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color:
                                isCurrentUser
                                    ? Colors.purple
                                    : Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            rankWidget,
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                item['name'],
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            Text(
                              '${(item['total_skor'] is String ? double.parse(item['total_skor']) : item['total_skor']).round()}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
