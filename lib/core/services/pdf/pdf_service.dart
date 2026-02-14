import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

class PdfService {
  Future<File> createPdfFromImage(File imageFile) async {
    try {
      final pdf = pw.Document();

      // قراءة الصورة وتحويلها لتنسيق يفهمه الـ PDF
      final image = pw.MemoryImage(imageFile.readAsBytesSync());

      // إضافة صفحة تحتوي على الصورة
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

      // الحصول على مسار التخزين في الجهاز
      final output = await getApplicationDocumentsDirectory();
      final fileName = "Scan_${DateTime.now().millisecondsSinceEpoch}.pdf";
      final file = File("${output.path}/$fileName");

      // حفظ الملف
      await file.writeAsBytes(await pdf.save());
      return file;
    } catch (e) {
      throw Exception("Failed to generate PDF: $e");
    }
  }
}