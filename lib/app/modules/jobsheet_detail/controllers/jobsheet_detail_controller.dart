import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:apk_logic_gate/config.dart';
import 'package:apk_logic_gate/model/jobsheet_detail_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class JobsheetDetailController extends GetxController {
  final isLoading = false.obs;
  final isProcessing = false.obs;
  var detail = Rxn<JobsheetDetailModel>();
  final pickedFile = Rxn<File>();
  void fetchDetail(int id) async {
    isLoading.value = true;
    try {
      final token = GetStorage().read('token');
      final response = await http.get(
        Uri.parse('$baseUrl/jobsheets/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        detail.value = JobsheetDetailModel.fromJson(data);
      } else {
        Get.snackbar('Error', 'Gagal memuat data');
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan $e');
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> downloadAndOpenPdfJobsheet(String url, String title) async {
    if (isProcessing.value) return;

    isProcessing.value = true;
    try {
      final dir = await getTemporaryDirectory();
      final filePath = "${dir.path}/jobsheet-${title}.pdf";

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

  Future<void> uploadPdf(int jobsheetId) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result == null) return;

    final file = File(result.files.single.path!);
    final token = GetStorage().read('token');

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/log-jobsheets'),
    );

    request.headers['Authorization'] = 'Bearer $token';
    request.files.add(await http.MultipartFile.fromPath('file', file.path));
    request.fields['jobsheet_id'] = jobsheetId.toString();

    final response = await request.send();
    if (response.statusCode == 201) {
      Get.snackbar('Sukses', 'Berhasil mengumpulkan');
      fetchDetail(jobsheetId);
    } else if (response.statusCode == 409) {
      Get.snackbar('Info', 'Sudah pernah mengumpulkan');
    } else {
      Get.snackbar('Gagal', 'Gagal mengunggah PDF');
    }
  }

  Future<void> downloadAndOpenPdf(String url) async {
    if (isProcessing.value) return;

    isProcessing.value = true;
    try {
      final dir = await getTemporaryDirectory();
      final filePath = "${dir.path}/jobsheet.pdf";

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

  Future<void> pickPdf() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      pickedFile.value = File(result.files.single.path!);
    }
  }

  Future<void> submitPdf(int jobsheetId) async {
    final file = pickedFile.value;
    if (file == null || isProcessing.value) return;

    isProcessing.value = true;
    try {
      final token = GetStorage().read('token');

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/log-jobsheets'),
      );

      request.headers['Authorization'] = 'Bearer $token';
      request.files.add(await http.MultipartFile.fromPath('file', file.path));
      request.fields['jobsheet_id'] = jobsheetId.toString();

      final response = await request.send();
      if (response.statusCode == 201) {
        Get.snackbar('Sukses', 'Berhasil mengumpulkan');
        pickedFile.value = null;
        fetchDetail(jobsheetId);
      } else if (response.statusCode == 409) {
        Get.snackbar('Info', 'Sudah pernah mengumpulkan');
      } else {
        Get.snackbar('Gagal', 'Gagal mengunggah PDF');
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan saat upload');
    } finally {
      isProcessing.value = false;
    }
  }
}
