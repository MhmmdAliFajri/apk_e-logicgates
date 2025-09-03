import 'package:apk_logic_gate/app/modules/blog/views/blog_view.dart';
import 'package:apk_logic_gate/app/modules/course/views/course_view.dart';
import 'package:apk_logic_gate/app/modules/home/views/home_view.dart';
import 'package:apk_logic_gate/app/modules/profile/views/profile_view.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  final List<Widget> pages = const [
    HomeView(),
    CourseView(),
    BlogView(),
    ProfileView(),
  ];

  final List<String> labels = ['Beranda', 'Kursus Saya', 'Blog', 'Profil Saya'];

  final List<String> activeIcons = [
    'assets/icons/home_active.png',
    'assets/icons/video_active.png',
    'assets/icons/book_active.png',
    'assets/icons/profile_active.png',
  ];

  final List<String> inactiveIcons = [
    'assets/icons/home_inactive.png',
    'assets/icons/video_inactive.png',
    'assets/icons/book_inactive.png',
    'assets/icons/profile_inactive.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: pages[controller.currentIndex.value],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changeTab,
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: true,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          items: List.generate(4, (index) {
            final isSelected = index == controller.currentIndex.value;
            return BottomNavigationBarItem(
              icon: Image.asset(
                isSelected ? activeIcons[index] : inactiveIcons[index],
                width: 24,
                height: 24,
              ),
              label: labels[index],
            );
          }),
        ),
      ),
    );
  }
}
