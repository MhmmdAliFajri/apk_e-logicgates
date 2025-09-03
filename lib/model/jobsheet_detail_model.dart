class JobsheetDetailModel {
  final int id;
  final String title;
  final String description;
  final int duration;
  final String status;
  final String? jobsheetLinkPdf;
  final double? nilai;
  final String? linkPdf;

  JobsheetDetailModel({
    required this.id,
    required this.title,
    required this.description,
    required this.duration,
    required this.status,
    this.jobsheetLinkPdf,
    this.nilai,
    this.linkPdf,
  });

  factory JobsheetDetailModel.fromJson(Map<String, dynamic> json) {
    return JobsheetDetailModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      duration: json['duration'],
      status: json['status'],
      jobsheetLinkPdf: json['jobsheet_link_pdf'],
      nilai: json['nilai'],
      linkPdf: json['link_pdf'],
    );
  }
}
