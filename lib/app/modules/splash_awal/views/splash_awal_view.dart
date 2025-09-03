import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/splash_awal_controller.dart';

class SplashAwalView extends GetView<SplashAwalController> {
  const SplashAwalView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Image.asset('assets/icons/logo_apk.png', width: 160)),
    );
  }
}
