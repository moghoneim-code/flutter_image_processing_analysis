import 'dart:io';
import '../../../home/data/models/history_model.dart';

/// Abstract repository interface for face detection data operations.
///
/// [FaceDetectionRepository] defines the contract for persisting face
/// detection history, generating PDF documents from face composite images,
/// and sharing face detection results via the platform share sheet.
///
/// Implemented by [FaceDetectionRepositoryImpl].
abstract class FaceDetectionRepository {
  /// Persists a face detection result to the history database.
  ///
  ///
  /// - [history]: The [HistoryModel] containing the face detection record.
  Future<void> saveFaceHistory(HistoryModel history);

  /// Generates a PDF document from the given face composite [image].
  ///
  /// Returns a [File] pointing to the generated PDF on disk.
  Future<File> generateFaceDocument(File image);

  /// Shares the given [file] via the platform share sheet.
  ///
  /// - [file]: The image or PDF file to share.
  /// - [text]: Optional descriptive text to include with the share.
  Future<void> shareFaceContent(File file, {String? text});
}