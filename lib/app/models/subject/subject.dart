class Subject {
  final String id;
  final String name;
  final String description;
  final String subjectImage;
  final String classId; // Updated from ClassInfo to String

  Subject({
    required this.id,
    required this.name,
    required this.description,
    required this.subjectImage,
    required this.classId,
  });

  // factory Subject.fromJson(Map<String, dynamic> json) {
  //   return Subject(
  //     id: json['_id'],
  //     name: json['name'],
  //     description: json['description'],
  //     subjectImage: json['subjectImage'],
  //     classId: json['class'], // Parsing class as String
  //   );
  // }

  factory Subject.fromJson(Map<String, dynamic> json) {
  return Subject(
    id: json['_id'],
    name: json['name'],
    description: json['description'],
    subjectImage: json['subjectImage'],
    classId: json['class'] is Map<String, dynamic>
        ? json['class']['name'] // Extract the ID from the object
        : json['class'], // Use the string directly
  );
}


  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'subjectImage': subjectImage,
      'class': classId, // Serialize classId as String
    };
  }
}
