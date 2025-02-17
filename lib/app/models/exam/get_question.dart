import '../../models/classes/class_info.dart';
import '../../models/subject/subject.dart';
import '../../models/board/board.dart';


import 'option.dart';

class GetQuestion {
  final String id;
  final String questionText;
  final String questionType;
  final List<Option>? options;
  final ClassInfo classInfo;
  final SubjectInfo subject;
  final BoardInfo board;

  GetQuestion({
    required this.id,
    required this.questionText,
    required this.questionType,
    this.options,
    required this.classInfo,
    required this.subject,
    required this.board,
  });

  factory GetQuestion.fromJson(Map<String, dynamic> json) {
    return GetQuestion(
      id: json['_id'],
      questionText: json['questionText'],
      questionType: json['questionType'],
      options: json['options'] != null
          ? List<Option>.from(
              json['options'].map((x) => Option.fromJson(x)))
          : null,
      classInfo: ClassInfo.fromJson(json['class']),
      subject: SubjectInfo.fromJson(json['subject']),
      board: BoardInfo.fromJson(json['board']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'questionText': questionText,
      'questionType': questionType,
      if (options != null) 'options': options!.map((option) => option.toJson()).toList(),
      'class': classInfo,
      'subject': subject,
      'board': board,
    };
  }
}

class ClassInfo {
  final String id;
  final String name;

  ClassInfo({required this.id, required this.name});

  factory ClassInfo.fromJson(Map<String, dynamic> json) {
    return ClassInfo(
      id: json['_id'],
      name: json['name'],
    );
  }
}

class SubjectInfo {
  final String id;
  final String name;

  SubjectInfo({required this.id, required this.name});

  factory SubjectInfo.fromJson(Map<String, dynamic> json) {
    return SubjectInfo(
      id: json['_id'],
      name: json['name'],
    );
  }
}

class BoardInfo {
  final String id;
  final String name;

  BoardInfo({required this.id, required this.name});

  factory BoardInfo.fromJson(Map<String, dynamic> json) {
    return BoardInfo(
      id: json['_id'],
      name: json['name'],
    );
  }
}
