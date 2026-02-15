import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_image_processing_analysis/features/home/data/models/history_model.dart';
import 'package:flutter_image_processing_analysis/features/home/domain/repositories/home_repository.dart';
import 'package:flutter_image_processing_analysis/features/home/domain/use_cases/get_history_use_case.dart';
import 'package:flutter_image_processing_analysis/core/errors/failures.dart';
import 'package:flutter_image_processing_analysis/core/utils/constants/enums/processing_type.dart';

/// A fake repository that returns a pre-defined list of history items.
class FakeHomeRepository extends HomeRepository {
  final List<HistoryModel> items;
  final bool shouldThrow;

  FakeHomeRepository({this.items = const [], this.shouldThrow = false});

  @override
  Future<List<HistoryModel>> getAllHistory() async {
    if (shouldThrow) throw Exception('DB error');
    return items;
  }

  @override
  Future<void> deleteHistoryItem(int id) async {}

  @override
  Future<void> addHistoryItem(HistoryModel item) async {}
}

void main() {
  group('GetHistoryUseCase', () {
    test('returns list of history items from repository', () async {
      final items = [
        HistoryModel(
          id: 1,
          imagePath: '/img1.jpg',
          result: 'Face detected',
          dateTime: '2026-02-15',
          type: ProcessingType.face,
        ),
        HistoryModel(
          id: 2,
          imagePath: '/img2.jpg',
          result: 'PDF Document',
          dateTime: '2026-02-14',
          type: ProcessingType.document,
        ),
      ];

      final useCase = GetHistoryUseCase(FakeHomeRepository(items: items));
      final result = await useCase.call();

      expect(result, hasLength(2));
      expect(result[0].type, ProcessingType.face);
      expect(result[1].type, ProcessingType.document);
    });

    test('returns empty list when no history exists', () async {
      final useCase = GetHistoryUseCase(FakeHomeRepository());
      final result = await useCase.call();

      expect(result, isEmpty);
    });

    test('wraps unexpected errors in DatabaseFailure', () async {
      final useCase = GetHistoryUseCase(FakeHomeRepository(shouldThrow: true));

      expect(
        () => useCase.call(),
        throwsA(isA<DatabaseFailure>()),
      );
    });
  });
}
