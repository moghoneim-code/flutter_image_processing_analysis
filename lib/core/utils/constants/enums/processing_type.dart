/// Defines the type of content detected in an image.
///
/// Used throughout the application to route processing logic
/// and display the appropriate result screen.
enum ProcessingType {
  /// Image contains one or more human faces.
  face,

  /// Image contains a document with readable text.
  document,

  /// Extracted text content (used for history records).
  text,

  /// No recognizable content was detected in the image.
  none,
}