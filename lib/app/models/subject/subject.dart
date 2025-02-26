
import '../classes/class_info.dart';

class Subject {
  final String id;
  final String name;
  final String description;
  final String subjectImage;
  final ClassInfo classInfo; // Updated from ClassInfo to String

  Subject({
    required this.id,
    required this.name,
    required this.description,
    required this.subjectImage,
    required this.classInfo,
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
  return Subject(
    id: json['_id'],
    name: json['name'],
    description: json['description'],
    subjectImage: json['subjectImage'],
    classInfo: ClassInfo.fromJson(json['class']) // Use the ClassInfo mode
  );
}


  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'subjectImage': subjectImage,
      'class': classInfo.toJson(), // Serialize classInfo as a JSON object
    };
  }
}
