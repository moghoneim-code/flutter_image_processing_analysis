import 'dart:io';
import '../entities/processing_result.dart';
import '../repositories/i_processing_repository.dart';

class ProcessImageUseCase {
  final IProcessingRepository _repository;

  ProcessImageUseCase(this._repository);

  Future<ProcessingResult> execute(File image) async {
    final enhanced = await _repository.applyInitialEnhancement(image);
    final type = await _repository.analyzeImage(enhanced);

    return ProcessingResult(file: enhanced, type: type);
  }
}