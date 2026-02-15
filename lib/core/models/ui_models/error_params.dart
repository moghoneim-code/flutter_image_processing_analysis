import 'dart:ui';

/// Parameter object that configures the [AppErrorWidget] display.
///
/// [ErrorParams] bundles the error message, optional title, and
/// an optional retry callback used by the error UI to offer
/// the user a recovery action.
class ErrorParams {
  /// The main error message displayed to the user.
  final String message;

  /// The title displayed above the error message.
  ///
  /// Defaults to `"Oops!"` if not provided.
  final String? title;

  /// Optional callback triggered when the user taps the retry button.
  ///
  /// If `null`, the retry button is hidden.
  final VoidCallback? onRetry;

  /// Creates an [ErrorParams] instance.
  ///
  /// - [message]: Required error description.
  /// - [title]: Optional header text, defaults to `"Oops!"`.
  /// - [onRetry]: Optional callback for the retry action.
  ErrorParams({
    required this.message,
    this.title = "Oops!",
    this.onRetry
  });
}