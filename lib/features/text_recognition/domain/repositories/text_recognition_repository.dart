import '../../../home/data/models/history_model.dart';

abstract class TextRecognitionRepository {
  Future<void> saveResult(HistoryModel item);
}