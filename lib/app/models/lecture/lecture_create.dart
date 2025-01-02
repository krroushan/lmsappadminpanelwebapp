class LectureCreate {
  final String title;
  final String description;
  final String thumbnail;
  final String recordingUrl;
  final String lectureType;
  final String classId;
  final String subjectId;
  final String teacherId;
  final String startTime;
  final String endTime;

  LectureCreate({
    required this.title,
    required this.description,
    required this.thumbnail,
    required this.recordingUrl,
    required this.lectureType,
    required this.classId,
    required this.subjectId,
    required this.teacherId,
    required this.startTime,
    required this.endTime,
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
      startTime: json['startTime'],
      endTime: json['endTime'],
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
      'startTime': startTime,
      'endTime': endTime,
    };
  }
}