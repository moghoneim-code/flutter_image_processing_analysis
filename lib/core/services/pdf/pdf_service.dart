import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import '../../errors/failures.dart';

/// Service for generating PDF documents from images.
///
/// [PdfService] converts a given image file into an A4-sized PDF
/// document and saves it to the application's documents directory.
class PdfService {
  /// Creates a single-page A4 PDF containing the given [imageFile].
  ///
  /// The image is centered on the page and scaled to fit within the
  /// A4 dimensions while maintaining its aspect ratio.
  ///
  /// Returns the generated PDF [File] saved to the documents directory
  /// with a timestamp-based filename (e.g., `Scan_1234567890.pdf`).
  ///
  /// Throws a [PdfFailure] if PDF generation or saving fails.
  Future<File> createPdfFromImage(File imageFile) async {
    try {
      final pdf = pw.Document();

      final image = pw.MemoryImage(imageFile.readAsBytesSync());

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Image(image, fit: pw.BoxFit.contain),
            );
          },
        ),
      );

      final output = await getApplicationDocumentsDirectory();
      final fileName = "Scan_${DateTime.now().millisecondsSinceEpoch}.pdf";
      final file = File("${output.path}/$fileName");

      await file.writeAsBytes(await pdf.save());
      return file;
    } catch (e) {
      throw PdfFailure('Failed to generate PDF: $e');
    }
  }
}