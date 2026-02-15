import 'dart:io';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import '../../../../core/services/ml_services/ml_service.dart';

/// Abstract repository interface for image processing operations.
///
/// [ProcessingRepository] defines the contract for analyzing images,
/// creating face composites, enhancing documents, and extracting text.
/// Implementations such as [ProcessingRepositoryImpl] provide the
/// concrete logic using [MLService] and [ImagePreProcessor].
abstract class ProcessingRepository {
  /// Downscales the [image] to a safe processing size to prevent OOM.
  ///
  /// Returns the resized [File].
  Future<File> resizeForProcessing(File image);

  /// Analyzes the [image] and returns an [AnalysisResult] containing
  /// the detected type and any cached ML Kit data (e.g. face list).
  Future<AnalysisResult> analyzeImage(File image);

  /// Creates a face composite from the [image] using the provided
  /// [faces] list (cached from analysis) instead of re-running detection.
  ///
  /// Returns the processed [File].
  Future<File> processFaceComposite(File image, List<Face> faces);

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
