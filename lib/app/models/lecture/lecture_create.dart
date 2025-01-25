class LectureCreate {
  final String title;
  final String description;
  final String thumbnail;
  final String recordingUrl;
  final String lectureType;
  final String classId;
  final String subjectId;
  final String teacherId;
  final String startDate;
  final String startTime;

  LectureCreate({
    required this.title,
    required this.description,
    required this.thumbnail,
    required this.recordingUrl,
    required this.lectureType,
    required this.classId,
    required this.subjectId,
    required this.teacherId,
    required this.startDate,
    required this.startTime,
  });

  factory LectureCreate.fromJson(Map<String, dynamic> json) {
    return LectureCreate(
      title: json['title'],
      description: json['description'],
      thumbnail: json['thumbnail'],
      recordingUrl: json['recordingUrl'],
      lectureType: json['lectureType'],
      classId: json['class'],
      subjectId: json['subject'],
      teacherId: json['teacher'],
      startDate: json['startDate'],
      startTime: json['startTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'thumbnail': thumbnail,
      'lectureType': lectureType,
      'recordingUrl': recordingUrl,
      'class': classId,
      'subject': subjectId,
      'teacher': teacherId,
      'startDate': startDate,
      'startTime': startTime,
    };
  }
}