import '../../../../core/utils/constants/enums/processing_type.dart';

/// Data model representing a single history record in the database.
///
/// [HistoryModel] maps directly to the `history` table in SQLite
/// and provides serialization methods for database I/O.
///
/// Required data:
/// - [imagePath]: The file system path to the processed image.
/// - [result]: A description of the processing outcome or extracted text.
/// - [dateTime]: An ISO 8601 formatted timestamp of when the record was created.
/// - [type]: The [ProcessingType] indicating what kind of processing was performed.
///
/// Optional:
/// - [id]: The auto-incremented database row ID (null for new records).
class HistoryModel {
  /// The unique database identifier, or `null` for unsaved records.
  final int? id;

  /// The file system path to the associated image or PDF.
  final String imagePath;

  /// The processing result description or extracted text content.
  final String result;

  /// ISO 8601 formatted timestamp of record creation.
  final String dateTime;

  /// The type of processing that produced this record.
  final ProcessingType type;

  /// Creates a [HistoryModel] instance.
  HistoryModel({
    this.id,
    required this.imagePath,
    required this.result,
    required this.dateTime,
    required this.type
  });

  /// Converts this model to a map suitable for SQLite insertion.
  ///
  /// The [type] field is serialized as its enum name string.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imagePath': imagePath,
      'result': result,
      'dateTime': dateTime,
      'type': type.name,
    };
  }

  /// Creates a [HistoryModel] from a SQLite row map.
  ///
  /// The `type` field is deserialized from its enum name string
  /// back to a [ProcessingType] value.
  factory HistoryModel.fromMap(Map<String, dynamic> map) {
    return HistoryModel(
      id: map['id'],
      imagePath: map['imagePath'],
      result: map['result'],
      dateTime: map['dateTime'],
      type: ProcessingType.values.byName(map['type']),
    );
  }
}