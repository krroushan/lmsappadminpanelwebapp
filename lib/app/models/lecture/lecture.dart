import '../../../app/models/classes/class_info.dart';
import '../../../app/models/subject/subject.dart';
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
    teacher: Teacher.fromJson(json['teacher']), // Parses the nested teacher object
    classInfo: ClassInfo.fromJson(json['class']), // Parses the nested class object
    subject: Subject.fromJson(json['subject']), // Parses the nested subject object
    recordingUrl: json['recordingUrl'] ?? "", // This can be null
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
      'recordingUrl': recordingUrl ?? "",
      'lectureType': lectureType,
      'thumbnail': thumbnail,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'streamId': streamId,
    };
  }
}