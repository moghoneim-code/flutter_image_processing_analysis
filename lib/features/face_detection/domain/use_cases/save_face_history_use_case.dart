import '../../../../core/errors/failures.dart';
import '../../../home/data/models/history_model.dart';
import '../../domain/repositories/i_face_detection_repository.dart';

/// Use case for persisting a face detection result to history.
///
/// [SaveFaceHistoryUseCase] delegates the save operation to
/// [IFaceDetectionRepository] and wraps unexpected errors in a
/// [DatabaseFailure].
///
/// Required parameters:
/// - [repository]: The [IFaceDetectionRepository] used for persistence.
class SaveFaceHistoryUseCase {
  /// The repository used to persist face detection history.
  final IFaceDetectionRepository repository;

  /// Creates a [SaveFaceHistoryUseCase] with the given [repository].
  SaveFaceHistoryUseCase(this.repository);

  /// Saves the given [history] record to the database.
  ///
  /// - [history]: The [HistoryModel] containing the face detection data.
  ///
  /// Throws a [DatabaseFailure] if the save operation fails.
  Future<void> execute(HistoryModel history) async {
    try {
      return await repository.saveFaceHistory(history);
    } on Failure {
      rethrow;
    } catch (e) {
      throw DatabaseFailure('Failed to save face history: $e');
    }
  }
}