import '../../../../features/home/data/models/history_model.dart';

abstract class AppDatabase {
  Future<void> init();
  Future<int> insert(HistoryModel history);
  Future<List<HistoryModel>> getAll();
  Future<int> delete(int id);
  Future<void> close();
}