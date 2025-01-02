class ClassInfo {
  final String id;
  final String name;
  final String description;
  final String classImage;
  final DateTime createdAt;
  final DateTime updatedAt;

  ClassInfo({
    required this.id,
    required this.name,
    required this.description,
    required this.classImage,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory method to create a ClassInfo from JSON
  factory ClassInfo.fromJson(Map<String, dynamic> json) {
    return ClassInfo(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      classImage: json['classImage'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'classImage': classImage,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}