import '../../../app/models/classes/class_info.dart';
import '../../../app/models/subject/subjector.dart';
import '../../../app/models/teacher/teacher.dart';
import '../../../app/models/board/board.dart';

class Syllabus {
  final String id;
  final String title;
  final String fileUrl;
  final Subject? subject;
  final ClassInfo? classInfo;
  final Board? board;
  final Teacher? teacher;

  Syllabus({
    required this.id,
    required this.title,
    required this.fileUrl,
    required this.subject,
    required this.classInfo,
    required this.board,
    required this.teacher,
  });

  // Factory method to create a StudyMaterial from JSON
  factory Syllabus.fromJson(Map<String, dynamic> json) {
    return Syllabus(
      id: json['_id'],
      title: json['title'],
      fileUrl: json['fileUrl'],
      subject: json['subject'] != null ? Subject.fromJson(json['subject']) : null,
      classInfo: json['class'] != null ? ClassInfo.fromJson(json['class']) : null,
      board: json['board'] != null ? Board.fromJson(json['board']) : null,
      teacher: json['teacher'] != null ? Teacher.fromJson(json['teacher']) : null,
    );
  }

  // Method to convert a StudyMaterial to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'fileUrl': fileUrl,
      'subject': subject?.toJson(),
      'class': classInfo?.toJson(),
      'board': board?.toJson(),
      'teacher': teacher?.toJson(),
    };
  }
}