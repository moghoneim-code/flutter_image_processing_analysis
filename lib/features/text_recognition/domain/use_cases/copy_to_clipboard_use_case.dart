import 'package:flutter/services.dart';

class CopyToClipboardUseCase {
  Future<void> execute(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
  }
}