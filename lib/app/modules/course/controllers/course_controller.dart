import 'package:apk_logic_gate/config.dart';
import 'package:apk_logic_gate/model/materi_model.dart';
import 'package:apk_logic_gate/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CourseController extends GetxController {
  var materis = <MateriModel>[].obs;
  var filteredMateris = <MateriModel>[].obs;
  var isLoading = false.obs;

  final user = {}.obs;

  var searchText = ''.obs;
  final searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadProfile();
    fetchMateri();
    debounce(searchText, (value) {
      fetchMateri(query: value);
    }, time: Duration(milliseconds: 500));
  }

  Future<void> loadProfile() async {
    isLoading.value = true;
    final profile = await AuthService().profile();
    user.value = profile!;
    // if (profile != null) {
    //   user.value = profile;
    // } else {
    //   Get.offAllNamed(Routes.LOGIN); // token expired?
    // }
    isLoading.value = false;
  }

  void fetchMateri({String? query}) async {
    try {
      isLoading.value = true;

      final token = GetStorage().read('token');
      final url =
          query != null && query.isNotEmpty
              ? '$baseUrl/materis?search=$query'
              : '$baseUrl/materis';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List data = json.decode(response.body)['data'];
        materis.value = data.map((e) => MateriModel.fromJson(e)).toList();
      } else {
        // print('❌ Error: ${response.body}');
      }
    } catch (e) {
      // print('❌ Exception: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
