import '../../../../core/services/database/app_database.dart';
import '../../../home/data/models/history_model.dart';
import '../../domain/repositories/text_recognition_repository.dart';

class TextRecognitionRepositoryImpl implements TextRecognitionRepository {
  final AppDatabase database;
  TextRecognitionRepositoryImpl(this.database);

  @override
  Future<void> saveResult(HistoryModel item) async {
    await database.insert(item);
  }
}