import 'dart:io';
import '../../../../core/utils/constants/enums/processing_type.dart';

/// Domain entity representing the outcome of image processing.
///
/// [ProcessingResult] carries the processed image file, its detected
/// content type, and optionally extracted text. It is passed as a
/// navigation argument from the [ProcessingScreen] to the appropriate
/// result screen (face detection or text recognition).
///
/// Required data:
/// - [file]: The processed image [File].
/// - [type]: The [ProcessingType] determined during analysis.
///
/// Optional:
/// - [extractedText]: The OCR-extracted text, available only for
///   document-type images.
class ProcessingResult {
  /// The processed image file.
  final File file;

  /// The detected content type of the image.
  final ProcessingType type;

  /// The text extracted from the image via OCR, if applicable.
  final String? extractedText;

  /// The original unprocessed image file, used for before/after comparison.
  final File? originalFile;

  /// Creates a [ProcessingResult] with the given properties.
  ProcessingResult({
    required this.file,
    required this.type,
    this.extractedText,
    this.originalFile,
  });
}