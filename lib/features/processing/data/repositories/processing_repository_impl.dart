import 'dart:io';
import '../../../../core/services/image_processing/image_pre_processor.dart';
import '../../../../core/services/ml_services/ml_service.dart';
import '../../../../core/utils/utils/constants/enums/ProcessingType.dart';
import '../../domain/repositories/i_processing_repository.dart';

class ProcessingRepositoryImpl implements IProcessingRepository {
  final MLService _mlService;
  final ImagePreProcessor _preProcessor;

  ProcessingRepositoryImpl(this._mlService, this._preProcessor);

  @override
  Future<ProcessingType> analyzeImage(File image) async {
    return await _mlService.detectContentType(image);
  }

  @override
  Future<File> applyInitialEnhancement(File image) async {
    return await _preProcessor.enhanceForScanning(image);
  }
}