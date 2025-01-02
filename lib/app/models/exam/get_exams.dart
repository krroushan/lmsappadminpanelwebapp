import 'question.dart';
import '../../models/subject/subject.dart';
import '../../models/classes/class_info.dart';

class GetExams {
  final String id;
  final String title;
  final String? description;
  final Subject subject;
  final ClassInfo classInfo;
  final int duration;
  final int numberOfQuestions;
  final bool isActive;

  GetExams({
    required this.id,
    required this.title,
    this.description,
    required this.subject,
    required this.classInfo,
    required this.duration,
    required this.numberOfQuestions,
    this.isActive = true,
  });

  factory GetExams.fromJson(Map<String, dynamic> json) {
    return GetExams(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      subject: Subject.fromJson(json['subject']),
      classInfo: ClassInfo.fromJson(json['class']),
      duration: json['duration'],
      numberOfQuestions: json['numberOfQuestions'],
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'subject': subject.toJson(),
      'class': classInfo.toJson(),
      'duration': duration,
      'numberOfQuestions': numberOfQuestions,
      'isActive': isActive,
    };
  }
}