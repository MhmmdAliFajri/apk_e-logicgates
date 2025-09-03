import 'package:apk_logic_gate/theme.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/introduction_controller.dart';

class IntroductionView extends GetView<IntroductionController> {
  const IntroductionView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => Column(
          children: [
            Expanded(
              flex: 8,
              child: PageView.builder(
                controller: controller.pageController,
                onPageChanged: controller.changePage,
                itemCount: controller.slides.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 40),

                        Image.asset(
                          controller.slides[index]['image']!,
                          width: Get.width * 0.8,
                        ),
                        SizedBox(height: 40),
                        Text(
                          controller.slides[index]['title']!,
                          textAlign: TextAlign.center,
                          style: primaryBold_18,
                        ),
                        SizedBox(height: 18),
                        Text(
                          controller.slides[index]['sub_title']!,
                          textAlign: TextAlign.center,
                          style: dark2Regular_16,
                        ),
                        SizedBox(height: 80),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            controller.slides.length,
                            (dotIndex) => Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color:
                                    controller.currentPage.value == dotIndex
                                        ? primary
                                        : dark3,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  if (controller.currentPage.value > 0)
                    GestureDetector(
                      onTap: controller.prevPage,
                      child: Text("Kembali", style: primaryBold_14),
                    )
                  else
                    SizedBox(width: 80),
                  ElevatedButton(
                    onPressed: controller.nextPage,
                    style: buttonIntroduction,
                    child: Text(
                      controller.isLastPage()
                          ? '      Mulai      '
                          : '   Selanjutnya   ',
                      style: dark4Bold_14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
