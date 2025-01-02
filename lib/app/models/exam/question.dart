import 'option.dart';

class Question {
  String questionText;
  String questionType;
  List<Option> options;
  String? answer;
  String? correctOpenEndedAnswer;
  String? correctMultipleChoiceAnswer;

  Question({
    required this.questionText,
    required this.questionType,
    required this.options,
    this.answer,
    this.correctOpenEndedAnswer,
    this.correctMultipleChoiceAnswer,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    var optionsFromJson = json['options'] as List;
    List<Option> optionsList = optionsFromJson.map((i) => Option.fromJson(i)).toList();

    return Question(
      questionText: json['questionText'],
      questionType: json['questionType'],
      options: optionsList,
      answer: json['answer'],
      correctOpenEndedAnswer: json['correctOpenEndedAnswer'],
      correctMultipleChoiceAnswer: json['correctMultipleChoiceAnswer'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questionText': questionText,
      'questionType': questionType,
      'options': options.map((option) => option.toJson()).toList(),
      'answer': answer,
      'correctOpenEndedAnswer': correctOpenEndedAnswer,
      'correctMultipleChoiceAnswer': correctMultipleChoiceAnswer,
    };
  }
}
