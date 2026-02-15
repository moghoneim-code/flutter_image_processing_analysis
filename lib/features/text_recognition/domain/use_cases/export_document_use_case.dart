import 'dart:io';
import '../../../../core/errors/failures.dart';
import '../../../../core/services/pdf/pdf_service.dart';
import '../../../../core/utils/constants/enums/processing_type.dart';
import '../../../home/data/models/history_model.dart';
import '../repositories/i_text_recognition_repository.dart';

/// Use case for exporting an image as a PDF document and saving to history.
///
/// [ExportDocumentUseCase] converts the given image file to a PDF
/// using [PdfService], then persists a history record referencing
/// the generated PDF via [ITextRecognitionRepository].
class ExportDocumentUseCase {
  /// The PDF generation service.
  final PdfService _pdfService;

  /// The repository for persisting history records.
  final ITextRecognitionRepository _repository;

  /// Creates an [ExportDocumentUseCase] with the given dependencies.
  ExportDocumentUseCase(this._pdfService, this._repository);

  /// Exports the [imageFile] as a PDF and saves it to history.
  ///
  /// - [imageFile]: The image to convert to PDF.
  /// - [text]: The associated recognized text (used for metadata).
  ///
  /// Returns the generated PDF [File].
  /// Throws a [PdfFailure] if the export fails.
  Future<File> execute(File imageFile, String text) async {
    try {
      final pdfFile = await _pdfService.createPdfFromImage(imageFile);

      await _repository.addHistory(
        HistoryModel(
          imagePath: pdfFile.path,
          result:
              "PDF Document: ${imageFile.path.split('/').last}",
          dateTime: DateTime.now().toIso8601String(),
          type: ProcessingType.document,
        ),
      );

      return pdfFile;
    } on Failure {
      rethrow;
    } catch (e) {
      throw PdfFailure('Failed to export document: $e');
    }
  }
}