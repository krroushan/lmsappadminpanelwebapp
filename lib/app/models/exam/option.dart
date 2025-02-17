class Option {
  String optionText;
  bool isCorrect;

  Option({
    required this.optionText,
    required this.isCorrect,
  });

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      optionText: json['optionText'].trim(),
      isCorrect: json['isCorrect'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'optionText': optionText.trim(),
      'isCorrect': isCorrect,
    };
  }
}