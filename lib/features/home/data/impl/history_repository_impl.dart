import '../../domain/repositories/home_repository.dart';
import '../models/history_model.dart';
import '../../../../core/services/database/app_database.dart';

class HomeRepositoryImpl implements HomeRepository {
  final AppDatabase database;

  HomeRepositoryImpl(this.database);

  @override
  Future<List<HistoryModel>> getAllHistory() async {
    return await database.getAll();
  }

  @override
  Future<void> deleteHistoryItem(int id) async {
    await database.delete(id);
  }

  @override
  Future<void> addHistoryItem(HistoryModel item) async  {
    await database.insert(item);
  }
}