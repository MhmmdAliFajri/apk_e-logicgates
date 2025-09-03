// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class SimulasiViewPage extends StatefulWidget {
//   final String url;

//   const SimulasiViewPage({super.key, required this.url});

//   @override
//   State<SimulasiViewPage> createState() => _SimulasiViewPageState();
// }

// class _SimulasiViewPageState extends State<SimulasiViewPage> {
//   late final WebViewController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller =
//         WebViewController()
//           ..loadRequest(Uri.parse(widget.url))
//           ..setJavaScriptMode(JavaScriptMode.unrestricted);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Simulasi")),
//       body: WebViewWidget(controller: _controller),
//     );
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
import 'package:path/path.dart' as p;
import 'package:share_plus/share_plus.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SimulasiViewPage extends StatefulWidget {
  final String url;

  const SimulasiViewPage({super.key, required this.url});

  @override
  State<SimulasiViewPage> createState() => _SimulasiViewPageState();
}

class _SimulasiViewPageState extends State<SimulasiViewPage> {
  InAppWebViewController? webViewController;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  Future<void> downloadFile(
    String url,
    String fileName,
    BuildContext context,
  ) async {
    print("▶️ Mulai proses download...");

    // Minta izin
    if (Platform.isAndroid) {
      var status = await Permission.manageExternalStorage.request();

      if (!status.isGranted) {
        print("❌ Izin tidak diberikan");
        Get.snackbar(
          "Izin Ditolak",
          "Silakan aktifkan izin penyimpanan di pengaturan.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        openAppSettings();
        return;
      }
    }

    try {
      // Folder Download
      final downloadDir = Directory('/storage/emulated/0/Download');
      final savePath = p.join(downloadDir.path, fileName);

      if (url.startsWith("data:application/json;base64,")) {
        final base64Str = url.split(',')[1];
        final bytes = base64.decode(base64Str);

        final file = File(savePath);
        await file.writeAsBytes(bytes);

        print("✅ File berhasil disimpan di: $savePath");

        Get.snackbar(
          "Berhasil",
          "File disimpan di folder Download sebagai $fileName",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Langsung share (opsional)
        Share.shareXFiles([XFile(savePath)], text: 'Ini hasil file kamu!');
      } else {
        print("⚠️ URL bukan base64");
      }
    } catch (e) {
      print("❌ Gagal simpan file: $e");
      Get.snackbar(
        "Gagal",
        "Terjadi kesalahan saat menyimpan file.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Simulasi")),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(url: WebUri(widget.url)),
            initialSettings: InAppWebViewSettings(
              javaScriptEnabled: true,
              allowFileAccessFromFileURLs: true,
              allowUniversalAccessFromFileURLs: true,
            ),
            onWebViewCreated: (controller) {
              webViewController = controller;
            },
            onLoadStart: (controller, url) {
              setState(() {
                isLoading = true;
              });
            },
            onLoadStop: (controller, url) {
              setState(() {
                isLoading = false;
              });
            },
            onDownloadStartRequest: (controller, request) async {
              final url = request.url.toString();
              final now = DateTime.now();
              final formatter = DateFormat('yyyyMMdd_HHmmssSSS');
              final formatted = formatter.format(now);
              final filename =
                  url.contains("base64")
                      ? "data-$formatted.json"
                      : url.split("/").last;

              await downloadFile(url, filename, context);
            },
          ),
          if (isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
