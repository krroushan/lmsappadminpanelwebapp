import 'option.dart';

class Question {
  String id;
  String questionText;
  String questionType;
  List<Option>? options;
  String? correctOpenEndedAnswer;
  String classId;    // Reference to Class
  String subjectId;  // Reference to Subject
  String boardId;    // Reference to Board
  DateTime? createdAt;
  DateTime? updatedAt;

  Question({
    this.id = '',
    required this.questionText,
    required this.questionType,
    this.options,
    this.correctOpenEndedAnswer,
    required this.classId,
    required this.subjectId,
    required this.boardId,
    this.createdAt,
    this.updatedAt,
  }) {
    // Validate question type
    assert(questionType.toLowerCase() == 'multiple-choice' || 
           questionType.toLowerCase() == 'open-ended',
           'questionType must be either multiple-choice or open-ended');
    
    // Validate multiple choice questions have options with at least one correct answer
    if (questionType.toLowerCase() == 'multiple-choice') {
      assert(options != null && options!.any((option) => option.isCorrect),
             'Multiple choice questions must have options with at least one correct answer');
    }
    
    // Validate open-ended questions have a correct answer
    if (questionType.toLowerCase() == 'open-ended') {
      assert(correctOpenEndedAnswer != null,
             'Open ended questions must have a correct answer');
    }
  }

  factory Question.fromJson(Map<String, dynamic> json) {
    var optionsFromJson = json['options'] as List?;
    List<Option>? optionsList = optionsFromJson?.map((i) => Option.fromJson(i)).toList();

    return Question(
      id: json['_id'],
      questionText: json['questionText'],
      questionType: json['questionType'].toString().toLowerCase(),
      options: optionsList,
      correctOpenEndedAnswer: json['correctOpenEndedAnswer']?.toString().toLowerCase().trim(),
      classId: json['class'],
      subjectId: json['subject'],
      boardId: json['board'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'questionText': questionText,
      'questionType': questionType.toLowerCase(),
      if (options != null) 'options': options!.map((option) => option.toJson()).toList(),
      if (correctOpenEndedAnswer != null) 'correctOpenEndedAnswer': correctOpenEndedAnswer!.toLowerCase().trim(),
      'class': classId,
      'subject': subjectId,
      'board': boardId,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
  }
}
