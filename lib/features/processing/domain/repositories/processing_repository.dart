import 'dart:io';
import '../../../../core/utils/constants/enums/processing_type.dart';

/// Abstract repository interface for image processing operations.
///
/// [ProcessingRepository] defines the contract for analyzing images,
/// creating face composites, enhancing documents, and extracting text.
/// Implementations such as [ProcessingRepositoryImpl] provide the
/// concrete logic using [MLService] and [ImagePreProcessor].
abstract class ProcessingRepository {
  /// Analyzes the [image] and returns its detected [ProcessingType].
  Future<ProcessingType> analyzeImage(File image);

  /// Creates a face composite from the [image] where detected faces
  /// are rendered in grayscale over the original color image.
  ///
  /// Returns the processed [File].
  Future<File> processFaceComposite(File image);

  /// Enhances the [image] for document scanning by applying
  /// grayscale conversion and contrast adjustment.
  ///
  /// Returns the enhanced [File].
  Future<File> processDocumentEnhancement(File image);

  /// Extracts text from the [image] using optical character recognition.
  ///
  /// Returns the recognized text as a string.
  Future<String> extractText(File image);
}