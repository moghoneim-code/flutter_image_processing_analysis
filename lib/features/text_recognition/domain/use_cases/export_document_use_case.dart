import 'dart:io';
import '../../../../core/services/pdf/pdf_service.dart';
import '../../../../core/utils/utils/constants/enums/ProcessingType.dart';
import '../../../home/data/models/history_model.dart';
import '../../data/repositories/history_repository.dart';



class ExportDocumentUseCase {
  final PdfService _pdfService;
  final HistoryRepository _repository;

  ExportDocumentUseCase(this._pdfService, this._repository);

  Future<File> execute(File imageFile, String text) async {
    // 1. تحويل الصورة لـ PDF
    final pdfFile = await _pdfService.createPdfFromImage(imageFile);

    // 2. الحفظ في الـ SQLite اللي عملناه
    await _repository.addHistory(
      HistoryModel(
        imagePath: pdfFile.path,
        result: "PDF Document: ${imageFile.path.split('/').last}", // خلي العنوان مميز
        dateTime: DateTime.now().toIso8601String(),
        type: ProcessingType.document, // دي أهم حتة
      ),
    );

    return pdfFile;
  }
}