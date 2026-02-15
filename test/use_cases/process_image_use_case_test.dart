import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:flutter_image_processing_analysis/features/processing/domain/repositories/processing_repository.dart';
import 'package:flutter_image_processing_analysis/features/processing/domain/use_cases/process_image_use_case.dart';
import 'package:flutter_image_processing_analysis/core/errors/failures.dart';
import 'package:flutter_image_processing_analysis/core/utils/constants/enums/processing_type.dart';
import 'package:flutter_image_processing_analysis/core/services/ml_services/ml_service.dart';

/// A fake repository that returns pre-configured results based on content type.
class FakeProcessingRepository extends ProcessingRepository {
  final ProcessingType contentType;
  final String extractedText;
  final bool shouldThrow;

  FakeProcessingRepository({
    this.contentType = ProcessingType.none,
    this.extractedText = 'Sample text',
    this.shouldThrow = false,
  });

  @override
  Future<File> resizeForProcessing(File image) async {
    return image;
  }

  @override
  Future<AnalysisResult> analyzeImage(File image) async {
    if (shouldThrow) throw Exception('ML Kit crashed');
    return AnalysisResult(
      type: contentType,
      faces: contentType == ProcessingType.face ? [] : null,
    );
  }

  @override
  Future<File> processFaceComposite(File image, List<Face> faces) async {
    return File('${image.path}_face_composite.jpg');
  }

  @override
  Future<File> processDocumentEnhancement(File image) async {
    return File('${image.path}_enhanced.jpg');
  }

  @override
  Future<String> extractText(File image) async {
    return extractedText;
  }
}

void main() {
  group('ProcessImageUseCase', () {
    late File testFile;

    setUp(() {
      testFile = File('/tmp/test_image.jpg');
    });

    test('returns face result with originalFile when faces detected', () async {
      final repo = FakeProcessingRepository(contentType: ProcessingType.face);
      final useCase = ProcessImageUseCase(repo);

      final result = await useCase.execute(testFile);

      expect(result.type, ProcessingType.face);
      expect(result.originalFile, testFile);
      expect(result.file.path, contains('face_composite'));
      expect(result.extractedText, isNull);
    });

    test('returns document result with extracted text', () async {
      final repo = FakeProcessingRepository(
        contentType: ProcessingType.document,
        extractedText: 'Invoice total: \$500',
      );
      final useCase = ProcessImageUseCase(repo);

      final result = await useCase.execute(testFile);

      expect(result.type, ProcessingType.document);
      expect(result.extractedText, 'Invoice total: \$500');
      expect(result.file.path, contains('enhanced'));
      expect(result.originalFile, isNull);
    });

    test('returns original file unchanged when nothing detected', () async {
      final repo = FakeProcessingRepository(contentType: ProcessingType.none);
      final useCase = ProcessImageUseCase(repo);

      final result = await useCase.execute(testFile);

      expect(result.type, ProcessingType.none);
      expect(result.file, testFile);
      expect(result.extractedText, isNull);
    });

    test('wraps unexpected errors in ProcessingFailure', () async {
      final repo = FakeProcessingRepository(shouldThrow: true);
      final useCase = ProcessImageUseCase(repo);

      expect(
        () => useCase.execute(testFile),
        throwsA(isA<ProcessingFailure>()),
      );
    });
  });
}
