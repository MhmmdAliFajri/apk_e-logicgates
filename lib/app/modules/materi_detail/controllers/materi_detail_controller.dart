import 'package:apk_logic_gate/model/materi_model.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../../config.dart';

class MateriDetailController extends GetxController {
  final id = Get.arguments as int;
  final isProcessing = false.obs;
  var isLoading = true.obs;
  var buttonisLoading = false.obs;
  var materi = Rxn<MateriModel>();

  @override
  void onInit() {
    super.onInit();
    fetchMateriDetail();
  }

  void fetchMateriDetail() async {
    isLoading.value = true;
    final token = GetStorage().read('token');
    final url = Uri.parse('$baseUrl/materis/$id');

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      materi.value = MateriModel.fromJson(data);
    } else {
      print('❌ Gagal mengambil detail materi');
    }

    isLoading.value = false;
  }

  Future<void> markAsRead() async {
    buttonisLoading.value = true;
    final token = GetStorage().read('token');
    final response = await http.post(
      Uri.parse('$baseUrl/log-materis'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
      body: {'materi_id': id.toString()},
    );

    if (response.statusCode == 200) {
      Get.snackbar("Berhasil", "Materi ditandai sudah dibaca");
      fetchMateriDetail();
    } else if (response.statusCode == 409) {
      Get.snackbar("Info", "Materi sudah ditandai sebelumnya");
    } else {
      Get.snackbar("Gagal", "Tidak dapat menandai materi");
    }
    buttonisLoading.value = false;
  }

  Future<void> downloadAndOpenPdf(String url, String title) async {
    if (isProcessing.value) return;

    isProcessing.value = true;
    try {
      final dir = await getTemporaryDirectory();
      final filePath = "${dir.path}/materi-${title}.pdf";

      final response = await Dio().download(url, filePath);

      if (response.statusCode == 200) {
        await OpenFilex.open(filePath);
      } else {
        Get.snackbar('Gagal', 'Gagal mendownload file');
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan membuka file');
    } finally {
      isProcessing.value = false;
    }
  }
}
