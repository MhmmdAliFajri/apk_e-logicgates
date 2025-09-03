// lib/app/data/models/jobsheet_model.dart

class JobsheetModel {
  final int id;
  final String title;
  final String description;
  final int duration;
  final String status;
  final String? jobsheetLinkPdf;
  final double? nilai;
  final String? linkPdf;

  JobsheetModel({
    required this.id,
    required this.title,
    required this.description,
    required this.duration,
    required this.status,
    required this.nilai,
    required this.linkPdf,
    this.jobsheetLinkPdf,
  });

  factory JobsheetModel.fromJson(Map<String, dynamic> json) {
    return JobsheetModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      duration: json['duration'],
      status: json['status'],
      nilai: json['nilai'],
      jobsheetLinkPdf: json['jobsheet_link_pdf'],
      linkPdf: json['link_pdf'],
    );
  }
}
