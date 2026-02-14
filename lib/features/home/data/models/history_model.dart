import '../../../../core/utils/utils/constants/enums/ProcessingType.dart';

class HistoryModel {
  final int? id;
  final String imagePath;
  final String result;
  final String dateTime;
  final ProcessingType type;

  HistoryModel({
    this.id,
    required this.imagePath,
    required this.result,
    required this.dateTime,
    required this.type
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imagePath': imagePath,
      'result': result,
      'dateTime': dateTime,
      'type': type.name,
    };
  }

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