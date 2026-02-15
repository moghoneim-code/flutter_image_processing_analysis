import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_image_processing_analysis/features/processing/domain/entities/processing_result.dart';
import 'package:flutter_image_processing_analysis/core/utils/constants/enums/processing_type.dart';

void main() {
  group('ProcessingResult', () {
    test('creates face result with originalFile for comparison', () {
      final processed = File('/processed/face.jpg');
      final original = File('/original/photo.jpg');

      final result = ProcessingResult(
        file: processed,
        type: ProcessingType.face,
        originalFile: original,
      );

      expect(result.file.path, '/processed/face.jpg');
      expect(result.type, ProcessingType.face);
      expect(result.originalFile, isNotNull);
      expect(result.originalFile!.path, '/original/photo.jpg');
      expect(result.extractedText, isNull);
    });

    test('creates document result with extracted text', () {
      final file = File('/enhanced/doc.jpg');

      final result = ProcessingResult(
        file: file,
        type: ProcessingType.document,
        extractedText: 'Hello World',
      );

      expect(result.type, ProcessingType.document);
      expect(result.extractedText, 'Hello World');
      expect(result.originalFile, isNull);
    });

    test('creates none result with minimal fields', () {
      final file = File('/original/unknown.jpg');

      final result = ProcessingResult(
        file: file,
        type: ProcessingType.none,
      );

      expect(result.type, ProcessingType.none);
      expect(result.extractedText, isNull);
      expect(result.originalFile, isNull);
    });

    test('can hold both extractedText and originalFile simultaneously', () {
      final file = File('/processed.jpg');
      final original = File('/original.jpg');

      final result = ProcessingResult(
        file: file,
        type: ProcessingType.document,
        extractedText: 'Some OCR text',
        originalFile: original,
      );

      expect(result.extractedText, isNotNull);
      expect(result.originalFile, isNotNull);
    });

    test('ProcessingType enum has all expected values', () {
      expect(ProcessingType.values, hasLength(4));
      expect(ProcessingType.values, containsAll([
        ProcessingType.face,
        ProcessingType.document,
        ProcessingType.text,
        ProcessingType.none,
      ]));
    });
  });
}
