import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SnackBarHelper {

  static void showErrorMessage(String message) {
    _showSnackbar(
      title: "Error occurred",
      message: message,
      backgroundColor: Colors.redAccent,
      icon: Icons.warning_amber_rounded,
    );
  }

  static void showSuccessMessage(String message) {
    _showSnackbar(
      title: "Success",
      message: message,
      backgroundColor: Colors.green.shade600,
      icon: Icons.check_circle_outline_rounded,
    );
  }

  static void showInfoMessage(String message) {
    _showSnackbar(
      title: "Notification",
      message: message,
      backgroundColor: Colors.blueGrey.shade700,
      icon: Icons.info_outline_rounded,
    );
  }

  static void _showSnackbar({
    required String title,
    required String message,
    required Color backgroundColor,
    required IconData icon,
  }) {
    Get.rawSnackbar(
      title: title,
      message: message,
      backgroundColor: backgroundColor.withOpacity(0.9),
      snackPosition: SnackPosition.BOTTOM,
      icon: Icon(icon, color: Colors.white),
      borderRadius: 12,
      margin: const EdgeInsets.all(12),
      duration: const Duration(seconds: 3),
      snackStyle: SnackStyle.FLOATING,
    );
  }
}