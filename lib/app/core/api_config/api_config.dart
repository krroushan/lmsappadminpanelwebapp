//api config Class

abstract class ApiConfig {
  static const String baseUrl = 'https://api.ramaanya.com/api';
  static const String loginUrl = '$baseUrl/login';
  static const String subjectImageUrl = 'https://api.ramaanya.com/uploads/subjects/';
  static const String classImageUrl = 'https://api.ramaanya.com/uploads/classes/';
  static const String lectureThumbnailUrl = 'https://api.ramaanya.com/uploads/lectures/thumbnails/';
  static const String lectureVideoUrl = 'https://api.ramaanya.com/uploads/lectures/videos/';
  static const String syllabusPdfUrl = 'https://api.ramaanya.com/uploads/syllabus/';
  static const String studentImageUrl = 'https://api.ramaanya.com/uploads/students/';
  static const String teacherImageUrl = 'https://api.ramaanya.com/uploads/teachers/';
  static const String adminImageUrl = 'https://api.ramaanya.com/uploads/admins/';
  static const String otherImageUrl = 'https://api.ramaanya.com/uploads/others/';
}

