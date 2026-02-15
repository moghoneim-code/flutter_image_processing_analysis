import 'dart:io';
import 'package:share_plus/share_plus.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/repositories/i_face_detection_repository.dart';
import '../../../../core/services/database/app_database.dart';
import '../../../../core/services/pdf/pdf_service.dart';
import '../../../home/data/models/history_model.dart';

/// Concrete implementation of [IFaceDetectionRepository].
///
/// [FaceDetectionRepositoryImpl] handles face detection data operations
/// including database persistence via [AppDatabase], PDF generation
/// via [PdfService], and file sharing via the `share_plus` package.
///
/// Required parameters:
/// - [_database]: The [AppDatabase] instance for SQLite operations.
/// - [_pdfService]: The [PdfService] instance for PDF generation.
class FaceDetectionRepositoryImpl implements IFaceDetectionRepository {
  /// The database service for persisting history records.
  final AppDatabase _database;

  /// The PDF generation service.
  final PdfService _pdfService;

  /// Creates a [FaceDetectionRepositoryImpl] with the given [_database] and [_pdfService].
  FaceDetectionRepositoryImpl(this._database, this._pdfService);

  @override
  Future<void> saveFaceHistory(HistoryModel history) async {
    try {
      await _database.insert(history);
    } on DatabaseFailure {
      rethrow;
    } catch (e) {
      throw DatabaseFailure('Failed to save face detection history: $e');
    }
  }

  @override
  Future<File> generateFaceDocument(File image) async {
    try {
      return await _pdfService.createPdfFromImage(image);
    } on PdfFailure {
      rethrow;
    } catch (e) {
      throw PdfFailure('Failed to generate face document PDF: $e');
    }
  }

  @override
  Future<void> shareFaceContent(File file, {String? text}) async {
    try {
      await Share.shareXFiles(
        [XFile(file.path)],
        text: text ?? 'Owl AI Face Detection Result',
      );
    } catch (e) {
      throw ShareFailure('Failed to share face detection result: $e');
    }
  }
}