// subject create model

class SubjectCreate {
  final String name;
  final String description;
  final String classId;
  final String subjectImage;

  SubjectCreate({
    required this.name,
    required this.description,
    required this.classId,
    required this.subjectImage,
  });

  factory SubjectCreate.fromJson(Map<String, dynamic> json) {
    return SubjectCreate(
      name: json['name'],
      description: json['description'],
      classId: json['classId'],
      subjectImage: json['subjectImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'classId': classId,
      'subjectImage': subjectImage,
    };
  }
}