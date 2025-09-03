import 'package:apk_logic_gate/config.dart';
import 'package:apk_logic_gate/headder.dart';
import 'package:apk_logic_gate/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../controllers/jobsheet_detail_controller.dart';

class JobsheetDetailView extends GetView<JobsheetDetailController> {
  const JobsheetDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final int jobsheetId = Get.arguments as int;
    controller.fetchDetail(jobsheetId);

    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value || controller.detail.value == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final jobsheet = controller.detail.value!;
          final status = jobsheet.status;

          Color getStatusColor(String status) {
            switch (status) {
              case 'Sudah dinilai':
                return Colors.green;
              case 'Sudah dikumpulkan':
                return Colors.blue;
              case 'Belum dikumpulkan':
              default:
                return Colors.grey;
            }
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                header(),
                const SizedBox(height: 20),
                Text(jobsheet.title, style: dark1Bold_18),
                const SizedBox(height: 12),
                Card(
                  elevation: 1,
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.timer, color: primary),
                        title: Text('Durasi', style: dark1SemiBold_14),
                        trailing: Text(
                          '${jobsheet.duration} menit',
                          style: dark2SemiBold_14,
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.flag, color: danger),
                        title: const Text('Status'),
                        trailing: Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: getStatusColor(status),
                          ),
                          child: Text(status, style: dark4Bold_12),
                        ),
                      ),
                      if (jobsheet.nilai != null)
                        ListTile(
                          leading: const Icon(Icons.grade, color: Colors.amber),
                          title: const Text('Nilai'),
                          trailing: Text(
                            '${jobsheet.nilai}',
                            style: dark2Bold_12,
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                const Text(
                  'Deskripsi',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 6),
                Text(jobsheet.description),
                SizedBox(height: 8),
                Text("Jobsheet Pdf", style: dark1Bold_14),
                SizedBox(height: 8),
                SizedBox(
                  height: 500, // beri tinggi tetap
                  child: WebViewWidget(
                    controller:
                        WebViewController()
                          ..setJavaScriptMode(JavaScriptMode.unrestricted)
                          ..loadRequest(
                            Uri.parse(
                              'https://docs.google.com/gview?embedded=true&url=$baseUrlStorage/${jobsheet.jobsheetLinkPdf}',
                            ),
                          ),
                    gestureRecognizers: {
                      // WebView langsung “menggenggam” semua gesture drag/tap
                      Factory<OneSequenceGestureRecognizer>(
                        () => EagerGestureRecognizer(),
                      ),
                    },
                  ),
                ),
                SizedBox(height: 8),

                Container(
                  width: double.infinity,
                  child: Obx(
                    () => ElevatedButton.icon(
                      style: buttonSuccess,
                      onPressed:
                          controller.isProcessing.value
                              ? null
                              : () {
                                final url =
                                    "$baseUrlStorage/${jobsheet.jobsheetLinkPdf}";
                                controller.downloadAndOpenPdfJobsheet(
                                  url,
                                  jobsheet.title,
                                );
                              },
                      icon: Icon(Icons.picture_as_pdf, color: dark4),
                      label:
                          controller.isProcessing.value
                              ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                              : const Text('Download File Jobsheet'),
                    ),
                  ),
                ),
                SizedBox(height: 30),

                if (jobsheet.linkPdf != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("File Yang dikumpulkan", style: dark1Bold_16),
                      SizedBox(height: 8),
                      SizedBox(
                        height: 500, // beri tinggi tetap
                        child: WebViewWidget(
                          controller:
                              WebViewController()
                                ..setJavaScriptMode(JavaScriptMode.unrestricted)
                                ..loadRequest(
                                  Uri.parse(
                                    'https://docs.google.com/gview?embedded=true&url=$baseUrlStorage/${jobsheet.linkPdf}',
                                  ),
                                ),
                          gestureRecognizers: {
                            // WebView langsung “menggenggam” semua gesture drag/tap
                            Factory<OneSequenceGestureRecognizer>(
                              () => EagerGestureRecognizer(),
                            ),
                          },
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        child: Obx(
                          () => ElevatedButton.icon(
                            style: buttonPrimary,
                            onPressed:
                                controller.isProcessing.value
                                    ? null
                                    : () {
                                      final url =
                                          "$baseUrlStorage/${jobsheet.linkPdf}";
                                      controller.downloadAndOpenPdf(url);
                                    },
                            icon: const Icon(Icons.picture_as_pdf),
                            label:
                                controller.isProcessing.value
                                    ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                    : const Text('Download File yang Dikirim'),
                          ),
                        ),
                      ),
                    ],
                  ),

                const SizedBox(height: 12),

                if (status == "Belum dikumpulkan") ...[
                  Container(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => controller.pickPdf(),
                      icon: const Icon(Icons.upload_file, color: Colors.white),
                      label: const Text('Pilih File PDF'),
                      style: buttonSuccess,
                    ),
                  ),
                  Obx(() {
                    final file = controller.pickedFile.value;
                    if (file == null) return const SizedBox();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          'File dipilih: ${file.path.split('/').last}',
                          style: primaryRegular_14.copyWith(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          child: Obx(
                            () => ElevatedButton.icon(
                              onPressed:
                                  controller.isProcessing.value
                                      ? null
                                      : () => controller.submitPdf(jobsheetId),
                              icon:
                                  controller.isProcessing.value
                                      ? const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                      : const Icon(
                                        Icons.send,
                                        color: Colors.white,
                                      ),
                              label: const Text('Kumpulkan Sekarang'),
                              style: buttonPrimary,
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ],
              ],
            ),
          );
        }),
      ),
    );
  }
}
