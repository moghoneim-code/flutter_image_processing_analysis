import '../../data/models/history_model.dart';
import '../repositories/home_repository.dart';

class GetHistoryUseCase {
  final HomeRepository repository;
  GetHistoryUseCase(this.repository);

  Future<List<HistoryModel>> call() async {
    return await repository.getAllHistory();
  }
}