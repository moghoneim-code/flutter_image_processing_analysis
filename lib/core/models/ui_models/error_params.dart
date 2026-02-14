import 'dart:ui';

class ErrorParams {
  final String message;
  final String? title;
  final VoidCallback? onRetry;

  ErrorParams({
    required this.message,
    this.title = "Oops!",
    this.onRetry
  });
}