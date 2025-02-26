import 'question.dart';

class Exam {
  final String title;
  final String? description;
  final String subjectId;
  final String classId;
  final String boardId;
  final List<Question> questions;
  final int duration;
  final int numberOfQuestions;
  final int totalMarks;
  final bool isActive;
  final String createdBy;
  final String createdByModel;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Exam({
    required this.title,
    this.description,
    required this.subjectId,
    required this.classId,
    required this.boardId,
    required this.questions,
    required this.duration,
    required this.numberOfQuestions,
    required this.totalMarks,
    this.isActive = true,
    required this.createdBy,
    required this.createdByModel,
    this.createdAt,
    this.updatedAt,
  });

  factory Exam.fromJson(Map<String, dynamic> json) {
    var questionsFromJson = json['questions'] as List;
    List<Question> questionsList = questionsFromJson.map((i) => Question.fromJson(i)).toList();

    return Exam(
      title: json['title'],
      description: json['description'],
      subjectId: json['subject'],
      classId: json['class'],
      boardId: json['board'],
      questions: questionsList,
      duration: json['duration'],
      numberOfQuestions: json['numberOfQuestions'],
      totalMarks: json['totalMarks'],
      isActive: json['isActive'] ?? true,
      createdBy: json['createdBy'],
      createdByModel: json['createdByModel'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'subject': subjectId,
      'class': classId,
      'board': boardId,
      'questions': questions.map((question) => question.toJson()).toList(),
      'duration': duration,
      'numberOfQuestions': numberOfQuestions,
      'totalMarks': totalMarks,
      'isActive': isActive,
      'createdBy': createdBy,
      'createdByModel': createdByModel,
    };
  }
}