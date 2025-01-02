import 'question.dart';

class Exam {
  final String title;
  final String? description;
  final String subjectId;
  final String classId;
  final List<Question> questions;
  final int duration;
  final int numberOfQuestions;
  final bool isActive;

  Exam({
    required this.title,
    this.description,
    required this.subjectId,
    required this.classId,
    required this.questions,
    required this.duration,
    required this.numberOfQuestions,
    this.isActive = true,
  });

  factory Exam.fromJson(Map<String, dynamic> json) {
    var questionsFromJson = json['questions'] as List;
    List<Question> questionsList = questionsFromJson.map((i) => Question.fromJson(i)).toList();

    return Exam(
      title: json['title'],
      description: json['description'],
      subjectId: json['subject'],
      classId: json['class'],
      questions: questionsList,
      duration: json['duration'],
      numberOfQuestions: json['numberOfQuestions'],
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'subject': subjectId,
      'class': classId,
      'questions': questions.map((question) => question.toJson()).toList(),
      'duration': duration,
      'numberOfQuestions': numberOfQuestions,
      'isActive': isActive,
    };
  }
}