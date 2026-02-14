import 'dart:io';
import '../../../../core/services/ml_services/ml_service.dart';
import '../../../../core/utils/utils/constants/enums/ProcessingType.dart';
import '../../../home/data/models/history_model.dart';
import '../repositories/text_recognition_repository.dart';

class RecognizeTextUseCase {

  final TextRecognitionRepository repository;
  final MLService mlService;

  RecognizeTextUseCase(this.repository, this.mlService);

  Future<HistoryModel> execute(File image) async {
    final text = await mlService.recognizeText(image);

    final newItem = HistoryModel(
      id: DateTime.now().millisecondsSinceEpoch,
      imagePath: image.path,
      result: text.isEmpty ? "No text detected" : text,
      type: ProcessingType.text,
      dateTime: DateTime.now().toString(),
    );

    await repository.saveResult(newItem);
    return newItem;
  }
}