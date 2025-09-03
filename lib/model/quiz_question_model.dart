// lib/app/model/quiz_question_model.dart
class QuizQuestionModel {
  final int id;
  final String question;
  final Map<String, String> options;
  final String? correctAnswer; // A/B/C/D
  final String? userAnswer; // jawaban user dari API (A/B/C/D) atau null
  final bool isCorrect; // true kalau jawaban benar (API: 1 / 0 / true / false)

  QuizQuestionModel({
    required this.id,
    required this.question,
    required this.options,
    this.correctAnswer,
    this.userAnswer,
    this.isCorrect = false,
  });

  factory QuizQuestionModel.fromJson(Map<String, dynamic> json) {
    // Normalisasi options (bisa berupa Map dari API)
    final Map<String, String> opts = {};
    if (json['options'] is Map) {
      (json['options'] as Map).forEach((k, v) {
        opts[k.toString()] = v?.toString() ?? '';
      });
    } else {
      // fallback jika API pakai option_a/option_b dll
      if (json['option_a'] != null) opts['A'] = json['option_a'].toString();
      if (json['option_b'] != null) opts['B'] = json['option_b'].toString();
      if (json['option_c'] != null) opts['C'] = json['option_c'].toString();
      if (json['option_d'] != null) opts['D'] = json['option_d'].toString();
    }

    final correct = json['correct_answer']?.toString();
    final user = json['user_answer']?.toString();

    final isCorrectRaw = json['is_correct'];
    final bool isCorr =
        (isCorrectRaw == 1) ||
        (isCorrectRaw == '1') ||
        (isCorrectRaw == true) ||
        (isCorrectRaw?.toString().toLowerCase() == 'true');

    return QuizQuestionModel(
      id: int.parse(json['id'].toString()),
      question: json['question']?.toString() ?? '',
      options: opts,
      correctAnswer: correct,
      userAnswer: user,
      isCorrect: isCorr,
    );
  }
}
