/// Base class for all domain-level failures in the application.
///
/// Every specific failure type extends [Failure] and carries a
/// human-readable [message] describing what went wrong.
abstract class Failure {
  /// A human-readable description of the failure.
  final String message;

  /// Creates a [Failure] with the given [message].
  const Failure(this.message);
}

/// Represents a failure that occurred during a database operation.
///
/// Thrown by repository implementations when SQLite operations fail.
class DatabaseFailure extends Failure {
  /// Creates a [DatabaseFailure] with the given [message].
  const DatabaseFailure(super.message);
}

/// Represents a failure that occurred during image processing or ML analysis.
///
/// Thrown when content detection, face detection, or text recognition
/// encounters an unexpected error.
class ProcessingFailure extends Failure {
  /// Creates a [ProcessingFailure] with the given [message].
  const ProcessingFailure(super.message);
}

/// Represents a failure that occurred while picking an image.
///
/// Thrown when the camera or gallery image selection process fails.
class ImagePickerFailure extends Failure {
  /// Creates an [ImagePickerFailure] with the given [message].
  const ImagePickerFailure(super.message);
}

/// Represents a failure that occurred during image pre-processing.
///
/// Thrown when operations such as grayscale conversion, contrast
/// adjustment, or face composite generation fail.
class ImageProcessingFailure extends Failure {
  /// Creates an [ImageProcessingFailure] with the given [message].
  const ImageProcessingFailure(super.message);
}

/// Represents a failure that occurred during PDF generation.
///
/// Thrown when converting an image to a PDF document fails.
class PdfFailure extends Failure {
  /// Creates a [PdfFailure] with the given [message].
  const PdfFailure(super.message);
}

/// Represents a failure that occurred while sharing content.
///
/// Thrown when the share intent or file sharing operation fails.
class ShareFailure extends Failure {
  /// Creates a [ShareFailure] with the given [message].
  const ShareFailure(super.message);
}

/// Represents a failure related to camera hardware or initialization.
///
/// Thrown when camera access or configuration encounters an error.
class CameraFailure extends Failure {
  /// Creates a [CameraFailure] with the given [message].
  const CameraFailure(super.message);
}