import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:apk_logic_gate/app/modules/home/controllers/home_controller.dart';
import 'package:apk_logic_gate/app/modules/profile/controllers/profile_controller.dart';
import 'package:apk_logic_gate/app/routes/app_pages.dart';
import 'package:apk_logic_gate/config.dart';
import 'package:apk_logic_gate/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class AuthService {
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/login'),
            body: {'email': email, 'password': password},
          )
          .timeout(const Duration(seconds: 10));

      final data = json.decode(response.body);
      if (response.statusCode == 200) {
        box.write('token', data['token']);
        box.write('photo', data['user']['photo']);

        await box.write(kAuthToken, data['token']);
        print(data['token']);
        print('SESUDAH WRITE: key=$kAuthToken');
        print('READ LANGSUNG : ${box.read(kAuthToken)}');
        print('HAS DATA?     : ${box.hasData(kAuthToken)}');
        return {'success': true, 'user': data['user']};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Login failed'};
      }
    } on SocketException {
      return {'success': false, 'message': 'Tidak dapat terhubung ke server'};
    } on TimeoutException {
      return {'success': false, 'message': 'Koneksi ke server timeout'};
    } catch (e) {
      print("error $e");
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
    }
  }

  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
    String confirmPassword,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Accept': 'application/json'},
        body: {
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': confirmPassword,
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        return {'success': true, 'message': data['message']};
      } else if (response.statusCode == 422) {
        // Validasi gagal, parsing semua error
        final errors = data['errors'] as Map<String, dynamic>;
        final allMessages = errors.values
            .expand((e) => e) // gabung semua list error jadi satu
            .join('\n'); // pisahkan dengan newline

        return {'success': false, 'message': allMessages};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Terjadi kesalahan.',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Gagal terhubung ke server.'};
    }
  }

  Future<Map<String, dynamic>> updateProfile({
    String? name,
    String? email,
    String? password,
    String? confirmPassword,
  }) async {
    try {
      final token = box.read('token');
      if (token == null) {
        return {'success': false, 'message': 'Anda belum login.'};
      }

      // Bangun body hanya dengan field yang tidak null
      final Map<String, String> body = {};
      if (name != null) body['name'] = name;
      if (email != null) body['email'] = email;
      if (password != null) {
        body['password'] = password;
        body['password_confirmation'] = confirmPassword ?? '';
      }

      if (body.isEmpty) {
        return {'success': false, 'message': 'Tidak ada data yang di‑update.'};
      }

      final response = await http
          .post(
            Uri.parse('$baseUrl/profile'),
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: body,
          )
          .timeout(const Duration(seconds: 10));

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'user': data['user']};
      } else if (response.statusCode == 422) {
        // validasi gagal
        final errors = (data['errors'] as Map<String, dynamic>).values
            .expand((e) => e)
            .join('\n');
        return {'success': false, 'message': errors};
      } else if (response.statusCode == 401) {
        return {'success': false, 'message': 'Token tidak valid / kedaluwarsa'};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Gagal update profil.',
        };
      }
    } on SocketException {
      return {'success': false, 'message': 'Tidak dapat terhubung ke server'};
    } on TimeoutException {
      return {'success': false, 'message': 'Koneksi ke server timeout'};
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
    }
  }

  Future<void> logout() async {
    try {
      // ambil token yang sama dgn saat login
      final token = box.read(kAuthToken);

      // jika token masih ada, kabari server
      if (token != null) {
        await http
            .post(
              Uri.parse('$baseUrl/logout'),
              headers: {'Authorization': 'Bearer $token'},
            )
            .timeout(const Duration(seconds: 10));
      }
    } catch (e) {
      // tidak fatal; kita tetap lanjut bersihkan token lokal
      debugPrint('Logout gagal (server): $e');
    } finally {
      // HAPUS token di storage
      await box.remove(kAuthToken);
      await box.remove('token');
      await box.remove('photo');

      // (opsional) bersihkan controller yang hanya dipakai saat login
      Get.delete<HomeController>();
      Get.delete<ProfileController>();

      // pindahkan user ke halaman Login
      Get.offAllNamed(Routes.LOGIN);
    }
  }

  Future<Map<String, dynamic>?> profile() async {
    try {
      final token = box.read('token');
      print('Token: $token');
      if (token == null) return null;

      final response = await http
          .get(
            Uri.parse('$baseUrl/profile'),
            headers: {'Authorization': 'Bearer $token'},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['user'];
      }
    } on SocketException {
      print('Tidak bisa akses server');
    } on TimeoutException {
      print('Koneksi ke server timeout');
    } catch (e) {
      print('Error ambil profil: $e');
    }
    return null;
  }

  Future<Map<String, dynamic>> uploadPhoto(File image) async {
    final token = box.read('token');
    if (token == null) {
      return {'success': false, 'message': 'Anda belum login'};
    }

    try {
      final uri = Uri.parse('$baseUrl/profile');
      final request =
          http.MultipartRequest('POST', uri)
            ..headers['Authorization'] = 'Bearer $token'
            ..headers['Accept'] = 'application/json'
            ..files.add(await http.MultipartFile.fromPath('photo', image.path));

      final streamed = await request.send().timeout(
        const Duration(seconds: 15),
      );
      final response = await http.Response.fromStream(streamed);
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // perbarui cache user jika perlu
        box.write('photo', data['user']['photo']);
        return {'success': true, 'user': data['user']};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Upload gagal'};
      }
    } on SocketException {
      return {'success': false, 'message': 'Tidak ada koneksi'};
    } on TimeoutException {
      return {'success': false, 'message': 'Timeout'};
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  bool isLoggedIn() => box.hasData('token');
}
