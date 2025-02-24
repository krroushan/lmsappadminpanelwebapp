import '../../../app/models/board/board.dart';

import '../../../app/models/classes/class_info.dart';
import '../../../app/models/subject/subjector.dart';
import '../../../app/models/teacher/teacher.dart';

class Lecture {
  final String id;
  final String title;
  final String description;
  final String startDate;
  final String startTime;
  final Teacher? teacher;
  final ClassInfo? classInfo; 
  final Subject? subject;
  final Board? board; 
  final String? recordingUrl;
  final String lectureType;
  final String thumbnail;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String streamId;

  Lecture({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.startTime,
    required this.teacher,
    required this.classInfo,
    required this.subject,
    required this.board,
    this.recordingUrl,
    required this.lectureType,
    required this.thumbnail,
    required this.createdAt,
    required this.updatedAt,
    required this.streamId,
  });

  factory Lecture.fromJson(Map<String, dynamic> json) {
    return Lecture(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      startDate: json['startDate'],
      startTime: json['startTime'],
      teacher: json['teacher'] != null ? Teacher.fromJson(json['teacher']) : null,
      classInfo: json['class'] != null ? ClassInfo.fromJson(json['class']) : null,
      subject: json['subject'] != null ? Subject.fromJson(json['subject']) : null,
      board: json['board'] != null ? Board.fromJson(json['board']) : null,
      recordingUrl: json['recordingUrl'] ?? "",
      lectureType: json['lectureType'] ?? "",
      thumbnail: json['thumbnail'] ?? "",
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      streamId: json['streamId'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'startDate': startDate,
      'startTime': startTime,
      'teacher': teacher?.toJson(),
      'class': classInfo?.toJson(),
      'subject': subject?.toJson(),
      'board': board?.toJson(),
      'recordingUrl': recordingUrl ?? "",
      'lectureType': lectureType,
      'thumbnail': thumbnail,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'streamId': streamId,
    };
  }
}