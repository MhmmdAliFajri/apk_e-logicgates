import 'package:apk_logic_gate/app/routes/app_pages.dart';
import 'package:apk_logic_gate/config.dart';
import 'package:apk_logic_gate/model/jobsheet_model.dart';
import 'package:apk_logic_gate/model/materi_model.dart';
import 'package:apk_logic_gate/model/quiz_model.dart'; // <- tambahkan
import 'package:apk_logic_gate/service/auth_service.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeController extends GetxController {
  final Rxn<Map<String, dynamic>> user = Rxn<Map<String, dynamic>>();

  var jobsheets = <JobsheetModel>[].obs;
  var quizzes = <QuizModel>[].obs; // <- daftar quiz
  var isLoading = false.obs;
  final RxString newMateri = "".obs;
  var selectedFilter = 'All'.obs;

  var myRank = Rxn<Map<String, dynamic>>(); // data rank
  var isRankLoading = false.obs;
  var leaderboard = <Map<String, dynamic>>[].obs;
  var isLeaderboardLoading = false.obs;

  @override
  void onInit() async {
    super.onInit();
    await fetchMyRank();
    await loadProfile();
    await fetchJobsheets();
    await fetchQuizzes(); // <- ambil quiz juga
    await fetchNewMateriDetail();
  }

  Future<void> loadProfile() async {
    try {
      isLoading.value = true;
      final profile = await AuthService().profile();

      if (profile == null) {
        GetStorage().erase();
        Get.offAllNamed(Routes.LOGIN);
        return;
      }

      user.value = profile;
    } catch (e) {
      print("Gagal load profile: $e");
      GetStorage().erase();
      Get.offAllNamed(Routes.LOGIN);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchJobsheets() async {
    try {
      isLoading.value = true;
      final token = GetStorage().read('token');

      final response = await http.get(
        Uri.parse('$baseUrl/jobsheets'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List data = json.decode(response.body)['data'];
        jobsheets.value = data.map((e) => JobsheetModel.fromJson(e)).toList();
      } else {
        print('Gagal fetch jobsheets: ${response.body}');
      }
    } catch (e) {
      print('Error fetch jobsheets: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchQuizzes() async {
    try {
      isLoading.value = true;
      final token = GetStorage().read('token');

      final response = await http.get(
        Uri.parse('$baseUrl/quizzes'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List data = json.decode(response.body)['data'];
        quizzes.value = data.map((e) => QuizModel.fromJson(e)).toList();
      } else {
        print('Gagal fetch quizzes: ${response.body}');
      }
      print(quizzes.value);
    } catch (e) {
      print('Error fetch quizzes: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchNewMateriDetail() async {
    final token = GetStorage().read('token');
    final url = Uri.parse('$baseUrl/materis/new');

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['materi'];
      newMateri.value = data ?? 'Tidak ada judul';
    } else {
      newMateri.value = "Tidak ada";
    }
  }

  Future<void> fetchMyRank() async {
    try {
      isRankLoading.value = true;
      final token = GetStorage().read('token');
      final url = Uri.parse('$baseUrl/my-rank');

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        myRank.value =
            response.body.isNotEmpty
                ? json.decode(response.body)['data']
                : null;
      }
    } catch (e) {
      print("Error fetchMyRank: $e");
    } finally {
      isRankLoading.value = false;
    }
  }

  Future<void> fetchLeaderboard() async {
    try {
      isLeaderboardLoading.value = true;
      final token = GetStorage().read('token');
      final url = Uri.parse('$baseUrl/leaderboard'); // API leaderboard

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final resData = json.decode(response.body);
        if (resData['status'] == true) {
          leaderboard.value = List<Map<String, dynamic>>.from(resData['data']);
        } else {
          leaderboard.value = [];
        }
      }
    } catch (e) {
      print("Error fetchLeaderboard: $e");
      leaderboard.value = [];
    } finally {
      isLeaderboardLoading.value = false;
    }
  }
}
