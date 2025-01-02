import 'student.dart';

class StudentAllResponse {
  final bool success;
  final int currentPage;
  final int total;
  final int totalPages;
  final List<Student> students; // Ensure Student is used here

    StudentAllResponse({
      required this.success,
      required this.currentPage,
      required this.total,
      required this.totalPages,
      required this.students,
    });

    // Factory method to create a StudentResponse from JSON
    factory StudentAllResponse.fromJson(Map<String, dynamic> json) {
      return StudentAllResponse(
        success: json['success'],
        currentPage: json['current_page'],
        total: json['total'],
        totalPages: json['totalPages'],
        students: (json['students'] as List)
            .map((studentJson) => Student.fromJson(studentJson)) // Ensure Student is used here
            .toList(),
      );
    }
}