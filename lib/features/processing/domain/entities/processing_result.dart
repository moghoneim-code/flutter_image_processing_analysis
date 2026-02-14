import 'dart:io';
import '../../../../core/utils/utils/constants/enums/ProcessingType.dart';

class ProcessingResult {
  final File file;
  final ProcessingType type;

  ProcessingResult({
    required this.file,
    required this.type,
  });
}