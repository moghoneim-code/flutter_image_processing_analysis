import 'package:flutter/services.dart';
import 'snackbar_helper.dart';

class ClipboardHelper {
  static Future<void> copyText(String text) async {
    if (text.trim().isEmpty) return;
    await Clipboard.setData(ClipboardData(text: text));
    SnackBarHelper.showInfoMessage("Text copied to clipboard!");
  }
}