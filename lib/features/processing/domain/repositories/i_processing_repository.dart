import 'dart:io';

import '../../../../core/utils/utils/constants/enums/ProcessingType.dart';

abstract class IProcessingRepository {
  Future<ProcessingType> analyzeImage(File image);
  Future<File> applyInitialEnhancement(File image);
}