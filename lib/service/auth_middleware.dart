import 'package:apk_logic_gate/app/routes/app_pages.dart';
import 'package:apk_logic_gate/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/routes/route_middleware.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final seenIntro = box.read(kIntroDone) ?? false;
    final hasToken = box.read(kAuthToken) != null;

    // Intro belum selesai → paksa ke Intro
    if (!seenIntro && route != Routes.INTRODUCTION) {
      return const RouteSettings(name: Routes.INTRODUCTION);
    }
    // Sudah login tapi mau ke login/register → lempar ke Dashboard
    if (hasToken && (route == Routes.LOGIN || route == Routes.REGISTER)) {
      return const RouteSettings(name: Routes.DASHBOARD);
    }
    return null; // lanjut normal
  }
}
