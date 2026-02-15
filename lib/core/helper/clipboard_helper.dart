import 'package:flutter/services.dart';
import 'snackbar_helper.dart';

/// Utility class for clipboard operations.
///
/// [ClipboardHelper] provides a convenient static method to copy
/// text to the system clipboard with automatic user feedback.
class ClipboardHelper {
  /// Copies the given [text] to the system clipboard.
  ///
  /// If [text] is empty or contains only whitespace, the operation
  /// is silently skipped. On success, an informational snackbar
  /// is displayed to confirm the copy action.
  static Future<void> copyText(String text) async {
    if (text.trim().isEmpty) return;
    await Clipboard.setData(ClipboardData(text: text));
    SnackBarHelper.showInfoMessage("Text copied to clipboard!");
  }
}