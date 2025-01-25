class SyllabusCreate {
  final String title;
  final String fileUrl;
  final String subjectId;
  final String classId;
  final String teacherId;

  SyllabusCreate({
    required this.title,
    required this.fileUrl,
    required this.subjectId,
    required this.classId,
    required this.teacherId,
  });

  // Factory method to create a StudyMaterial from JSON
  factory SyllabusCreate.fromJson(Map<String, dynamic> json) {
    return SyllabusCreate(
      title: json['title'],
      fileUrl: json['fileUrl'],
      subjectId: json['subject'],
      classId: json['class'],
      teacherId: json['teacher'],
    );
  }

  // Method to convert a StudyMaterial to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'fileUrl': fileUrl,
      'subject': subjectId,
      'class': classId,
      'teacher': teacherId,
    };
  }
}