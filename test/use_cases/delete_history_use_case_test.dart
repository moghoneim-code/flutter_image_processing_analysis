import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_image_processing_analysis/features/home/data/models/history_model.dart';
import 'package:flutter_image_processing_analysis/features/home/domain/repositories/home_repository.dart';
import 'package:flutter_image_processing_analysis/features/home/domain/use_cases/delete_history_use_case.dart';
import 'package:flutter_image_processing_analysis/core/errors/failures.dart';

/// A fake repository that tracks delete calls.
class FakeHomeRepository extends HomeRepository {
  final List<int> deletedIds = [];
  final bool shouldThrow;

  FakeHomeRepository({this.shouldThrow = false});

  @override
  Future<List<HistoryModel>> getAllHistory() async => [];

  @override
  Future<void> deleteHistoryItem(int id) async {
    if (shouldThrow) throw Exception('DB constraint violation');
    deletedIds.add(id);
  }

  @override
  Future<void> addHistoryItem(HistoryModel item) async {}
}

void main() {
  group('DeleteHistoryUseCase', () {
    test('delegates deletion to the repository with correct id', () async {
      final repo = FakeHomeRepository();
      final useCase = DeleteHistoryUseCase(repo);

      await useCase.execute(42);

      expect(repo.deletedIds, contains(42));
    });

    test('can delete multiple different ids', () async {
      final repo = FakeHomeRepository();
      final useCase = DeleteHistoryUseCase(repo);

      await useCase.execute(1);
      await useCase.execute(2);
      await useCase.execute(3);

      expect(repo.deletedIds, [1, 2, 3]);
    });

    test('wraps unexpected errors in DatabaseFailure', () async {
      final useCase = DeleteHistoryUseCase(FakeHomeRepository(shouldThrow: true));

      expect(
        () => useCase.execute(1),
        throwsA(isA<DatabaseFailure>()),
      );
    });

    test('rethrows Failure subclasses without wrapping', () async {
      final repo = _ThrowsFailureRepo();
      final useCase = DeleteHistoryUseCase(repo);

      expect(
        () => useCase.execute(1),
        throwsA(isA<DatabaseFailure>().having(
          (f) => f.message,
          'message',
          'Already a failure',
        )),
      );
    });
  });
}

class _ThrowsFailureRepo extends HomeRepository {
  @override
  Future<List<HistoryModel>> getAllHistory() async => [];

  @override
  Future<void> deleteHistoryItem(int id) async {
    throw const DatabaseFailure('Already a failure');
  }

  @override
  Future<void> addHistoryItem(HistoryModel item) async {}
}
