import 'package:apk_logic_gate/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:apk_logic_gate/app/modules/home/views/leaderboard_view.dart';
import 'package:apk_logic_gate/app/modules/home/views/simulasi_view.dart';
import 'package:apk_logic_gate/app/routes/app_pages.dart';
import 'package:apk_logic_gate/config.dart';
import 'package:apk_logic_gate/headder.dart';
import 'package:apk_logic_gate/theme.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    final dashboardC = Get.find<DashboardController>();
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          await controller.loadProfile();
          await controller.fetchJobsheets();
          await controller.fetchQuizzes();
          await controller.fetchNewMateriDetail();
          await controller.fetchMyRank();
        },
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            header(),
            const SizedBox(height: 20),
            Obx(() {
              final name = controller.user.value?['name'] ?? '';
              return Text('Halo, $name!', style: dark1Bold_18);
            }),

            SizedBox(height: 6),
            Text('Apa yang ingin Anda pelajari?', style: dark2Regular_16),
            const SizedBox(height: 20),
            TextField(decoration: inputCaristyle("Cari ...")),
            const SizedBox(height: 20),
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                children: [
                  // Background image
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        'assets/images/banner.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Overlay content
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Kursus Baru!',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                controller.newMateri.value,
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () => dashboardC.changeTab(1),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.purple,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text('Lihat Sekarang'),
                              ),
                            ],
                          ),
                        ),
                        Image.asset(
                          'assets/images/banner_person.png',
                          height: 90,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Obx(() {
              if (controller.isRankLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final rankData = controller.myRank.value;

              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.purple.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.emoji_events,
                      color: Colors.amber,
                      size: 30,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Kamu berada di peringkat ${rankData?['rank']}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Dengan total skor ${rankData?['user']['total_skor']}",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                          SizedBox(height: 4),
                          GestureDetector(
                            onTap: () {
                              Get.to(() => const LeaderboardView());
                            },
                            child: Text(
                              'Lihat Peringkat selengkapnya',
                              style: TextStyle(
                                color: Colors.purple,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Kursus',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text('Lihat Semua', style: TextStyle(color: Colors.purple)),
              ],
            ),
            const SizedBox(height: 10),
            Obx(
              () => Row(
                children: [
                  FilterChip(
                    label: const Text('All'),
                    selected: controller.selectedFilter.value == 'All',
                    selectedColor: Colors.purple.shade100,
                    onSelected: (_) => controller.selectedFilter.value = 'All',
                    checkmarkColor: Colors.purple,
                    labelStyle: TextStyle(
                      color:
                          controller.selectedFilter.value == 'All'
                              ? Colors.purple
                              : Colors.black,
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: const Text('Jobsheet'),
                    selected: controller.selectedFilter.value == 'Jobsheet',
                    selectedColor: Colors.purple.shade100,
                    onSelected:
                        (_) => controller.selectedFilter.value = 'Jobsheet',
                    checkmarkColor: Colors.purple,
                    labelStyle: TextStyle(
                      color:
                          controller.selectedFilter.value == 'Jobsheet'
                              ? Colors.purple
                              : Colors.black,
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: const Text('Simulasi'),
                    selected: controller.selectedFilter.value == 'Simulasi',
                    selectedColor: Colors.purple.shade100,
                    onSelected:
                        (_) => controller.selectedFilter.value = 'Simulasi',
                    checkmarkColor: Colors.purple,
                    labelStyle: TextStyle(
                      color:
                          controller.selectedFilter.value == 'Simulasi'
                              ? Colors.purple
                              : Colors.black,
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: const Text('Quiz'),
                    selected: controller.selectedFilter.value == 'Quiz',
                    selectedColor: Colors.purple.shade100,
                    onSelected: (_) => controller.selectedFilter.value = 'Quiz',
                    checkmarkColor: Colors.purple,
                    labelStyle: TextStyle(
                      color:
                          controller.selectedFilter.value == 'Quiz'
                              ? Colors.purple
                              : Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final selected = controller.selectedFilter.value;
              final jobsheets = controller.jobsheets;

              List<Widget> cards = [];

              if ((selected == 'All' || selected == 'Jobsheet') &&
                  jobsheets.isNotEmpty) {
                cards.addAll(
                  jobsheets.map((jobsheet) {
                    return GestureDetector(
                      onTap: () async {
                        await Get.toNamed(
                          Routes.JOBSHEET_DETAIL,
                          arguments: jobsheet.id,
                        );
                        controller.fetchJobsheets();
                        controller.fetchMyRank();
                      },
                      child: _buildCourseCard(
                        jobsheet.title,
                        "${jobsheet.nilai ?? 0}",
                        "${jobsheet.duration} menit",
                        jobsheet.status,
                      ),
                    );
                  }).toList(),
                );
              }
              if (selected == 'All' || selected == 'Simulasi') {
                cards.add(
                  GestureDetector(
                    onTap: () {
                      Get.to(
                        () => const SimulasiViewPage(
                          //url: "http://jirtdan.org/app/app.html",
                          url:
                              "https://gerbang-logika-web-for-android1.vercel.app/",
                        ),
                      );
                    },

                    child: _buildCourseCard(
                      "Simulasi Logic Gate",
                      "-",
                      "-",
                      "Belum Selesai",
                    ),
                  ),
                );
              }
              if (selected == 'All' || selected == 'Quiz') {
                cards.addAll(
                  controller.quizzes.map((quiz) {
                    return GestureDetector(
                      onTap: () async {
                        await Get.toNamed(
                          Routes.QUIZ, // ganti sesuai route quiz kamu
                          arguments: {"quizId": quiz.id},
                        );
                        controller.fetchQuizzes();
                        controller.fetchMyRank();
                      },
                      child: _buildCourseCard(
                        quiz.title,
                        quiz.attempted
                            ? "${quiz.score ?? 0}"
                            : "Belum Dikerjakan",
                        "${quiz.totalQuestions} soal",
                        quiz.attempted ? "Selesai" : "Belum Dikerjakan",
                      ),
                    );
                  }).toList(),
                );
              }

              if (cards.isEmpty) {
                return const Center(child: Text("Belum ada kursus."));
              }

              return Column(children: cards);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseCard(
    String title,
    String rating,
    String duration,
    String status,
  ) {
    return Card(
      color: dark4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 12),
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: dark1Bold_14,
                      softWrap: true,
                      overflow: TextOverflow.visible,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 20),
                        const SizedBox(width: 4),
                        Text(rating),
                        const SizedBox(width: 12),
                        const Icon(Icons.access_time_filled, size: 16),
                        const SizedBox(width: 4),
                        Text(duration),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                status == "Sudah dinilai"
                    ? Icons.check_circle
                    : status == "Sudah dikumpulkan"
                    ? Icons.hourglass_bottom
                    : Icons.arrow_right,
                color:
                    status == "Sudah dinilai"
                        ? Colors.green
                        : status == "Sudah dikumpulkan"
                        ? Colors.orange
                        : Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
