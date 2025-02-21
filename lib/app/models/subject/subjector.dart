
class Subject {
  final String id;
  final String name;
  final String description;
  final String subjectImage;
  final String classId; // Changed from ClassInfo to String

  Subject({
    required this.id,
    required this.name,
    required this.description,
    required this.subjectImage,
    required this.classId,
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      subjectImage: json['subjectImage'],
      classId: json['class'].toString(), // Convert to String since it's just an ID
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'subjectImage': subjectImage,
      'class': classId, // Send the ID as is
    };
  }
}
