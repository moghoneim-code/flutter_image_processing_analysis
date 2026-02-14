import '../../../home/domain/repositories/home_repository.dart';
import '../../../home/data/models/history_model.dart';
import '../../../../../../../core/utils/utils/constants/enums/ProcessingType.dart';

class SaveLiveResultUseCase {
  final HomeRepository repository;

  SaveLiveResultUseCase(this.repository);

  Future<void> execute({required String text, required String imagePath}) async {
    final historyItem = HistoryModel(
      result: text,
      imagePath: imagePath,
      dateTime: DateTime.now().toIso8601String(),
      type: ProcessingType.text, // حفظ كـ نص مستخرج
    );

    return await repository.addHistoryItem(historyItem);
  }
}