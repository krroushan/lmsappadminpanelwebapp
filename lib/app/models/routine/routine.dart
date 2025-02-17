import 'period.dart';
import '../../models/board/board.dart';
import '../../models/classes/class_info.dart';

class Routine {
  final String id;
  final Board board;
  final ClassInfo classInfo;
  final int year;
  final List<Period> periods;

  final DateTime createdAt;
  final DateTime updatedAt;

  Routine({
    required this.id,
    required this.board,
    required this.classInfo,
    required this.year,
    required this.periods,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Routine.fromJson(Map<String, dynamic> json) {
    return Routine(
      id: json['_id'],
      board: Board.fromJson(json['board']),
      classInfo: ClassInfo.fromJson(json['class']),
      year: json['year'],
      periods: (json['periods'] as List)
          .map((period) => Period.fromJson(period))
          .toList(),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  static List<Routine> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Routine.fromJson(json)).toList();
  }
}