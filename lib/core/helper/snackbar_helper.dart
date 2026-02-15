import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Utility class for displaying styled snackbar notifications.
///
/// [SnackBarHelper] provides static methods for showing error,
/// success, and informational floating snackbars using the
/// GetX snackbar system.
class SnackBarHelper {

  /// Displays an error snackbar with a red background.
  ///
  /// - [message]: The error description to display.
  static void showErrorMessage(String message) {
    _showSnackbar(
      title: "Error occurred",
      message: message,
      backgroundColor: Colors.redAccent,
      icon: Icons.warning_amber_rounded,
    );
  }

  /// Displays a success snackbar with a green background.
  ///
  /// - [message]: The success description to display.
  static void showSuccessMessage(String message) {
    _showSnackbar(
      title: "Success",
      message: message,
      backgroundColor: Colors.green.shade600,
      icon: Icons.check_circle_outline_rounded,
    );
  }

  /// Displays an informational snackbar with a blue-grey background.
  ///
  /// - [message]: The information to display.
  static void showInfoMessage(String message) {
    _showSnackbar(
      title: "Notification",
      message: message,
      backgroundColor: Colors.blueGrey.shade700,
      icon: Icons.info_outline_rounded,
    );
  }

  /// Internal method that creates and shows the floating snackbar.
  ///
  /// - [title]: Bold header text for the snackbar.
  /// - [message]: Body text describing the notification.
  /// - [backgroundColor]: Background color of the snackbar.
  /// - [icon]: Leading icon displayed beside the text.
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