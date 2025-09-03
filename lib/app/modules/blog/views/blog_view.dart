import 'package:apk_logic_gate/headder.dart';
import 'package:apk_logic_gate/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../controllers/blog_controller.dart';

class BlogView extends GetView<BlogController> {
  const BlogView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => controller.fetchBlogs(),
          child: Column(
            children: [
              Padding(padding: const EdgeInsets.all(20.0), child: header()),
              Center(child: Text("ADS", style: dark1Bold_18)),
              SizedBox(height: 10),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.blogList.isEmpty) {
                    return const Center(child: Text('Tidak ada data.'));
                  }

                  return ListView.builder(
                    padding: EdgeInsets.all(20),
                    itemCount: controller.blogList.length,
                    itemBuilder: (context, index) {
                      final item = controller.blogList[index];
                      final link = item['link'] ?? '';
                      String? ytThumb;
                      String? faviconThumb;
                      final ytRegex = RegExp(
                        r'(?:youtu.be/|youtube.com/(?:watch\?v=|embed/|v/|shorts/))([\w-]{11})',
                      );
                      final match = ytRegex.firstMatch(link);
                      if (match != null && match.groupCount >= 1) {
                        final videoId = match.group(1);
                        ytThumb = 'https://img.youtube.com/vi/$videoId/0.jpg';
                      } else if (link.isNotEmpty) {
                        try {
                          final uri = Uri.parse(link);
                          final domain = uri.host;
                          if (domain.isNotEmpty) {
                            faviconThumb =
                                'https://www.google.com/s2/favicons?domain=$domain';
                          }
                        } catch (_) {}
                      }
                      return Card(
                        color: Colors.white,
                        margin: EdgeInsets.only(bottom: 20),
                        child: ListTile(
                          leading:
                              ytThumb != null
                                  ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      ytThumb,
                                      width: 60,
                                      height: 40,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Icon(Icons.broken_image),
                                    ),
                                  )
                                  : (faviconThumb != null
                                      ? ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          faviconThumb,
                                          width: 40,
                                          height: 40,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Icon(Icons.web),
                                        ),
                                      )
                                      : Icon(Icons.web)),
                          title: Text(
                            item['title'] ?? '-',
                            style: dark1Bold_16,
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal: 10,
                            ),
                            child: Text(link),
                          ),
                          trailing: const Icon(Icons.link),
                          onTap: () async {
                            final url = link;
                            if (url.isNotEmpty) {
                              final success = await launchUrlString(
                                url,
                                mode: LaunchMode.externalApplication,
                              );

                              if (!success) {
                                Get.snackbar('Error', 'Gagal membuka link');
                              }
                            } else {
                              Get.snackbar('Error', 'Link tidak valid');
                            }
                          },
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
