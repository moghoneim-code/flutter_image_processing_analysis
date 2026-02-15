import '../../../../core/errors/failures.dart';
import '../../../home/data/models/history_model.dart';
import '../../domain/repositories/face_detection_repository.dart';

/// Use case for persisting a face detection result to history.
///
/// [SaveFaceHistoryUseCase] delegates the save operation to
/// [FaceDetectionRepository] and wraps unexpected errors in a
/// [DatabaseFailure].
///
/// Required parameters:
/// - [repository]: The [FaceDetectionRepository] used for persistence.
class SaveFaceHistoryUseCase {
  /// The repository used to persist face detection history.
  final FaceDetectionRepository repository;

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