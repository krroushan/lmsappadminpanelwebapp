import 'time_slot.dart';

class Period {
  final TimeSlot timeSlot;
  final String day;
  final int periodNumber;
  final String subjectId;
  final String teacherId;
  final String id;


  Period({
    required this.timeSlot,
    required this.day,
    required this.periodNumber,
    required this.subjectId,
    required this.teacherId,
    required this.id,
  });

  factory Period.fromJson(Map<String, dynamic> json) {
    return Period(
      timeSlot: TimeSlot.fromJson(json['timeSlot']),
      day: json['day'],
      periodNumber: json['periodNumber'],
      subjectId: json['subject'],
      teacherId: json['teacher'],
      id: json['_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'timeSlot': timeSlot.toJson(),
      'day': day,
      'periodNumber': periodNumber,
      'subject': subjectId,
      'teacher': teacherId,
      '_id': id,
    };
  }
}