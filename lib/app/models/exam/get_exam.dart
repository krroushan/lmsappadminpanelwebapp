import '../classes/class_info.dart';
import 'question.dart';
import '../subject/subjector.dart';
import '../board/board.dart';

class GetExam {
  final String id;
  final String title;
  final String? description;
  final Subject subject;
  final ClassInfo classInfo;
  final Board board;
  final List<Question> questions;
  final int duration;
  final int numberOfQuestions;
  final int totalMarks;
  final bool isActive;
  final String createdBy;
  final String createdByModel;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  GetExam({
    required this.id,
    required this.title,
    this.description,
    required this.subject,
    required this.classInfo,
    required this.board,
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

  factory GetExam.fromJson(Map<String, dynamic> json) {
    var questionsFromJson = json['questions'] as List;
    List<Question> questionsList = questionsFromJson.map((i) => Question.fromJson(i)).toList();

    return GetExam(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      subject: Subject.fromJson(json['subject']),
      classInfo: ClassInfo.fromJson(json['class']),
      board: Board.fromJson(json['board']),
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
      'id': id,
      'title': title,
      'description': description,
      'subject': subject,
      'class': classInfo,
      'board': board,
      'questions': questions.map((question) => question.toJson()).toList(),
      'duration': duration,
      'numberOfQuestions': numberOfQuestions,
      'totalMarks': totalMarks,
      'isActive': isActive,
      'createdBy': createdBy,
      'createdByModel': createdByModel,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}