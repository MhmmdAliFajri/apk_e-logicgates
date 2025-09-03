import 'package:apk_logic_gate/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/quiz_controller.dart';
import 'package:apk_logic_gate/headder.dart';

class QuizView extends StatelessWidget {
  QuizView({super.key});
  final QuizController controller = Get.put(QuizController());

  @override
  Widget build(BuildContext context) {
    final letters = const ['A', 'B', 'C', 'D'];

    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          // Kalau tidak ada soal
          if (controller.questions.isEmpty) {
            return const Center(child: Text("Tidak ada soal"));
          }

          // =============================
          // MODE REVIEW
          // =============================
          if (controller.isReviewMode.value) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  header(),
                  const SizedBox(height: 20),
                  Text(controller.quizTitle.value, style: dark1Bold_18),
                  const SizedBox(height: 8),
                  Text(
                    "Skor Kamu: ${controller.score.value}%",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color:
                          controller.score.value >= 70
                              ? Colors.green
                              : Colors.red,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (controller.questions.isEmpty) {
                      return const Center(child: Text("Tidak ada soal"));
                    }

                    return Expanded(
                      child: ListView.builder(
                        itemCount: controller.questions.length,
                        itemBuilder: (_, i) {
                          final q = controller.questions[i];
                          final selected = controller.selectedAnswers[i];
                          final correct = q.correctAnswer;
                          final isCorrect = selected == correct;

                          return Card(
                            margin: const EdgeInsets.only(bottom: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 3,
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Judul soal
                                  Text(
                                    "Soal ${i + 1}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(q.question),
                                  const SizedBox(height: 12),

                                  // Opsi jawaban
                                  ...letters.map((letter) {
                                    final optionText = q.options[letter] ?? '';
                                    if (optionText.isEmpty) {
                                      return const SizedBox.shrink();
                                    }

                                    // Tentukan warna status
                                    Color bgColor = Colors.white;
                                    Color borderColor = Colors.grey.shade300;
                                    Color textColor = Colors.black87;

                                    if (letter == correct) {
                                      bgColor = Colors.green.withOpacity(0.1);
                                      borderColor = Colors.green;
                                      textColor = Colors.green.shade800;
                                    }
                                    if (letter == selected && !isCorrect) {
                                      bgColor = Colors.red.withOpacity(0.1);
                                      borderColor = Colors.red;
                                      textColor = Colors.red.shade800;
                                    }

                                    return Container(
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 4,
                                      ),
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: bgColor,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: borderColor),
                                      ),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 14,
                                            backgroundColor: borderColor,
                                            child: Text(
                                              letter,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              optionText,
                                              style: TextStyle(
                                                color: textColor,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }),
                ],
              ),
            );
          }

          // =============================
          // MODE KERJAKAN QUIZ
          // =============================
          final qIndex = controller.currentIndex.value;
          final question = controller.questions[qIndex];

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                header(),
                const SizedBox(height: 20),
                Text(controller.quizTitle.value, style: dark1Bold_18),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: (qIndex + 1) / controller.questions.length,
                  minHeight: 10,
                ),
                const SizedBox(height: 8),
                Text('Soal ${qIndex + 1} / ${controller.questions.length}'),
                const SizedBox(height: 16),
                Text(
                  question.question,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: Obx(() {
                    final selectedAtThisQuestion =
                        (controller.selectedAnswers.length > qIndex)
                            ? controller.selectedAnswers[qIndex]
                            : null;

                    return ListView.builder(
                      padding: const EdgeInsets.only(top: 8),
                      itemCount: letters.length,
                      itemBuilder: (_, i) {
                        final letter = letters[i];
                        final text = question.options[letter] ?? '';
                        if (text.isEmpty) return const SizedBox.shrink();
                        final selected = selectedAtThisQuestion == letter;

                        return GestureDetector(
                          onTap: () => controller.selectAnswer(qIndex, letter),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color:
                                    selected
                                        ? Colors.purple
                                        : Colors.grey.shade400,
                                width: 2,
                              ),
                              color: selected ? Colors.purple : Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                  color: Colors.black.withOpacity(0.08),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 16,
                                  backgroundColor:
                                      selected
                                          ? Colors.white
                                          : Colors.grey.shade300,
                                  child: Text(
                                    letter,
                                    style: TextStyle(
                                      color:
                                          selected
                                              ? Colors.purple
                                              : Colors.black87,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    text,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color:
                                          selected
                                              ? Colors.white
                                              : Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    if (qIndex > 0)
                      Expanded(
                        child: OutlinedButton(
                          style: buttonPrimary,
                          onPressed: controller.prevQuestion,
                          child: const Text("Sebelumnya"),
                        ),
                      ),
                    if (qIndex > 0) const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: buttonPrimary,
                        onPressed: () {
                          if (qIndex < controller.questions.length - 1) {
                            controller.nextQuestion();
                          } else {
                            if (!controller.isSubmitting.value) {
                              controller.submitQuiz();
                            }
                          }
                        },
                        child: Obx(() {
                          if (controller.isSubmitting.value) {
                            return const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            );
                          }
                          return Text(
                            qIndex < controller.questions.length - 1
                                ? "Selanjutnya"
                                : "Selesai",
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
