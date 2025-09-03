import 'package:apk_logic_gate/app/routes/app_pages.dart';
import 'package:apk_logic_gate/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IntroductionController extends GetxController {
  var currentPage = 0.obs;
  late PageController pageController;

  final slides = [
    {
      'image': 'assets/images/slider_1.png',
      'title': 'Selamat datang di Aplikasi  Gerbang Logika',
      'sub_title': '',
    },
    {
      'image': 'assets/images/slider_2.png',
      'title': 'Mari masuk ke Menu',
      'sub_title': '',
    },
    {
      'image': 'assets/images/slider_3.png',
      'title': 'Dapatkan Pengetahuan',
      'sub_title': 'Mulai belajar dan dapatkan pengetahuan ',
    },
  ];

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
  }

  void changePage(int index) {
    currentPage.value = index;
  }

  void nextPage() {
    // …
    if (isLastPage()) {
      box.write(kIntroDone, true); // <-- public key
      Get.offNamed(Routes.LOGIN);
    }
    // …
    else {
      pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void prevPage() {
    pageController.previousPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  bool isLastPage() => currentPage.value == slides.length - 1;
}
