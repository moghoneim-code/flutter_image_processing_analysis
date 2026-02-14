import '../repositories/home_repository.dart';

class DeleteHistoryUseCase {
  final HomeRepository repository;
  DeleteHistoryUseCase(this.repository);

  Future<void> execute(int id) async {
    return await repository.deleteHistoryItem(id);
  }
}