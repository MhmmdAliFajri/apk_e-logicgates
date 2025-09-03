import 'package:apk_logic_gate/config.dart';
import 'package:apk_logic_gate/headder.dart';
import 'package:apk_logic_gate/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../controllers/materi_detail_controller.dart';

class MateriDetailView extends GetView<MateriDetailController> {
  const MateriDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final materi = controller.materi.value!;
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                header(),
                const SizedBox(height: 20),
                Text(
                  materi.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.access_time_filled, size: 16),
                    const SizedBox(width: 4),
                    Text('${materi.duration} menit'),
                  ],
                ),

                const SizedBox(height: 16),
                Html(data: materi.konten), // Tidak perlu Expanded
                const SizedBox(height: 16),
                Text("Materi Pdf", style: dark1Bold_14),
                SizedBox(height: 8),
                SizedBox(
                  height: 500, // beri tinggi tetap
                  child: WebViewWidget(
                    controller:
                        WebViewController()
                          ..setJavaScriptMode(JavaScriptMode.unrestricted)
                          ..loadRequest(
                            Uri.parse(
                              'https://docs.google.com/gview?embedded=true&url=$baseUrlStorage/${materi.linkPdf}',
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
                                final url = "$baseUrlStorage/${materi.linkPdf}";
                                controller.downloadAndOpenPdf(
                                  url,
                                  materi.title,
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
                              : const Text('Download File Materi'),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                if (!materi.accessed)
                  Container(
                    width: double.infinity,
                    child: Obx(
                      () =>
                          controller.buttonisLoading.value
                              ? ElevatedButton(
                                onPressed: () {},
                                style: buttonPrimary,
                                child: CircularProgressIndicator(),
                              )
                              : ElevatedButton.icon(
                                onPressed: controller.markAsRead,
                                style: buttonPrimary,
                                icon: Icon(Icons.check, color: dark4),
                                label: Text(
                                  "Tandai Sudah Dibaca",
                                  style: dark4Regular_14,
                                ),
                              ),
                    ),
                  ),
                if (materi.accessed)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    color: Colors.green,
                    child: Center(
                      child: const Text(
                        "✅ Materi sudah dibaca",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
