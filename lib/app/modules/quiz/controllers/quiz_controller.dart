// lib/app/modules/quiz/controllers/quiz_controller.dart
import 'dart:convert';
import 'package:apk_logic_gate/model/quiz_question_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../../../config.dart';

class QuizController extends GetxController {
  final int quizId = Get.arguments['quizId'];
  var quizTitle = 'Quiz'.obs;

  var questions = <QuizQuestionModel>[].obs;
  var currentIndex = 0.obs;
  var isLoading = false.obs;
  var isSubmitting = false.obs;
  var reviewData = [].obs; // untuk menyimpan detail hasil
  var isReviewMode = false.obs;
  var score = 0.0.obs; // untuk menyimpan skor akhir
  var isAttempted = false.obs; // apakah quiz sudah dikerjakan

  /// RxList untuk jawaban terpilih: index = index soal, value = 'A'/'B'/'C'/'D' atau null
  var selectedAnswers = <String?>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchQuestions();
  }

  Future<void> fetchQuestions() async {
    try {
      isLoading.value = true;
      final token = GetStorage().read('token');

      final resp = await http.get(
        Uri.parse('$baseUrl/quizzes/$quizId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (resp.statusCode == 200) {
        final decoded = json.decode(resp.body);
        final data = decoded['data'] as Map<String, dynamic>;

        // Judul quiz
        quizTitle.value = (data['title'] ?? 'Quiz').toString();

        // Skor (null kalau belum dikerjakan)
        score.value =
            data['score'] != null
                ? double.tryParse(data['score'].toString()) ?? 0
                : 0;

        // Flag attempted
        isAttempted.value = data['attempted'] == true;

        // Parsing soal
        final List qList = (data['questions'] ?? []) as List;
        final parsed =
            qList.map((e) {
              final map = Map<String, dynamic>.from(e);

              return QuizQuestionModel.fromJson({
                ...map,
                'correct_answer': map['correct_answer']?.toString(),
                'user_answer': map['user_answer']?.toString(),
                'is_correct': map['is_correct'] == 1,
              });
            }).toList();

        questions.assignAll(parsed);

        if (!isAttempted.value) {
          // Quiz baru → inisialisasi jawaban kosong
          selectedAnswers.assignAll(
            List<String?>.generate(parsed.length, (index) {
              return parsed[index].userAnswer; // kalau quiz sudah dijawab
            }),
          );

          isReviewMode.value = false;
        } else {
          // Sudah dikerjakan → review mode
          selectedAnswers.assignAll(
            List<String?>.generate(parsed.length, (index) {
              return parsed[index].userAnswer; // simpan jawaban user
            }),
          );

          isReviewMode.value = true;
        }

        // Reset index ke soal pertama
        currentIndex.value = 0;
      } else {
        print('Gagal fetch questions: ${resp.body}');
      }
    } catch (e) {
      print('Error fetch questions: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void selectAnswer(int questionIndex, String letter) {
    // Safety: kalau belum terinisialisasi (mustahil kalau fetchQuestions sukses, tapi jaga-jaga)
    if (selectedAnswers.length != questions.length) {
      selectedAnswers.assignAll(
        List<String?>.filled(questions.length, null, growable: true),
      );
    }

    selectedAnswers[questionIndex] = letter;
    // Penting: refresh agar Obx menangkap perubahan
    selectedAnswers.refresh();
  }

  bool isSelected(int questionIndex, String letter) {
    if (questionIndex < 0 || questionIndex >= selectedAnswers.length)
      return false;
    return selectedAnswers[questionIndex] == letter;
  }

  void nextQuestion() {
    if (currentIndex.value < questions.length - 1) {
      currentIndex.value++;
    }
  }

  void prevQuestion() {
    if (currentIndex.value > 0) {
      currentIndex.value--;
    }
  }

  Future<void> submitQuiz() async {
    isSubmitting.value = true;
    try {
      final token = GetStorage().read('token');

      final answersPayload = <Map<String, dynamic>>[];
      for (var i = 0; i < questions.length; i++) {
        final q = questions[i];
        final selected =
            (i < selectedAnswers.length) ? selectedAnswers[i] : null;
        if (selected != null) {
          answersPayload.add({
            'question_id': q.id,
            'selected_answer': selected,
          });
        }
      }

      final resp = await http.post(
        Uri.parse('$baseUrl/quizzes/$quizId/answer'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'answers': answersPayload}),
      );

      if (resp.statusCode == 200) {
        final body = json.decode(resp.body);
        final score = body['score'] ?? 0;
        final total = body['total_questions'] ?? questions.length;

        Get.defaultDialog(
          title: "🎉 Hasil Quiz",
          titleStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          content: Column(
            children: [
              Text(
                "Nilai kamu:",
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              const SizedBox(height: 8),
              Text(
                "$score / 100",
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "(${answersPayload.length} jawaban dikirim, total $total soal)",
                style: const TextStyle(fontSize: 14, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          textConfirm: "OK",
          confirmTextColor: Colors.white,
          buttonColor: Colors.green,
          onConfirm: () {
            Get.back(); // tutup dialog
            Get.back(); // kembali halaman sebelumnya
          },
        );
      } else {
        String errorMsg = "Gagal mengirim jawaban.";
        try {
          final err = json.decode(resp.body);
          if (err is Map && err['message'] != null) {
            errorMsg = err['message'];
          }
        } catch (_) {}
        Get.defaultDialog(
          title: "❌ Gagal",
          middleText: errorMsg,
          textConfirm: "OK",
          confirmTextColor: Colors.white,
          buttonColor: Colors.red,
          onConfirm: () => Get.back(),
        );
      }
    } catch (e) {
      Get.defaultDialog(
        title: "⚠️ Error",
        middleText: "Terjadi kesalahan, coba lagi nanti.",
        textConfirm: "OK",
        confirmTextColor: Colors.white,
        buttonColor: Colors.orange,
        onConfirm: () => Get.back(),
      );
    } finally {
      isSubmitting.value = false;
    }
  }
}
