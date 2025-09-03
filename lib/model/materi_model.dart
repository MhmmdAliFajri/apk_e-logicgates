// lib/app/data/models/materi_model.dart

class MateriModel {
  final int id;
  final String title;
  final int duration;
  final String konten;
  final String linkPdf;
  final bool accessed;

  MateriModel({
    required this.id,
    required this.title,
    required this.duration,
    required this.konten,
    required this.linkPdf,
    required this.accessed,
  });

  factory MateriModel.fromJson(Map<String, dynamic> json) {
    return MateriModel(
      id: json['id'],
      title: json['title'],
      duration: json['duration'],
      konten: json['konten'],
      linkPdf: json['link_pdf'],
      accessed: json['accessed'],
    );
  }
}
