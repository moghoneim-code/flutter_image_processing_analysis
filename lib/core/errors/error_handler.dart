import '../helper/snackbar_helper.dart';
import 'failures.dart';

/// Centralized error handling utility for the application.
///
/// [ErrorHandler] provides static methods to uniformly handle errors
/// across all layers. If the error is a known [Failure], its message
/// is displayed; otherwise a generic fallback message is shown.
class ErrorHandler {
  ErrorHandler._();

  /// Displays an error snackbar for the given [error].
  ///
  /// If [error] is a [Failure], its [Failure.message] is shown.
  /// Otherwise, the optional [fallbackMessage] is displayed, defaulting
  /// to a generic unexpected error message.
  static void handle(Object error, {String? fallbackMessage}) {
    if (error is Failure) {
      SnackBarHelper.showErrorMessage(error.message);
    } else {
      SnackBarHelper.showErrorMessage(
        fallbackMessage ?? 'An unexpected error occurred.',
      );
    }
  }

  /// Executes [action] and returns its result, or `null` if an error occurs.
  ///
  /// On failure, the error is handled via [handle] using the optional
  /// [fallbackMessage], and [onFailure] is invoked if provided.
  ///
  /// - [action]: The asynchronous operation to execute.
  /// - [fallbackMessage]: Message displayed if the error is not a [Failure].
  /// - [onFailure]: Optional callback invoked with the caught error.
  static Future<T?> guard<T>(
    Future<T> Function() action, {
    String? fallbackMessage,
    void Function(Object error)? onFailure,
  }) async {
    try {
      return await action();
    } catch (e) {
      handle(e, fallbackMessage: fallbackMessage);
      onFailure?.call(e);
      return null;
    }
  }

  /// Executes a void [action] and returns `true` on success, `false` on failure.
  ///
  /// On failure, the error is handled via [handle] using the optional
  /// [fallbackMessage], and [onFailure] is invoked if provided.
  ///
  /// - [action]: The asynchronous void operation to execute.
  /// - [fallbackMessage]: Message displayed if the error is not a [Failure].
  /// - [onFailure]: Optional callback invoked with the caught error.
  static Future<bool> guardVoid(
    Future<void> Function() action, {
    String? fallbackMessage,
    void Function(Object error)? onFailure,
  }) async {
    try {
      await action();
      return true;
    } catch (e) {
      handle(e, fallbackMessage: fallbackMessage);
      onFailure?.call(e);
      return false;
    }
  }
}