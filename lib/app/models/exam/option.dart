class Option {
  String optionText;
  bool isCorrect;

  Option({
    required this.optionText,
    this.isCorrect = false,
  });

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      optionText: json['optionText'],
      isCorrect: json['isCorrect'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'optionText': optionText,
      'isCorrect': isCorrect,
    };
  }
}