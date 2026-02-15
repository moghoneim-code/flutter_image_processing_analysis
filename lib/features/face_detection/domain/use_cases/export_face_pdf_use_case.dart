import 'dart:io';
import '../../../../core/errors/failures.dart';
import '../../domain/repositories/i_face_detection_repository.dart';

/// Use case for exporting a face composite image as a PDF document.
///
/// [ExportFacePdfUseCase] delegates PDF generation to
/// [IFaceDetectionRepository] and wraps unexpected errors in a
/// [PdfFailure].
///
/// Required parameters:
/// - [repository]: The [IFaceDetectionRepository] used for PDF generation.
class ExportFacePdfUseCase {
  /// The repository used to generate PDF documents.
  final IFaceDetectionRepository repository;

  /// Creates an [ExportFacePdfUseCase] with the given [repository].
  ExportFacePdfUseCase(this.repository);

  /// Generates a PDF from the given face composite [image].
  ///
  /// Returns a [File] pointing to the generated PDF document.
  ///
  /// Throws a [PdfFailure] if the generation fails.
  Future<File> execute(File image) async {
    try {
      return await repository.generateFaceDocument(image);
    } on Failure {
      rethrow;
    } catch (e) {
      throw PdfFailure('Failed to export face PDF: $e');
    }
  }
}
