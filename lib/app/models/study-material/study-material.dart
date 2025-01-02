import '../../../app/models/classes/class_info.dart';
import '../../../app/models/subject/subject.dart';
import '../../../app/models/teacher/teacher.dart';

class StudyMaterial {
  final String id;
  final String title;
  final String? description;
  final String fileUrl;
  final String type;
  final Subject subject;
  final ClassInfo classInfo;
  final Teacher teacher;

  StudyMaterial({
    required this.id,
    required this.title,
    this.description,
    required this.fileUrl,
    required this.type,
    required this.subject,
    required this.classInfo,
    required this.teacher,
  });

  // Factory method to create a StudyMaterial from JSON
  factory StudyMaterial.fromJson(Map<String, dynamic> json) {
    return StudyMaterial(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      fileUrl: json['fileUrl'],
      type: json['type'],
      subject: Subject.fromJson(json['subject']),
      classInfo: ClassInfo.fromJson(json['class']),
      teacher: Teacher.fromJson(json['teacher']),
    );
  }

  // Method to convert a StudyMaterial to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'fileUrl': fileUrl,
      'type': type,
      'subject': subject.toJson(),
      'class': classInfo.toJson(),
      'teacher': teacher.toJson(),
    };
  }
}