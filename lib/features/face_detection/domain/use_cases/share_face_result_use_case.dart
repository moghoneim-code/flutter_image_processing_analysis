import 'dart:io';
import '../../../../core/errors/failures.dart';
import '../../domain/repositories/i_face_detection_repository.dart';

/// Use case for sharing a face detection result via the platform share sheet.
///
/// [ShareFaceResultUseCase] delegates the share operation to
/// [IFaceDetectionRepository] and wraps unexpected errors in a
/// [ShareFailure].
///
/// Required parameters:
/// - [repository]: The [IFaceDetectionRepository] used for sharing.
class ShareFaceResultUseCase {
  /// The repository used to share face detection files.
  final IFaceDetectionRepository repository;

  /// Creates a [ShareFaceResultUseCase] with the given [repository].
  ShareFaceResultUseCase(this.repository);

  /// Shares the given face detection [file] via the platform share sheet.
  ///
  /// Throws a [ShareFailure] if the share operation fails.
  Future<void> execute(File file) async {
    try {
      return await repository.shareFaceContent(file);
    } on Failure {
      rethrow;
    } catch (e) {
      throw ShareFailure('Failed to share face result: $e');
    }
  }
}