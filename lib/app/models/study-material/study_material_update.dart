class StudyMaterialUpdate {
  final String title;
  final String description;
  final String fileUrl;
  final String type;
  final String subjectId;
  final String classId;
  final String teacherId;

  StudyMaterialUpdate({
    required this.title,
    required this.description,
    required this.fileUrl,
    required this.type,
    required this.subjectId,
    required this.classId,
    required this.teacherId,
  });

  // Factory method to create a StudyMaterial from JSON
  factory StudyMaterialUpdate.fromJson(Map<String, dynamic> json) {
    return StudyMaterialUpdate(
      title: json['title'],
      description: json['description'],
      fileUrl: json['fileUrl'],
      type: json['type'],
      subjectId: json['subject'],
      classId: json['class'],
      teacherId: json['teacher'],
    );
  }

  // Method to convert a StudyMaterial to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'fileUrl': fileUrl,
      'type': type,
      'subject': subjectId,
      'class': classId,
      'teacher': teacherId,
    };
  }
}