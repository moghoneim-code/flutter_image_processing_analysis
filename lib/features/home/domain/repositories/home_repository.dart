import '../../data/models/history_model.dart';

abstract class HomeRepository {
  Future<List<HistoryModel>> getAllHistory();
  Future<void> deleteHistoryItem(int id);
  Future<void> addHistoryItem(HistoryModel item);
}