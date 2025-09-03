import 'dart:convert';
import 'package:get/get.dart';
import 'package:apk_logic_gate/config.dart'; // baseUrl
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

class BlogController extends GetxController {
  final isLoading = false.obs;
  final blogList = [].obs;

  @override
  void onInit() {
    super.onInit();
    fetchBlogs();
  }

  Future<void> fetchBlogs() async {
    isLoading.value = true;

    try {
      final token = GetStorage().read('token');

      final response = await http.get(
        Uri.parse('$baseUrl/adds'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        blogList.value = data['data'];
      } else {
        Get.snackbar('Error', 'Gagal mengambil data blog');
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan saat memuat blog');
    } finally {
      isLoading.value = false;
    }
  }
}
