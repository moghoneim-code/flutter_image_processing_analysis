/// Defines all named route path constants for the application.
///
/// [AppRoutes] centralizes route strings to prevent typos and
/// provide a single source of truth for navigation paths.
/// Used in conjunction with [AppPages] for route registration.
class AppRoutes {
  /// Route path for the home screen displaying processing history.
  static const String home = '/home';

  /// Route path for the text recognition result screen.
  static const String textRecognition = '/text-recognition';

  /// Route path for the image processing/analysis screen.
  static const String processing = '/processing';

  /// Route path for the live camera text recognition screen.
  static const String liveTextRecognition = '/live-text-recognition';

  /// Route path for the face detection result screen.
  static const String faceDetection = '/face-detection';

  /// Route path for the history detail screen.
  static const String historyDetail = '/history-detail';
}