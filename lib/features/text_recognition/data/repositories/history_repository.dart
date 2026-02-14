import '../../../../core/services/database/app_database.dart';
import '../../../home/data/models/history_model.dart';

class HistoryRepository {
  final AppDatabase _db;

  HistoryRepository(this._db);

  // استخدمنا الاسم اللي إنت متعود عليه addHistory
  Future<void> addHistory(HistoryModel history) async {
    await _db.insert(history);
  }

  Future<List<HistoryModel>> getAllHistory() async {
    return await _db.getAll();
  }
}