import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showErrorDialog(String message) {
  Get.defaultDialog(
    title: "",
    backgroundColor: Colors.white,
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.error_outline, color: Colors.red, size: 60),
        SizedBox(height: 10),
        Text(
          "Gagal Mengirim Jawaban",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
        SizedBox(height: 8),
        Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: Colors.black87),
        ),
      ],
    ),
    textConfirm: "Coba Lagi",
    confirmTextColor: Colors.white,
    buttonColor: Colors.red,
    onConfirm: () {
      Get.back();
    },
  );
}
