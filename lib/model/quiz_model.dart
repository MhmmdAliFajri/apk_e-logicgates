// lib/app/data/models/quiz_model.dart

class QuizModel {
  final int id;
  final String title;
  final int totalQuestions;
  final bool attempted;
  final double? score; // nullable karena belum tentu sudah dikerjakan

  QuizModel({
    required this.id,
    required this.title,
    required this.totalQuestions,
    required this.attempted,
    this.score,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
      id: json['id'],
      title: json['title'],
      totalQuestions: json['total_questions'],
      attempted: json['attempted'],
      score:
          json['score'] != null
              ? double.tryParse(json['score'].toString())
              : null,
    );
  }
}
