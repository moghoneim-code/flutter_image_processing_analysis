import 'package:share_plus/share_plus.dart';
import '../../../../core/errors/failures.dart';

/// Use case for sharing recognized text via the platform share sheet.
///
/// [ShareTextUseCase] wraps the [Share] plugin to share text
/// content with other applications on the device.
class ShareTextUseCase {
  /// Shares the given [text] using the platform share dialog.
  ///
  /// Throws a [ShareFailure] if the share operation fails.
  Future<void> execute(String text) async {
    try {
      await Share.share(text);
    } catch (e) {
      throw ShareFailure('Failed to share text: $e');
    }
  }
}