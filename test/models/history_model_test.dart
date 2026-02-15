import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_image_processing_analysis/features/home/data/models/history_model.dart';
import 'package:flutter_image_processing_analysis/core/utils/constants/enums/processing_type.dart';

void main() {
  group('HistoryModel', () {
    test('toMap() serializes all fields correctly', () {
      final model = HistoryModel(
        id: 1,
        imagePath: '/path/to/image.jpg',
        result: 'Detected 2 faces',
        dateTime: '2026-02-15T10:30:00',
        type: ProcessingType.face,
      );

      final map = model.toMap();

      expect(map['id'], 1);
      expect(map['imagePath'], '/path/to/image.jpg');
      expect(map['result'], 'Detected 2 faces');
      expect(map['dateTime'], '2026-02-15T10:30:00');
      expect(map['type'], 'face');
    });

    test('fromMap() deserializes all fields correctly', () {
      final map = {
        'id': 42,
        'imagePath': '/docs/scan.pdf',
        'result': 'PDF Document: invoice.pdf',
        'dateTime': '2026-01-20T14:00:00',
        'type': 'document',
      };

      final model = HistoryModel.fromMap(map);

      expect(model.id, 42);
      expect(model.imagePath, '/docs/scan.pdf');
      expect(model.result, 'PDF Document: invoice.pdf');
      expect(model.dateTime, '2026-01-20T14:00:00');
      expect(model.type, ProcessingType.document);
    });

    test('toMap() and fromMap() are symmetrical', () {
      final original = HistoryModel(
        id: 7,
        imagePath: '/tmp/test.jpg',
        result: 'Hello world',
        dateTime: '2026-02-15',
        type: ProcessingType.text,
      );

      final restored = HistoryModel.fromMap(original.toMap());

      expect(restored.id, original.id);
      expect(restored.imagePath, original.imagePath);
      expect(restored.result, original.result);
      expect(restored.dateTime, original.dateTime);
      expect(restored.type, original.type);
    });

    test('fromMap() handles all ProcessingType values', () {
      for (final type in ProcessingType.values) {
        final map = {
          'id': 1,
          'imagePath': '/path',
          'result': 'test',
          'dateTime': '2026-01-01',
          'type': type.name,
        };

        final model = HistoryModel.fromMap(map);
        expect(model.type, type);
      }
    });

    test('id can be null for unsaved records', () {
      final model = HistoryModel(
        imagePath: '/new/image.jpg',
        result: 'New scan',
        dateTime: '2026-02-15',
        type: ProcessingType.face,
      );

      expect(model.id, isNull);
      expect(model.toMap()['id'], isNull);
    });
  });
}
