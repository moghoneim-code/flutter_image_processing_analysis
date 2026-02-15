import 'package:flutter/services.dart';
import '../../../../core/errors/failures.dart';

/// Use case for copying text to the system clipboard.
///
/// [CopyToClipboardUseCase] wraps the [Clipboard] API and
/// throws a [ProcessingFailure] if the operation fails.
class CopyToClipboardUseCase {
  /// Copies the given [text] to the system clipboard.
  ///
  /// Throws a [ProcessingFailure] if the clipboard operation fails.
  Future<void> execute(String text) async {
    try {
      await Clipboard.setData(ClipboardData(text: text));
    } catch (e) {
      throw ProcessingFailure('Failed to copy text to clipboard: $e');
    }
  }
}