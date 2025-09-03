import 'package:get/get.dart';

import '../../service/auth_middleware.dart';
import '../modules/blog/bindings/blog_binding.dart';
import '../modules/blog/views/blog_view.dart';
import '../modules/course/bindings/course_binding.dart';
import '../modules/course/views/course_view.dart';
import '../modules/dashboard/bindings/dashboard_binding.dart';
import '../modules/dashboard/views/dashboard_view.dart';
import '../modules/edit_profile/bindings/edit_profile_binding.dart';
import '../modules/edit_profile/views/edit_profile_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/introduction/bindings/introduction_binding.dart';
import '../modules/introduction/views/introduction_view.dart';
import '../modules/jobsheet_detail/bindings/jobsheet_detail_binding.dart';
import '../modules/jobsheet_detail/views/jobsheet_detail_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/materi_detail/bindings/materi_detail_binding.dart';
import '../modules/materi_detail/views/materi_detail_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/bantuan_dukungan_view.dart';
import '../modules/profile/views/pengaturan_view.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/profile/views/tentang_kami_view.dart';
import '../modules/quiz/bindings/quiz_binding.dart';
import '../modules/quiz/views/quiz_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/splash_awal/bindings/splash_awal_binding.dart';
import '../modules/splash_awal/views/splash_awal_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH_AWAL;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.INTRODUCTION,
      page: () => const IntroductionView(),
      binding: IntroductionBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.DASHBOARD,
      page: () => DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.BLOG,
      page: () => const BlogView(),
      binding: BlogBinding(),
    ),
    GetPage(
      name: _Paths.COURSE,
      page: () => const CourseView(),
      binding: CourseBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.MATERI_DETAIL,
      page: () => const MateriDetailView(),
      binding: MateriDetailBinding(),
    ),
    GetPage(
      name: _Paths.JOBSHEET_DETAIL,
      page: () => const JobsheetDetailView(),
      binding: JobsheetDetailBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_PROFILE,
      page: () => const EditProfileView(),
      binding: EditProfileBinding(),
    ),
    GetPage(name: Routes.PENGATURAN, page: () => const PengaturanView()),
    GetPage(
      name: Routes.BANTUAN_DUKUNGAN,
      page: () => const BantuanDukunganView(),
    ),
    GetPage(name: Routes.TENTANG_KAMI, page: () => const TentangKamiView()),
    GetPage(
      name: _Paths.SPLASH_AWAL,
      page: () => const SplashAwalView(),
      binding: SplashAwalBinding(),
    ),
    GetPage(name: _Paths.QUIZ, page: () => QuizView(), binding: QuizBinding()),
  ];
}
